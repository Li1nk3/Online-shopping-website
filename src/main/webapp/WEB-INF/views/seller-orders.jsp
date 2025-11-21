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
                                    <span class="status-badge status-${order.orderStatus}">${order.orderStatus}</span>
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
                                            <button type="submit" class="btn-primary">
                                                确认订单
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.orderStatus == 'confirmed' || order.orderStatus == 'processing'}">
                                        <form action="seller-orders" method="post" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="ship">
                                            <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #007bff, #0056b3);">
                                                发货
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