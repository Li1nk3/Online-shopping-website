<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单付款 - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
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
            <a href="products">商品列表</a> > <a href="orders">我的订单</a> > <span>订单付款</span>
        </div>
        
        <div class="payment-container">
            <div class="payment-header">
                <h2>订单付款</h2>
                <p class="order-info">订单号: <strong>${order.orderNumber}</strong></p>
            </div>
            
            <div class="payment-amount">
                <div class="amount-label">应付金额</div>
                <div class="amount-value amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></div>
            </div>
            
            <div class="payment-methods-section">
                <h3>选择支付方式</h3>
                <div class="payment-options-grid">
                    <label class="payment-method-card">
                        <input type="radio" name="paymentMethod" value="alipay" checked>
                        <div class="method-content">
                            <div class="method-icon">
                                <svg viewBox="0 0 24 24" class="payment-icon-svg">
                                    <path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/>
                                    <circle cx="6" cy="16" r="1"/>
                                    <circle cx="10" cy="16" r="1"/>
                                    <circle cx="14" cy="16" r="1"/>
                                    <circle cx="18" cy="16" r="1"/>
                                </svg>
                            </div>
                            <div class="method-name">支付宝</div>
                            <div class="method-desc">推荐使用</div>
                        </div>
                    </label>
                    
                    <label class="payment-method-card">
                        <input type="radio" name="paymentMethod" value="wechat">
                        <div class="method-content">
                            <div class="method-icon">
                                <svg viewBox="0 0 24 24" class="payment-icon-svg">
                                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                                </svg>
                            </div>
                            <div class="method-name">微信支付</div>
                            <div class="method-desc">快捷支付</div>
                        </div>
                    </label>
                    
                    <label class="payment-method-card">
                        <input type="radio" name="paymentMethod" value="bank">
                        <div class="method-content">
                            <div class="method-icon">
                                <svg viewBox="0 0 24 24" class="payment-icon-svg">
                                    <rect x="2" y="4" width="20" height="16" rx="2" ry="2" fill="none" stroke="currentColor" stroke-width="2"/>
                                    <path d="M5 8h14M5 12h14M5 16h14" stroke="currentColor" stroke-width="2"/>
                                </svg>
                            </div>
                            <div class="method-name">银行卡</div>
                            <div class="method-desc">支持各大银行</div>
                        </div>
                    </label>
                </div>
            </div>
            
            <div class="payment-actions">
                <a href="orders" class="btn-back-payment">返回订单列表</a>
                <button onclick="processPayment()" class="btn-pay-now" id="payButton">
                    <span class="btn-text">立即支付</span>
                    <span class="btn-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- 自定义确认对话框 -->
    <div id="confirmDialog" class="confirm-dialog-overlay" style="display: none;">
        <div class="confirm-dialog">
            <div class="confirm-dialog-header">
                <h3>确认支付</h3>
            </div>
            <div class="confirm-dialog-body">
                <p>确认支付 <strong class="confirm-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong> 元吗？</p>
                <p class="confirm-method">支付方式：<span id="selectedPaymentMethod">支付宝</span></p>
            </div>
            <div class="confirm-dialog-actions">
                <button class="btn-confirm-cancel" onclick="closeConfirmDialog()">取消</button>
                <button class="btn-confirm-ok" onclick="confirmPayment()">确认支付</button>
            </div>
        </div>
    </div>
    
    <script>
        // 支付处理功能
        function processPayment() {
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            const paymentMethodNames = {
                'alipay': '支付宝',
                'wechat': '微信支付',
                'bank': '银行卡'
            };
            
            // 显示选中的支付方式
            document.getElementById('selectedPaymentMethod').textContent = paymentMethodNames[paymentMethod];
            
            // 显示自定义确认对话框
            document.getElementById('confirmDialog').style.display = 'flex';
        }

        // 关闭确认对话框
        function closeConfirmDialog() {
            document.getElementById('confirmDialog').style.display = 'none';
        }

        // 确认支付
        function confirmPayment() {
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            const payButton = document.getElementById('payButton');
            
            closeConfirmDialog();
            
            payButton.disabled = true;
            payButton.innerHTML = '<span class="btn-text">处理中...</span>';
            
            fetch('payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=process&orderNumber=${order.orderNumber}&paymentMethod=' + paymentMethod
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('付款成功！', 'success');
                    setTimeout(() => {
                        window.location.href = 'order-detail?orderNumber=' + data.orderNumber;
                    }, 1500);
                } else {
                    showNotification('付款失败: ' + data.message, 'error');
                    payButton.disabled = false;
                    payButton.innerHTML = '<span class="btn-text">立即支付</span><span class="btn-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('网络错误，请重试', 'error');
                payButton.disabled = false;
                payButton.innerHTML = '<span class="btn-text">立即支付</span><span class="btn-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>';
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