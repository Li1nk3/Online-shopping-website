<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单确认 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://js.stripe.com/v3/"></script>
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
                                    <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                        <a href="product-management" class="dropdown-item">商品管理</a>
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
            <a href="products">商品列表</a> > <a href="orders">我的订单</a> > <span>订单确认</span>
        </div>
        
        <div class="payment-container">
            <div class="payment-header">
                <h2>订单确认</h2>
                <p class="order-info">订单号: <strong>${order.orderNumber}</strong></p>
            </div>
            
            <div class="payment-amount">
                <div class="amount-row">
                    <div class="amount-label">应付金额</div>
                    <div class="amount-value amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></div>
                </div>
                
                <!-- Stripe 安全支付提示 -->
                <div class="stripe-security-notice">
                    <div class="stripe-logo">
                        <svg viewBox="0 0 24 24" class="stripe-icon">
                            <path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm-1 14H5c-.55 0-1-.45-1-1V8h16v9c0 .55-.45 1-1 1z"/>
                            <path d="M8 11h8v2H8z"/>
                        </svg>
                        <span class="stripe-text">Stripe</span>
                    </div>
                    <div class="security-text">
                        <strong>安全支付</strong><br>
                        您将通过 Stripe 安全网关进行人民币支付
                    </div>
                </div>
            </div>
            
            <div class="payment-actions">
                <a href="orders" class="btn-back-payment">返回订单列表</a>
                <button onclick="processStripePayment()" class="btn-pay-now" id="payButton">
                    <span class="btn-text">前往 Stripe 支付</span>
                    <span class="btn-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                </button>
            </div>
        </div>
    </div>
    
    
    <script>
        // 初始化Stripe - 使用配置中的发布密钥
        const stripe = Stripe('<%= com.javanet.util.StripeConfig.getPublishableKey() %>');
        
        // 处理Stripe支付
        function processStripePayment() {
            const payButton = document.getElementById('payButton');
            payButton.disabled = true;
            payButton.innerHTML = '<span class="btn-text">正在跳转到Stripe...</span>';
            
            fetch('payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=create-checkout-session&orderNumber=${order.orderNumber}'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 跳转到Stripe Checkout
                    return stripe.redirectToCheckout({ sessionId: data.sessionId });
                } else {
                    throw new Error(data.message || '创建支付会话失败');
                }
            })
            .then(result => {
                if (result.error) {
                    showNotification(result.error.message, 'error');
                    payButton.disabled = false;
                    payButton.innerHTML = '<span class="btn-text">前往 Stripe 支付</span><span class="btn-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('创建支付会话失败: ' + error.message, 'error');
                payButton.disabled = false;
                payButton.innerHTML = '<span class="btn-text">前往 Stripe 支付</span><span class="btn-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>';
            });
        }

        // 显示通知消息
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = `notification notification-${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            // 显示通知
            setTimeout(() => {
                notification.classList.add('show');
            }, 100);
            
            // 3秒后自动隐藏
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    document.body.removeChild(notification);
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