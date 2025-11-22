<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理 - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="modern-header">
        <div class="nav-container">
            <div class="nav-left">
                <a href="home" class="logo"><span class="logo-text">JavaNet</span></a>
                <div class="nav-links">
                    <a href="product-management" class="nav-link">商品管理</a>
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
                            <span>订单</span>
                        </a>
                        <div class="user-menu">
                            <span class="user-name" onclick="toggleDropdown()">欢迎, ${sessionScope.user.username} ▼</span>
                            <div class="dropdown">
                                <a href="profile" class="dropdown-item">个人信息</a>
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
            <a href="home">首页</a> > <span>订单管理</span>
        </div>
        
        <div class="management-header">
            <h2>订单管理</h2>
        </div>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">${param.error}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-placeholder">
                    <h3>暂无订单</h3>
                    <p>还没有客户购买您的商品。</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="orders-layout">
                    <!-- 左侧订单列表 -->
                    <div class="orders-sidebar">
                        <c:forEach var="order" items="${orders}" varStatus="status">
                            <div class="order-tab-link ${status.first ? 'active' : ''}" onclick="showOrder('${order.id}', this)">
                                <div class="order-tab-number">订单号: ${order.orderNumber}</div>
                                <div class="order-tab-date"><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd"/></div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- 右侧订单详情 -->
                    <div class="orders-content-area">
                        <c:forEach var="order" items="${orders}" varStatus="status">
                            <div id="order-${order.id}" class="single-order-view ${status.first ? 'active' : ''}">
                                <div class="order-detail-header">
                                    <h3>订单详情</h3>
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
                                        <c:when test="${order.orderStatus == 'completed'}">
                                            <span class="status-badge status-completed">已完成</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'cancelled'}">
                                            <span class="status-badge status-cancelled">已取消</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="order-detail-grid">
                                    <div class="detail-group">
                                        <h5>订单号</h5>
                                        <div class="detail-value">${order.orderNumber}</div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>下单时间</h5>
                                        <div class="detail-value"><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>买家信息</h5>
                                        <div class="detail-value">${buyers[order.userId].username}</div>
                                    </div>
                                    <div class="detail-group">
                                        <h5>订单总额</h5>
                                        <div class="detail-value amount"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></div>
                                    </div>
                                </div>
                                
                                <div class="detail-group" style="margin-bottom: 30px;">
                                    <h5>收货地址</h5>
                                    <div class="detail-value">${order.shippingAddress}</div>
                                </div>
                                
                                <div class="order-actions-seller">
                                    <a href="order-detail?id=${order.id}" class="btn-view-detail">查看完整详情</a>
                                    <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'paid'}">
                                        <form action="seller-orders" method="post" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="confirm">
                                            <button type="submit" class="btn-confirm-order">
                                                确认订单
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'confirmed' || order.orderStatus == 'processing'}">
                                        <form action="seller-orders" method="post" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="ship">
                                            <button type="submit" class="btn-ship-order">
                                                发货
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${sessionScope.user.role == 'admin'}">
                                        <form action="seller-orders" method="post" style="display: inline;" onsubmit="return confirm('确定要删除这个订单吗？删除后无法恢复！');">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="btn-delete-order">
                                                删除订单
                                            </button>
                                        </form>
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
        function showOrder(orderId, tabElement) {
            document.querySelectorAll('.order-tab-link').forEach(link => link.classList.remove('active'));
            tabElement.classList.add('active');
            document.querySelectorAll('.single-order-view').forEach(view => view.classList.remove('active'));
            document.getElementById('order-' + orderId).classList.add('active');
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