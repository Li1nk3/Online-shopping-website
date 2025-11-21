# JavaNet 在线购物网站

基于 Java Web 技术栈开发的在线购物网站，类似淘宝的电商平台。

## 技术栈

- **后端**: Java 8, Servlet, JSP
- **数据库**: MySQL 8.0
- **前端**: HTML, CSS, JavaScript
- **构建工具**: Maven
- **服务器**: Tomcat 9.0+

## 项目结构

```
javanet/
├── src/main/java/com/javanet/
│   ├── model/          # 实体类
│   │   ├── User.java
│   │   ├── Product.java
│   │   └── Order.java
│   ├── dao/            # 数据访问层
│   │   ├── UserDAO.java
│   │   └── ProductDAO.java
│   ├── service/        # 业务逻辑层
│   │   └── UserService.java
│   ├── servlet/        # 控制器层
│   │   └── LoginServlet.java
│   └── util/           # 工具类
│       └── DatabaseConnection.java
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── views/      # JSP页面
│   │   │   ├── login.jsp
│   │   │   └── products.jsp
│   │   └── web.xml     # Web配置
│   └── css/
│       └── style.css   # 样式文件
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
- 在线下单
- 多种支付方式（支付宝、微信支付、银行卡、货到付款）
- 在线支付功能

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
- 商品管理（添加、编辑、删除）
- 订单管理
- 库存管理

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

### 3. 修改数据库连接
编辑 `src/main/java/com/javanet/util/DatabaseConnection.java`，修改数据库连接参数：
```java
private static final String URL = "jdbc:mysql://localhost:3306/javanet_shop";
private static final String USERNAME = "your_username";
private static final String PASSWORD = "your_password";
```

### 4. 编译部署
```bash
# 编译项目
mvn clean compile

# 打包WAR文件
mvn package

# 部署到Tomcat
cp target/javanet-shop.war $TOMCAT_HOME/webapps/
```

### 5. 启动访问
- 启动Tomcat服务器
- 访问: http://localhost:8080/javanet-shop

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
   - 多种支付方式选择（支付宝、微信、银行卡）
   - 模拟支付处理
   - 付款成功后发送确认邮件
   - 更新订单付款状态

5. **确认收货**
   - 订单发货后可确认收货
   - 确认收货后发送邮件通知
   - 订单状态更新为已完成

### 邮件通知功能

系统集成了完整的邮件通知功能，在关键节点自动发送邮件：

- **订单确认邮件** - 提交订单后立即发送
- **付款成功邮件** - 完成付款后发送
- **发货通知邮件** - 卖家发货后发送（待实现）
- **确认收货邮件** - 用户确认收货后发送

**邮件配置：**
详细配置说明请参考 [EMAIL_CONFIGURATION.md](EMAIL_CONFIGURATION.md)

**邮件特点：**
- 精美的HTML邮件模板
- 包含订单详细信息
- 自动发送，无需人工干预
- 支持多种邮箱服务商

## 技术亮点

- 采用经典MVC架构模式
- 使用AJAX实现异步交互
- 完善的权限验证机制
- 响应式用户界面设计
- 完整的订单状态管理
- 集成JavaMail邮件发送功能
- 模拟在线支付流程
- 完整的购买流程闭环

## 后续扩展

- 集成真实支付接口（支付宝、微信支付）
- 添加物流跟踪功能
- 实现退款/退货功能
- 添加优惠券系统
- 实现订单评价提醒
- 添加站内消息通知
- 短信通知功能
- 订单发票功能