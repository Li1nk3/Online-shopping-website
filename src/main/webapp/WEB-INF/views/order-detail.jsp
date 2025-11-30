<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单详情 - JavaNet 在线商城</title>
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
            <a href="home">首页</a> > 
            <a href="orders">我的订单</a> > 
            <span>订单详情</span>
        </div>
        
        <div class="order-detail-container">
            <!-- 订单信息卡片 -->
            <div class="order-info-card">
                <h2 class="card-title">
                    <span class="title-icon">
                        <svg viewBox="0 0 24 24" class="icon-svg"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                    </span>
                    订单信息
                </h2>
                
                <div class="info-grid">
                    <div class="info-item">
                        <label>订单号:</label>
                        <span class="order-number">${order.orderNumber}</span>
                    </div>
                    <div class="info-item">
                        <label>下单时间:</label>
                        <span><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
                    </div>
                    <div class="info-item">
                        <label>订单状态:</label>
                        <span>
                            <c:choose>
                                <c:when test="${order.orderStatus == 'pending'}"><span class="status-badge status-pending">待处理</span></c:when>
                                <c:when test="${order.orderStatus == 'confirmed'}"><span class="status-badge status-confirmed">已确认</span></c:when>
                                <c:when test="${order.orderStatus == 'processing'}"><span class="status-badge status-processing">处理中</span></c:when>
                                <c:when test="${order.orderStatus == 'shipped'}"><span class="status-badge status-shipped">已发货</span></c:when>
                                <c:when test="${order.orderStatus == 'delivered'}"><span class="status-badge status-delivered">已送达</span></c:when>
                                <c:when test="${order.orderStatus == 'cancelled'}"><span class="status-badge status-cancelled">已取消</span></c:when>
                                <c:otherwise><span class="status-badge">${order.orderStatus}</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <label>支付方式:</label>
                        <span>
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'online'}">在线支付</c:when>
                                <c:when test="${order.paymentMethod == 'cod'}">货到付款</c:when>
                                <c:otherwise>${order.paymentMethod}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <label>支付状态:</label>
                        <span>
                            <c:choose>
                                <c:when test="${order.paymentStatus == 'pending'}"><span class="payment-pending">待支付</span></c:when>
                                <c:when test="${order.paymentStatus == 'paid'}"><span class="payment-paid">已支付</span></c:when>
                                <c:when test="${order.paymentStatus == 'failed'}"><span class="payment-failed">支付失败</span></c:when>
                                <c:when test="${order.paymentStatus == 'refunded'}"><span class="payment-refunded">已退款</span></c:when>
                                <c:otherwise><span class="payment-pending">${order.paymentStatus}</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item full-width">
                        <label>收货地址:</label>
                        <span>${order.shippingAddress}</span>
                    </div>
                </div>
            </div>
            
            <!-- 商品列表卡片 -->
            <div class="order-items-card">
                <h2 class="card-title">
                    <span class="title-icon">
                        <svg viewBox="0 0 24 24" class="icon-svg"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6-2h4v2h-4V4zm-6 2h4V4h-4v2z"/></svg>
                    </span>
                    商品清单
                </h2>
                
                <div class="cart-items" style="border-top: 1px solid var(--border-color);">
                    <c:forEach var="item" items="${orderItems}">
                        <div class="cart-item">
                            <div class="item-image">
                                <img src="${not empty item.imageUrl ? item.imageUrl : 'https://via.placeholder.com/100x100/F0F0F0/999999?text=暂无图片'}" alt="${item.productName}">
                            </div>
                            <div class="item-info">
                                <h4><a href="products?id=${item.productId}">${item.productName}</a></h4>
                            </div>
                            <div class="item-quantity-static">
                                <div class="item-price"><fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></div>
                                <div class="quantity-static-text">x ${item.quantity}</div>
                            </div>
                            <div class="item-subtotal-area">
                                <div class="item-subtotal">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="order-summary">
                    <div class="summary-row total">
                        <span class="summary-label">订单总计:</span>
                        <span class="summary-value total-amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="order-actions-detail">
                <a href="orders" class="btn-back-order btn-primary">返回订单列表</a>
                
                <!-- 买家操作按钮 -->
                <c:if test="${sessionScope.user.id == order.userId}">
                    <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'pending'}">
                        <button class="btn-cancel-order" onclick="cancelOrder('${order.id}')">取消订单</button>
                    </c:if>
                    <c:if test="${order.paymentStatus == 'pending' && order.orderStatus != 'cancelled'}">
                        <a href="payment?orderNumber=${order.orderNumber}" class="btn-pay-now">立即付款</a>
                    </c:if>
                    <c:if test="${order.orderStatus == 'shipped'}">
                        <button class="btn-confirm-delivery" onclick="confirmReceipt('${order.id}')">确认收货</button>
                    </c:if>
                </c:if>
                
                <!-- 卖家操作按钮 -->
                <c:if test="${isSeller && order.paymentStatus == 'paid' && order.orderStatus != 'shipped' && order.orderStatus != 'delivered' && order.orderStatus != 'cancelled'}">
                    <button class="btn-ship-order" onclick="shipOrder('${order.id}')">发货</button>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
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

        // 取消订单功能
        function cancelOrder(orderId) {
            showConfirm('确定要取消这个订单吗？', function() {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'orders', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                showAlert('订单已成功取消！', 'success').then(() => {
                                    window.location.reload();
                                });
                            } else {
                                showAlert('取消订单失败: ' + (response.message || '未知错误'), 'error');
                            }
                        } catch (e) {
                            showAlert('取消订单失败: 服务器响应格式错误', 'error');
                        }
                    }
                };
                
                xhr.onerror = function() {
                    showAlert('取消订单失败: 网络错误', 'error');
                };
                
                xhr.send('action=cancel&orderId=' + encodeURIComponent(orderId));
            }, { type: 'danger', title: '取消订单' });
        }

        // 确认收货功能
        function confirmReceipt(orderId) {
            showConfirm('确定要确认收货吗？', function() {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'orders', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                showAlert('确认收货成功！', 'success').then(() => {
                                    window.location.reload();
                                });
                            } else {
                                showAlert('确认收货失败: ' + (response.message || '未知错误'), 'error');
                            }
                        } catch (e) {
                            showAlert('确认收货失败: 服务器响应格式错误', 'error');
                        }
                    }
                };
                
                xhr.onerror = function() {
                    showAlert('确认收货失败: 网络错误', 'error');
                };
                
                xhr.send('action=confirmDelivery&orderId=' + encodeURIComponent(orderId));
            }, { type: 'success', title: '确认收货' });
        }

        // 卖家发货功能
        function shipOrder(orderId) {
            showConfirm('确定要发货吗？发货后买家将收到通知。', function() {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'order-detail', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                showAlert('发货成功！买家已收到通知', 'success').then(() => {
                                    window.location.reload();
                                });
                            } else {
                                showAlert('发货失败: ' + (response.message || '未知错误'), 'error');
                            }
                        } catch (e) {
                            showAlert('发货失败: 服务器响应格式错误', 'error');
                        }
                    }
                };
                
                xhr.onerror = function() {
                    showAlert('发货失败: 网络错误', 'error');
                };
                
                xhr.send('action=ship&orderId=' + encodeURIComponent(orderId));
            }, { type: 'warning', title: '确认发货' });
        }
    </script>
</body>
</html>