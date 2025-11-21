package com.javanet.servlet;

import com.google.gson.Gson;
import com.javanet.dao.OrderDAO;
import com.javanet.model.Order;
import com.javanet.model.OrderItem;
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

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        gson = new Gson();
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
        
        try {
            String orderIdStr = request.getParameter("id");
            String orderNumber = request.getParameter("orderNumber");
            
            Order order = null;
            
            if (orderNumber != null && !orderNumber.trim().isEmpty()) {
                order = orderDAO.getOrderByNumber(orderNumber);
            } else if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                int orderId = Integer.parseInt(orderIdStr);
                order = orderDAO.getOrderById(orderId);
            } else {
                response.sendRedirect("orders");
                return;
            }
            
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "订单不存在");
                return;
            }
            
            // 验证订单是否属于当前用户，或者用户是管理员
            if (order.getUserId() != user.getId() && !"admin".equals(user.getRole())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问此订单");
                return;
            }
            
            // 获取订单商品项
            List<OrderItem> orderItems = orderDAO.getOrderItems(order.getId());
            
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.getRequestDispatcher("/WEB-INF/views/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("orders");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取订单详情失败");
        }
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
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        
        if ("confirmReceipt".equals(action)) {
            // 确认收货
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                out.print(gson.toJson(new Response(false, "订单ID不能为空")));
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                
                if (order == null || (order.getUserId() != user.getId() && !"admin".equals(user.getRole()))) {
                    out.print(gson.toJson(new Response(false, "订单不存在或无权操作")));
                    return;
                }
                
                // 更新订单状态为已送达
                boolean success = orderDAO.updateOrderStatus(orderId, "delivered", order.getPaymentStatus());
                
                if (success) {
                    // 发送确认收货邮件
                    try {
                        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
                            EmailUtil.sendDeliveryConfirmation(user.getEmail(), order.getOrderNumber());
                        }
                    } catch (Exception e) {
                        System.err.println("发送确认收货邮件失败: " + e.getMessage());
                    }
                    
                    out.print(gson.toJson(new Response(true, "确认收货成功")));
                } else {
                    out.print(gson.toJson(new Response(false, "确认收货失败")));
                }
                
            } catch (NumberFormatException e) {
                out.print(gson.toJson(new Response(false, "无效的订单ID")));
            }
        } else if ("cancel".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"订单ID不能为空\"}");
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                // 对于取消订单操作，只有订单所有者才能取消，管理员不能代为取消
                boolean success = orderDAO.cancelOrder(orderId, user.getId());
                
                if (success) {
                    out.print(gson.toJson(new Response(true, "订单已成功取消")));
                } else {
                    out.print(gson.toJson(new Response(false, "订单取消失败，可能订单状态不允许取消或订单不存在")));
                }
                
            } catch (NumberFormatException e) {
                out.print(gson.toJson(new Response(false, "无效的订单ID")));
            }
        } else {
            out.print(gson.toJson(new Response(false, "无效的操作")));
        }
    }
    
    // 响应类
    private static class Response {
        private boolean success;
        private String message;
        
        public Response(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}