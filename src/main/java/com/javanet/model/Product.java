package com.javanet.model;

import java.math.BigDecimal;
import java.util.List;

public class Product {
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private String category;
    private String imageUrl;
    private int sellerId;
    private List<ProductImage> images;
    
    public Product() {}
    
    public Product(String name, String description, BigDecimal price, int stock, String category, String imageUrl) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category = category;
        this.imageUrl = imageUrl;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    
    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }
    
    // 获取主图片URL，优先使用图片列表中的主图片
    public String getPrimaryImageUrl() {
        if (images != null && !images.isEmpty()) {
            for (ProductImage image : images) {
                if (image.isPrimary()) {
                    return image.getImageUrl();
                }
            }
            // 如果没有设置主图片，返回第一张图片
            return images.get(0).getImageUrl();
        }
        // 如果没有图片列表，返回原来的imageUrl
        return imageUrl;
    }
}