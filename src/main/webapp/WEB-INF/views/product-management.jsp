<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="modern-header">
        <div class="nav-container">
            <div class="nav-left">
                <a href="home" class="logo">
                    <span class="logo-text">JavaNet</span>
                </a>
                <div class="nav-links">
                    <a href="products" class="nav-link">所有商品</a>
                </div>
            </div>
            <div class="nav-right">
                <div class="user-actions">
                    <c:if test="${sessionScope.user != null}">
                        <a href="cart" class="action-btn cart-btn">
                            <span class="btn-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/></svg>
                            </span>
                            <span>购物车</span>
                        </a>
                        <a href="orders" class="action-btn">
                            <span class="btn-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                            </span>
                            <span>我的订单</span>
                        </a>
                        <div class="user-menu">
                            <span class="user-name" onclick="toggleDropdown()">欢迎, ${sessionScope.user.username} ▼</span>
                            <div class="dropdown">
                                <a href="profile" class="dropdown-item">个人信息</a>
                                <a href="browse-history" class="dropdown-item">浏览记录</a>
                                <a href="product-management" class="dropdown-item">商品管理</a>
                                <a href="customer-management" class="dropdown-item">客户管理</a>
                                <a href="logout" class="dropdown-item">退出登录</a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="home">首页</a> > <span>商品管理</span>
        </div>
        
        <div class="management-header">
            <h2>商品管理</h2>
            <div class="management-actions">
                <a href="seller-orders" class="btn-primary">
                    <svg viewBox="0 0 24 24" class="icon-svg" style="width:18px; height:18px; fill:white;"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm0 15c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm6-3H6v-2h12v2z"/></svg>
                    订单管理
                </a>
                <a href="product-management?action=add" class="btn-primary">
                    <svg viewBox="0 0 24 24" class="icon-svg" style="width:18px; height:18px; fill:white;"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                    添加新商品
                </a>
            </div>
        </div>
        
        <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-placeholder">
                    <h3>您还没有商品</h3>
                    <p>开始添加您的第一个商品吧！</p>
                    <a href="product-management?action=add" class="btn-primary">添加商品</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="management-table-container">
                    <table class="management-table">
                        <thead>
                            <tr>
                                <th>商品信息</th>
                                <th>分类</th>
                                <th>价格</th>
                                <th>库存</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td>
                                        <div class="product-table-info">
                                            <img src="${not empty product.imageUrl ? product.imageUrl : 'https://via.placeholder.com/80x80/F0F0F0/999999?text=暂无图片'}" alt="${product.name}" class="table-product-image">
                                            <div class="product-details">
                                                <h4>${product.name}</h4>
                                                <p>${product.description}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${product.category}</td>
                                    <td class="price-cell"><fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="stock-badge ${product.stock > 5 ? 'in-stock' : (product.stock > 0 ? 'low-stock' : 'out-of-stock')}">
                                            ${product.stock}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <a href="product-management?action=edit&id=${product.id}" class="btn-edit">编辑</a>
                                            <button onclick="confirmDelete('${product.id}', '${product.name}')" class="btn-delete">删除</button>
                                        </div>
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
            showConfirm('确定要删除商品 "' + productName + '" 吗？此操作不可恢复。', function() {
                var form = document.createElement('form');
                form.method = 'post';
                form.action = 'product-management?action=delete&id=' + productId;
                document.body.appendChild(form);
                form.submit();
            }, { type: 'danger', title: '删除商品' });
        }

        function toggleDropdown() {
            const dropdown = document.querySelector('.dropdown');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        }

        document.addEventListener('click', function(event) {
            const userMenu = document.querySelector('.user-menu');
            const dropdown = document.querySelector('.dropdown');
            if (userMenu && !userMenu.contains(event.target)) {
                dropdown.style.display = 'none';
            }
        });
    </script>
</body>
</html>