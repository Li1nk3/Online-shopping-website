-- 创建数据库
CREATE DATABASE IF NOT EXISTS javanet_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE javanet_shop;

-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建商品表
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    image_url VARCHAR(255),
    seller_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_seller FOREIGN KEY (seller_id) REFERENCES users(id)
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

-- 创建商品评论表
CREATE TABLE IF NOT EXISTS product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 插入测试用户（包含角色）
INSERT INTO users (username, password, email, phone, address, role) VALUES
('admin', 'admin123', 'admin@javanet.com', '13800138000', '北京市朝阳区', 'admin'),
('seller1', 'seller123', 'seller1@javanet.com', '13700137000', '广州市天河区', 'seller'),
('seller2', 'seller123', 'seller2@javanet.com', '13600136000', '深圳市南山区', 'seller'),
('test', 'test123', 'test@javanet.com', '13900139000', '上海市浦东新区', 'customer');

-- 插入示例商品数据（关联到卖家）
-- 注意：这里假设seller1的ID是2，seller2的ID是3，实际使用时需要根据实际ID调整
INSERT INTO products (name, description, price, stock, category, image_url, seller_id) VALUES
('iPhone 15', '苹果最新款智能手机，搭载A17 Pro芯片，支持5G网络，拍照效果出色', 6999.00, 50, '电子产品', '/images/products/macbook.jpg', 2),
('MacBook Pro', '苹果笔记本电脑，M3芯片，16GB内存，512GB存储，适合专业工作', 12999.00, 30, '电子产品', '/images/products/macbook.jpg', 2),
('AirPods Pro', '苹果无线耳机，主动降噪，空间音频，长续航', 1999.00, 100, '电子产品', '/images/products/airpods.jpg', 2),
('小米13', '小米旗舰手机，骁龙8 Gen2处理器，徕卡影像系统', 3999.00, 80, '电子产品', '/images/products/mi13.jpg', 3),
('华为P60', '华为拍照手机，XMAGE影像系统，超感知摄影', 4999.00, 60, '电子产品', '/images/products/huawei.jpg', 3);

-- 为已存在但没有seller_id的商品更新seller_id
-- 这里将现有商品随机分配给不同的卖家
UPDATE products SET seller_id = 2 WHERE seller_id IS NULL AND id % 2 = 1;
UPDATE products SET seller_id = 3 WHERE seller_id IS NULL AND id % 2 = 0;

-- 插入一些示例评论数据
INSERT INTO product_reviews (product_id, user_id, rating, comment) VALUES
(1, 4, 5, '非常好的手机，拍照效果很棒，系统流畅！'),
(1, 1, 4, '整体不错，就是价格有点贵'),
(2, 4, 5, '办公神器，性能强劲，续航给力'),
(3, 1, 4, '音质很好，降噪效果不错'),
(4, 4, 5, '性价比很高，拍照也很棒'),
(5, 1, 4, '华为的拍照确实厉害');