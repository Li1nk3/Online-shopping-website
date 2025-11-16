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

- 用户注册/登录
- 商品浏览
- 购物车管理
- 订单处理
- 用户管理

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

- 管理员: admin / admin123
- 普通用户: test / test123

## 开发说明

本项目采用经典的 MVC 架构模式：
- **Model**: 实体类和数据访问对象
- **View**: JSP页面
- **Controller**: Servlet控制器

数据库连接使用原生JDBC，实现了基本的CRUD操作。

## 后续扩展

- 添加商品分类管理
- 实现购物车功能
- 添加订单状态跟踪
- 集成支付接口
- 添加商品评价系统