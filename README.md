# JavaNet 在线购物网站

基于 Java Web 技术栈开发的现代化在线购物网站，采用IKEA风格的简约设计理念，提供完整的电商购物体验。

## 技术栈

- **后端**: Java 8, Servlet, JSP, JDBC
- **数据库**: MySQL 8.0
- **前端**: HTML5, CSS3, JavaScript (ES6+)
- **UI框架**: 自定义现代化UI组件库
- **支付集成**: Stripe (国际信用卡支付)
- **邮件服务**: JavaMail
- **构建工具**: Maven
- **服务器**: Tomcat 9.0+

## 项目结构

```
javanet/
├── src/main/java/com/javanet/
│   ├── model/          # 实体类
│   │   ├── User.java           # 用户模型
│   │   ├── Product.java        # 商品模型
│   │   ├── Order.java          # 订单模型
│   │   ├── OrderItem.java      # 订单项模型
│   │   ├── Cart.java           # 购物车模型
│   │   └── ProductReview.java  # 商品评价模型
│   ├── dao/            # 数据访问层
│   │   ├── UserDAO.java        # 用户数据访问
│   │   ├── ProductDAO.java     # 商品数据访问
│   │   ├── OrderDAO.java       # 订单数据访问
│   │   └── CartDAO.java        # 购物车数据访问
│   ├── service/        # 业务逻辑层
│   │   └── UserService.java    # 用户服务
│   ├── servlet/        # 控制器层
│   │   ├── LoginServlet.java           # 登录控制器
│   │   ├── ProductServlet.java         # 商品控制器
│   │   ├── CartServlet.java            # 购物车控制器
│   │   ├── OrderServlet.java           # 订单控制器
│   │   ├── PaymentServlet.java         # 支付控制器
│   │   └── PaymentSuccessServlet.java  # 支付成功控制器
│   └── util/           # 工具类
│       ├── DatabaseConnection.java     # 数据库连接
│       ├── EmailUtil.java              # 邮件工具
│       └── StripeConfig.java           # Stripe配置
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── views/      # JSP页面
│   │   │   ├── home.jsp           # 首页
│   │   │   ├── products.jsp       # 商品列表
│   │   │   ├── product-detail.jsp # 商品详情
│   │   │   ├── cart.jsp           # 购物车
│   │   │   ├── checkout.jsp       # 结算页面
│   │   │   ├── payment.jsp        # 支付确认页
│   │   │   ├── payment-success.jsp # 支付成功页
│   │   │   ├── orders.jsp         # 订单列表
│   │   │   ├── order-detail.jsp   # 订单详情
│   │   │   ├── login.jsp          # 登录页面
│   │   │   └── register.jsp       # 注册页面
│   │   └── web.xml     # Web配置
│   ├── css/
│   │   └── style.css   # 现代化样式文件
│   ├── js/
│   │   └── universal-dialog.js  # 通用对话框组件
│   └── images/
│       ├── favicon.svg  # 网站图标
│       └── products/    # 商品图片
├── database/
│   └── init.sql        # 数据库初始化脚本
├── pom.xml             # Maven配置
└── README.md
```

## 功能特性

### 用户功能
- 用户注册/登录
- 个人信息管理
- 收货地址管理

### 商品功能
- 商品浏览与搜索
- 商品详情查看
- 商品分类展示
- 商品评价系统

### 购物功能
- 购物车管理（添加、删除、修改数量）
- 智能购物车交互（悬停显示快速操作）
- 在线下单流程
- Stripe国际信用卡支付（人民币结算）
- 支付状态实时跟踪

### 订单功能
- 订单列表查看
- 订单详情查看
- 订单取消功能
- 订单状态跟踪
- 支付状态管理
- 在线付款功能
- 确认收货功能
- 邮件通知功能

### 卖家功能
- 商品管理（添加、编辑、删除、图片管理）
- 订单管理（查看、确认、发货）
- 库存管理（实时库存跟踪）
- 客户购买统计
- 浏览记录分析

## 安装部署

### 1. 环境要求
- JDK 8+
- MySQL 8.0+
- Tomcat 9.0+
- Maven 3.6+

### 2. 数据库配置
```sql
-- 执行数据库初始化脚本
mysql -u root -p < database/init.sql
```

