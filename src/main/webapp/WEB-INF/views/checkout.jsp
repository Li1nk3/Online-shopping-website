<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>结算 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
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
            <a href="products">商品列表</a> > <a href="cart">购物车</a> > <span>结算</span>
        </div>
        
        <h2>订单结算</h2>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <div class="checkout-container">
            <div class="checkout-main">
                <!-- 收货信息 -->
                <div class="checkout-section">
                    <h3>收货信息</h3>
                    <form action="checkout" method="post" id="checkoutForm">
                        <div class="form-group">
                            <label for="receiverName">收货人姓名:</label>
                            <input type="text" id="receiverName" name="receiverName" 
                                   value="${user.username}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="receiverPhone">联系电话:</label>
                            <input type="tel" id="receiverPhone" name="receiverPhone" 
                                   value="${user.phone}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="shippingAddress">收货地址:</label>
                            <textarea id="shippingAddress" name="shippingAddress" 
                                      rows="3" required placeholder="请输入详细的收货地址">${user.address}</textarea>
                        </div>
                </div>
                
                <!-- 支付方式 -->
                <div class="checkout-section">
                    <h3>支付方式</h3>
                    <div class="payment-methods">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="online" checked>
                            <span class="payment-label">在线支付</span>
                            <small>支持支付宝、微信支付、银行卡</small>
                        </label>
                        
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="cod">
                            <span class="payment-label">货到付款</span>
                            <small>送货上门后付款</small>
                        </label>
                    </div>
                </div>
                
                <!-- 商品清单 -->
                <div class="checkout-section">
                    <h3>商品清单</h3>
                    <div class="order-items">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="order-item">
                                <div class="item-image">
                                    <img src="${item.product.imageUrl}" alt="${item.product.name}">
                                </div>
                                <div class="item-info">
                                    <h4>${item.product.name}</h4>
                                    <p class="item-price"><fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/></p>
                                </div>
                                <div class="item-quantity">
                                    数量: ${item.quantity}
                                </div>
                                <div class="item-subtotal">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                    </form>
            </div>
            
            <!-- 订单摘要 -->
            <div class="checkout-summary">
                <h3>订单摘要</h3>
                <div class="summary-row">
                    <span>商品总计:</span>
                    <span class="amount"><fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="summary-row">
                    <span>运费:</span>
                    <span>免费</span>
                </div>
                <div class="summary-row total">
                    <span>应付总额:</span>
                    <span class="total-amount"><fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                </div>
                
                <div class="checkout-actions">
                    <a href="cart" class="btn-back">返回购物车</a>
                    <button type="submit" form="checkoutForm" class="btn-submit-order">提交订单</button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // 结算表单验证
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const address = document.getElementById('shippingAddress').value.trim();
            if (!address) {
                e.preventDefault();
                showAlert('请填写收货地址', 'warning');
                return false;
            }
            
            e.preventDefault();
            showConfirm('确认提交订单吗？', function() {
                document.getElementById('checkoutForm').submit();
            }, { title: '提交订单' });
        });

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