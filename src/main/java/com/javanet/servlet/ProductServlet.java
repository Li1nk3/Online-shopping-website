package com.javanet.servlet;

import com.javanet.model.Product;
import com.javanet.model.ProductImage;
import com.javanet.model.ProductReview;
import com.javanet.model.User;
import com.javanet.model.CustomerBrowseLog;
import com.javanet.dao.ProductDAO;
import com.javanet.dao.ProductImageDAO;
import com.javanet.dao.ProductReviewDAO;
import com.javanet.dao.UserDAO;
import com.javanet.dao.OrderDAO;
import com.javanet.dao.CustomerBrowseLogDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private ProductImageDAO productImageDAO;
    private ProductReviewDAO reviewDAO;
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private CustomerBrowseLogDAO browseLogDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        productImageDAO = new ProductImageDAO();
        reviewDAO = new ProductReviewDAO();
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
        browseLogDAO = new CustomerBrowseLogDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String productId = request.getParameter("id");
            String category = request.getParameter("category");
            String search = request.getParameter("search");
            
            if (productId != null) {
                // 显示单个商品详情
                Product product = productDAO.getProductById(Integer.parseInt(productId));
                if (product != null) {
                    // 加载商品图片
                    List<ProductImage> images = productImageDAO.getImagesByProductId(product.getId());
                    product.setImages(images);
                    
                    // 获取卖家信息
                    User seller = userDAO.getUserById(product.getSellerId());
                    request.setAttribute("seller", seller);
                    
                    // 获取评论信息
                    List<ProductReview> reviews = reviewDAO.getReviewsByProductId(product.getId());
                    double avgRating = reviewDAO.getAverageRating(product.getId());
                    int reviewCount = reviewDAO.getReviewCount(product.getId());
                    
                    // 检查当前用户是否购买过该商品
                    HttpSession session = request.getSession();
                    User currentUser = (User) session.getAttribute("user");
                    boolean hasPurchased = false;
                    if (currentUser != null) {
                        hasPurchased = orderDAO.hasUserPurchasedProduct(currentUser.getId(), product.getId());
                    }
                    
                    request.setAttribute("product", product);
                    request.setAttribute("reviews", reviews);
                    request.setAttribute("avgRating", avgRating);
                    request.setAttribute("reviewCount", reviewCount);
                    request.setAttribute("hasPurchased", hasPurchased);
                    
                    // 记录浏览日志（异步记录，不影响页面显示）
                    recordBrowseLogAsync(request, product.getId(), currentUser);
                    
                    request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "商品不存在");
                }
            } else {
                // 显示商品列表
                List<Product> products;
                String pageTitle = "商品列表";
                
                if (search != null && !search.trim().isEmpty()) {
                    // 搜索商品
                    products = productDAO.searchProducts(search.trim());
                    request.setAttribute("searchKeyword", search.trim());
                    pageTitle = "搜索结果： " + search.trim();
                } else if (category != null && !category.trim().isEmpty()) {
                    // 按分类获取商品
                    products = productDAO.getProductsByCategory(category);
                    request.setAttribute("currentCategory", category);
                    pageTitle = category;
                } else {
                    // 获取所有商品
                    products = productDAO.getAllProducts();
                }
                
                request.setAttribute("pageTitle", pageTitle);
                
                // 为每个商品加载图片
                for (Product product : products) {
                    List<ProductImage> images = productImageDAO.getImagesByProductId(product.getId());
                    product.setImages(images);
                }
                
                request.setAttribute("products", products);
                request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取商品信息失败");
        }
    }
    
    /**
     * 异步记录浏览日志
     */
    private void recordBrowseLogAsync(HttpServletRequest request, int productId, User user) {
        // 在新线程中记录浏览日志，避免影响页面响应速度
        new Thread(() -> {
            try {
                // System.out.println("DEBUG: 开始记录浏览日志 - productId=" + productId + ", user=" + (user != null ? user.getId() : "null"));
                
                CustomerBrowseLog log = new CustomerBrowseLog();
                log.setProductId(productId);
                log.setSessionId(request.getSession().getId());
                log.setIpAddress(getClientIpAddress(request));
                log.setUserAgent(request.getHeader("User-Agent"));
                
                if (user != null) {
                    log.setUserId(user.getId());
                    // System.out.println("DEBUG: 设置用户ID=" + user.getId());
                } else {
                    // System.out.println("DEBUG: 用户未登录，user ID为null");
                }
                
                boolean success = browseLogDAO.addBrowseLog(log);
                // System.out.println("DEBUG: 浏览日志记录结果=" + success);
                
            } catch (Exception e) {
                // 记录日志失败不应该影响主要功能
                System.err.println("记录浏览日志失败: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }
    
    /**
     * 获取客户端真实IP地址
     */
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
}