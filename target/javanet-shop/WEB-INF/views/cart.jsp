<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车 - JavaNet 在线商城</title>
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
            <a href="products">商品列表</a> > <span>购物车</span>
        </div>
        
        <h2>我的购物车</h2>
        
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">
                    <h3>购物车是空的</h3>
                    <p>快去挑选您喜欢的商品吧！</p>
                    <a href="products" class="btn-primary">继续购物</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-container">
                    <div class="cart-items">
                        <c:set var="total" value="0" />
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item" data-product-id="${item.productId}">
                                <div class="item-image">
                                    <img src="${item.product.imageUrl}" alt="${item.product.name}">
                                </div>
                                <div class="item-info">
                                    <h4><a href="products?id=${item.productId}">${item.product.name}</a></h4>
                                    <p class="item-price">¥<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/></p>
                                </div>
                                <div class="item-quantity">
                                    <button onclick="updateQuantity(${item.productId}, ${item.quantity - 1})" class="qty-btn">-</button>
                                    <input type="number" value="${item.quantity}" min="1" max="${item.product.stock}" 
                                           onchange="updateQuantity(${item.productId}, this.value)" class="qty-input">
                                    <button onclick="updateQuantity(${item.productId}, ${item.quantity + 1})" class="qty-btn">+</button>
                                </div>
                                <div class="item-subtotal">
                                    ¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                </div>
                                <div class="item-actions">
                                    <button onclick="removeItem(${item.productId})" class="btn-remove">移除</button>
                                </div>
                            </div>
                            <c:set var="total" value="${total + item.subtotal}" />
                        </c:forEach>
                    </div>
                    
                    <div class="cart-summary">
                        <div class="summary-row">
                            <span>商品总计：</span>
                            <span class="total-amount">¥<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="summary-actions">
                            <button onclick="clearCart()" class="btn-clear">清空购物车</button>
                            <a href="products" class="btn-continue">继续购物</a>
                            <a href="checkout" class="btn-checkout">去结算</a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        function updateQuantity(productId, quantity) {
            if (quantity < 1) {
                removeItem(productId);
                return;
            }
            
            fetch('cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=update&productId=' + productId + '&quantity=' + quantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('更新失败: ' + data.message);
                }
            });
        }
        
        function removeItem(productId) {
            if (confirm('确定要移除这个商品吗？')) {
                fetch('cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=remove&productId=' + productId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('移除失败: ' + data.message);
                    }
                });
            }
        }
        
        function clearCart() {
            if (confirm('确定要清空购物车吗？')) {
                fetch('cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=clear'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('清空失败: ' + data.message);
                    }
                });
            }
        }
    </script>
</body>
</html>