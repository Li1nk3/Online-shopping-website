<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=3.0">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
</head>
<body>
    <!-- 现代化导航栏 -->
    <nav class="modern-header">
        <div class="nav-container">
            <div class="nav-left">
                <a href="home" class="logo">
                    <span class="logo-icon">
                        <svg viewBox="0 0 24 24" class="icon-svg"><path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/></svg>
                    </span>
                    <span class="logo-text">JavaNet</span>
                </a>
                <div class="nav-links">
                    <a href="products" class="nav-link">所有商品</a>
                    <a href="products?category=<c:out value='电子产品'/>" class="nav-link">电子产品</a>
                    <a href="products?category=<c:out value='家居用品'/>" class="nav-link">家居用品</a>
                    <a href="products?category=<c:out value='服装鞋帽'/>" class="nav-link">服装鞋帽</a>
                </div>
            </div>
            <div class="nav-right">
                <div class="search-box">
                    <input type="text" placeholder="搜索商品..." class="search-input" value="${searchKeyword}">
                    <button class="search-btn">搜索</button>
                </div>
                <div class="user-actions">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
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
                                <span>订单</span>
                            </a>
                            <div class="user-menu">
                                <span class="user-name" onclick="toggleDropdown()">欢迎, ${sessionScope.user.username} ▼</span>
                                <div class="dropdown">
                                    <a href="profile" class="dropdown-item">个人信息</a>
                                    <a href="browse-history" class="dropdown-item">浏览记录</a>
                                    <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                        <a href="product-management" class="dropdown-item">商品管理</a>
                                        <a href="customer-management" class="dropdown-item">客户管理</a>
                                    </c:if>
                                    <a href="logout" class="dropdown-item">退出登录</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="login" class="action-btn login-btn">登录</a>
                            <a href="register" class="action-btn register-btn">注册</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="breadcrumb">
            <a href="home">首页</a> >
            <c:choose>
                <c:when test="${not empty currentCategory}">
                    <a href="products">商品列表</a> > ${currentCategory}
                </c:when>
                <c:otherwise>
                    商品列表
                </c:otherwise>
            </c:choose>
        </div>
        
        <h2 class="section-title">
            <c:choose>
                <c:when test="${not empty searchKeyword}">
                    搜索结果：${searchKeyword}
                    <span class="search-count">(共找到 ${products.size()} 件商品)</span>
                </c:when>
                <c:when test="${not empty currentCategory}">
                    ${currentCategory}
                </c:when>
                <c:otherwise>
                    商品列表
                </c:otherwise>
            </c:choose>
        </h2>
        
        <div class="products-grid">
            <c:forEach var="product" items="${products}">
                <div class="modern-product-card">
                    <a href="products?id=${product.id}" class="product-link">
                        <div class="product-image-container">
                            <c:choose>
                                <c:when test="${not empty product.images}">
                                    <c:forEach var="image" items="${product.images}">
                                        <c:if test="${image.primary}">
                                            <img src="${image.imageUrl}" alt="${product.name}" class="product-image">
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <img src="${product.imageUrl}" alt="${product.name}" class="product-image"
                                         onerror="this.src='https://via.placeholder.com/300x200/F0F0F0/999999?text=暂无图片'">
                                </c:otherwise>
                            </c:choose>
                            <div class="product-overlay">
                                <c:choose>
                                    <c:when test="${sessionScope.user != null}">
                                        <c:if test="${product.stock > 0}">
                                            <button class="quick-add-btn" onclick="addToCart(${product.id}); return false;">
                                                快速加入购物车
                                            </button>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${product.stock > 0}">
                                            <button class="quick-add-btn" onclick="promptLogin(); event.preventDefault();">
                                                快速加入购物车
                                            </button>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="product-info">
                            <h3 class="product-name">${product.name}</h3>
                            <p class="product-category">${product.category}</p>
                            <div class="product-price">${product.price}</div>
                            <div class="product-stock">
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <span class="in-stock">库存: ${product.stock}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="out-of-stock">缺货</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty products}">
            <div class="empty-products">
                <h3>
                    <c:choose>
                        <c:when test="${not empty searchKeyword}">
                            <svg viewBox="0 0 24 24" class="icon-svg" style="width: 32px; height: 32px;"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg> 未找到相关商品
                        </c:when>
                        <c:otherwise>
                            暂无商品
                        </c:otherwise>
                    </c:choose>
                </h3>
                <p>
                    <c:choose>
                        <c:when test="${not empty searchKeyword}">
                            没有找到与 "${searchKeyword}" 相关的商品，请尝试其他关键词
                        </c:when>
                        <c:when test="${not empty currentCategory}">
                            该分类下暂无商品
                        </c:when>
                        <c:otherwise>
                            还没有任何商品，请等待商品上架
                        </c:otherwise>
                    </c:choose>
                </p>
                <c:choose>
                    <c:when test="${not empty searchKeyword}">
                        <a href="products" class="btn-add-product">浏览所有商品</a>
                    </c:when>
                    <c:otherwise>
                        <a href="home" class="btn-add-product">返回首页</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
    
    <script>
        function addToCart(productId) {
            fetch('cart?action=add&productId=' + productId, {method: 'POST'})
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        showNotification('商品已加入购物车');
                    } else {
                        showNotification('添加失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    showNotification('网络错误，请重试', 'error');
                });
        }
        
        function promptLogin() {
            showConfirm('请先登录后再加入购物车，是否现在登录？', function() {
                window.location.href = 'login';
            }, { title: '需要登录' });
        }
        
        // 通知功能
        function showNotification(message, type = 'success') {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.classList.add('show');
            }, 100);
            
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    if (notification.parentNode) {
                        document.body.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }

        // 搜索功能
        document.querySelector('.search-input').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const query = this.value.trim();
                if (query) {
                    window.location.href = 'products?search=' + encodeURIComponent(query);
                }
            }
        });

        document.querySelector('.search-btn').addEventListener('click', function() {
            const query = document.querySelector('.search-input').value.trim();
            if (query) {
                window.location.href = 'products?search=' + encodeURIComponent(query);
            }
        });

        // 用户下拉菜单功能
        function toggleDropdown() {
            const dropdown = document.querySelector('.dropdown');
            if (dropdown) {
                dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            }
        }

        // 点击其他地方关闭下拉菜单
        document.addEventListener('click', function(event) {
            const userMenu = document.querySelector('.user-menu');
            const dropdown = document.querySelector('.dropdown');
            
            if (userMenu && dropdown && !userMenu.contains(event.target)) {
                dropdown.style.display = 'none';
            }
        });
    </script>
</body>
</html>