<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>错误信息 - JavaNet商城</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-container {
            max-width: 800px;
            margin: 100px auto;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 64px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 18px;
            color: #7f8c8d;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .error-details {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            color: #495057;
            white-space: pre-wrap;
            word-break: break-all;
        }
        .back-button {
            display: inline-block;
            background: #3498db;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            margin: 10px;
        }
        .back-button:hover {
            background: #2980b9;
        }
        .home-button {
            display: inline-block;
            background: #27ae60;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            margin: 10px;
        }
        .home-button:hover {
            background: #229954;
        }
    </style>
</head>
<body>
    <%@ include file="components/header.jsp" %>
    
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        
        <h1 class="error-title">系统错误</h1>
        
        <div class="error-message">
            <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "发生了未知错误" %>
        </div>
        
        <% if (request.getAttribute("errorDetails") != null) { %>
        <div class="error-details">
            <strong>错误详情：</strong><br>
            <%= request.getAttribute("errorDetails") %>
        </div>
        <% } %>
        
        <div class="error-actions">
            <a href="javascript:history.back()" class="back-button">
                <i class="fas fa-arrow-left"></i> 返回上一页
            </a>
            <a href="${pageContext.request.contextPath}/" class="home-button">
                <i class="fas fa-home"></i> 返回首页
            </a>
        </div>
        
        <div style="margin-top: 30px; font-size: 14px; color: #95a5a6;">
            <p>如果问题持续存在，请联系系统管理员</p>
            <p>错误时间：<%= new java.util.Date() %></p>
        </div>
    </div>
    
    <%@ include file="components/footer.jsp" %>
</body>
</html>