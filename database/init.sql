-- 创建数据库
CREATE DATABASE IF NOT EXISTS javanet_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE javanet_shop;

-- 创建用户表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('buyer', 'seller', 'admin') DEFAULT 'buyer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建商品表
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    image_url VARCHAR(255),
    seller_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(id)
);

-- 创建订单表
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    order_status ENUM('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending',
    payment_method VARCHAR(20) DEFAULT 'online',
    payment_status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 创建订单详情表
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 创建购物车表
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- 创建商品图片表
CREATE TABLE product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    display_order INT DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 创建客户浏览日志表（简化版本）
-- user_id 允许 NULL，支持未登录用户浏览
CREATE TABLE customer_browse_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    product_id INT,
    session_id VARCHAR(100),
    ip_address VARCHAR(45),
    user_agent TEXT,
    duration_seconds INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_user_created (user_id, created_at),
    INDEX idx_product_created (product_id, created_at),
    INDEX idx_duration (duration_seconds)
);

-- 创建客户购买统计表
CREATE TABLE customer_purchase_stats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    seller_id INT NOT NULL,
    total_orders INT DEFAULT 0,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    last_purchase_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (seller_id) REFERENCES users(id),
    UNIQUE KEY unique_user_seller (user_id, seller_id)
);

-- 创建产品评价表
CREATE TABLE product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    UNIQUE KEY unique_product_order (product_id, order_id)
);

-- 插入测试用户
INSERT INTO users (username, password, email, phone, address, role) VALUES
('admin', 'admin123', 'admin@javanet.com', '13800138000', '北京市朝阳区', 'admin'),
('seller1', 'seller123', 'seller1@javanet.com', '13900139001', '上海市浦东新区', 'seller'),
('seller2', 'seller123', 'seller2@javanet.com', '13900139002', '广州市天河区', 'seller'),
('buyer1', 'buyer123', 'buyer1@javanet.com', '13900139003', '深圳市南山区', 'buyer'),
('buyer2', 'buyer123', 'buyer2@javanet.com', '13900139004', '杭州市西湖区', 'buyer');

-- 插入测试商品
INSERT INTO products (name, description, price, stock, category, image_url, seller_id) VALUES
('MacBook Pro 14寸', 'Apple M3 Pro芯片，18GB内存，512GB存储', 12999.00, 50, '电子产品', 'images/products/macbook.jpg', 2),
('iPhone 15 Pro', 'Apple A17 Pro芯片，256GB存储，钛金属设计', 8999.00, 100, '电子产品', 'images/products/iphone15.jpg', 2),
('华为Mate 60 Pro', '麒麟9000S芯片，512GB存储，卫星通话', 6999.00, 80, '电子产品', 'images/products/huawei.jpg', 3),
('小米13 Ultra', '骁龙8 Gen2芯片，256GB存储，徕卡影像', 5999.00, 120, '电子产品', 'images/products/mi13.jpg', 3),
('AirPods Pro 2', '主动降噪，空间音频，USB-C充电盒', 1899.00, 200, '电子产品', 'images/products/airpods.jpg', 2);

-- 插入商品图片
INSERT INTO product_images (product_id, image_url, display_order, is_primary) VALUES
(1, 'images/products/macbook.jpg', 0, TRUE),
(2, 'images/products/iphone15.jpg', 0, TRUE),
(3, 'images/products/huawei.jpg', 0, TRUE),
(4, 'images/products/mi13.jpg', 0, TRUE),
(5, 'images/products/airpods.jpg', 0, TRUE);

-- 插入一些示例浏览记录（用于测试客户管理功能）
INSERT INTO customer_browse_logs (user_id, product_id, session_id, ip_address, user_agent, duration_seconds) VALUES
(4, 1, 'session_001', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 3),
(4, 2, 'session_001', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 2),
(5, 1, 'session_002', '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', 5),
(5, 3, 'session_002', '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', 1),
(4, 4, 'session_003', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 2);

-- 插入一些示例购买统计（用于测试客户管理功能）
INSERT INTO customer_purchase_stats (user_id, seller_id, total_orders, total_amount, last_purchase_date) VALUES
(4, 2, 2, 21998.00, '2024-01-15 10:30:00'),
(4, 3, 1, 6999.00, '2024-01-20 14:20:00'),
(5, 2, 1, 12999.00, '2024-01-18 16:45:00');

-- 创建索引以优化查询性能
CREATE INDEX idx_products_seller ON products(seller_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_product_images_product ON product_images(product_id);
CREATE INDEX idx_reviews_product ON product_reviews(product_id);
CREATE INDEX idx_reviews_user ON product_reviews(user_id);