### 3. 配置Stripe支付
**重要：为了安全起见，请使用环境变量配置Stripe密钥**

#### 方法一：使用环境变量（推荐）
```bash
# 设置环境变量
export STRIPE_PUBLISHABLE_KEY="pk_test_your_publishable_key"
export STRIPE_SECRET_KEY="sk_test_your_secret_key"
```

#### 方法二：使用.env文件
```bash
# 复制环境变量模板
cp .env.example .env

# 编辑.env文件，填入您的Stripe密钥
nano .env
```

**注意：**
- `.env` 文件已添加到 `.gitignore`，不会被提交到版本控制
- 请从 [Stripe Dashboard](https://dashboard.stripe.com/apikeys) 获取您的API密钥
- 生产环境请使用生产密钥，开发环境使用测试密钥

### 4. 修改数据库连接
编辑 `src/main/java/com/javanet/util/DatabaseConnection.java`，修改数据库连接参数：
```java
private static final String URL = "jdbc:mysql://localhost:3306/javanet_shop";
private static final String USERNAME = "your_username";
private static final String PASSWORD = "your_password";
```

### 5. 本地开发部署
```bash
# 编译项目
mvn clean compile

# 打包WAR文件
mvn package

# 部署到Tomcat
cp target/javanet-shop.war $TOMCAT_HOME/webapps/
```

### 6. 本地启动访问
- 启动Tomcat服务器
- 访问: http://localhost:8080/javanet-shop

## 公网部署指南

### 前提条件
- 拥有云服务器（阿里云、腾讯云、AWS等）
- 服务器具有公网IP地址
- 具有服务器管理员权限（root或sudo）

### 1. 服务器环境准备
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装Java 8
sudo apt install openjdk-8-jdk -y

# 安装MySQL
sudo apt install mysql-server -y

# 安装Maven
sudo apt install maven -y

# 验证安装
java -version
mvn -version
```

### 2. 部署项目到服务器
```bash
# 上传项目文件到服务器
# 可以使用scp、git clone或其他方式

# 进入项目目录
cd javanet-shop

# 修改pom.xml配置（重要）
# 将tomcat7-maven-plugin端口改为80，路径改为根路径
<configuration>
    <port>80</port>
    <path>/</path>
</configuration>

# 编译项目
mvn clean compile

# 启动服务（需要root权限运行80端口）
sudo mvn tomcat7:run
```

### 3. 防火墙配置
```bash
# 启用UFW防火墙
sudo ufw --force enable

# 开放HTTP端口（80）
sudo ufw allow 80/tcp

# 开放SSH端口（22，确保不会断开连接）
sudo ufw allow 22/tcp

# 检查防火墙状态
sudo ufw status
```

### 4. 云服务器安全组配置

#### 阿里云ECS
1. 登录阿里云控制台
2. 进入ECS管理 → 实例列表
3. 选择实例 → 更多 → 网络和安全组 → 安全组配置
4. 添加规则：
   - 端口范围：80/80
   - 授权对象：0.0.0.0/0
   - 协议类型：TCP

#### 腾讯云CVM
1. 登录腾讯云控制台
2. 进入CVM实例列表
3. 选择实例 → 更多 → 安全组 → 配置规则
4. 添加规则：
   - 端口：80
   - 来源：0.0.0.0/0
   - 协议：TCP

#### AWS EC2
1. 登录AWS控制台
2. 进入EC2管理控制台
3. 选择实例 → 安全组 → 编辑入站规则
4. 添加规则：
   - 类型：HTTP
   - 协议：TCP
   - 端口范围：80
   - 来源：Anywhere-IPv4 (0.0.0.0/0)

### 5. 端口冲突处理
如果80端口被占用（如nginx、apache等）：

```bash
# 查看端口占用情况
sudo netstat -tlnp | grep :80

# 停止占用80端口的服务（以nginx为例）
sudo systemctl stop nginx
sudo systemctl disable nginx  # 禁止开机启动

# 或者修改Tomcat配置使用其他端口（如8080）
# 同时需要在安全组中开放对应端口
```

### 6. 验证公网访问
```bash
# 获取服务器公网IP
curl -s ifconfig.me

# 本地测试访问
curl -I http://localhost

# 公网测试访问
curl -I http://你的公网IP
```

### 7. 域名配置（可选）
```bash
# 购买域名后，在域名解析中添加A记录
# 主机记录：@ 或 www
# 记录类型：A
# 记录值：你的公网IP地址
# TTL：600秒

# 配置完成后，可通过域名访问
# http://yourdomain.com
```

### 8. SSL证书配置（可选）
```bash
# 安装certbot
sudo apt install certbot python3-certbot-nginx -y

# 申请免费SSL证书（需要先配置nginx反向代理）
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# 自动续期
sudo crontab -e
# 添加：0 12 * * * /usr/bin/certbot renew --quiet
```

### 9. 生产环境优化建议

#### 进程管理
```bash
# 使用systemd管理Tomcat进程
sudo nano /etc/systemd/system/javanet-shop.service
```

服务配置文件内容：
```ini
[Unit]
Description=JavaNet Shop
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/javanet
ExecStart=/usr/bin/mvn tomcat7:run
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 启用服务
sudo systemctl enable javanet-shop
sudo systemctl start javanet-shop
```

#### 性能优化
- 配置数据库连接池
- 启用Gzip压缩
- 配置静态资源缓存
- 使用CDN加速静态资源

#### 安全加固
- 定期更新系统和依赖
- 配置fail2ban防止暴力破解
- 启用数据库审计日志
- 定期备份数据库

### 10. 监控和日志
```bash
# 查看应用日志
tail -f target/tomcat/logs/catalina.out

# 监控系统资源
htop
df -h
free -h

# 配置日志轮转
sudo nano /etc/logrotate.d/javanet-shop
```

### 常见问题解决

#### 1. 80端口无法启动
- 确保以root权限运行
- 检查端口是否被占用
- 验证防火墙配置

#### 2. 公网无法访问
- 检查安全组配置
- 验证防火墙规则
- 确认服务正在运行

#### 3. 域名解析问题
- 检查DNS配置
- 验证A记录设置
- 等待DNS生效（通常5-10分钟）

### 部署成功示例
- 公网IP：113.45.208.85
- 访问地址：http://113.45.208.85
- 状态：✅ 正常运行

通过以上步骤，你的JavaNet在线商城就可以成功部署到公网，供全球用户访问！

## 测试账号

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 管理员 | admin | admin123 | 系统管理员 |
| 卖家1 | seller1 | seller123 | 商品卖家 |
| 卖家2 | seller2 | seller123 | 商品卖家 |
| 买家 | test | test123 | 普通用户 |

## 开发说明

本项目采用经典的 MVC 架构模式：
- **Model**: 实体类和数据访问对象
- **View**: JSP页面
- **Controller**: Servlet控制器

数据库连接使用原生JDBC，实现了基本的CRUD操作。

## 核心功能说明

### 订单取消功能

用户可以在以下页面取消订单：
- **订单列表页面** (`/orders`)：浏览所有订单并取消符合条件的订单
- **订单详情页面** (`/order-detail`)：查看订单详情并取消订单

**取消条件：**
- 订单状态必须为"待处理"（pending）
- 支付状态必须为"待支付"（pending）
- 订单必须属于当前登录用户

**实现特点：**
- 使用AJAX技术实现无刷新操作
- 自动验证订单所有权和状态
- 取消成功后自动刷新页面显示最新状态
- 已取消的订单不再显示"取消订单"和"立即支付"按钮

### 完整购买流程

系统实现了完整的电商购买流程：

1. **浏览/查询商品**
   - 首页商品展示
   - 分类浏览
   - 搜索功能
   - 商品详情查看

2. **添加至购物车**
   - 快速加入购物车（悬停显示）
   - 购物车数量管理
   - 购物车商品删除

3. **结算下单**
   - 填写收货信息
   - 选择支付方式
   - 提交订单
   - 发送订单确认邮件

4. **在线付款**
    - Stripe安全支付网关集成
    - 人民币支付（CNY货币）
    - 支付状态实时验证
    - 付款成功后自动跳转
    - 发送付款确认邮件

5. **确认收货**
   - 订单发货后可确认收货
   - 确认收货后发送邮件通知
   - 订单状态更新为已完成

### 邮件通知功能

系统集成了完整的邮件通知功能，在关键节点自动发送邮件：

- **订单确认邮件** - 提交订单后立即发送
- **付款成功邮件** - 完成付款后发送
- **确认收货邮件** - 用户确认收货后发送
