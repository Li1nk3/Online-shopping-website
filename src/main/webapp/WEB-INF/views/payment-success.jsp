<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>支付成功 - JavaNet 在线商城</title>
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
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > <a href="orders">我的订单</a> > <span>支付成功</span>
        </div>
        
        <div class="payment-success-container">
            <div class="success-icon-wrapper">
                <svg class="success-icon" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="11" fill="#4CAF50"/>
                    <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z" fill="white"/>
                </svg>
            </div>
            
            <h1 class="success-title">支付成功!</h1>
            <p class="success-message">感谢您的购买,我们将尽快为您发货</p>
            
            <div class="order-info-card">
                <h3 class="card-title">订单信息</h3>
                <div class="info-row">
                    <span class="info-label">订单号:</span>
                    <span class="info-value">${order.orderNumber}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">订单金额:</span>
                    <span class="info-value amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="info-row">
                    <span class="info-label">支付方式:</span>
                    <span class="info-value">Stripe</span>
                </div>
                <div class="info-row">
                    <span class="info-label">支付时间:</span>
                    <span class="info-value"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd HH:mm:ss"/></span>
                </div>
            </div>
            
            <div class="verification-status" id="verificationStatus">
                <div class="status-icon">⏳</div>
                <div class="status-text">正在验证支付状态...</div>
            </div>
            
            <div class="action-buttons">
                <a href="order-detail?orderNumber=${order.orderNumber}" class="btn btn-primary">查看订单详情</a>
                <a href="products" class="btn btn-secondary">继续购物</a>
            </div>
        </div>
    </div>
    
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
    
    <script>
        // 验证Stripe支付
        const sessionId = '${sessionId}';
        const orderNumber = '${order.orderNumber}';
        
        if (sessionId) {
            fetch('payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=verify-payment&orderNumber=' + orderNumber + '&sessionId=' + sessionId
            })
            .then(response => response.json())
            .then(data => {
                const statusDiv = document.getElementById('verificationStatus');
                if (data.success) {
                    statusDiv.innerHTML = '<div class="status-icon">✓</div><div class="status-text status-success">支付已确认!</div>';
                    statusDiv.className = 'verification-status success';
                } else {
                    statusDiv.innerHTML = '<div class="status-icon">✗</div><div class="status-text status-error">支付验证失败: ' + data.message + '</div>';
                    statusDiv.className = 'verification-status error';
                }
                
                // 3秒后隐藏消息
                setTimeout(() => {
                    statusDiv.style.display = 'none';
                }, 3000);
            })
            .catch(error => {
                console.error('Error:', error);
                const statusDiv = document.getElementById('verificationStatus');
                statusDiv.innerHTML = '<div class="status-icon">✗</div><div class="status-text status-error">验证支付时出错</div>';
                statusDiv.className = 'verification-status error';
            });
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
            const dropdown = document.getElementById('userDropdown');
            if (dropdown) {
                dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            }
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