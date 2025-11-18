<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理 - JavaNet 在线商城</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛒</text></svg>">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="product-management" class="btn-cart-nav">商品管理</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > <span>订单管理</span>
        </div>
        
        <div class="management-header">
            <h2>📦 订单管理</h2>
        </div>
        
        <!-- 成功/错误消息 -->
        <c:if test="${not empty param.success}">
            <div class="success-message">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="error-message">${param.error}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-orders">
                    <h3>暂无订单</h3>
                    <p>还没有客户购买您的商品</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="seller-orders-list">
                    <c:forEach var="order" items="${orders}">
                        <div class="seller-order-card">
                            <div class="order-header">
                                <div class="order-info">
                                    <h4>订单号: ${order.orderNumber}</h4>
                                    <p class="order-date">
                                        <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </p>
                                    <p class="buyer-info">
                                        <span class="label">买家:</span>
                                        <span class="buyer-name">${buyers[order.userId].username}</span>
                                    </p>
                                </div>
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
                                            <span class="status-badge">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <br>
                                    <span class="payment-status">
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'pending'}">
                                                <span class="payment-pending">待支付</span>
                                            </c:when>
                                            <c:when test="${order.paymentStatus == 'paid'}">
                                                <span class="payment-paid">已支付</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>${order.paymentStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            
                            <!-- 商品列表 -->
                            <div class="order-items-section">
                                <h5>我的商品:</h5>
                                <div class="items-grid">
                                    <c:forEach var="item" items="${orderItemsMap[order.id]}">
                                        <div class="seller-order-item">
                                            <div class="item-image">
                                                <c:choose>
                                                    <c:when test="${not empty item.imageUrl}">
                                                        <img src="${item.imageUrl}" alt="${item.productName}"
                                                             onerror="this.src='https://via.placeholder.com/60x60/F0F0F0/999999?text=暂无图片'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/60x60/F0F0F0/999999?text=暂无图片" alt="${item.productName}">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="item-details">
                                                <h6>${item.productName}</h6>
                                                <p>单价: ¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></p>
                                                <p>数量: ${item.quantity}</p>
                                                <p class="item-subtotal">小计: ¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <div class="order-footer">
                                <div class="shipping-info">
                                    <span class="label">收货地址:</span>
                                    <span>${order.shippingAddress}</span>
                                </div>
                                
                                <div class="order-actions-seller">
                                    <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'paid'}">
                                        <form action="seller-orders" method="post" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="confirm">
                                            <button type="submit" class="btn-confirm-order">确认订单</button>
                                        </form>
                                    </c:if>
                                    
                                    <c:if test="${order.orderStatus == 'confirmed' || order.orderStatus == 'processing'}">
                                        <form action="seller-orders" method="post" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="ship">
                                            <button type="submit" class="btn-ship-order">发货</button>
                                        </form>
                                    </c:if>
                                    
                                    <c:if test="${order.orderStatus == 'shipped'}">
                                        <form action="seller-orders" method="post" style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <input type="hidden" name="action" value="deliver">
                                            <button type="submit" class="btn-deliver-order">标记送达</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>