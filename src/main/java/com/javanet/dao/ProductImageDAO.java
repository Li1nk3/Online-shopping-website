package com.javanet.dao;

import com.javanet.model.ProductImage;
import com.javanet.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDAO {
    
    public List<ProductImage> getProductImages(int productId) {
        List<ProductImage> images = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY display_order, id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ProductImage image = new ProductImage();
                image.setId(rs.getInt("id"));
                image.setProductId(rs.getInt("product_id"));
                image.setImageUrl(rs.getString("image_url"));
                image.setDisplayOrder(rs.getInt("display_order"));
                image.setPrimary(rs.getBoolean("is_primary"));
                image.setCreatedAt(rs.getTimestamp("created_at"));
                images.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }
    
    public ProductImage getPrimaryImage(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = ? AND is_primary = true LIMIT 1";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                ProductImage image = new ProductImage();
                image.setId(rs.getInt("id"));
                image.setProductId(rs.getInt("product_id"));
                image.setImageUrl(rs.getString("image_url"));
                image.setDisplayOrder(rs.getInt("display_order"));
                image.setPrimary(rs.getBoolean("is_primary"));
                image.setCreatedAt(rs.getTimestamp("created_at"));
                return image;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addProductImage(ProductImage image) {
        String sql = "INSERT INTO product_images (product_id, image_url, display_order, is_primary) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, image.getProductId());
            stmt.setString(2, image.getImageUrl());
            stmt.setInt(3, image.getDisplayOrder());
            stmt.setBoolean(4, image.isPrimary());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteProductImages(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePrimaryImage(int productId, int imageId) {
        String sql1 = "UPDATE product_images SET is_primary = false WHERE product_id = ?";
        String sql2 = "UPDATE product_images SET is_primary = true WHERE id = ? AND product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmt1 = conn.prepareStatement(sql1);
                 PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                
                stmt1.setInt(1, productId);
                stmt1.executeUpdate();
                
                stmt2.setInt(1, imageId);
                stmt2.setInt(2, productId);
                int result = stmt2.executeUpdate();
                
                conn.commit();
                return result > 0;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // 添加缺失的方法别名
    public List<ProductImage> getImagesByProductId(int productId) {
        return getProductImages(productId);
    }
    
    public boolean addImage(ProductImage image) {
        return addProductImage(image);
    }
    
    public boolean deleteImagesByProductId(int productId) {
        return deleteProductImages(productId);
    }
}