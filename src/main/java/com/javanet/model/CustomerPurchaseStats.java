package com.javanet.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class CustomerPurchaseStats {
    private int id;
    private int userId;
    private int sellerId;
    private int totalOrders;
    private BigDecimal totalAmount;
    private Timestamp lastPurchaseDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // 关联信息（用于显示）
    private User user;
    private User seller;
    
    public CustomerPurchaseStats() {}
    
    public CustomerPurchaseStats(int userId, int sellerId) {
        this.userId = userId;
        this.sellerId = sellerId;
        this.totalOrders = 0;
        this.totalAmount = BigDecimal.ZERO;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    
    public Timestamp getLastPurchaseDate() { return lastPurchaseDate; }
    public void setLastPurchaseDate(Timestamp lastPurchaseDate) { this.lastPurchaseDate = lastPurchaseDate; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public User getSeller() { return seller; }
    public void setSeller(User seller) { this.seller = seller; }
    
    // 计算平均订单金额
    public BigDecimal getAverageOrderAmount() {
        if (totalOrders > 0) {
            return totalAmount.divide(new BigDecimal(totalOrders), 2, BigDecimal.ROUND_HALF_UP);
        }
        return BigDecimal.ZERO;
    }
}