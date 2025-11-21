<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.name} - JavaNet 在线商城</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛒</text></svg>">
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
            <a href="products">商品列表</a> > <span>${product.name}</span>
        </div>
        
        <div class="product-detail">
            <div class="product-image-section">
                <c:choose>
                    <c:when test="${not empty product.images}">
                        <div class="main-image">
                            <c:forEach var="image" items="${product.images}" varStatus="status">
                                <c:if test="${image.primary}">
                                    <img src="${image.imageUrl}" alt="${product.name}" class="detail-image" id="mainImage">
                                </c:if>
                            </c:forEach>
                        </div>
                        <c:if test="${product.images.size() > 1}">
                            <div class="image-thumbnails">
                                <c:forEach var="image" items="${product.images}" varStatus="status">
                                    <img src="${image.imageUrl}" alt="${product.name}"
                                         class="thumbnail-image ${image.primary ? 'active' : ''}"
                                         onclick="changeMainImage('${image.imageUrl}', this)">
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <img src="${product.imageUrl}" alt="${product.name}" class="detail-image">
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="product-info-section">
                <h1 class="product-title">${product.name}</h1>
                <div class="product-category">分类: ${product.category}</div>
                <div class="product-price-large">${product.price}</div>
                <div class="product-stock">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <span class="in-stock">库存: ${product.stock} 件</span>
                        </c:when>
                        <c:otherwise>
                            <span class="out-of-stock">暂时缺货</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="product-description">
                    <h3>商品描述</h3>
                    <p>${product.description}</p>
                </div>
                
                <!-- 卖家信息 -->
                <div class="seller-info">
                    <h3>卖家信息</h3>
                    <div class="seller-details">
                        <div class="seller-info-item">
                            <span class="info-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                            </span>
                            <div class="info-content">
                                <label>卖家名称</label>
                                <span>${seller.username}</span>
                            </div>
                        </div>
                        <div class="seller-info-item">
                            <span class="info-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                            </span>
                            <div class="info-content">
                                <label>联系邮箱</label>
                                <span>${seller.email}</span>
                            </div>
                        </div>
                        <c:if test="${not empty seller.phone}">
                            <div class="seller-info-item">
                                <span class="info-icon">
                                    <svg viewBox="0 0 24 24" class="icon-svg"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
                                </span>
                                <div class="info-content">
                                    <label>联系电话</label>
                                    <span>${seller.phone}</span>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="product-actions">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <c:if test="${product.stock > 0}">
                                <button onclick="addToCart('${product.id}')" class="btn-cart-large">加入购物车</button>
                            </c:if>
                            <c:if test="${product.stock == 0}">
                                <button disabled class="btn-disabled-large">暂时缺货</button>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${product.stock > 0}">
                                <button onclick="promptLogin()" class="btn-cart-large">加入购物车</button>
                            </c:if>
                            <c:if test="${product.stock == 0}">
                                <button disabled class="btn-disabled-large">暂时缺货</button>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                    <button onclick="history.back()" class="btn-back">返回商品列表</button>
                </div>
            </div>
        </div>
        
        <!-- 评论区域 -->
        <div class="reviews-section">
            <!-- 添加评论表单 -->
            <c:choose>
                <c:when test="${sessionScope.user != null && hasPurchased}">
                    <div class="add-review-card">
                        <h3 class="review-card-title">
                            <span class="title-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                            </span>
                            发表您的评价
                        </h3>
                        <form action="review" method="post" class="review-form-modern">
                            <input type="hidden" name="productId" value="${product.id}">
                            <div class="form-section">
                                <label class="form-label">商品评分</label>
                                <div class="star-rating-input">
                                    <input type="radio" name="rating" value="5" id="star5" required>
                                    <label for="star5" class="star-label" title="非常满意">★</label>
                                    <input type="radio" name="rating" value="4" id="star4">
                                    <label for="star4" class="star-label" title="满意">★</label>
                                    <input type="radio" name="rating" value="3" id="star3">
                                    <label for="star3" class="star-label" title="一般">★</label>
                                    <input type="radio" name="rating" value="2" id="star2">
                                    <label for="star2" class="star-label" title="不满意">★</label>
                                    <input type="radio" name="rating" value="1" id="star1">
                                    <label for="star1" class="star-label" title="非常不满意">★</label>
                                </div>
                            </div>
                            <div class="form-section">
                                <label class="form-label" for="comment">评价内容</label>
                                <textarea name="comment" id="comment" rows="5"
                                    placeholder="请分享您的使用体验，帮助其他买家做出更好的选择..."
                                    required></textarea>
                            </div>
                            <button type="submit" class="btn-submit-review-modern">
                                <span class="btn-icon">
                                    <svg viewBox="0 0 24 24" class="icon-svg"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
                                </span>
                                提交评价
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:when test="${sessionScope.user != null && !hasPurchased}">
                    <div class="add-review-card" style="background: #fff3cd; border-color: #ffc107;">
                        <h3 class="review-card-title" style="color: #856404;">
                            <span class="title-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M11 7h2v2h-2zm0 4h2v6h-2zm1-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
                            </span>
                            评价提示
                        </h3>
                        <p style="color: #856404; margin: 15px 0; line-height: 1.6;">
                            只有购买过该商品的用户才能发表评价。<br>
                            购买商品后,您就可以分享您的使用体验了!
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="add-review-card" style="background: #f8f9fa; border-color: #dee2e6;">
                        <h3 class="review-card-title" style="color: #495057;">
                            <span class="title-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
                            </span>
                            评价提示
                        </h3>
                        <p style="color: #6c757d; margin: 15px 0; line-height: 1.6;">
                            请先<a href="login" style="color: #007bff; text-decoration: underline;">登录</a>并购买该商品后才能发表评价。
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- 评论列表 -->
            <div class="reviews-list-modern">
                <div class="reviews-header">
                    <h3 class="reviews-list-title">
                        <span class="title-icon">
                            <svg viewBox="0 0 24 24" class="icon-svg"><path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/></svg>
                        </span>
                        全部评价 <span class="count-badge">${reviewCount}</span>
                    </h3>
                    <c:if test="${reviewCount > 0}">
                        <div class="rating-summary-inline">
                            <span class="rating-score">${String.format("%.1f", avgRating)}</span>
                            <div class="rating-stars">
                                <c:forEach var="i" begin="1" end="5">
                                    <span class="star ${i <= avgRating ? 'filled' : ''}">★</span>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-card">
                                <div class="review-card-header">
                                    <div class="reviewer-avatar">
                                        ${review.username.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div class="reviewer-info">
                                        <div class="reviewer-name-row">
                                            <span class="reviewer-name">${review.username}</span>
                                            <div class="review-rating-stars">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <span class="star ${i <= review.rating ? 'filled' : ''}">★</span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <span class="review-time">
                                            <span class="time-icon">
                                                <svg viewBox="0 0 24 24" class="icon-svg" style="width: 14px; height: 14px;"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm.5-13H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                                            </span>
                                            ${review.createdAt}
                                        </span>
                                    </div>
                                </div>
                                <div class="review-card-content">
                                    <p>${review.comment}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-reviews-placeholder">
                            <span class="placeholder-icon">
                                <svg viewBox="0 0 24 24" class="icon-svg" style="width: 64px; height: 64px; fill: #ccc;"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H4V8l8 5 8-5v10zm-8-7L4 6h16l-8 5z"/></svg>
                            </span>
                            <p>还没有评价，快来成为第一个评价的用户吧！</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="modern-footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>关于JavaNet</h4>
                    <ul>
                        <li><a href="info/about">公司介绍</a></li>
                        <li><a href="info/contact">联系我们</a></li>
                        <li><a href="info/careers">招聘信息</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>客户服务</h4>
                    <ul>
                        <li><a href="info/help">帮助中心</a></li>
                        <li><a href="info/returns">退换货政策</a></li>
                        <li><a href="info/shipping">配送信息</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>购物指南</h4>
                    <ul>
                        <li><a href="info/how-to-buy">如何购买</a></li>
                        <li><a href="info/payment">支付方式</a></li>
                        <li><a href="info/membership">会员权益</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>关注我们</h4>
                    <div class="social-links">
                        <a href="#" class="social-link">微信</a>
                        <a href="#" class="social-link">微博</a>
                        <a href="#" class="social-link">抖音</a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 JavaNet 在线商城. 保留所有权利.</p>
            </div>
        </div>
    </footer>
    
    <script>
        function addToCart(productId) {
            fetch('cart?action=add&productId=' + productId, {method: 'POST'})
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        showNotification('商品已加入购物车');
                    } else {
                        showNotification('添加失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    showNotification('网络错误，请重试', 'error');
                });
        }
        
        function promptLogin() {
            showConfirm('请先登录后再加入购物车，是否现在登录？', function() {
                window.location.href = 'login';
            }, { title: '需要登录' });
        }
        
        function changeMainImage(imageUrl, thumbnail) {
            // 更换主图
            document.getElementById('mainImage').src = imageUrl;
            
            // 更新缩略图的激活状态
            const thumbnails = document.querySelectorAll('.thumbnail-image');
            thumbnails.forEach(thumb => thumb.classList.remove('active'));
            thumbnail.classList.add('active');
        }

        // 通知功能
        function showNotification(message, type = 'success') {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.classList.add('show');
            }, 100);
            
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    if (notification.parentNode) {
                        document.body.removeChild(notification);
                    }
                }, 300);
            }, 3000);
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