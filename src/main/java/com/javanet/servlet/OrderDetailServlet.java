package com.javanet.servlet;

import com.javanet.dao.OrderDAO;
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
import java.util.List;

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
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
            if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                response.sendRedirect("orders");
                return;
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "订单不存在");
                return;
            }
            
            // 验证订单是否属于当前用户
            if (order.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问此订单");
                return;
            }
            
            // 获取订单商品项
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
            
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
}