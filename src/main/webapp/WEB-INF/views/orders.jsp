<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="cart" class="btn-cart-nav">购物车</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > <span>我的订单</span>
        </div>
        
        <h2>我的订单</h2>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-orders">
                    <h3>您还没有任何订单</h3>
                    <p>快去挑选您喜欢的商品吧！</p>
                    <a href="products" class="btn-primary">开始购物</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="orders-list">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div class="order-info">
                                    <h4>订单号: ${order.orderNumber}</h4>
                                    <p class="order-date">
                                        <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
                                            <span class="status-badge status-pending">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="order-details">
                                <div class="order-amount">
                                    <span class="label">订单金额:</span>
                                    <span class="amount">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                </div>
                                
                                <div class="payment-info">
                                    <span class="label">支付方式:</span>
                                    <span class="payment-method">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'online'}">在线支付</c:when>
                                            <c:when test="${order.paymentMethod == 'cod'}">货到付款</c:when>
                                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    
                                    <span class="payment-status">
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
                                    </span>
                                </div>
                                
                                <div class="shipping-address">
                                    <span class="label">收货地址:</span>
                                    <span class="address">${order.shippingAddress}</span>
                                </div>
                            </div>
                            
                            <div class="order-actions">
                                <a href="order-detail?id=${order.id}" class="btn-view-detail">查看详情</a>
                                <c:if test="${order.orderStatus == 'pending' && order.paymentStatus == 'pending'}">
                                    <button class="btn-cancel-order" onclick="cancelOrder('${order.id}')">取消订单</button>
                                </c:if>
                                <c:if test="${order.paymentStatus == 'pending' && order.paymentMethod == 'online' && order.orderStatus != 'cancelled'}">
                                    <button class="btn-pay-now" onclick="payOrder('${order.id}')">立即支付</button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        function cancelOrder(orderId) {
            if (confirm('确定要取消这个订单吗？')) {
                // 发送AJAX请求取消订单
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'orders', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        try {
                            var response = JSON.parse(xhr.responseText);
                            if (xhr.status === 200 && response.success) {
                                alert('订单已成功取消！');
                                // 刷新页面以显示更新后的订单状态
                                window.location.reload();
                            } else {
                                alert('取消订单失败: ' + (response.message || '未知错误'));
                            }
                        } catch (e) {
                            alert('取消订单失败: 服务器响应格式错误');
                        }
                    }
                };
                
                xhr.onerror = function() {
                    alert('取消订单失败: 网络错误');
                };
                
                // 发送请求
                xhr.send('action=cancel&orderId=' + encodeURIComponent(orderId));
            }
        }
        
        function payOrder(orderId) {
            // 这里可以添加支付功能
            alert('支付功能待实现');
        }
    </script>
</body>
</html>