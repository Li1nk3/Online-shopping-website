<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaNet 在线商城 - 品质生活，从这里开始</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=3.0">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="modern-header">
        <div class="nav-container">
            <div class="nav-left">
                <a href="home" class="logo">
                    <span class="logo-icon">🛒</span>
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
                    <button class="search-btn">🔍</button>
                </div>
                <div class="user-actions">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <a href="cart" class="action-btn cart-btn">
                                <span class="btn-icon">🛒</span>
                                <span>购物车</span>
                            </a>
                            <a href="orders" class="action-btn">
                                <span class="btn-icon">📋</span>
                                <span>订单</span>
                            </a>
                            <div class="user-menu">
                                <span class="user-name">欢迎, ${sessionScope.user.username}</span>
                                <div class="dropdown">
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

    <!-- 主轮播图 -->
    <section class="hero-carousel">
        <div class="carousel-container">
            <div class="carousel-slide active">
                <div class="slide-content">
                    <div class="slide-text">
                        <h1>品质生活，从这里开始</h1>
                        <p>发现更多优质商品，享受便捷购物体验</p>
                        <a href="products" class="cta-button">立即购买</a>
                    </div>
                    <div class="slide-image">
                        <img src="https://imgs.gvm.com.tw/upload/gallery/20191108/69304_01.jpg" alt="品质生活">
                    </div>
                </div>
            </div>
            <div class="carousel-slide">
                <div class="slide-content">
                    <div class="slide-text">
                        <h1>新品上市</h1>
                        <p>最新科技产品，引领时尚潮流</p>
                        <a href="products?category=电子产品" class="cta-button">查看新品</a>
                    </div>
                    <div class="slide-image">
                        <img src="https://www.ventuz.com.cn/uploadfile/202210/e98fdea035899f3.png" alt="新品上市">
                    </div>
                </div>
            </div>
            <div class="carousel-slide">
                <div class="slide-content">
                    <div class="slide-text">
                        <h1>家居好物</h1>
                        <p>打造温馨舒适的家居环境</p>
                        <a href="products?category=家居用品" class="cta-button">探索家居</a>
                    </div>
                    <div class="slide-image">
                        <img src="https://tion-china.cn/wp-content/uploads/2020/03/dongdognban.jpg" alt="家居好物">
                    </div>
                </div>
            </div>
            <c:if test="${not empty categories}">
                <div class="carousel-slide">
                    <div class="slide-content">
                        <div class="slide-text">
                            <h1>商品分类</h1>
                            <p>浏览所有商品分类，找到您需要的商品</p>
                        </div>
                        <div class="categories-in-carousel">
                            <c:forEach var="category" items="${categories}">
                                <a href="products?category=${category}" class="category-item">
                                    <div class="category-icon-small">
                                        <c:choose>
                                            <c:when test="${category == '电子产品'}">&#128241;</c:when>
                                            <c:when test="${category == '家居用品'}">&#127968;</c:when>
                                            <c:when test="${category == '服装鞋帽'}">&#128085;</c:when>
                                            <c:when test="${category == '图书文具'}">&#128218;</c:when>
                                            <c:when test="${category == '运动户外'}">&#9917;</c:when>
                                            <c:when test="${category == '美妆护肤'}">&#128132;</c:when>
                                            <c:when test="${category == '食品饮料'}">&#127828;</c:when>
                                            <c:when test="${category == '游戏产品'}">&#127918;</c:when>
                                            <c:otherwise>&#128717;</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span>${category}</span>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
        <div class="carousel-nav">
            <button class="nav-dot active" onclick="showSlide(0)"></button>
            <button class="nav-dot" onclick="showSlide(1)"></button>
            <button class="nav-dot" onclick="showSlide(2)"></button>
            <c:if test="${not empty categories}">
                <button class="nav-dot" onclick="showSlide(3)"></button>
            </c:if>
        </div>
    </section>

    <!-- 精选推荐 -->
    <section class="category-section">
        <div class="container">
            <h2 class="section-title">精选推荐</h2>
            <div class="products-grid">
                <c:forEach var="product" items="${featuredProducts}">
                    <div class="modern-product-card">
                        <a href="products?id=${product.id}" class="product-link">
                            <div class="product-image-container">
                                <c:choose>
                                    <c:when test="${not empty product.images}">
                                        <c:forEach var="image" items="${product.images}">
                                            <c:if test="${image.primary}">
                                                <img src="${image.imageUrl}" alt="${product.name}" class="product-image">
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${product.imageUrl}" alt="${product.name}" class="product-image"
                                             onerror="this.style.display='none'">
                                    </c:otherwise>
                                </c:choose>
                                <div class="product-overlay">
                                    <button class="quick-add-btn" onclick="event.stopPropagation(); addToCart(${product.id}); return false;">
                                        快速加入购物车
                                    </button>
                                </div>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${product.name}</h3>
                                <p class="product-category">${product.category}</p>
                                <div class="product-price">¥${product.price}</div>
                                <div class="product-stock">
                                    <c:choose>
                                        <c:when test="${product.stock > 0}">
                                            <span class="in-stock">有库存</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="out-of-stock">缺货</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>


    <!-- 新品推荐 -->
    <c:if test="${not empty newProducts}">
        <section class="new-products-section">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">新品上市</h2>
                    <a href="products" class="view-all">查看更多 →</a>
                </div>
                <div class="new-products-grid">
                    <c:forEach var="product" items="${newProducts}">
                        <div class="new-product-card">
                            <a href="products?id=${product.id}" class="product-link">
                                <div class="product-badge">NEW</div>
                                <div class="product-image-container">
                                    <c:choose>
                                        <c:when test="${not empty product.images}">
                                            <c:forEach var="image" items="${product.images}">
                                                <c:if test="${image.primary}">
                                                    <img src="${image.imageUrl}" alt="${product.name}" class="product-image">
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${product.imageUrl}" alt="${product.name}" class="product-image"
                                                 onerror="this.style.display='none'">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-info">
                                    <h3 class="product-name">${product.name}</h3>
                                    <div class="product-price">¥${product.price}</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
    </c:if>

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
        // 轮播图功能
        let currentSlide = 0;
        const slides = document.querySelectorAll('.carousel-slide');
        const dots = document.querySelectorAll('.nav-dot');

        function showSlide(index) {
            slides[currentSlide].classList.remove('active');
            dots[currentSlide].classList.remove('active');
            
            currentSlide = index;
            
            slides[currentSlide].classList.add('active');
            dots[currentSlide].classList.add('active');
        }

        // 自动轮播
        setInterval(() => {
            const nextSlide = (currentSlide + 1) % slides.length;
            showSlide(nextSlide);
        }, 5000);

        // 快速加入购物车
        function addToCart(productId) {
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    fetch('cart', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=add&productId=' + productId
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if(data.success) {
                            showNotification('商品已加入购物车');
                        } else {
                            showNotification('添加失败: ' + (data.message || '未知错误'), 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showNotification('网络错误，请重试', 'error');
                    });
                </c:when>
                <c:otherwise>
                    if(confirm('请先登录后再加入购物车，是否现在登录？')) {
                        window.location.href = 'login';
                    }
                </c:otherwise>
            </c:choose>
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
                    document.body.removeChild(notification);
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
        
        // 用户菜单交互功能
        document.addEventListener('DOMContentLoaded', function() {
            const userMenu = document.querySelector('.user-menu');
            const dropdown = document.querySelector('.dropdown');
            
            if (userMenu && dropdown) {
                let hoverTimeout;
                
                userMenu.addEventListener('mouseenter', function() {
                    clearTimeout(hoverTimeout);
                    dropdown.style.display = 'block';
                });
                
                userMenu.addEventListener('mouseleave', function() {
                    hoverTimeout = setTimeout(function() {
                        dropdown.style.display = 'none';
                    }, 300); // 300ms延迟，给用户时间移动到菜单上
                });
                
                dropdown.addEventListener('mouseenter', function() {
                    clearTimeout(hoverTimeout);
                });
                
                dropdown.addEventListener('mouseleave', function() {
                    dropdown.style.display = 'none';
                });
            }
        });
    </script>
</body>
</html>