package com.javanet.dao;

import com.javanet.model.CustomerPurchaseStats;
import com.javanet.model.User;
import com.javanet.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerPurchaseStatsDAO {
    
    public boolean addOrUpdatePurchaseStats(int userId, int sellerId, java.math.BigDecimal amount) {
        String sql = "INSERT INTO customer_purchase_stats (user_id, seller_id, total_orders, total_amount, last_purchase_date) " +
                    "VALUES (?, ?, 1, ?, NOW()) " +
                    "ON DUPLICATE KEY UPDATE " +
                    "total_orders = total_orders + 1, " +
                    "total_amount = total_amount + ?, " +
                    "last_purchase_date = NOW(), " +
                    "updated_at = NOW()";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, sellerId);
            stmt.setBigDecimal(3, amount);
            stmt.setBigDecimal(4, amount);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<CustomerPurchaseStats> getPurchaseStatsBySellerId(int sellerId) {
        List<CustomerPurchaseStats> stats = new ArrayList<>();
        String sql = "SELECT cps.*, u.username, u.email, u.phone " +
                    "FROM customer_purchase_stats cps " +
                    "INNER JOIN users u ON cps.user_id = u.id " +
                    "WHERE cps.seller_id = ? " +
                    "ORDER BY cps.total_amount DESC, cps.last_purchase_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerPurchaseStats stat = new CustomerPurchaseStats();
                stat.setId(rs.getInt("id"));
                stat.setUserId(rs.getInt("user_id"));
                stat.setSellerId(rs.getInt("seller_id"));
                stat.setTotalOrders(rs.getInt("total_orders"));
                stat.setTotalAmount(rs.getBigDecimal("total_amount"));
                stat.setLastPurchaseDate(rs.getTimestamp("last_purchase_date"));
                stat.setCreatedAt(rs.getTimestamp("created_at"));
                stat.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                stat.setUser(user);
                
                stats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    public List<CustomerPurchaseStats> getTopCustomersBySellerId(int sellerId, int limit) {
        List<CustomerPurchaseStats> stats = new ArrayList<>();
        String sql = "SELECT cps.*, u.username, u.email, u.phone " +
                    "FROM customer_purchase_stats cps " +
                    "INNER JOIN users u ON cps.user_id = u.id " +
                    "WHERE cps.seller_id = ? " +
                    "ORDER BY cps.total_amount DESC " +
                    "LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerPurchaseStats stat = new CustomerPurchaseStats();
                stat.setId(rs.getInt("id"));
                stat.setUserId(rs.getInt("user_id"));
                stat.setSellerId(rs.getInt("seller_id"));
                stat.setTotalOrders(rs.getInt("total_orders"));
                stat.setTotalAmount(rs.getBigDecimal("total_amount"));
                stat.setLastPurchaseDate(rs.getTimestamp("last_purchase_date"));
                
                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                stat.setUser(user);
                
                stats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    public CustomerPurchaseStats getPurchaseStatsByUserAndSeller(int userId, int sellerId) {
        String sql = "SELECT cps.*, u.username, u.email, u.phone " +
                    "FROM customer_purchase_stats cps " +
                    "INNER JOIN users u ON cps.user_id = u.id " +
                    "WHERE cps.user_id = ? AND cps.seller_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, sellerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                CustomerPurchaseStats stat = new CustomerPurchaseStats();
                stat.setId(rs.getInt("id"));
                stat.setUserId(rs.getInt("user_id"));
                stat.setSellerId(rs.getInt("seller_id"));
                stat.setTotalOrders(rs.getInt("total_orders"));
                stat.setTotalAmount(rs.getBigDecimal("total_amount"));
                stat.setLastPurchaseDate(rs.getTimestamp("last_purchase_date"));
                stat.setCreatedAt(rs.getTimestamp("created_at"));
                stat.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                stat.setUser(user);
                
                return stat;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<CustomerPurchaseStats> getRecentCustomers(int sellerId, int days) {
        List<CustomerPurchaseStats> stats = new ArrayList<>();
        String sql = "SELECT cps.*, u.username, u.email, u.phone " +
                    "FROM customer_purchase_stats cps " +
                    "INNER JOIN users u ON cps.user_id = u.id " +
                    "WHERE cps.seller_id = ? AND cps.last_purchase_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "ORDER BY cps.last_purchase_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerPurchaseStats stat = new CustomerPurchaseStats();
                stat.setId(rs.getInt("id"));
                stat.setUserId(rs.getInt("user_id"));
                stat.setSellerId(rs.getInt("seller_id"));
                stat.setTotalOrders(rs.getInt("total_orders"));
                stat.setTotalAmount(rs.getBigDecimal("total_amount"));
                stat.setLastPurchaseDate(rs.getTimestamp("last_purchase_date"));
                
                // 设置用户信息
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                stat.setUser(user);
                
                stats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    public java.math.BigDecimal getTotalRevenueBySellerId(int sellerId) {
        String sql = "SELECT SUM(total_amount) as total_revenue FROM customer_purchase_stats WHERE seller_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total_revenue");
            }
        } catch (SQLException e) {
            System.err.println("获取总收入失败 - sellerId: " + sellerId);
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("获取总收入时发生未知错误 - sellerId: " + sellerId);
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    public int getTotalCustomersBySellerId(int sellerId) {
        String sql = "SELECT COUNT(*) as total_customers FROM customer_purchase_stats WHERE seller_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_customers");
            }
        } catch (SQLException e) {
            System.err.println("获取总客户数失败 - sellerId: " + sellerId);
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("获取总客户数时发生未知错误 - sellerId: " + sellerId);
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<CustomerPurchaseStats> getCustomerPurchaseTrend(int sellerId, int months) {
        List<CustomerPurchaseStats> stats = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(cps.last_purchase_date, '%Y-%m') as month, " +
                    "COUNT(*) as customer_count, SUM(cps.total_amount) as month_revenue " +
                    "FROM customer_purchase_stats cps " +
                    "WHERE cps.seller_id = ? AND cps.last_purchase_date >= DATE_SUB(NOW(), INTERVAL ? MONTH) " +
                    "GROUP BY DATE_FORMAT(cps.last_purchase_date, '%Y-%m') " +
                    "ORDER BY month DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            stmt.setInt(2, months);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerPurchaseStats stat = new CustomerPurchaseStats();
                stat.setTotalOrders(rs.getInt("customer_count"));
                stat.setTotalAmount(rs.getBigDecimal("month_revenue"));
                // 可以通过其他方式传递月份信息
                stats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}