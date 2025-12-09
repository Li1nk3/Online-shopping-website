# JavaNet 在线购物网站

基于 Java Web 技术栈开发的在线购物网站，提供完整的电商购物体验。

## 技术栈

- **后端**: Java 8, Servlet, JSP, JDBC
- **数据库**: MySQL 8.0
- **前端**: HTML5, CSS3, JavaScript
- **支付**: Stripe 国际信用卡支付
- **构建**: Maven + Tomcat

## 功能特性

### 买家功能
- 用户注册/登录、个人信息管理
- 商品浏览、搜索、分类展示
- 购物车管理（添加、删除、修改数量）
- 在线下单、Stripe支付
- 订单管理（查看、取消、确认收货）
- 商品评价

### 卖家功能
- 商品管理（添加、编辑、删除、图片管理）
- 订单管理（查看、确认、发货）
- 库存管理、客户购买统计

### 管理员功能
- 查看所有订单和商品
- 客户数据管理

## 脚本说明

| 脚本 | 用途 |
|------|------|
| `restart-server.sh` | 重启服务器：停止现有进程 → 清理编译 → 后台启动 |
| `stop-server.sh` | 停止服务器：终止所有tomcat7进程 |
| `javanet-migration/install.sh` | 服务器迁移安装：一键安装Java、Maven、MySQL、Tomcat并部署项目 |

### 使用示例

```bash
# 启动/重启服务器
chmod +x restart-server.sh
./restart-server.sh

# 停止服务器
./stop-server.sh

# 查看日志
tail -f /root/javanet/server.log

# 新服务器部署（需要root权限）
cd javanet-migration
chmod +x install.sh
sudo ./install.sh
```

## 快速开始

### 环境要求
- JDK 8+
- MySQL 8.0+
- Maven 3.6+

### 本地部署

1. **初始化数据库**
```bash
mysql -u root -p < database/init.sql
```

2. **配置数据库连接**
编辑 `src/main/java/com/javanet/util/DatabaseConnection.java`

3. **配置Stripe支付**
```bash
cp .env.example .env
# 编辑.env填入Stripe密钥
```

4. **启动服务**
```bash
./restart-server.sh
```

5. **访问网站**: http://localhost:1337

## 公网部署指南

### 1. 服务器环境准备
```bash
# 安装依赖
sudo apt update && sudo apt upgrade -y
sudo apt install openjdk-8-jdk mysql-server maven -y
```

### 2. 部署项目
```bash
# 上传项目到服务器后
cd javanet
mvn clean compile
./restart-server.sh
```

### 3. 防火墙配置
```bash
sudo ufw allow 1337/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable
```

### 4. 云服务器安全组
在云服务商控制台添加入站规则：端口 1337，协议 TCP，来源 0.0.0.0/0

### 5. 验证访问
```bash
curl -I http://你的公网IP:1337
```

### 常见问题
- **端口无法访问**: 检查防火墙和安全组配置
- **服务启动失败**: 查看日志 `tail -f /root/javanet/server.log`

## 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |
| 卖家 | seller1 | seller123 |
| 买家 | test | test123 |

## 在线演示

- **地址**: http://113.45.208.85:1337
