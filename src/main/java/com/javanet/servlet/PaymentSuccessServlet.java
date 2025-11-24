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

@WebServlet("/payment-success")
public class PaymentSuccessServlet extends HttpServlet {
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
        
        String orderNumber = request.getParameter("orderNumber");
        String sessionId = request.getParameter("session_id");
        
        if (orderNumber == null || sessionId == null) {
            response.sendRedirect("orders");
            return;
        }
        
        Order order = orderDAO.getOrderByNumber(orderNumber);
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect("orders");
            return;
        }
        
        request.setAttribute("order", order);
        request.setAttribute("sessionId", sessionId);
        request.getRequestDispatcher("/WEB-INF/views/payment-success.jsp").forward(request, response);
    }
}