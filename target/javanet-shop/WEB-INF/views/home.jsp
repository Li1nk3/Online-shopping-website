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
        </div>
        <div class="carousel-nav">
            <button class="nav-dot active" onclick="showSlide(0)"></button>
            <button class="nav-dot" onclick="showSlide(1)"></button>
            <button class="nav-dot" onclick="showSlide(2)"></button>
        </div>
    </section>

    <!-- 分类快捷入口 -->
    <section class="category-section">
        <div class="container">
            <h2 class="section-title">热门分类</h2>
            <div class="category-grid">
                <a href="products?category=电子产品" class="category-card">
                    <div class="category-icon">📱</div>
                    <h3>电子产品</h3>
                    <p>手机、电脑、数码配件</p>
                </a>
                <a href="products?category=家居用品" class="category-card">
                    <div class="category-icon">🏠</div>
                    <h3>家居用品</h3>
                    <p>家具、装饰、生活用品</p>
                </a>
                <a href="products?category=服装鞋帽" class="category-card">
                    <div class="category-icon">👕</div>
                    <h3>服装鞋帽</h3>
                    <p>时尚服饰、鞋子、配饰</p>
                </a>
                <a href="products?category=图书文具" class="category-card">
                    <div class="category-icon">📚</div>
                    <h3>图书文具</h3>
                    <p>书籍、文具、办公用品</p>
                </a>
                <a href="products?category=运动户外" class="category-card">
                    <div class="category-icon">⚽</div>
                    <h3>运动户外</h3>
                    <p>运动装备、户外用品</p>
                </a>
                <a href="products?category=美妆护肤" class="category-card">
                    <div class="category-icon">💄</div>
                    <h3>美妆护肤</h3>
                    <p>化妆品、护肤品、香水</p>
                </a>
            </div>
        </div>
    </section>

    <!-- 推荐商品 -->
    <section class="featured-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">精选推荐</h2>
                <a href="products" class="view-all">查看全部 →</a>
            </div>
            <div class="product-carousel">
                <div class="product-scroll">
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
                        <li><a href="#">公司介绍</a></li>
                        <li><a href="#">联系我们</a></li>
                        <li><a href="#">招聘信息</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>客户服务</h4>
                    <ul>
                        <li><a href="#">帮助中心</a></li>
                        <li><a href="#">退换货政策</a></li>
                        <li><a href="#">配送信息</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>购物指南</h4>
                    <ul>
                        <li><a href="#">如何购买</a></li>
                        <li><a href="#">支付方式</a></li>
                        <li><a href="#">会员权益</a></li>
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