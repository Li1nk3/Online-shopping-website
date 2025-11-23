package com.javanet.dao;

import com.javanet.model.CustomerBrowseLog;
import com.javanet.model.User;
import com.javanet.model.Product;
import com.javanet.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerBrowseLogDAO {
    
    public boolean addBrowseLog(CustomerBrowseLog log) {
        // 首先尝试新结构（不包含时间字段，使用默认的created_at）
        String sql = "INSERT INTO customer_browse_logs (user_id, product_id, session_id, ip_address, user_agent) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, log.getUserId());
            stmt.setObject(2, log.getProductId());
            stmt.setString(3, log.getSessionId());
            stmt.setString(4, log.getIpAddress());
            stmt.setString(5, log.getUserAgent());
            
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in addBrowseLog: " + e.getMessage());
            e.printStackTrace();
            
            // 如果新结构失败，尝试旧结构（包含browse_time字段）
            if (e.getMessage().contains("Unknown column")) {
                return addBrowseLogOldStructure(log);
            }
            return false;
        } catch (Exception e) {
            System.err.println("General Error in addBrowseLog: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // 兼容旧数据库结构的方法
    private boolean addBrowseLogOldStructure(CustomerBrowseLog log) {
        String sql = "INSERT INTO customer_browse_logs (user_id, product_id, session_id, ip_address, user_agent, browse_time, duration_seconds) VALUES (?, ?, ?, ?, ?, ?, 0)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, log.getUserId());
            stmt.setObject(2, log.getProductId());
            stmt.setString(3, log.getSessionId());
            stmt.setString(4, log.getIpAddress());
            stmt.setString(5, log.getUserAgent());
            stmt.setTimestamp(6, log.getCreatedAt());
            
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in addBrowseLogOldStructure: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("General Error in addBrowseLogOldStructure: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // 移除更新浏览时长的方法，不再需要
    
    public List<CustomerBrowseLog> getBrowseLogsByUserId(int userId, int limit) {
        return getBrowseLogsByUserId(userId, 0, limit);
    }
    
    public List<CustomerBrowseLog> getBrowseLogsByUserId(int userId, int offset, int limit) {
        List<CustomerBrowseLog> logs = new ArrayList<>();
        
        // 修改查询：去重，每个商品只显示最近一次浏览记录
        String sql = "SELECT cbl.*, u.username, p.name as product_name, p.image_url, p.id as product_id " +
                    "FROM customer_browse_logs cbl " +
                    "LEFT JOIN users u ON cbl.user_id = u.id " +
                    "LEFT JOIN products p ON cbl.product_id = p.id " +
                    "INNER JOIN (" +
                    "    SELECT product_id, MAX(created_at) as max_time " +
                    "    FROM customer_browse_logs " +
                    "    WHERE user_id = ? " +
                    "    GROUP BY product_id" +
                    ") latest ON cbl.product_id = latest.product_id AND cbl.created_at = latest.max_time " +
                    "WHERE cbl.user_id = ? " +
                    "ORDER BY cbl.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, limit);
            stmt.setInt(4, offset);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerBrowseLog log = new CustomerBrowseLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("user_id"));
                log.setProductId(rs.getInt("product_id"));
                log.setSessionId(rs.getString("session_id"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setUserAgent(rs.getString("user_agent"));
                
                // 兼容新旧字段名
                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp == null) {
                    timestamp = rs.getTimestamp("browse_time"); // 尝试旧字段名
                }
                log.setCreatedAt(timestamp);
                
                // 设置关联信息
                User user = new User();
                user.setUsername(rs.getString("username"));
                log.setUser(user);
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));
                product.setImageUrl(rs.getString("image_url"));
                log.setProduct(product);
                
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getBrowseLogsByUserId: " + e.getMessage());
            e.printStackTrace();
            
            // 如果新结构失败，尝试旧结构（browse_time）
            if (e.getMessage().contains("Unknown column 'created_at'")) {
                return getBrowseLogsByUserIdOldStructure(userId, offset, limit);
            }
        } catch (Exception e) {
            System.err.println("General Error in getBrowseLogsByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }
    
    // 兼容旧数据库结构的方法（也支持去重）
    private List<CustomerBrowseLog> getBrowseLogsByUserIdOldStructure(int userId, int offset, int limit) {
        List<CustomerBrowseLog> logs = new ArrayList<>();
        String sql = "SELECT cbl.*, u.username, p.name as product_name, p.image_url, p.id as product_id " +
                    "FROM customer_browse_logs cbl " +
                    "LEFT JOIN users u ON cbl.user_id = u.id " +
                    "LEFT JOIN products p ON cbl.product_id = p.id " +
                    "INNER JOIN (" +
                    "    SELECT product_id, MAX(browse_time) as max_time " +
                    "    FROM customer_browse_logs " +
                    "    WHERE user_id = ? " +
                    "    GROUP BY product_id" +
                    ") latest ON cbl.product_id = latest.product_id AND cbl.browse_time = latest.max_time " +
                    "WHERE cbl.user_id = ? " +
                    "ORDER BY cbl.browse_time DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, limit);
            stmt.setInt(4, offset);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerBrowseLog log = new CustomerBrowseLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("user_id"));
                log.setProductId(rs.getInt("product_id"));
                log.setSessionId(rs.getString("session_id"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setUserAgent(rs.getString("user_agent"));
                log.setCreatedAt(rs.getTimestamp("browse_time")); // 使用旧字段名
                
                // 设置关联信息
                User user = new User();
                user.setUsername(rs.getString("username"));
                log.setUser(user);
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));
                product.setImageUrl(rs.getString("image_url"));
                log.setProduct(product);
                
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getBrowseLogsByUserIdOldStructure: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General Error in getBrowseLogsByUserIdOldStructure: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }
    
    public List<CustomerBrowseLog> getBrowseLogsBySellerId(int sellerId, int limit) {
        List<CustomerBrowseLog> logs = new ArrayList<>();
        String sql = "SELECT cbl.*, u.username, p.name as product_name, p.image_url, " +
                    "(SELECT COUNT(*) FROM customer_browse_logs cbl2 WHERE cbl2.user_id = cbl.user_id AND cbl2.product_id = cbl.product_id) as browse_count " +
                    "FROM customer_browse_logs cbl " +
                    "LEFT JOIN users u ON cbl.user_id = u.id " +
                    "LEFT JOIN products p ON cbl.product_id = p.id " +
                    "WHERE p.seller_id = ? " +
                    "ORDER BY cbl.created_at DESC " +
                    "LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerBrowseLog log = new CustomerBrowseLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("user_id"));
                log.setProductId(rs.getInt("product_id"));
                log.setSessionId(rs.getString("session_id"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setUserAgent(rs.getString("user_agent"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                
                // 设置浏览次数和浏览时间
                log.setDurationSeconds(rs.getInt("browse_count"));
                log.setBrowseTime(rs.getTimestamp("created_at"));
                
                // 设置关联信息
                User user = new User();
                user.setUsername(rs.getString("username"));
                log.setUser(user);
                
                Product product = new Product();
                product.setName(rs.getString("product_name"));
                product.setImageUrl(rs.getString("image_url"));
                log.setProduct(product);
                
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
    
    public List<CustomerBrowseLog> getHotProducts(int days, int limit) {
        List<CustomerBrowseLog> logs = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.image_url, COUNT(cbl.id) as browse_count " +
                    "FROM customer_browse_logs cbl " +
                    "INNER JOIN products p ON cbl.product_id = p.id " +
                    "WHERE cbl.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "GROUP BY p.id, p.name, p.image_url " +
                    "ORDER BY browse_count DESC " +
                    "LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, days);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerBrowseLog log = new CustomerBrowseLog();
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImageUrl(rs.getString("image_url"));
                log.setProduct(product);
                
                // 设置浏览次数到durationSeconds字段（用于页面显示）
                log.setDurationSeconds(rs.getInt("browse_count"));
                
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getHotProducts: " + e.getMessage());
            e.printStackTrace();
            
            // 如果新结构失败，尝试旧结构（browse_time）
            if (e.getMessage().contains("Unknown column 'created_at'")) {
                return getHotProductsOldStructure(days, limit);
            }
        } catch (Exception e) {
            System.err.println("General Error in getHotProducts: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }
    
    // 兼容旧数据库结构的方法
    private List<CustomerBrowseLog> getHotProductsOldStructure(int days, int limit) {
        List<CustomerBrowseLog> logs = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.image_url, COUNT(cbl.id) as browse_count " +
                    "FROM customer_browse_logs cbl " +
                    "INNER JOIN products p ON cbl.product_id = p.id " +
                    "WHERE cbl.browse_time >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "GROUP BY p.id, p.name, p.image_url " +
                    "ORDER BY browse_count DESC " +
                    "LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, days);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerBrowseLog log = new CustomerBrowseLog();
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setImageUrl(rs.getString("image_url"));
                log.setProduct(product);
                
                // 设置浏览次数到durationSeconds字段（用于页面显示）
                log.setDurationSeconds(rs.getInt("browse_count"));
                
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getHotProductsOldStructure: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General Error in getHotProductsOldStructure: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }
    
    public int getTotalBrowseCountByProductId(int productId) {
        String sql = "SELECT COUNT(*) FROM customer_browse_logs WHERE product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<CustomerBrowseLog> getCustomerBrowseStats(int sellerId, int days) {
        List<CustomerBrowseLog> stats = new ArrayList<>();
        String sql = "SELECT u.id, u.username, COUNT(cbl.id) as browse_count, " +
                    "COUNT(DISTINCT cbl.product_id) as product_count " +
                    "FROM customer_browse_logs cbl " +
                    "INNER JOIN products p ON cbl.product_id = p.id " +
                    "INNER JOIN users u ON cbl.user_id = u.id " +
                    "WHERE p.seller_id = ? AND cbl.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "GROUP BY u.id, u.username " +
                    "ORDER BY browse_count DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sellerId);
            stmt.setInt(2, days);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CustomerBrowseLog stat = new CustomerBrowseLog();
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                stat.setUser(user);
                // 可以通过其他方式传递商品数量
                stats.add(stat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * 清空指定用户的所有浏览记录
     * @param userId 用户ID
     * @return 如果清空成功返回true,否则返回false
     */
    public boolean clearUserBrowseLogs(int userId) {
        String sql = "DELETE FROM customer_browse_logs WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 清空指定商品的所有浏览记录
     * @param productId 商品ID
     * @return 如果清空成功返回true,否则返回false
     */
    public boolean clearProductBrowseLogs(int productId) {
        String sql = "DELETE FROM customer_browse_logs WHERE product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 清空所有浏览记录（管理员功能）
     * @return 如果清空成功返回true,否则返回false
     */
    public boolean clearAllBrowseLogs() {
        String sql = "DELETE FROM customer_browse_logs";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 获取用户的浏览记录总数
     * @param userId 用户ID
     * @return 浏览记录总数
     */
    public int getUserBrowseLogCount(int userId) {
        // 修改为统计去重后的商品数量
        String sql = "SELECT COUNT(DISTINCT product_id) FROM customer_browse_logs WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getUserBrowseLogCount: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General Error in getUserBrowseLogCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * 删除指定的浏览记录（验证用户权限）
     * @param logId 记录ID
     * @param userId 用户ID
     * @return 如果删除成功返回true,否则返回false
     */
    public boolean deleteBrowseLog(int logId, int userId) {
        String sql = "DELETE FROM customer_browse_logs WHERE id = ? AND user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, logId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}