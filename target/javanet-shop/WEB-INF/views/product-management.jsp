<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理 - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="cart" class="btn-cart-nav">购物车</a>
            <a href="orders" class="btn-cart-nav">我的订单</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > <span>商品管理</span>
        </div>
        
        <div class="management-header">
            <h2>商品管理</h2>
            <div style="display: flex; gap: 10px;">
                <a href="seller-orders" class="btn-add-product" style="background: linear-gradient(45deg, #007bff, #0056b3);">📦 订单管理</a>
                <a href="product-management?action=add" class="btn-add-product">添加新商品</a>
            </div>
        </div>
        
        <c:if test="${not empty message}">
            <div class="success-message">${message}</div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-products">
                    <h3>暂无商品</h3>
                    <p>开始添加您的第一个商品吧！</p>
                    <a href="product-management?action=add" class="btn-primary">添加商品</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="products-table">
                    <table>
                        <thead>
                            <tr>
                                <th>图片</th>
                                <th>商品名称</th>
                                <th>分类</th>
                                <th>价格</th>
                                <th>库存</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td class="product-image-cell">
                                        <img src="${product.imageUrl}" alt="${product.name}" class="table-product-image">
                                    </td>
                                    <td>
                                        <div class="product-info">
                                            <h4>${product.name}</h4>
                                            <p class="product-desc">${product.description}</p>
                                        </div>
                                    </td>
                                    <td>${product.category}</td>
                                    <td class="price-cell">¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
                                    <td class="stock-cell">
                                        <span class="stock-badge ${product.stock > 0 ? 'in-stock' : 'out-of-stock'}">
                                            ${product.stock}
                                        </span>
                                    </td>
                                    <td class="actions-cell">
                                        <a href="product-management?action=edit&id=${product.id}" class="btn-edit">编辑</a>
                                        <button onclick="confirmDelete('${product.id}', '${product.name}')" class="btn-delete">删除</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        function confirmDelete(productId, productName) {
            if (confirm('确定要删除商品 "' + productName + '" 吗？此操作不可恢复。')) {
                window.location.href = 'product-management?action=delete&id=' + productId;
            }
        }
        
        // 自动隐藏消息
        setTimeout(function() {
            var messages = document.querySelectorAll('.success-message, .error-message');
            messages.forEach(function(msg) {
                msg.style.opacity = '0';
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 300);
            });
        }, 3000);
    </script>
</body>
</html>