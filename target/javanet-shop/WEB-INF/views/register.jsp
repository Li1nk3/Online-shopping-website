<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册 - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <a href="login" class="btn-login">登录</a>
        </div>
    </div>
    
    <div class="container">
        <div class="register-form">
            <h2>用户注册</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">${error}</div>
            <% } %>
            
            <form action="register" method="post">
                <div class="form-group">
                    <label for="username">用户名:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">密码:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="email">邮箱:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">手机号:</label>
                    <input type="tel" id="phone" name="phone">
                </div>
                
                <div class="form-group">
                    <label for="address">地址:</label>
                    <textarea id="address" name="address" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="role">身份类型:</label>
                    <select id="role" name="role" required>
                        <option value="buyer">买家</option>
                        <option value="seller">卖家</option>
                    </select>
                </div>
                
                <button type="submit" class="btn-register-submit">注册</button>
            </form>
            
            <p class="login-link">已有账号？<a href="login">立即登录</a></p>
        </div>
    </div>
</body>
</html>