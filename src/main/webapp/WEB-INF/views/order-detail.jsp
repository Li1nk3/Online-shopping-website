<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单详情 - JavaNet 在线商城</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛒</text></svg>">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="cart" class="btn-cart-nav">购物车</a>
            <a href="orders" class="btn-link">我的订单</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > 
            <a href="orders">我的订单</a> > 
            <span>订单详情</span>
        </div>
        
        <div class="order-detail-container">
            <!-- 订单信息卡片 -->
            <div class="order-info-card">
                <h2 class="card-title">
                    <span class="title-icon">📋</span>
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
                                    <span class="status-badge">${order.orderStatus}</span>
                                </c:otherwise>
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
                                    ${order.paymentStatus}
                                </c:otherwise>
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
                    <span class="title-icon">📦</span>
                    商品清单
                </h2>
                
                <div class="items-list">
                    <c:forEach var="item" items="${orderItems}">
                        <div class="order-item-row">
                            <div class="item-image">
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <img src="${item.imageUrl}" alt="${item.productName}" 
                                             onerror="this.src='https://via.placeholder.com/80x80/F0F0F0/999999?text=暂无图片'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/80x80/F0F0F0/999999?text=暂无图片" alt="${item.productName}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="item-info">
                                <h3 class="item-name">
                                    <a href="products?id=${item.productId}">${item.productName}</a>
                                </h3>
                                <div class="item-details">
                                    <span class="item-price">单价: ¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></span>
                                    <span class="item-quantity">数量: ${item.quantity}</span>
                                    <span class="item-subtotal">小计: ¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="order-summary">
                    <div class="summary-row">
                        <span class="summary-label">商品总额:</span>
                        <span class="summary-value">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="summary-row total">
                        <span class="summary-label">订单总计:</span>
                        <span class="summary-value total-amount">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                    </div>
                </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="order-actions-detail">
                <button onclick="history.back()" class="btn-back-order">返回订单列表</button>
                
                <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'pending'}">
                    <button class="btn-cancel-order" onclick="cancelOrder('${order.id}')">取消订单</button>
                </c:if>
                
                <c:if test="${order.paymentStatus == 'pending' && order.paymentMethod == 'online'}">
                    <button class="btn-pay-now" onclick="payOrder('${order.id}')">立即支付</button>
                </c:if>
                
                <c:if test="${order.orderStatus == 'delivered'}">
                    <button class="btn-confirm-receipt" onclick="confirmReceipt('${order.id}')">确认收货</button>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function cancelOrder(orderId) {
            if (confirm('确定要取消这个订单吗？')) {
                alert('取消订单功能待实现');
            }
        }
        
        function payOrder(orderId) {
            alert('支付功能待实现');
        }
        
        function confirmReceipt(orderId) {
            if (confirm('确认已收到商品吗？')) {
                alert('确认收货功能待实现');
            }
        }
    </script>
</body>
</html>