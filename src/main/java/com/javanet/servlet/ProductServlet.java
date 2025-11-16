package com.javanet.servlet;

import com.javanet.model.Product;
import com.javanet.model.ProductImage;
import com.javanet.dao.ProductDAO;
import com.javanet.dao.ProductImageDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private ProductImageDAO productImageDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        productImageDAO = new ProductImageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String productId = request.getParameter("id");
            
            if (productId != null) {
                // 显示单个商品详情
                Product product = productDAO.getProductById(Integer.parseInt(productId));
                if (product != null) {
                    // 加载商品图片
                    List<ProductImage> images = productImageDAO.getImagesByProductId(product.getId());
                    product.setImages(images);
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "商品不存在");
                }
            } else {
                // 显示商品列表
                List<Product> products = productDAO.getAllProducts();
                
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