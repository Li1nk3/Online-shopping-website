<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 现代化导航栏 -->
<nav class="modern-header">
    <div class="nav-container">
        <div class="nav-left">
            <a href="home" class="logo">
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

<style>
.modern-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
}

.nav-container {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
    height: 70px;
}

.nav-left {
    display: flex;
    align-items: center;
    gap: 30px;
}

.logo {
    text-decoration: none;
    display: flex;
    align-items: center;
}

.logo-text {
    font-size: 28px;
    font-weight: bold;
    color: white;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.nav-links {
    display: flex;
    gap: 25px;
}

.nav-link {
    color: white;
    text-decoration: none;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 20px;
    transition: all 0.3s ease;
}

.nav-link:hover {
    background: rgba(255,255,255,0.2);
    transform: translateY(-2px);
}

.nav-right {
    display: flex;
    align-items: center;
    gap: 20px;
}

.search-box {
    display: flex;
    background: rgba(255,255,255,0.9);
    border-radius: 25px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.search-input {
    border: none;
    padding: 10px 15px;
    outline: none;
    background: transparent;
    width: 200px;
}

.search-btn {
    background: #007bff;
    color: white;
    border: none;
    padding: 10px 15px;
    cursor: pointer;
    transition: background 0.3s ease;
}

.search-btn:hover {
    background: #0056b3;
}

.user-actions {
    display: flex;
    align-items: center;
    gap: 15px;
}

.action-btn {
    display: flex;
    align-items: center;
    gap: 5px;
    color: white;
    text-decoration: none;
    padding: 8px 15px;
    border-radius: 20px;
    transition: all 0.3s ease;
    background: rgba(255,255,255,0.1);
}

.action-btn:hover {
    background: rgba(255,255,255,0.2);
    transform: translateY(-2px);
}

.login-btn {
    background: #28a745 !important;
}

.login-btn:hover {
    background: #218838 !important;
}

.register-btn {
    background: #007bff !important;
}

.register-btn:hover {
    background: #0056b3 !important;
}

.user-menu {
    position: relative;
}

.user-name {
    color: white;
    cursor: pointer;
    padding: 8px 15px;
    border-radius: 20px;
    background: rgba(255,255,255,0.1);
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 5px;
}

.user-name:hover {
    background: rgba(255,255,255,0.2);
}

.dropdown {
    position: absolute;
    top: 100%;
    right: 0;
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    min-width: 150px;
    display: none;
    z-index: 1001;
    margin-top: 5px;
}

.dropdown-item {
    display: block;
    padding: 12px 16px;
    color: #333;
    text-decoration: none;
    transition: background 0.3s ease;
    border-bottom: 1px solid #f0f0f0;
}

.dropdown-item:first-child {
    border-radius: 8px 8px 0 0;
}

.dropdown-item:last-child {
    border-bottom: none;
    border-radius: 0 0 8px 8px;
}

.dropdown-item:hover {
    background: #f8f9fa;
}

.icon-svg {
    width: 20px;
    height: 20px;
    fill: currentColor;
}

@media (max-width: 768px) {
    .nav-container {
        flex-direction: column;
        height: auto;
        padding: 15px 20px;
    }
    
    .nav-left {
        flex-direction: column;
        gap: 15px;
        width: 100%;
    }
    
    .nav-links {
        flex-wrap: wrap;
        justify-content: center;
    }
    
    .nav-right {
        width: 100%;
        justify-content: center;
        margin-top: 10px;
    }
    
    .search-input {
        width: 150px;
    }
}
</style>

<script>
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