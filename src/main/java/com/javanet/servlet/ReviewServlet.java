package com.javanet.servlet;

import com.javanet.dao.ProductReviewDAO;
import com.javanet.model.ProductReview;
import com.javanet.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private ProductReviewDAO reviewDAO = new ProductReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // 验证参数
            String productIdStr = request.getParameter("productId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");
            
            if (productIdStr == null || ratingStr == null || comment == null || comment.trim().isEmpty()) {
                response.sendRedirect("products?id=" + (productIdStr != null ? productIdStr : "0") + "&error=" + URLEncoder.encode("请填写完整的评价信息", "UTF-8"));
                return;
            }
            
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // 验证评分范围
            if (rating < 1 || rating > 5) {
                response.sendRedirect("products?id=" + productId + "&error=" + URLEncoder.encode("评分必须在1-5星之间", "UTF-8"));
                return;
            }
            
            // 检查用户是否已经评论过该商品
            if (reviewDAO.hasUserReviewedProduct(user.getId(), productId)) {
                response.sendRedirect("products?id=" + productId + "&error=" + URLEncoder.encode("您已经评论过该商品", "UTF-8"));
                return;
            }
            
            ProductReview review = new ProductReview();
            review.setProductId(productId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setComment(comment.trim());
            
            boolean success = reviewDAO.addReview(review);
            if (success) {
                response.sendRedirect("products?id=" + productId + "&message=" + URLEncoder.encode("评论提交成功", "UTF-8"));
            } else {
                response.sendRedirect("products?id=" + productId + "&error=" + URLEncoder.encode("数据库操作失败，请重试", "UTF-8"));
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("products?error=" + URLEncoder.encode("参数格式错误", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products?error=" + URLEncoder.encode("系统错误：" + e.getMessage(), "UTF-8"));
        }
    }
}