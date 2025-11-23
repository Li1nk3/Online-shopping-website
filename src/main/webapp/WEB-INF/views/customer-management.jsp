<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>客户管理 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        .section-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .section-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .section-title {
            font-size: 1.2em;
            font-weight: bold;
            margin: 0;
        }
        .section-content {
            padding: 20px;
        }
        .customer-list {
            display: grid;
            gap: 15px;
        }
        .customer-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 5px;
            transition: background-color 0.2s;
        }
        .customer-item:hover {
            background-color: #f8f9fa;
        }
        .customer-info {
            flex: 1;
        }
        .customer-name {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .customer-contact {
            color: #666;
            font-size: 0.9em;
        }
        .customer-stats {
            text-align: right;
        }
        .customer-amount {
            font-weight: bold;
            color: #28a745;
        }
        .customer-orders {
            color: #666;
            font-size: 0.9em;
        }
        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        .product-item {
            text-align: center;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 5px;
        }
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        .product-image-placeholder {
            width: 80px;
            height: 80px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
        }
        .placeholder-icon {
            width: 40px;
            height: 40px;
            fill: #6c757d;
        }
        .product-name {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .browse-count {
            color: #007bff;
            font-size: 0.9em;
        }
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .alert {
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 导航栏 -->
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
                        <a href="products?category=电子产品" class="nav-link">电子产品</a>
                        <a href="products?category=家居用品" class="nav-link">家居用品</a>
                        <a href="products?category=服装鞋帽" class="nav-link">服装鞋帽</a>
                    </div>
                </div>
                <div class="nav-right">
                    <div class="search-box">
                        <input type="text" placeholder="搜索商品..." class="search-input">
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
                                <a href="orders" class="action-btn orders-btn">
                                    <span class="btn-icon">
                                        <svg viewBox="0 0 24 24" class="icon-svg"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                                    </span>
                                    <span>订单</span>
                                </a>
                                <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                    <a href="product-management" class="action-btn management-btn">
                                        <span>商品管理</span>
                                    </a>
                                </c:if>
                                <div class="user-menu">
                                    <span class="user-name" onclick="toggleDropdown()">欢迎, ${sessionScope.user.username} ▼</span>
                                    <div class="dropdown" id="userDropdown">
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
                                <a href="login" class="action-btn login-btn">
                                    <span class="btn-icon">
                                        <svg viewBox="0 0 24 24" class="icon-svg"><path d="M12.65 10C11.83 7.67 9.61 6 7 6c-3.31 0-6 2.69-6 6s2.69 6 6 6c2.61 0 4.83-1.67 5.65-4H17v4h4v-4h2v-4H12.65zM7 14c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/></svg>
                                    </span>
                                    <span>登录</span>
                                </a>
                                <a href="register" class="action-btn register-btn">
                                    <span class="btn-icon">
                                        <svg viewBox="0 0 24 24" class="icon-svg"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                    </span>
                                    <span>注册</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>
        
        <main class="main-content">
            <div class="page-header">
                <h1>客户管理</h1>
                <p>查看客户信息、浏览记录和购买统计</p>
            </div>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- 统计概览 -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${totalCustomers}</div>
                    <div class="stat-label">总客户数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">¥<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/></div>
                    <div class="stat-label">总收入</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${topCustomers.size()}</div>
                    <div class="stat-label">活跃客户</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${hotProducts.size()}</div>
                    <div class="stat-label">热门商品</div>
                </div>
            </div>
            
            <!-- 优质客户 -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">优质客户（按消费金额排序）</h3>
                    <a href="customer-management?action=purchase-stats" class="btn-secondary">查看全部</a>
                </div>
                <div class="section-content">
                    <c:choose>
                        <c:when test="${empty topCustomers}">
                            <p style="text-align: center; color: #666;">暂无客户数据</p>
                        </c:when>
                        <c:otherwise>
                            <div class="customer-list">
                                <c:forEach items="${topCustomers}" var="customer">
                                    <div class="customer-item">
                                        <div class="customer-info">
                                            <div class="customer-name">${customer.user.username}</div>
                                            <div class="customer-contact">
                                                <c:if test="${not empty customer.user.email}">${customer.user.email}</c:if>
                                                <c:if test="${not empty customer.user.phone}"> | ${customer.user.phone}</c:if>
                                            </div>
                                        </div>
                                        <div class="customer-stats">
                                            <div class="customer-amount">¥<fmt:formatNumber value="${customer.totalAmount}" pattern="#,##0.00"/></div>
                                            <div class="customer-orders">${customer.totalOrders} 个订单</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 最近客户 -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">最近购买客户（7天内）</h3>
                    <a href="customer-management?action=purchase-stats" class="btn-secondary">查看全部</a>
                </div>
                <div class="section-content">
                    <c:choose>
                        <c:when test="${empty recentCustomers}">
                            <p style="text-align: center; color: #666;">最近7天没有新客户</p>
                        </c:when>
                        <c:otherwise>
                            <div class="customer-list">
                                <c:forEach items="${recentCustomers}" var="customer">
                                    <div class="customer-item">
                                        <div class="customer-info">
                                            <div class="customer-name">${customer.user.username}</div>
                                            <div class="customer-contact">
                                                <c:if test="${not empty customer.user.email}">${customer.user.email}</c:if>
                                                <c:if test="${not empty customer.user.phone}"> | ${customer.user.phone}</c:if>
                                            </div>
                                        </div>
                                        <div class="customer-stats">
                                            <div class="customer-amount">¥<fmt:formatNumber value="${customer.totalAmount}" pattern="#,##0.00"/></div>
                                            <div class="customer-orders">
                                                最后购买：<fmt:formatDate value="${customer.lastPurchaseDate}" pattern="MM-dd HH:mm"/>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 热门商品 -->
            <div class="section-card">
                <div class="section-header">
                    <h3 class="section-title">热门商品（7天内浏览量）</h3>
                    <a href="customer-management?action=browse-logs" class="btn-secondary">查看所有浏览记录</a>
                </div>
                <div class="section-content">
                    <c:choose>
                        <c:when test="${empty hotProducts}">
                            <p style="text-align: center; color: #666;">暂无浏览数据</p>
                        </c:when>
                        <c:otherwise>
                            <div class="product-list">
                                <c:forEach items="${hotProducts}" var="item">
                                    <a href="product?id=${item.product.id}" class="product-item" style="text-decoration: none; color: inherit;">
                                        <c:choose>
                                            <c:when test="${not empty item.product.imageUrl}">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(item.product.imageUrl, 'http')}">
                                                        <img src="${item.product.imageUrl}"
                                                             alt="${item.product.name}" class="product-image"
                                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/${item.product.imageUrl}"
                                                             alt="${item.product.name}" class="product-image"
                                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="product-image-placeholder" style="display: none;">
                                                    <svg viewBox="0 0 24 24" class="placeholder-icon">
                                                        <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                                                    </svg>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-image-placeholder">
                                                    <svg viewBox="0 0 24 24" class="placeholder-icon">
                                                        <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                                                    </svg>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="product-name">${item.product.name}</div>
                                        <div class="browse-count">${item.durationSeconds} 次浏览</div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="btn-group">
                <a href="customer-management?action=purchase-stats" class="btn-secondary">购买统计</a>
                <a href="product-management" class="btn-secondary">商品管理</a>
                <a href="seller-orders" class="btn-secondary">订单管理</a>
            </div>
        </main>
        
        <!-- 页脚 -->
        <footer class="modern-footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h4>关于JavaNet</h4>
                        <ul>
                            <li><a href="info/about">公司介绍</a></li>
                            <li><a href="info/contact">联系我们</a></li>
                            <li><a href="info/careers">招聘信息</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h4>客户服务</h4>
                        <ul>
                            <li><a href="info/help">帮助中心</a></li>
                            <li><a href="info/returns">退换货政策</a></li>
                            <li><a href="info/shipping">配送信息</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h4>购物指南</h4>
                        <ul>
                            <li><a href="info/how-to-buy">如何购买</a></li>
                            <li><a href="info/payment">支付方式</a></li>
                            <li><a href="info/membership">会员权益</a></li>
                        </ul>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2025 JavaNet 在线商城. 保留所有权利.</p>
                </div>
            </div>
        </footer>
    </div>
    
    <script>
        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('客户管理页面加载完成');
        });

        // 搜索功能
        document.querySelector('.search-input').addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                const query = this.value.trim();
                if (query) {
                    window.location.href = 'products?search=' + encodeURIComponent(query);
                }
            }
        });

        document.querySelector('.search-btn').addEventListener('click', function () {
            const query = document.querySelector('.search-input').value.trim();
            if (query) {
                window.location.href = 'products?search=' + encodeURIComponent(query);
            }
        });

        // 用户下拉菜单功能
        function toggleDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        }

        // 点击其他地方关闭下拉菜单
        document.addEventListener('click', function(event) {
            const userMenu = document.querySelector('.user-menu');
            const dropdown = document.getElementById('userDropdown');
            
            if (userMenu && dropdown && !userMenu.contains(event.target)) {
                dropdown.style.display = 'none';
            }
        });
    </script>
</body>
</html>