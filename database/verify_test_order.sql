-- --------------------------------------------------------------------------------
-- JAVANET SHOP: 订单验证脚本
-- --------------------------------------------------------------------------------
-- 用途:
--   本脚本用于验证特定用户（默认为 'test'）成功创建订单后，
--   数据库中 `orders` 和 `order_items` 表的记录是否正确生成。
--
-- 如何使用:
--   1. 确保您已经通过网站前端使用 'test' 用户创建了一个订单。
--   2. 在MySQL客户端中连接到 `javanet_shop` 数据库。
--   3. 执行此脚本 (例如, 使用 `SOURCE database/verify_test_order.sql;` 命令)。
-- --------------------------------------------------------------------------------

-- --- 步骤 1: 设置并查找用户 ---
-- 将要查询的用户名设置到一个变量中，方便修改
SET @username_to_find = 'test';

-- 从 `users` 表中查找指定用户名的 `id`，并将其存入 `@user_id_found` 变量
SELECT id INTO @user_id_found FROM users WHERE username = @username_to_find LIMIT 1;

-- 打印提示信息，显示正在为哪个用户进行验证
SELECT CONCAT('--- 正在为用户 ''', @username_to_find, ''' (ID: ', @user_id_found, ') 进行订单验证 ---') AS '验证状态';


-- --- 步骤 2: 查询最新订单 ---
-- 使用上一步获取的用户ID，从 `orders` 表中查找最新的一条订单记录
SELECT '--- 1. 最新订单详情 (orders 表) ---' AS '查询目标';
SELECT * FROM orders WHERE user_id = @user_id_found ORDER BY created_at DESC LIMIT 1;


-- --- 步骤 3: 查询订单对应的商品项 ---
-- 首先，获取最新订单的ID，并将其存入 `@latest_order_id` 变量
SELECT id INTO @latest_order_id FROM orders WHERE user_id = @user_id_found ORDER BY created_at DESC LIMIT 1;

-- 使用上一步获取的订单ID，从 `order_items` 表中查找所有相关的商品记录
SELECT CONCAT('--- 2. 订单商品列表 (order_items 表 for Order ID: ', @latest_order_id, ') ---') AS '查询目标';
SELECT * FROM order_items WHERE order_id = @latest_order_id;

-- --------------------------------------------------------------------------------
-- 验证结束
-- --------------------------------------------------------------------------------