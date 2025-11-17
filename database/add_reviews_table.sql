-- 添加商品评论表
-- 如果表已存在则先删除
DROP TABLE IF EXISTS product_reviews;

-- 创建商品评论表
CREATE TABLE product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 插入一些示例评论数据
INSERT INTO product_reviews (product_id, user_id, rating, comment) VALUES
(1, 4, 5, '非常好的手机，拍照效果很棒，系统流畅！'),
(1, 1, 4, '整体不错，就是价格有点贵'),
(2, 4, 5, '办公神器，性能强劲，续航给力'),
(3, 1, 4, '音质很好，降噪效果不错'),
(4, 4, 5, '性价比很高，拍照也很棒'),
(5, 1, 4, '华为的拍照确实厉害');

-- 查看创建结果
SELECT * FROM product_reviews;