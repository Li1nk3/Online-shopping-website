package com.javanet.servlet;

import com.javanet.dao.ProductDAO;
import com.javanet.dao.ProductImageDAO;
import com.javanet.model.Product;
import com.javanet.model.ProductImage;
import com.javanet.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/product-management")
public class ProductManagementServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private ProductImageDAO productImageDAO = new ProductImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 检查用户是否登录且为卖家
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有卖家才能访问商品管理");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                // 编辑商品
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少商品ID参数");
                    return;
                }
                int productId = Integer.parseInt(idParam);
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    // 加载商品图片
                    List<ProductImage> images = productImageDAO.getImagesByProductId(productId);
                    product.setImages(images);
                    request.setAttribute("product", product);
                    // 获取所有分类
                    List<String> categories = productDAO.getAllCategories();
                    request.setAttribute("categories", categories);
                    request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "商品不存在");
                }
            } else if ("delete".equals(action)) {
                // 删除商品
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少商品ID参数");
                    return;
                }
                int productId = Integer.parseInt(idParam);
                
                // 验证商品所有权
                Product product = productDAO.getProductById(productId);
                if (product != null && !"admin".equals(user.getRole()) &&
                    product.getSellerId() != user.getId()) {
                    response.sendRedirect("product-management?error=您没有权限删除此商品");
                    return;
                }
                
                boolean success = productDAO.deleteProduct(productId);
                if (success) {
                    response.sendRedirect("product-management?message=删除成功");
                } else {
                    response.sendRedirect("product-management?error=删除失败");
                }
            } else if ("add".equals(action)) {
                // 添加新商品表单
                // 获取所有分类
                List<String> categories = productDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
            } else {
                // 显示商品列表 - 只显示该卖家的商品
                List<Product> products;
                if ("admin".equals(user.getRole())) {
                    // 管理员可以看到所有商品
                    products = productDAO.getAllProducts();
                } else {
                    // 卖家只能看到自己的商品
                    products = productDAO.getProductsBySeller(user.getId());
                }
                request.setAttribute("products", products);
                
                // 传递消息
                String message = request.getParameter("message");
                String error = request.getParameter("error");
                if (message != null) {
                    request.setAttribute("message", message);
                }
                if (error != null) {
                    request.setAttribute("error", error);
                }
                
                request.getRequestDispatcher("/WEB-INF/views/product-management.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 检查用户是否登录且为卖家
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        if (!"seller".equals(user.getRole()) && !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "只有卖家才能管理商品");
            return;
        }
        
        try {
            // 获取表单数据
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String category = request.getParameter("category");
            String[] imageUrls = request.getParameterValues("imageUrls");
            String primaryImageIndexStr = request.getParameter("primaryImageIndex");
            String productIdStr = request.getParameter("productId");
            
            // 验证必填字段
            if (name == null || name.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                stockStr == null || stockStr.trim().isEmpty() ||
                category == null || category.trim().isEmpty()) {
                
                request.setAttribute("error", "请填写所有必填字段");
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.setAttribute("price", priceStr);
                request.setAttribute("stock", stockStr);
                request.setAttribute("category", category);
                
                if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                    request.setAttribute("productId", productIdStr);
                }
                
                request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
                return;
            }
            
            // 验证图片
            List<String> validImageUrls = new ArrayList<>();
            if (imageUrls != null) {
                for (String url : imageUrls) {
                    if (url != null && !url.trim().isEmpty()) {
                        validImageUrls.add(url.trim());
                    }
                }
            }
            
            if (validImageUrls.isEmpty()) {
                request.setAttribute("error", "请至少添加一张商品图片");
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.setAttribute("price", priceStr);
                request.setAttribute("stock", stockStr);
                request.setAttribute("category", category);
                
                if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                    request.setAttribute("productId", productIdStr);
                }
                
                request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
                return;
            }
            
            // 解析数值
            BigDecimal price;
            int stock;
            try {
                price = new BigDecimal(priceStr);
                stock = Integer.parseInt(stockStr);
                
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new IllegalArgumentException("价格必须大于0");
                }
                if (stock < 0) {
                    throw new IllegalArgumentException("库存不能为负数");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "价格和库存必须为有效数字");
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.setAttribute("price", priceStr);
                request.setAttribute("stock", stockStr);
                request.setAttribute("category", category);
                
                if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                    request.setAttribute("productId", productIdStr);
                }
                
                request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
                return;
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "价格和库存必须为有效数字，且价格大于0，库存不能为负数");
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.setAttribute("price", priceStr);
                request.setAttribute("stock", stockStr);
                request.setAttribute("category", category);
                
                if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                    request.setAttribute("productId", productIdStr);
                }
                
                request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
                return;
            }
            
            // 解析主图索引
            int primaryImageIndex = 0;
            if (primaryImageIndexStr != null && !primaryImageIndexStr.trim().isEmpty()) {
                try {
                    primaryImageIndex = Integer.parseInt(primaryImageIndexStr);
                    if (primaryImageIndex < 0 || primaryImageIndex >= validImageUrls.size()) {
                        primaryImageIndex = 0;
                    }
                } catch (NumberFormatException e) {
                    primaryImageIndex = 0;
                }
            }
            
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description.trim());
            product.setPrice(price);
            product.setStock(stock);
            product.setCategory(category.trim());
            product.setSellerId(user.getId());
            // 设置主图URL用于向后兼容
            product.setImageUrl(validImageUrls.get(primaryImageIndex));
            
            boolean success;
            String successMessage;
            
            if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                // 更新商品
                int productId = Integer.parseInt(productIdStr);
                product.setId(productId);
                
                // 验证商品所有权
                Product existingProduct = productDAO.getProductById(productId);
                if (existingProduct != null && !"admin".equals(user.getRole()) &&
                    existingProduct.getSellerId() != user.getId()) {
                    request.setAttribute("error", "您没有权限修改此商品");
                    request.setAttribute("name", name);
                    request.setAttribute("description", description);
                    request.setAttribute("price", priceStr);
                    request.setAttribute("stock", stockStr);
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
                    return;
                }
                
                success = productDAO.updateProduct(product);
                
                if (success) {
                    // 删除旧图片
                    productImageDAO.deleteImagesByProductId(productId);
                    
                    // 添加新图片
                    for (int i = 0; i < validImageUrls.size(); i++) {
                        ProductImage image = new ProductImage();
                        image.setProductId(productId);
                        image.setImageUrl(validImageUrls.get(i));
                        image.setDisplayOrder(i);
                        image.setPrimary(i == primaryImageIndex);
                        productImageDAO.addImage(image);
                    }
                }
                successMessage = "商品更新成功";
            } else {
                // 添加新商品
                success = productDAO.addProduct(product);
                
                if (success) {
                    // 获取新添加商品的ID
                    int newProductId = product.getId();
                    
                    // 添加图片
                    for (int i = 0; i < validImageUrls.size(); i++) {
                        ProductImage image = new ProductImage();
                        image.setProductId(newProductId);
                        image.setImageUrl(validImageUrls.get(i));
                        image.setDisplayOrder(i);
                        image.setPrimary(i == primaryImageIndex);
                        productImageDAO.addImage(image);
                    }
                }
                successMessage = "商品添加成功";
            }
            
            if (success) {
                response.sendRedirect("product-management?message=" + java.net.URLEncoder.encode(successMessage, "UTF-8"));
            } else {
                request.setAttribute("error", "操作失败，请重试");
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.setAttribute("price", priceStr);
                request.setAttribute("stock", stockStr);
                request.setAttribute("category", category);
                
                if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                    request.setAttribute("productId", productIdStr);
                }
                
                request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器错误: " + e.getMessage());
        }
    }
}