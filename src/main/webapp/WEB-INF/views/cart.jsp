<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
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
                                    <a href="browse-history" class="dropdown-item">浏览记录</a>
                                    <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                        <a href="product-management" class="dropdown-item">商品管理</a>
                                        <a href="customer-management" class="dropdown-item">客户管理</a>
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
                                    <p class="item-price"><fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/></p>
                                </div>
                                <div class="item-quantity">
                                    <button onclick="decreaseQuantity(${item.productId}, ${item.quantity}, ${item.product.stock})" class="qty-btn">
                                        <svg viewBox="0 0 24 24" width="16" height="16"><path d="M19 13H5v-2h14v2z"/></svg>
                                    </button>
                                    <input type="number" value="${item.quantity}" min="1" max="${item.product.stock}"
                                           onchange="updateQuantity(${item.productId}, this.value, ${item.product.stock})" class="qty-input" readonly>
                                    <button onclick="increaseQuantity(${item.productId}, ${item.quantity}, ${item.product.stock})" class="qty-btn">
                                        <svg viewBox="0 0 24 24" width="16" height="16"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                                    </button>
                                </div>
                                <div class="item-subtotal-area">
                                    <div class="item-subtotal">
                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                                    </div>
                                    <button onclick="removeItem(${item.productId})" class="btn-remove">移除商品</button>
                                </div>
                            </div>
                            <c:set var="total" value="${total + item.subtotal}" />
                        </c:forEach>
                    </div>
                    
                    <div class="cart-summary">
                        <div class="summary-row">
                            <span>商品总计：</span>
                            <span class="total-amount"><fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="summary-actions">
                            <a href="checkout" class="btn-checkout">去结算</a>
                            <div class="summary-sub-actions">
                                <a href="products" class="btn-continue">继续购物</a>
                                <button onclick="clearCart()" class="btn-clear">清空购物车</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        function updateQuantity(productId, quantity, maxStock) {
            quantity = parseInt(quantity);
            
            if (isNaN(quantity) || quantity < 1) {
                showAlert('请输入有效的数量', 'warning').then(() => {
                    location.reload();
                });
                return;
            }
            
            if (quantity > maxStock) {
                showAlert('库存不足，最多只能购买 ' + maxStock + ' 件', 'warning').then(() => {
                    location.reload();
                });
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
                    showAlert('更新失败: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('网络错误，请重试', 'error');
            });
        }
        
        function increaseQuantity(productId, currentQuantity, maxStock) {
            const newQuantity = currentQuantity + 1;
            if (newQuantity > maxStock) {
                showAlert('库存不足，最多只能购买 ' + maxStock + ' 件', 'warning');
                return;
            }
            updateQuantity(productId, newQuantity, maxStock);
        }
        
        function decreaseQuantity(productId, currentQuantity, maxStock) {
            const newQuantity = currentQuantity - 1;
            if (newQuantity < 1) {
                removeItem(productId);
                return;
            }
            updateQuantity(productId, newQuantity, maxStock);
        }
        
        function removeItem(productId) {
            showConfirm('确定要移除这个商品吗？', function() {
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
                        showAlert('商品已移除', 'success').then(() => {
                            location.reload();
                        });
                    } else {
                        showAlert('移除失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('移除失败: 网络错误', 'error');
                });
            }, { type: 'danger', title: '移除商品' });
        }
        
        function clearCart() {
            showConfirm('确定要清空购物车吗？', function() {
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
                        showAlert('购物车已清空', 'success').then(() => {
                            location.reload();
                        });
                    } else {
                        showAlert('清空失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('清空失败: 网络错误', 'error');
                });
            }, { type: 'danger', title: '清空购物车' });
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