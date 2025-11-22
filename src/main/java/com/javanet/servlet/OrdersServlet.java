package com.javanet.servlet;

import com.javanet.dao.OrderDAO;
import com.javanet.dao.UserDAO;
import com.javanet.model.Order;
import com.javanet.model.User;
import com.javanet.util.EmailUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        // 根据用户角色获取不同的订单列表
        List<Order> orders;
        if ("admin".equals(user.getRole())) {
            // 管理员可以看到所有订单
            orders = orderDAO.getAllOrders();
        } else if ("seller".equals(user.getRole())) {
            // 卖家可以看到包含自己商品的订单
            orders = orderDAO.getOrdersBySellerId(user.getId());
        } else {
            // 普通用户只能看到自己的订单
            orders = orderDAO.getOrdersByUserId(user.getId());
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("userRole", user.getRole());
        request.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"用户未登录\"}");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("cancel".equals(action)) {
            // 取消订单逻辑保持不变
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"订单ID不能为空\"}");
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = orderDAO.cancelOrder(orderId, user.getId());
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                
                if (success) {
                    out.write("{\"success\": true, \"message\": \"订单已成功取消\"}");
                } else {
                    out.write("{\"success\": false, \"message\": \"订单取消失败，可能订单状态不允许取消或订单不存在\"}");
                }
                out.flush();
                
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"无效的订单ID\"}");
            }
        } else if ("confirm".equals(action)) {
            // 管理员确认订单
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"订单ID不能为空\"}");
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                boolean success = orderDAO.updateOrderStatus(orderId, "confirmed", "paid");
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                
                if (success) {
                    // 发送订单确认邮件给买家
                    try {
                        User buyer = userDAO.getUserById(order.getUserId());
                        if (buyer != null && buyer.getEmail() != null && !buyer.getEmail().trim().isEmpty()) {
                            boolean emailSent = EmailUtil.sendOrderConfirmation(buyer.getEmail(), order.getOrderNumber());
                            if (emailSent) {
                                out.write("{\"success\": true, \"message\": \"订单已确认，已通知买家\"}");
                                System.out.println("订单确认邮件已发送给买家: " + buyer.getEmail());
                            } else {
                                out.write("{\"success\": true, \"message\": \"订单已确认，但邮件通知发送失败\"}");
                                System.err.println("订单确认邮件发送失败: " + buyer.getEmail());
                            }
                        } else {
                            out.write("{\"success\": true, \"message\": \"订单已确认，但买家邮箱无效\"}");
                            System.err.println("买家邮箱无效或为空");
                        }
                    } catch (Exception e) {
                        out.write("{\"success\": true, \"message\": \"订单已确认，但邮件通知发送异常\"}");
                        System.err.println("发送订单确认邮件时出现异常: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    out.write("{\"success\": false, \"message\": \"确认订单失败\"}");
                }
                out.flush();
                
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"无效的订单ID\"}");
            }
        } else if ("ship".equals(action)) {
            // 管理员发货
            String orderIdStr = request.getParameter("orderId");
            String trackingNumber = request.getParameter("trackingNumber");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"订单ID不能为空\"}");
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                boolean success = orderDAO.updateOrderStatus(orderId, "shipped", "paid");
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                
                if (success) {
                    // 发送发货通知邮件给买家
                    try {
                        User buyer = userDAO.getUserById(order.getUserId());
                        if (buyer != null && buyer.getEmail() != null && !buyer.getEmail().trim().isEmpty()) {
                            boolean emailSent = EmailUtil.sendShipmentNotification(buyer.getEmail(), order.getOrderNumber());
                            if (emailSent) {
                                out.write("{\"success\": true, \"message\": \"订单已发货，已通知买家\"}");
                                System.out.println("发货通知邮件已发送给买家: " + buyer.getEmail());
                            } else {
                                out.write("{\"success\": true, \"message\": \"订单已发货，但邮件通知发送失败\"}");
                                System.err.println("发货通知邮件发送失败: " + buyer.getEmail());
                            }
                        } else {
                            out.write("{\"success\": true, \"message\": \"订单已发货，但买家邮箱无效\"}");
                            System.err.println("买家邮箱无效或为空");
                        }
                    } catch (Exception e) {
                        out.write("{\"success\": true, \"message\": \"订单已发货，但邮件通知发送异常\"}");
                        System.err.println("发送发货通知邮件时出现异常: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    out.write("{\"success\": false, \"message\": \"发货失败\"}");
                }
                out.flush();
                
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"无效的订单ID\"}");
            }
        } else if ("confirmDelivery".equals(action)) {
            // 用户确认收货
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"订单ID不能为空\"}");
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                
                // 验证订单归属
                if (order == null || order.getUserId() != user.getId()) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"success\": false, \"message\": \"无权操作此订单\"}");
                    return;
                }
                
                boolean success = orderDAO.updateOrderStatus(orderId, "delivered", "paid");
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                
                if (success) {
                    // 发送收货确认邮件
                    try {
                        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
                            EmailUtil.sendDeliveryConfirmation(
                                user.getEmail(),
                                order.getOrderNumber()
                            );
                        }
                    } catch (Exception e) {
                        System.err.println("发送收货确认邮件失败: " + e.getMessage());
                    }
                    
                    out.write("{\"success\": true, \"message\": \"确认收货成功\"}");
                } else {
                    out.write("{\"success\": false, \"message\": \"确认收货失败\"}");
                }
                out.flush();
                
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"无效的订单ID\"}");
            }
        } else if ("delete".equals(action)) {
        // 管理员删除订单
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"订单ID不能为空\"}");
            return;
        }
        
        // 检查是否是管理员
        if (!"admin".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"只有管理员才能删除订单\"}");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"订单不存在\"}");
                return;
            }
            
            boolean success = orderDAO.deleteOrder(orderId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            if (success) {
                out.write("{\"success\": true, \"message\": \"订单已删除\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"删除订单失败\"}");
            }
            out.flush();
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"无效的订单ID\"}");
        }
    } else {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\": false, \"message\": \"无效的操作\"}");
    }
    }
    
    /**
     * 根据用户ID获取用户信息
     */
    private User getUserById(int userId) {
        try {
            return userDAO.getUserById(userId);
        } catch (Exception e) {
            System.err.println("获取用户信息失败: " + e.getMessage());
            return null;
        }
    }
}