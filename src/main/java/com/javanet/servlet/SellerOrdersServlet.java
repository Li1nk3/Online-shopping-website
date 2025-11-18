package com.javanet.servlet;

import com.javanet.dao.OrderDAO;
import com.javanet.dao.UserDAO;
import com.javanet.model.Order;
import com.javanet.model.OrderItem;
import com.javanet.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/seller-orders")
public class SellerOrdersServlet extends HttpServlet {
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
        
        // 检查是否是卖家或管理员
        if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有卖家才能访问此页面");
            return;
        }
        
        try {
            // 获取卖家的所有订单
            List<Order> orders = orderDAO.getOrdersBySellerId(user.getId());
            
            // 为每个订单获取买家信息和该卖家的商品项
            Map<Integer, User> buyers = new HashMap<>();
            Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
            
            for (Order order : orders) {
                // 获取买家信息
                if (!buyers.containsKey(order.getUserId())) {
                    User buyer = userDAO.getUserById(order.getUserId());
                    buyers.put(order.getUserId(), buyer);
                }
                
                // 获取该订单中属于当前卖家的商品项
                List<OrderItem> items = orderDAO.getSellerOrderItems(order.getId(), user.getId());
                orderItemsMap.put(order.getId(), items);
            }
            
            request.setAttribute("orders", orders);
            request.setAttribute("buyers", buyers);
            request.setAttribute("orderItemsMap", orderItemsMap);
            request.getRequestDispatcher("/WEB-INF/views/seller-orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取订单列表失败");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        // 检查是否是卖家或管理员
        if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有卖家才能执行此操作");
            return;
        }
        
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null || action == null) {
            response.sendRedirect("seller-orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                response.sendRedirect("seller-orders?error=订单不存在");
                return;
            }
            
            boolean success = false;
            String message = "";
            
            switch (action) {
                case "confirm":
                    // 确认订单
                    success = orderDAO.updateOrderStatus(orderId, "confirmed", order.getPaymentStatus());
                    message = success ? "订单已确认" : "确认订单失败";
                    break;
                    
                case "ship":
                    // 发货
                    success = orderDAO.updateOrderStatus(orderId, "shipped", order.getPaymentStatus());
                    message = success ? "订单已发货" : "发货失败";
                    break;
                    
                case "deliver":
                    // 标记为已送达
                    success = orderDAO.updateOrderStatus(orderId, "delivered", order.getPaymentStatus());
                    message = success ? "订单已送达" : "操作失败";
                    break;
                    
                default:
                    message = "未知操作";
            }
            
            if (success) {
                response.sendRedirect("seller-orders?success=" + java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect("seller-orders?error=" + java.net.URLEncoder.encode(message, "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("seller-orders?error=无效的订单ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("seller-orders?error=操作失败");
        }
    }
}