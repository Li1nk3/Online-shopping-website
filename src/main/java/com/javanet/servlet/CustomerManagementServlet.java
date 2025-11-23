package com.javanet.servlet;

import com.javanet.dao.CustomerBrowseLogDAO;
import com.javanet.dao.CustomerPurchaseStatsDAO;
import com.javanet.dao.UserDAO;
import com.javanet.model.CustomerBrowseLog;
import com.javanet.model.CustomerPurchaseStats;
import com.javanet.model.User;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/customer-management")
public class CustomerManagementServlet extends HttpServlet {
    private CustomerBrowseLogDAO browseLogDAO;
    private CustomerPurchaseStatsDAO purchaseStatsDAO;
    private UserDAO userDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        browseLogDAO = new CustomerBrowseLogDAO();
        purchaseStatsDAO = new CustomerPurchaseStatsDAO();
        userDAO = new UserDAO();
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
        
        // 检查是否是卖家或管理员
        if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有卖家或管理员才能访问客户管理");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("test".equals(action)) {
                // 测试功能
                showTestPage(request, response, user);
            } else if ("browse-logs".equals(action)) {
                // 显示客户浏览日志
                showBrowseLogs(request, response, user);
            } else if ("purchase-stats".equals(action)) {
                // 显示客户购买统计
                showPurchaseStats(request, response, user);
            } else if ("customer-detail".equals(action)) {
                // 显示客户详细信息
                showCustomerDetail(request, response, user);
            } else {
                // 显示客户管理主页
                showCustomerManagement(request, response, user);
            }
        } catch (Exception e) {
            System.err.println("CustomerManagementServlet 错误: " + e.getMessage());
            e.printStackTrace();
            
            // 设置错误信息到请求中
            request.setAttribute("error", "获取客户数据失败: " + e.getMessage());
            request.setAttribute("exception", e.toString());
            
            // 转发到测试页面显示错误
            request.getRequestDispatcher("/WEB-INF/views/test-customer-management.jsp").forward(request, response);
            return;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        // 检查是否是卖家或管理员
        if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String action = request.getParameter("action");
        
        try {
            if ("record-browse".equals(action)) {
                // 记录浏览日志（AJAX调用）
                recordBrowseLog(request, response, user);
            } else if ("get-stats".equals(action)) {
                // 获取统计数据（AJAX调用）
                getStatistics(request, response, user);
            } else {
                result.put("success", false);
                result.put("message", "无效的操作");
                out.print(gson.toJson(result));
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "操作失败");
            out.print(gson.toJson(result));
        }
    }
    
    private void showCustomerManagement(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            System.out.println("=== 客户管理页面调试信息 ===");
            System.out.println("用户ID: " + user.getId());
            System.out.println("用户角色: " + user.getRole());
            
            // 获取基本统计数据
            System.out.println("开始获取统计数据...");
            
            int totalCustomers = purchaseStatsDAO.getTotalCustomersBySellerId(user.getId());
            System.out.println("总客户数: " + totalCustomers);
            
            BigDecimal totalRevenue = purchaseStatsDAO.getTotalRevenueBySellerId(user.getId());
            System.out.println("总收入: " + totalRevenue);
            
            List<CustomerPurchaseStats> topCustomers = purchaseStatsDAO.getTopCustomersBySellerId(user.getId(), 5);
            System.out.println("优质客户数量: " + (topCustomers != null ? topCustomers.size() : 0));
            
            List<CustomerPurchaseStats> recentCustomers = purchaseStatsDAO.getRecentCustomers(user.getId(), 7);
            System.out.println("最近客户数量: " + (recentCustomers != null ? recentCustomers.size() : 0));
            
            List<CustomerBrowseLog> hotProducts = browseLogDAO.getHotProducts(7, 6);
            System.out.println("热门商品数量: " + (hotProducts != null ? hotProducts.size() : 0));
            
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("topCustomers", topCustomers);
            request.setAttribute("recentCustomers", recentCustomers);
            request.setAttribute("hotProducts", hotProducts);
            
            System.out.println("数据设置完成，准备转发到JSP页面...");
            request.getRequestDispatcher("/WEB-INF/views/customer-management.jsp").forward(request, response);
            System.out.println("JSP页面转发完成");
            
        } catch (Exception e) {
            System.err.println("客户管理页面错误详情:");
            e.printStackTrace();
            throw e;
        }
    }
    
    private void showBrowseLogs(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        int limit = 50;
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.trim().isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam);
                limit = Math.min(Math.max(limit, 1), 200); // 限制在1-200之间
            } catch (NumberFormatException e) {
                limit = 50;
            }
        }
        
        List<CustomerBrowseLog> browseLogs = browseLogDAO.getBrowseLogsBySellerId(user.getId(), limit);
        request.setAttribute("browseLogs", browseLogs);
        request.setAttribute("limit", limit);
        
        request.getRequestDispatcher("/WEB-INF/views/customer-browse-logs.jsp").forward(request, response);
    }
    
    private void showPurchaseStats(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        List<CustomerPurchaseStats> purchaseStats = purchaseStatsDAO.getPurchaseStatsBySellerId(user.getId());
        request.setAttribute("purchaseStats", purchaseStats);
        
        request.getRequestDispatcher("/WEB-INF/views/customer-purchase-stats.jsp").forward(request, response);
    }
    
    private void showCustomerDetail(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            response.sendRedirect("customer-management");
            return;
        }
        
        try {
            int customerId = Integer.parseInt(customerIdStr);
            CustomerPurchaseStats stats = purchaseStatsDAO.getPurchaseStatsByUserAndSeller(customerId, user.getId());
            List<CustomerBrowseLog> browseLogs = browseLogDAO.getBrowseLogsByUserId(customerId, 20);
            
            if (stats == null) {
                response.sendRedirect("customer-management?error=客户不存在");
                return;
            }
            
            request.setAttribute("customerStats", stats);
            request.setAttribute("browseLogs", browseLogs);
            
            request.getRequestDispatcher("/WEB-INF/views/customer-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("customer-management?error=无效的客户ID");
        }
    }
    
    private void recordBrowseLog(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        try {
            String productIdStr = request.getParameter("productId");
            String sessionId = request.getSession().getId();
            String ipAddress = getClientIpAddress(request);
            String userAgent = request.getHeader("User-Agent");
            
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "商品ID不能为空");
                out.print(gson.toJson(result));
                return;
            }
            
            int productId = Integer.parseInt(productIdStr);
            
            CustomerBrowseLog log = new CustomerBrowseLog();
            log.setUserId(user.getId());
            log.setProductId(productId);
            log.setSessionId(sessionId);
            log.setIpAddress(ipAddress);
            log.setUserAgent(userAgent);
            
            boolean success = browseLogDAO.addBrowseLog(log);
            
            result.put("success", success);
            result.put("message", success ? "记录成功" : "记录失败");
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "无效的商品ID");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "记录失败");
        }
        
        out.print(gson.toJson(result));
    }
    
    private void getStatistics(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        try {
            String period = request.getParameter("period");
            int days = 30; // 默认30天
            
            if ("7".equals(period)) {
                days = 7;
            } else if ("30".equals(period)) {
                days = 30;
            } else if ("90".equals(period)) {
                days = 90;
            }
            
            // 获取统计数据
            int totalCustomers = purchaseStatsDAO.getTotalCustomersBySellerId(user.getId());
            BigDecimal totalRevenue = purchaseStatsDAO.getTotalRevenueBySellerId(user.getId());
            List<CustomerPurchaseStats> topCustomers = purchaseStatsDAO.getTopCustomersBySellerId(user.getId(), 10);
            List<CustomerBrowseLog> customerStats = browseLogDAO.getCustomerBrowseStats(user.getId(), days);
            
            result.put("success", true);
            result.put("totalCustomers", totalCustomers);
            result.put("totalRevenue", totalRevenue);
            result.put("topCustomers", topCustomers);
            result.put("customerStats", customerStats);
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "获取统计数据失败");
        }
        
        out.print(gson.toJson(result));
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty() && !"unknown".equalsIgnoreCase(xForwardedFor)) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty() && !"unknown".equalsIgnoreCase(xRealIp)) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
    
    private void showTestPage(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            System.out.println("=== 开始测试客户管理功能 ===");
            
            // 测试数据库连接
            java.util.Map<String, Object> dbTestResult = new java.util.HashMap<>();
            try {
                com.javanet.util.DatabaseConnection.getConnection().close();
                dbTestResult.put("success", true);
                dbTestResult.put("message", "数据库连接成功");
            } catch (Exception e) {
                dbTestResult.put("success", false);
                dbTestResult.put("message", "数据库连接失败: " + e.getMessage());
            }
            request.setAttribute("dbTestResult", dbTestResult);
            
            // 逐步测试每个DAO方法
            System.out.println("测试 getTotalCustomersBySellerId...");
            int totalCustomers = purchaseStatsDAO.getTotalCustomersBySellerId(user.getId());
            request.setAttribute("totalCustomers", totalCustomers);
            
            System.out.println("测试 getTotalRevenueBySellerId...");
            java.math.BigDecimal totalRevenue = purchaseStatsDAO.getTotalRevenueBySellerId(user.getId());
            request.setAttribute("totalRevenue", totalRevenue);
            
            System.out.println("测试 getTopCustomersBySellerId...");
            List<CustomerPurchaseStats> topCustomers = purchaseStatsDAO.getTopCustomersBySellerId(user.getId(), 5);
            request.setAttribute("topCustomers", topCustomers);
            
            System.out.println("测试 getRecentCustomers...");
            List<CustomerPurchaseStats> recentCustomers = purchaseStatsDAO.getRecentCustomers(user.getId(), 7);
            request.setAttribute("recentCustomers", recentCustomers);
            
            System.out.println("测试 getHotProducts...");
            List<CustomerBrowseLog> hotProducts = browseLogDAO.getHotProducts(7, 6);
            request.setAttribute("hotProducts", hotProducts);
            
            System.out.println("=== 测试完成 ===");
            
            request.getRequestDispatcher("/WEB-INF/views/test-customer-management.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("测试页面错误: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "测试失败: " + e.getMessage());
            request.setAttribute("exception", e.toString());
            request.getRequestDispatcher("/WEB-INF/views/test-customer-management.jsp").forward(request, response);
        }
    }
}