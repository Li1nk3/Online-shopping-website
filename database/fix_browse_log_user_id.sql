-- 修复浏览日志表，允许 user_id 为 NULL（支持未登录用户浏览）
USE javanet_shop;

-- 修改 user_id 字段，允许 NULL 值
ALTER TABLE customer_browse_logs 
MODIFY COLUMN user_id INT NULL;

-- 验证修改
DESCRIBE customer_browse_logs;