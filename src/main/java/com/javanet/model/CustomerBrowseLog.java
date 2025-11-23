package com.javanet.model;

import java.sql.Timestamp;

public class CustomerBrowseLog {
    private int id;
    private Integer userId;
    private Integer productId;
    private String sessionId;
    private String ipAddress;
    private String userAgent;
    private Timestamp createdAt;
    private int durationSeconds; // 用于存储浏览次数统计
    private Timestamp browseTime; // 浏览时间（用于JSP显示）
    
    // 关联信息（用于显示）
    private User user;
    private Product product;
    
    public CustomerBrowseLog() {}
    
    public CustomerBrowseLog(Integer userId, Integer productId, String sessionId,
                            String ipAddress, String userAgent) {
        this.userId = userId;
        this.productId = productId;
        this.sessionId = sessionId;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    
    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public int getDurationSeconds() { return durationSeconds; }
    public void setDurationSeconds(int durationSeconds) { this.durationSeconds = durationSeconds; }
    
    public Timestamp getBrowseTime() { return browseTime; }
    public void setBrowseTime(Timestamp browseTime) { this.browseTime = browseTime; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}