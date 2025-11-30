package com.javanet.servlet;

import com.google.gson.Gson;
import com.javanet.dao.OrderDAO;
import com.javanet.dao.CustomerPurchaseStatsDAO;
import com.javanet.dao.ProductDAO;
import com.javanet.model.Order;
import com.javanet.model.OrderItem;
import com.javanet.model.User;
import com.javanet.model.Product;
import com.javanet.util.EmailUtil;
import com.javanet.util.StripeConfig;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 付款处理Servlet
 */
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private CustomerPurchaseStatsDAO purchaseStatsDAO;
    private ProductDAO productDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        purchaseStatsDAO = new CustomerPurchaseStatsDAO();
        productDAO = new ProductDAO();
        gson = new Gson();
        // 初始化Stripe API密钥
        Stripe.apiKey = StripeConfig.getSecretKey();
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
        
        // 调试日志
        // System.out.println("DEBUG: Received action = " + action);
        // System.out.println("DEBUG: Received orderNumber = " + orderNumber);
        
        if (action == null || action.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "操作参数不能为空");
            out.print(gson.toJson(result));
            return;
        }
        
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
        
        if ("create-checkout-session".equals(action)) {
            // 创建Stripe Checkout会话
            try {
                String sessionId = createStripeCheckoutSession(order, request);
                result.put("success", true);
                result.put("sessionId", sessionId);
            } catch (StripeException e) {
                result.put("success", false);
                result.put("message", "创建支付会话失败: " + e.getMessage());
            }
        } else if ("process".equals(action)) {
            // 处理付款
            String paymentMethod = request.getParameter("paymentMethod");
            
            // 模拟付款处理
            boolean paymentSuccess = processPayment(order, paymentMethod);
            
            if (paymentSuccess) {
                // 更新订单付款状态
                boolean updated = orderDAO.updatePaymentStatus(order.getId(), "paid", paymentMethod);
                
                if (updated) {
                    // 扣减商品库存
                    deductProductStock(order.getId());
                    
                    // 付款成功后更新客户购买统计
                    updatePurchaseStatsAsync(order);
                    
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
        } else if ("verify-payment".equals(action)) {
            // 验证Stripe支付
            String sessionId = request.getParameter("sessionId");
            try {
                Session stripeSession = Session.retrieve(sessionId);
                if ("paid".equals(stripeSession.getPaymentStatus())) {
                    boolean updated = orderDAO.updatePaymentStatus(order.getId(), "paid", "stripe");
                    if (updated) {
                        // 扣减商品库存
                        deductProductStock(order.getId());
                        
                        updatePurchaseStatsAsync(order);
                        result.put("success", true);
                        result.put("message", "付款成功");
                        result.put("orderNumber", orderNumber);
                    } else {
                        result.put("success", false);
                        result.put("message", "付款状态更新失败");
                    }
                } else {
                    result.put("success", false);
                    result.put("message", "付款未完成");
                }
            } catch (StripeException e) {
                result.put("success", false);
                result.put("message", "验证支付失败: " + e.getMessage());
            }
        } else {
            result.put("success", false);
            result.put("message", "无效的操作");
        }
        
        out.print(gson.toJson(result));
    }
    
    /**
     * 创建Stripe Checkout会话
     */
    private String createStripeCheckoutSession(Order order, HttpServletRequest request) throws StripeException {
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
        
        SessionCreateParams params = SessionCreateParams.builder()
            .setMode(SessionCreateParams.Mode.PAYMENT)
            .setSuccessUrl(baseUrl + "/payment-success?orderNumber=" + order.getOrderNumber() + "&session_id={CHECKOUT_SESSION_ID}")
            .setCancelUrl(baseUrl + "/payment?orderNumber=" + order.getOrderNumber())
            .addLineItem(
                SessionCreateParams.LineItem.builder()
                    .setQuantity(1L)
                    .setPriceData(
                        SessionCreateParams.LineItem.PriceData.builder()
                            .setCurrency("cny")
                            .setUnitAmount(order.getTotalAmount().multiply(new java.math.BigDecimal(100)).longValue())
                            .setProductData(
                                SessionCreateParams.LineItem.PriceData.ProductData.builder()
                                    .setName("订单 #" + order.getOrderNumber())
                                    .setDescription("JavaNet在线购物订单")
                                    .build()
                            )
                            .build()
                    )
                    .build()
            )
            .putMetadata("order_number", order.getOrderNumber())
            .putMetadata("user_id", String.valueOf(order.getUserId()))
            .build();
        
        Session stripeSession = Session.create(params);
        return stripeSession.getId();
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
    
    /**
     * 异步更新客户购买统计
     */
    private void updatePurchaseStatsAsync(Order order) {
        // 在新线程中更新购买统计，避免影响页面响应速度
        new Thread(() -> {
            try {
                // 获取订单的所有商品项
                List<OrderItem> orderItems = orderDAO.getOrderItems(order.getId());
                
                for (OrderItem item : orderItems) {
                    Product product = productDAO.getProductById(item.getProductId());
                    if (product != null) {
                        // 更新客户购买统计
                        purchaseStatsDAO.addOrUpdatePurchaseStats(
                            order.getUserId(),
                            product.getSellerId(),
                            item.getPrice().multiply(new java.math.BigDecimal(item.getQuantity()))
                        );
                        System.out.println("更新购买统计成功: 用户ID=" + order.getUserId() +
                                         ", 卖家ID=" + product.getSellerId() +
                                         ", 金额=" + item.getPrice().multiply(new java.math.BigDecimal(item.getQuantity())));
                    }
                }
            } catch (Exception e) {
                // 更新统计失败不应该影响主要功能
                System.err.println("更新购买统计失败: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }
    
    /**
     * 扣减商品库存
     * @param orderId 订单ID
     */
    private void deductProductStock(int orderId) {
        try {
            // 获取订单的所有商品项
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
            
            for (OrderItem item : orderItems) {
                Product product = productDAO.getProductById(item.getProductId());
                if (product != null) {
                    // 计算新库存
                    int newStock = product.getStock() - item.getQuantity();
                    if (newStock < 0) {
                        newStock = 0; // 防止库存为负数
                    }
                    
                    // 更新库存
                    boolean updated = productDAO.updateStock(item.getProductId(), newStock);
                    if (updated) {
                        System.out.println("库存扣减成功: 商品ID=" + item.getProductId() +
                                         ", 原库存=" + product.getStock() +
                                         ", 购买数量=" + item.getQuantity() +
                                         ", 新库存=" + newStock);
                    } else {
                        System.err.println("库存扣减失败: 商品ID=" + item.getProductId());
                    }
                }
            }
        } catch (Exception e) {
            // 库存扣减失败不应该影响支付流程
            System.err.println("扣减库存时发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }
}