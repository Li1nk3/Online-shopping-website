-- 修改 products 表的 image_url 字段长度
-- 从 VARCHAR(255) 增加到 VARCHAR(500) 以支持更长的图片URL

USE javanet_shop;

ALTER TABLE products MODIFY COLUMN image_url VARCHAR(500);

-- 同时也修改 product_images 表的 image_url 字段长度以保持一致
ALTER TABLE product_images MODIFY COLUMN image_url VARCHAR(500) NOT NULL;

-- 验证修改
DESCRIBE products;
DESCRIBE product_images;