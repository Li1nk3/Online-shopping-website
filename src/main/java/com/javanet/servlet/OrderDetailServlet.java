package com.javanet.servlet;

import com.google.gson.Gson;
import com.javanet.dao.OrderDAO;
import com.javanet.dao.ProductDAO;
import com.javanet.dao.UserDAO;
import com.javanet.model.Order;
import com.javanet.model.OrderItem;
import com.javanet.model.Product;
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
    private ProductDAO productDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
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
            
            // 获取订单商品项
            List<OrderItem> orderItems = orderDAO.getOrderItems(order.getId());
            
            // 验证权限：订单所有者、管理员或卖家（订单中包含该卖家的商品）
            boolean hasPermission = false;
            
            if (order.getUserId() == user.getId()) {
                // 订单所有者
                hasPermission = true;
            } else if ("admin".equals(user.getRole())) {
                // 管理员
                hasPermission = true;
            } else if ("seller".equals(user.getRole())) {
                // 卖家：检查订单中是否包含该卖家的商品
                for (OrderItem item : orderItems) {
                    Product product = productDAO.getProductById(item.getProductId());
                    if (product != null && product.getSellerId() == user.getId()) {
                        hasPermission = true;
                        break;
                    }
                }
            }
            
            if (!hasPermission) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问此订单");
                return;
            }
            
            // 检查当前用户是否是卖家且订单中包含其商品
            boolean isSeller = false;
            if ("seller".equals(user.getRole())) {
                for (OrderItem item : orderItems) {
                    Product product = productDAO.getProductById(item.getProductId());
                    if (product != null && product.getSellerId() == user.getId()) {
                        isSeller = true;
                        break;
                    }
                }
            }
            
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("isSeller", isSeller);
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
                
                if (order == null) {
                    out.print(gson.toJson(new Response(false, "订单不存在")));
                    return;
                }
                
                // 验证权限：只有订单所有者和管理员可以确认收货
                if (order.getUserId() != user.getId() && !"admin".equals(user.getRole())) {
                    out.print(gson.toJson(new Response(false, "无权操作此订单")));
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
        } else if ("ship".equals(action)) {
            // 卖家发货
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                out.print(gson.toJson(new Response(false, "订单ID不能为空")));
                return;
            }
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                
                if (order == null) {
                    out.print(gson.toJson(new Response(false, "订单不存在")));
                    return;
                }
                
                // 验证权限：只有卖家和管理员可以发货
                if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
                    out.print(gson.toJson(new Response(false, "无权操作此订单")));
                    return;
                }
                
                // 如果是卖家，验证订单中是否包含该卖家的商品
                if ("seller".equals(user.getRole())) {
                    List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
                    boolean hasSellerProduct = false;
                    for (OrderItem item : orderItems) {
                        Product product = productDAO.getProductById(item.getProductId());
                        if (product != null && product.getSellerId() == user.getId()) {
                            hasSellerProduct = true;
                            break;
                        }
                    }
                    if (!hasSellerProduct) {
                        out.print(gson.toJson(new Response(false, "订单中不包含您的商品")));
                        return;
                    }
                }
                
                // 检查订单状态：只有已支付的订单才能发货
                if (!"paid".equals(order.getPaymentStatus())) {
                    out.print(gson.toJson(new Response(false, "订单尚未支付，无法发货")));
                    return;
                }
                
                // 检查订单状态：已发货或已送达的订单不能重复发货
                if ("shipped".equals(order.getOrderStatus()) || "delivered".equals(order.getOrderStatus())) {
                    out.print(gson.toJson(new Response(false, "订单已发货，无需重复操作")));
                    return;
                }
                
                // 更新订单状态为已发货
                boolean success = orderDAO.updateOrderStatus(orderId, "shipped", order.getPaymentStatus());
                
                if (success) {
                    // 发送发货通知邮件
                    try {
                        // 获取买家信息
                        UserDAO userDAO = new UserDAO();
                        User buyer = userDAO.getUserById(order.getUserId());
                        if (buyer != null && buyer.getEmail() != null && !buyer.getEmail().isEmpty()) {
                            EmailUtil.sendShipmentNotification(buyer.getEmail(), order.getOrderNumber());
                        }
                    } catch (Exception e) {
                        System.err.println("发送发货通知邮件失败: " + e.getMessage());
                    }
                    
                    out.print(gson.toJson(new Response(true, "发货成功")));
                } else {
                    out.print(gson.toJson(new Response(false, "发货失败")));
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