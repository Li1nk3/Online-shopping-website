<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录 - JavaNet购物网</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="login-form">
            <h2>用户登录</h2>
            <% if (request.getAttribute("success") != null) { %>
                <div class="success">${success}</div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">${error}</div>
            <% } %>
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">用户名:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">密码:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit">登录</button>
            </form>
            <p><a href="register">还没有账号？立即注册</a></p>
        </div>
    </div>
</body>
</html>