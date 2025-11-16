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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建订单表
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
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

-- 插入示例商品数据
INSERT INTO products (name, description, price, stock, category, image_url) VALUES
('iPhone 15', '苹果最新款智能手机', 6999.00, 50, '手机', '/images/iphone15.jpg'),
('MacBook Pro', '苹果笔记本电脑', 12999.00, 30, '电脑', '/images/macbook.jpg'),
('AirPods Pro', '苹果无线耳机', 1999.00, 100, '耳机', '/images/airpods.jpg'),
('小米13', '小米旗舰手机', 3999.00, 80, '手机', '/images/mi13.jpg'),
('华为P60', '华为拍照手机', 4999.00, 60, '手机', '/images/huawei.jpg');

-- 插入测试用户
INSERT INTO users (username, password, email, phone, address) VALUES
('admin', 'admin123', 'admin@javanet.com', '13800138000', '北京市朝阳区'),
('test', 'test123', 'test@javanet.com', '13900139000', '上海市浦东新区');