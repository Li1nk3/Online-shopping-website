package com.javanet.servlet;

import com.google.gson.Gson;
import com.javanet.dao.OrderDAO;
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
import java.util.HashMap;
import java.util.Map;

/**
 * 付款处理Servlet
 */
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
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
        
        String orderNumber = request.getParameter("orderNumber");
        if (orderNumber == null || orderNumber.trim().isEmpty()) {
            response.sendRedirect("orders");
            return;
        }
        
        Order order = orderDAO.getOrderByNumber(orderNumber);
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect("orders");
            return;
        }
        
        // 如果订单已付款，重定向到订单详情
        if ("paid".equals(order.getPaymentStatus())) {
            response.sendRedirect("order-detail?orderNumber=" + orderNumber);
            return;
        }
        
        request.setAttribute("order", order);
        request.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            out.print(gson.toJson(result));
            return;
        }
        
        String action = request.getParameter("action");
        String orderNumber = request.getParameter("orderNumber");
        
        if (orderNumber == null || orderNumber.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "订单号不能为空");
            out.print(gson.toJson(result));
            return;
        }
        
        Order order = orderDAO.getOrderByNumber(orderNumber);
        if (order == null || order.getUserId() != user.getId()) {
            result.put("success", false);
            result.put("message", "订单不存在");
            out.print(gson.toJson(result));
            return;
        }
        
        if ("process".equals(action)) {
            // 处理付款
            String paymentMethod = request.getParameter("paymentMethod");
            
            // 模拟付款处理
            boolean paymentSuccess = processPayment(order, paymentMethod);
            
            if (paymentSuccess) {
                // 更新订单付款状态
                boolean updated = orderDAO.updatePaymentStatus(order.getId(), "paid", paymentMethod);
                
                if (updated) {
                    
                    result.put("success", true);
                    result.put("message", "付款成功");
                    result.put("orderNumber", orderNumber);
                } else {
                    result.put("success", false);
                    result.put("message", "付款状态更新失败");
                }
            } else {
                result.put("success", false);
                result.put("message", "付款处理失败，请重试");
            }
        } else {
            result.put("success", false);
            result.put("message", "无效的操作");
        }
        
        out.print(gson.toJson(result));
    }
    
    /**
     * 模拟付款处理
     * 实际项目中应该对接真实的支付平台（支付宝、微信支付等）
     */
    private boolean processPayment(Order order, String paymentMethod) {
        try {
            // 模拟付款处理延迟
            Thread.sleep(1000);
            
            // 这里应该调用实际的支付接口
            // 例如：支付宝、微信支付、银行网关等
            
            // 模拟付款成功（实际应根据支付平台返回结果判断）
            return true;
        } catch (InterruptedException e) {
            e.printStackTrace();
            return false;
        }
    }
}