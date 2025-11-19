package com.javanet.servlet;

import com.javanet.model.Product;
import com.javanet.model.ProductImage;
import com.javanet.model.ProductReview;
import com.javanet.model.User;
import com.javanet.dao.ProductDAO;
import com.javanet.dao.ProductImageDAO;
import com.javanet.dao.ProductReviewDAO;
import com.javanet.dao.UserDAO;
import com.javanet.dao.OrderDAO;
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
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        productImageDAO = new ProductImageDAO();
        reviewDAO = new ProductReviewDAO();
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
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
}