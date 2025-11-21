<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - JavaNet 在线商城</title>
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
            <a href="products">商品列表</a> > <span>我的订单</span>
        </div>
        
        <h2>
            <c:choose>
                <c:when test="${userRole == 'admin'}">所有订单</c:when>
                <c:when test="${userRole == 'seller'}">订单管理</c:when>
                <c:otherwise>我的订单</c:otherwise>
            </c:choose>
        </h2>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-orders">
                    <h3>
                        <c:choose>
                            <c:when test="${userRole == 'admin'}">暂无订单</c:when>
                            <c:when test="${userRole == 'seller'}">暂无相关订单</c:when>
                            <c:otherwise>您还没有任何订单</c:otherwise>
                        </c:choose>
                    </h3>
                    <p>
                        <c:choose>
                            <c:when test="${userRole == 'admin'}">系统中还没有任何订单</c:when>
                            <c:when test="${userRole == 'seller'}">还没有客户购买您的商品</c:when>
                            <c:otherwise>快去挑选您喜欢的商品吧！</c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${userRole != 'admin' && userRole != 'seller'}">
                        <a href="products" class="btn-primary">开始购物</a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="orders-layout">
                    <!-- 左侧订单列表选项卡 -->
                    <div class="orders-sidebar">
                        <c:forEach var="order" items="${orders}" varStatus="status">
                            <div class="order-tab-link ${status.first ? 'active' : ''}" onclick="showOrder('${order.id}', this)">
                                <div class="order-tab-number">订单号: ${order.orderNumber}</div>
                                <div class="order-tab-date">
                                    <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- 右侧订单详情内容 -->
                    <div class="orders-content-area">
                        <c:forEach var="order" items="${orders}" varStatus="status">
                            <div id="order-${order.id}" class="single-order-view ${status.first ? 'active' : ''}">
                                <div class="order-detail-header">
                                    <h3>订单详情</h3>
                                    <div class="order-status">
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'pending'}">
                                                <span class="status-badge status-pending">待处理</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'confirmed'}">
                                                <span class="status-badge status-confirmed">已确认</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'processing'}">
                                                <span class="status-badge status-processing">处理中</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'shipped'}">
                                                <span class="status-badge status-shipped">已发货</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'delivered'}">
                                                <span class="status-badge status-delivered">已送达</span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'cancelled'}">
                                                <span class="status-badge status-cancelled">已取消</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending">${order.orderStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="order-detail-grid">
                                    <div class="detail-group">
                                        <h5>订单号</h5>
                                        <div class="detail-value">${order.orderNumber}</div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>下单时间</h5>
                                        <div class="detail-value">
                                            <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>订单金额</h5>
                                        <div class="detail-value amount">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                        </div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>支付方式</h5>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'online'}">在线支付</c:when>
                                                <c:when test="${order.paymentMethod == 'cod'}">货到付款</c:when>
                                                <c:otherwise>${order.paymentMethod}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>支付状态</h5>
                                        <div class="detail-value">
                                            <c:choose>
                                                <c:when test="${order.paymentStatus == 'pending'}">
                                                    <span class="payment-pending">待支付</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatus == 'paid'}">
                                                    <span class="payment-paid">已支付</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatus == 'failed'}">
                                                    <span class="payment-failed">支付失败</span>
                                                </c:when>
                                                <c:when test="${order.paymentStatus == 'refunded'}">
                                                    <span class="payment-refunded">已退款</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="payment-pending">${order.paymentStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-group" style="margin-bottom: 30px;">
                                    <h5>收货地址</h5>
                                    <div class="detail-value">${order.shippingAddress}</div>
                                </div>
                                
                                <div class="order-actions">
                                    <a href="order-detail?id=${order.id}" class="btn-view-detail">查看完整详情</a>
                                    <c:if test="${userRole == 'user' || userRole == null}">
                                        <!-- 普通用户的操作按钮 -->
                                        <c:if test="${order.paymentStatus == 'pending' && order.orderStatus != 'cancelled'}">
                                            <a href="payment?orderNumber=${order.orderNumber}" class="btn-pay-now">立即付款</a>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'pending'}">
                                            <button class="btn-cancel-order" onclick="cancelOrder('${order.id}')">取消订单</button>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${userRole == 'admin'}">
                                        <!-- 管理员的操作按钮 -->
                                        <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'paid'}">
                                            <button class="btn-confirm-order" onclick="confirmOrder('${order.id}')">确认订单</button>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'confirmed' || order.orderStatus == 'processing'}">
                                            <button class="btn-ship-order" onclick="shipOrder('${order.id}')">发货</button>
                                        </c:if>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        function cancelOrder(orderId) {
            showConfirm('确定要取消这个订单吗？', function() {
                // 发送AJAX请求取消订单
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'orders', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                showAlert('订单已成功取消！', 'success').then(() => {
                                    // 刷新页面以显示更新后的订单状态
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
                
                // 发送请求
                xhr.send('action=cancel&orderId=' + encodeURIComponent(orderId));
            }, { type: 'danger', title: '取消订单' });
        }
        
        function payOrder(orderId) {
            // 这里可以添加支付功能
            showAlert('支付功能待实现', 'warning');
        }
        
        function confirmOrder(orderId) {
            showConfirm('确定要确认这个订单吗？', function() {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'orders', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                showAlert('订单已确认！', 'success').then(() => {
                                    window.location.reload();
                                });
                            } else {
                                showAlert('确认订单失败: ' + (response.message || '未知错误'), 'error');
                            }
                        } catch (e) {
                            showAlert('确认订单失败: 服务器响应格式错误', 'error');
                        }
                    }
                };
                
                xhr.onerror = function() {
                    showAlert('确认订单失败: 网络错误', 'error');
                };
                
                xhr.send('action=confirm&orderId=' + encodeURIComponent(orderId));
            }, { type: 'success', title: '确认订单' });
        }
        
        function shipOrder(orderId) {
            showConfirm('确定要标记这个订单为已发货吗？', function() {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'orders', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                showAlert('订单已标记为发货！', 'success').then(() => {
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
            }, { type: 'success', title: '订单发货' });
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
        // 切换订单显示
        function showOrder(orderId, tabElement) {
            // 更新左侧选项卡状态
            document.querySelectorAll('.order-tab-link').forEach(link => {
                link.classList.remove('active');
            });
            tabElement.classList.add('active');
            
            // 更新右侧内容显示
            document.querySelectorAll('.single-order-view').forEach(view => {
                view.classList.remove('active');
            });
            document.getElementById('order-' + orderId).classList.add('active');
        }
    </script>
</body>
</html>