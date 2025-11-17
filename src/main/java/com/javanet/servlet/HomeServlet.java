package com.javanet.servlet;

import com.javanet.dao.ProductDAO;
import com.javanet.dao.ProductImageDAO;
import com.javanet.model.Product;
import com.javanet.model.ProductImage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private ProductImageDAO productImageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取所有商品
            List<Product> allProducts = productDAO.getAllProducts();
            
            // 为每个商品加载图片
            for (Product product : allProducts) {
                List<ProductImage> images = productImageDAO.getImagesByProductId(product.getId());
                product.setImages(images);
            }
            
            // 获取推荐商品（前3个）
            List<Product> featuredProducts = allProducts.stream()
                    .limit(3)
                    .collect(Collectors.toList());
            
            // 获取新品（按ID倒序，最新6个）
            List<Product> newProducts = allProducts.stream()
                    .sorted((p1, p2) -> Integer.compare(p2.getId(), p1.getId()))
                    .limit(6)
                    .collect(Collectors.toList());
            
            // 获取所有分类
            List<String> categories = productDAO.getAllCategories();

            request.setAttribute("featuredProducts", featuredProducts);
            request.setAttribute("newProducts", newProducts);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取首页数据失败");
        }
    }
}