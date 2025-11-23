<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>浏览记录 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=3.0">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
    <style>
        .history-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-header h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .page-header p {
            color: #666;
            font-size: 16px;
        }
        
        .history-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .limit-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .limit-selector select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .history-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        
        .history-list {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .list-header {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .list-title {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
        }
        
        .list-content {
            padding: 0;
        }
        
        .history-item {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }
        
        .history-item:hover {
            background-color: #f8f9fa;
        }
        
        .history-item:last-child {
            border-bottom: none;
        }
        
        .product-info {
            display: flex;
            align-items: center;
            gap: 15px;
            flex: 1;
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .product-image.placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            color: #999;
            font-size: 12px;
        }
        
        .product-details {
            flex: 1;
        }
        
        .product-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        .browse-info {
            color: #666;
            font-size: 14px;
            line-height: 1.4;
        }
        
        .browse-time {
            margin-bottom: 4px;
        }
        
        .browse-duration {
            color: #007bff;
            font-weight: 500;
        }
        
        .item-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .view-btn {
            background: #007bff;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: background-color 0.3s ease;
        }
        
        .view-btn:hover {
            background: #0056b3;
        }
        
        .delete-btn {
            background: none;
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }
        
        .delete-btn:hover {
            background: #dc3545;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .empty-icon {
            font-size: 48px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-title {
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .empty-description {
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .pagination-info {
            color: #666;
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .history-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .product-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .product-image {
                width: 60px;
                height: 60px;
            }
            
            .history-item {
                flex-direction: column;
                align-items: stretch;
                gap: 15px;
            }
            
            .item-actions {
                justify-content: flex-end;
            }
        }
    </style>
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
            <a href="home">首页</a> > 浏览记录
        </div>
        
        <div class="history-container">
            <div class="page-header">
                <h1>我的浏览记录</h1>
                <p>查看您最近浏览过的商品</p>
            </div>
            
            <!-- 统计信息 -->
            <div class="history-stats">
                <div class="stat-card">
                    <div class="stat-number">${totalLogs}</div>
                    <div class="stat-label">浏览商品数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${fn:length(browseLogs)}</div>
                    <div class="stat-label">当前显示</div>
                </div>
            </div>
            
            <!-- 控制按钮 -->
            <div class="history-controls">
                <div class="limit-selector">
                    <label>每页显示：</label>
                    <select onchange="changeLimit(this.value)">
                        <option value="10" ${limit == 10 ? 'selected' : ''}>10条</option>
                        <option value="20" ${limit == 20 ? 'selected' : ''}>20条</option>
                        <option value="50" ${limit == 50 ? 'selected' : ''}>50条</option>
                        <option value="100" ${limit == 100 ? 'selected' : ''}>100条</option>
                    </select>
                </div>
                
                <div class="action-buttons">
                    <a href="products" class="btn btn-primary">
                        继续购物
                    </a>
                    <button onclick="clearAllHistory()" class="btn btn-danger">
                        清空记录
                    </button>
                </div>
            </div>
            
            <!-- 浏览记录列表 -->
            <div class="history-list">
                <div class="list-header">
                    <h3 class="list-title">浏览历史</h3>
                    <span style="color: #666;">共 ${totalLogs} 条记录</span>
                </div>
                <div class="list-content">
                    <c:choose>
                        <c:when test="${empty browseLogs}">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <svg viewBox="0 0 24 24" class="icon-svg" style="width: 48px; height: 48px;"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                                </div>
                                <div class="empty-title">暂无浏览记录</div>
                                <div class="empty-description">开始浏览商品后，这里将显示您的浏览历史</div>
                                <a href="products" class="btn btn-primary">去逛逛</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${browseLogs}" var="log">
                                <div class="history-item" onclick="viewProduct(${log.product.id})">
                                    <div class="product-info">
                                        <c:if test="${not empty log.product.imageUrl}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(log.product.imageUrl, 'http')}">
                                                    <img src="${log.product.imageUrl}"
                                                         alt="${log.product.name}" class="product-image">
                                                </c:when>
                                                <c:when test="${fn:startsWith(log.product.imageUrl, '/')}">
                                                    <img src="${pageContext.request.contextPath}${log.product.imageUrl}"
                                                         alt="${log.product.name}" class="product-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${log.product.imageUrl}"
                                                         alt="${log.product.name}" class="product-image">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                        <c:if test="${empty log.product.imageUrl}">
                                            <div class="product-image placeholder">暂无图片</div>
                                        </c:if>
                                        <div class="product-details">
                                            <div class="product-name">${log.product.name}</div>
                                            <div class="browse-info">
                                                <div class="browse-duration">
                                                    <c:if test="${not empty log.createdAt}">
                                                        <fmt:formatDate value="${log.createdAt}" pattern="yyyy-MM-dd"/>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="item-actions">
                                        <button class="view-btn" onclick="event.stopPropagation(); viewProduct(${log.product.id})">
                                            查看商品
                                        </button>
                                        <button class="delete-btn" onclick="event.stopPropagation(); deleteHistory(${log.id})">
                                            删除
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 分页信息 -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <span class="pagination-info">
                        第 ${currentPage} 页，共 ${totalPages} 页
                    </span>
                </div>
            </c:if>
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
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 JavaNet 在线商城. 保留所有权利.</p>
            </div>
        </div>
    </footer>
    
    <script>
        // 改变每页显示数量
        function changeLimit(limit) {
            window.location.href = 'browse-history?limit=' + limit;
        }
        
        // 查看商品详情
        function viewProduct(productId) {
            window.location.href = 'products?id=' + productId;
        }
        
        // 清空所有浏览记录
        function clearAllHistory() {
            if (confirm('确定要清空所有浏览记录吗？此操作不可恢复。')) {
                fetch('browse-history', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=clear'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('浏览记录已清空');
                        window.location.reload();
                    } else {
                        showNotification('清空失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('网络错误，请重试', 'error');
                });
            }
        }
        
        // 删除单条浏览记录
        function deleteHistory(logId) {
            if (confirm('确定要删除这条浏览记录吗？')) {
                fetch('browse-history', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&logId=' + logId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 移除对应的DOM元素
                        const item = event.target.closest('.history-item');
                        item.style.opacity = '0';
                        item.style.transform = 'translateX(-100%)';
                        setTimeout(() => {
                            item.remove();
                            // 更新统计信息
                            updateStats();
                        }, 300);
                    } else {
                        showNotification('删除失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('网络错误，请重试', 'error');
                });
            }
        }
        
        // 更新统计信息
        function updateStats() {
            const totalLogsElement = document.querySelector('.stat-number');
            if (totalLogsElement) {
                const currentTotal = parseInt(totalLogsElement.textContent);
                totalLogsElement.textContent = Math.max(0, currentTotal - 1);
            }
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
        
        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('浏览记录页面加载完成');
        });
    </script>
</body>
</html>