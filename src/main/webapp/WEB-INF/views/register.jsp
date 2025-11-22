<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <a href="home" class="auth-logo">
                <span class="logo-text">JavaNet</span>
            </a>
            <h2 class="auth-title">创建您的新账户</h2>
            <p class="auth-subtitle">加入我们，开启您的购物之旅！</p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="register" method="post" class="auth-form">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" required placeholder="创建您的用户名">
                </div>
                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password" id="password" name="password" required placeholder="设置您的密码">
                </div>
                <div class="form-group">
                    <label for="email">邮箱</label>
                    <input type="email" id="email" name="email" required placeholder="例如: yourname@example.com">
                </div>
                <div class="form-group">
                    <label for="address">地址</label>
                    <input type="text" id="address" name="address" placeholder="输入您的地址">
                </div>
                <div class="form-group">
                    <label for="role">账户类型</label>
                    <select id="role" name="role" required>
                        <option value="buyer" selected>我是买家</option>
                        <option value="seller">我是卖家</option>
                    </select>
                </div>
                <button type="submit" class="btn-primary btn-full-width">立即注册</button>
            </form>
            
            <div class="auth-footer">
                <p>已经有账户了？ <a href="login">直接登录</a></p>
            </div>
        </div>
    </div>
</body>
</html>