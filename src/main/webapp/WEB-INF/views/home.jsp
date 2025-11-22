<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>JavaNet 在线商城 - 品质生活，从这里开始</title>
            <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=3.0">
            <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
        </head>

        <body>
            <!-- 导航栏 -->
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
                                    <a href="orders" class="action-btn orders-btn">
                                        <span class="btn-icon">
                                            <svg viewBox="0 0 24 24" class="icon-svg"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                                        </span>
                                        <span>订单</span>
                                    </a>
                                    <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                        <a href="product-management" class="action-btn management-btn">
                                            <span>商品管理</span>
                                        </a>
                                    </c:if>
                                    <div class="user-menu">
                                        <span class="user-name" onclick="toggleDropdown()">欢迎, ${sessionScope.user.username} ▼</span>
                                        <div class="dropdown" id="userDropdown">
                                            <a href="profile" class="dropdown-item">个人信息</a>
                                            <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                                <a href="product-management" class="dropdown-item">商品管理</a>
                                            </c:if>
                                            <a href="logout" class="dropdown-item">退出登录</a>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <a href="login" class="action-btn login-btn">
                                        <span class="btn-icon">
                                            <svg viewBox="0 0 24 24" class="icon-svg"><path d="M12.65 10C11.83 7.67 9.61 6 7 6c-3.31 0-6 2.69-6 6s2.69 6 6 6c2.61 0 4.83-1.67 5.65-4H17v4h4v-4h2v-4H12.65zM7 14c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/></svg>
                                        </span>
                                        <span>登录</span>
                                    </a>
                                    <a href="register" class="action-btn register-btn">
                                        <span class="btn-icon">
                                            <svg viewBox="0 0 24 24" class="icon-svg"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                        </span>
                                        <span>注册</span>
                                    </a>
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
                                <img src="https://5b0988e595225.cdn.sohucs.com/q_70,c_zoom,w_640/images/20180412/6f8183f387134bd7947c2a8cb482a52f.jpeg"
                                    alt="品质生活">
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
                                                    <c:when test="${category == '电子产品'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg></c:when>
                                                    <c:when test="${category == '家居用品'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg></c:when>
                                                    <c:when test="${category == '服装鞋帽'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M20 6h-2.18c.11-.31.18-.65.18-1 0-1.66-1.34-3-3-3-1.05 0-1.96.54-2.5 1.35l-.5.67-.5-.68C10.96 2.54 10.05 2 9 2 7.34 2 6 3.34 6 5c0 .35.07.69.18 1H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-5-2c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zM9 4c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm11 15H4v-2h16v2zm0-5H4V8h5.08L7 10.83 8.62 12 11 8.76l1-1.36 1 1.36L15.38 12 17 10.83 14.92 8H20v6z"/></svg></c:when>
                                                    <c:when test="${category == '图书文具'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/></svg></c:when>
                                                    <c:when test="${category == '运动户外'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg></c:when>
                                                    <c:when test="${category == '美妆护肤'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 14l-5-5 1.41-1.41L12 14.17l7.59-7.59L21 8l-9 9z"/></svg></c:when>
                                                    <c:when test="${category == '食品饮料'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M11 9H9V2H7v7H5V2H3v7c0 2.12 1.66 3.84 3.75 3.97V22h2.5v-9.03C11.34 12.84 13 11.12 13 9V2h-2v7zm5-3v8h2.5v8H21V2c-2.76 0-5 2.24-5 4z"/></svg></c:when>
                                                    <c:when test="${category == '游戏产品'}"><svg viewBox="0 0 24 24" class="icon-svg"><path d="M21 6H3c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h18c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-10 7H8v3H6v-3H3v-2h3V8h2v3h3v2zm4.5 2c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm4-3c-.83 0-1.5-.67-1.5-1.5S18.67 9 19.5 9s1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/></svg></c:when>
                                                    <c:otherwise><svg viewBox="0 0 24 24" class="icon-svg"><path d="M12 2l-5.5 9h11z"/></svg></c:otherwise>
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
                                                        <img src="${image.imageUrl}" alt="${product.name}"
                                                            class="product-image">
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${product.imageUrl}" alt="${product.name}"
                                                    class="product-image" onerror="this.style.display='none'">
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="product-overlay">
                                            <button class="quick-add-btn"
                                                onclick="event.stopPropagation(); addToCart('${product.id}'); return false;">
                                                快速加入购物车
                                            </button>
                                        </div>
                                    </div>
                                    <div class="product-info">
                                        <h3 class="product-name">${product.name}</h3>
                                        <p class="product-category">${product.category}</p>
                                        <div class="product-price">${product.price}</div>
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
                                <div class="modern-product-card">
                                    <a href="products?id=${product.id}" class="product-link">
                                        <div class="product-image-container">
                                            <c:choose>
                                                <c:when test="${not empty product.images}">
                                                    <c:forEach var="image" items="${product.images}">
                                                        <c:if test="${image.primary}">
                                                            <img src="${image.imageUrl}" alt="${product.name}"
                                                                class="product-image">
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${product.imageUrl}" alt="${product.name}"
                                                        class="product-image" onerror="this.style.display='none'">
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="product-overlay">
                                                <c:choose>
                                                    <c:when test="${sessionScope.user != null}">
                                                        <c:if test="${product.stock > 0}">
                                                            <button class="quick-add-btn"
                                                                onclick="event.stopPropagation(); addToCart('${product.id}'); return false;">
                                                                快速加入购物车
                                                            </button>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:if test="${product.stock > 0}">
                                                            <button class="quick-add-btn"
                                                                onclick="event.stopPropagation(); showConfirm('请先登录后再加入购物车，是否现在登录？', function() { window.location.href='login'; }, { title: '需要登录' }); return false;">
                                                                快速加入购物车
                                                            </button>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="product-info">
                                            <h3 class="product-name">${product.name}</h3>
                                            <p class="product-category">${product.category}</p>
                                            <div class="product-price">${product.price}</div>
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
                document.querySelector('.search-input').addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        const query = this.value.trim();
                        if (query) {
                            window.location.href = 'products?search=' + encodeURIComponent(query);
                        }
                    }
                });

                document.querySelector('.search-btn').addEventListener('click', function () {
                    const query = document.querySelector('.search-input').value.trim();
                    if (query) {
                        window.location.href = 'products?search=' + encodeURIComponent(query);
                    }
                });

                // 用户下拉菜单功能
                function toggleDropdown() {
                    const dropdown = document.getElementById('userDropdown');
                    dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
                }

                // 点击其他地方关闭下拉菜单
                document.addEventListener('click', function(event) {
                    const userMenu = document.querySelector('.user-menu');
                    const dropdown = document.getElementById('userDropdown');
                    
                    if (userMenu && dropdown && !userMenu.contains(event.target)) {
                        dropdown.style.display = 'none';
                    }
                });
            </script>
        </body>

        </html>