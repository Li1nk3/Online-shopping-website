package com.javanet.servlet;

import com.javanet.dao.CartDAO;
import com.javanet.dao.OrderDAO;
import com.javanet.model.Cart;
import com.javanet.model.Order;
import com.javanet.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
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
        
        List<Cart> cartItems = cartDAO.getCartItems(user.getId());
        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // 计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart item : cartItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
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
        
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "请填写收货地址");
            doGet(request, response);
            return;
        }
        
        List<Cart> cartItems = cartDAO.getCartItems(user.getId());
        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // 计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart item : cartItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }
        
        // 创建订单
        String orderNumber = orderDAO.generateOrderNumber();
        Order order = new Order(user.getId(), orderNumber, totalAmount, shippingAddress);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "online");
        
        int orderId = orderDAO.createOrder(order);
        if (orderId > 0) {
            // 添加订单项
            boolean success = true;
            for (Cart item : cartItems) {
                if (!orderDAO.addOrderItem(orderId, item.getProductId(), 
                                          item.getQuantity(), item.getProduct().getPrice())) {
                    success = false;
                    break;
                }
            }
            
            if (success) {
                // 清空购物车
                cartDAO.clearCart(user.getId());
                
                // 重定向到订单确认页面
                response.sendRedirect("order-confirmation?orderNumber=" + orderNumber);
            } else {
                request.setAttribute("error", "订单创建失败，请重试");
                doGet(request, response);
            }
        } else {
            request.setAttribute("error", "订单创建失败，请重试");
            doGet(request, response);
        }
    }
}