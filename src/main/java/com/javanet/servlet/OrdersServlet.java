package com.javanet.servlet;

import com.javanet.dao.OrderDAO;
import com.javanet.model.Order;
import com.javanet.model.User;
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
        
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        request.setAttribute("orders", orders);
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
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"无效的操作\"}");
        }
    }
}