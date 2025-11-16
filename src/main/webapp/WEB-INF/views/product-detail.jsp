<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.name} - JavaNet 在线商城</title>
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