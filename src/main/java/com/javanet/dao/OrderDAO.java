package com.javanet.dao;

import com.javanet.model.Order;
import com.javanet.model.OrderItem;
import com.javanet.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, order_number, total_amount, status, order_status, " +
                    "payment_method, payment_status, shipping_address) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, order.getUserId());
            stmt.setString(2, order.getOrderNumber());
            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setString(4, order.getStatus());
            stmt.setString(5, order.getOrderStatus());
            stmt.setString(6, order.getPaymentMethod());
            stmt.setString(7, order.getPaymentStatus());
            stmt.setString(8, order.getShippingAddress());
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean addOrderItem(int orderId, int productId, int quantity, java.math.BigDecimal price) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            stmt.setBigDecimal(4, price);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setCreateTime(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setCreateTime(rs.getTimestamp("created_at"));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateOrderStatus(int orderId, String orderStatus, String paymentStatus) {
        String sql = "UPDATE orders SET order_status = ?, payment_status = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, orderStatus);
            stmt.setString(2, paymentStatus);
            stmt.setInt(3, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public String generateOrderNumber() {
        return "ORD" + System.currentTimeMillis();
    }
    
    /**
     * 检查用户是否购买过指定商品
     * @param userId 用户ID
     * @param productId 商品ID
     * @return 如果购买过返回true,否则返回false
     */
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM orders o " +
                    "INNER JOIN order_items oi ON o.id = oi.order_id " +
                    "WHERE o.user_id = ? AND oi.product_id = ? AND o.payment_status = '已支付'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * 获取订单的所有商品项
     * @param orderId 订单ID
     * @return 订单商品项列表
     */
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as product_name, p.image_url " +
                    "FROM order_items oi " +
                    "INNER JOIN products p ON oi.product_id = p.id " +
                    "WHERE oi.order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setImageUrl(rs.getString("image_url"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    /**
     * 获取卖家的所有订单(包含该卖家商品的订单)
     * @param sellerId 卖家ID
     * @return 订单列表
     */
    public List<Order> getOrdersBySellerId(int sellerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT DISTINCT o.* FROM orders o " +
                    "INNER JOIN order_items oi ON o.id = oi.order_id " +
                    "INNER JOIN products p ON oi.product_id = p.id " +
                    "WHERE p.seller_id = ? " +
                    "ORDER BY o.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setCreateTime(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    /**
     * 获取订单中属于指定卖家的商品项
     * @param orderId 订单ID
     * @param sellerId 卖家ID
     * @return 商品项列表
     */
    public List<OrderItem> getSellerOrderItems(int orderId, int sellerId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as product_name, p.image_url " +
                    "FROM order_items oi " +
                    "INNER JOIN products p ON oi.product_id = p.id " +
                    "WHERE oi.order_id = ? AND p.seller_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setInt(2, sellerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setImageUrl(rs.getString("image_url"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}