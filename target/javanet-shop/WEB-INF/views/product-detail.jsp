<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.name} - JavaNet 在线商城</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛒</text></svg>">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    欢迎, ${sessionScope.user.username}! 
                    <a href="logout" class="btn-link">退出</a>
                </c:when>
                <c:otherwise>
                    <a href="login" class="btn-login">登录</a>
                    <a href="register" class="btn-register">注册</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
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
                <div class="product-price">¥${product.price}</div>
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
                            <span class="info-icon">👨‍💼</span>
                            <div class="info-content">
                                <label>卖家名称</label>
                                <span>${seller.username}</span>
                            </div>
                        </div>
                        <div class="seller-info-item">
                            <span class="info-icon">📧</span>
                            <div class="info-content">
                                <label>联系邮箱</label>
                                <span>${seller.email}</span>
                            </div>
                        </div>
                        <c:if test="${not empty seller.phone}">
                            <div class="seller-info-item">
                                <span class="info-icon">📱</span>
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
                                <button onclick="addToCart(${product.id})" class="btn-cart-large">加入购物车</button>
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
                            <span class="title-icon">✍️</span>
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
                                <span class="btn-icon">📤</span>
                                提交评价
                            </button>
                        </form>
                    </div>
                </c:when>
                <c:when test="${sessionScope.user != null && !hasPurchased}">
                    <div class="add-review-card" style="background: #fff3cd; border-color: #ffc107;">
                        <h3 class="review-card-title" style="color: #856404;">
                            <span class="title-icon">ℹ️</span>
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
                            <span class="title-icon">🔒</span>
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
                        <span class="title-icon">💬</span>
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
                                            <span class="time-icon">🕒</span>
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
                            <span class="placeholder-icon">📭</span>
                            <p>还没有评价，快来成为第一个评价的用户吧！</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script>
        function addToCart(productId) {
            fetch('cart?action=add&productId=' + productId, {method: 'POST'})
                .then(response => response.json())
                .then(data => {
                    if(data.success) {
                        alert('商品已加入购物车');
                    } else {
                        alert('添加失败: ' + data.message);
                    }
                });
        }
        
        function promptLogin() {
            if(confirm('请先登录后再加入购物车，是否现在登录？')) {
                window.location.href = 'login';
            }
        }
        
        function changeMainImage(imageUrl, thumbnail) {
            // 更换主图
            document.getElementById('mainImage').src = imageUrl;
            
            // 更新缩略图的激活状态
            const thumbnails = document.querySelectorAll('.thumbnail-image');
            thumbnails.forEach(thumb => thumb.classList.remove('active'));
            thumbnail.classList.add('active');
        }
    </script>
</body>
</html>