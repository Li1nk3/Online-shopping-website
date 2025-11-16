<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>结算 - JavaNet 在线商城</title>
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
                                    <p class="item-price">¥<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/></p>
                                </div>
                                <div class="item-quantity">
                                    数量: ${item.quantity}
                                </div>
                                <div class="item-subtotal">
                                    ¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
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
                    <span>¥<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                </div>
                <div class="summary-row">
                    <span>运费:</span>
                    <span>免费</span>
                </div>
                <div class="summary-row total">
                    <span>应付总额:</span>
                    <span class="total-amount">¥<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/></span>
                </div>
                
                <div class="checkout-actions">
                    <a href="cart" class="btn-back">返回购物车</a>
                    <button type="submit" form="checkoutForm" class="btn-submit-order">提交订单</button>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const address = document.getElementById('shippingAddress').value.trim();
            if (!address) {
                e.preventDefault();
                alert('请填写收货地址');
                return false;
            }
            
            if (confirm('确认提交订单吗？')) {
                return true;
            } else {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>