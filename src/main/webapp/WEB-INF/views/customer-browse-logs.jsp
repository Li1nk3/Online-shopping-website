<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>客户浏览日志 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .logs-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .limit-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .limit-selector select {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn-refresh {
            background: #007bff;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-refresh:hover {
            background: #0056b3;
        }
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-back:hover {
            background: #5a6268;
        }
        .logs-table {
            width: 100%;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .table-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .table-title {
            font-size: 1.2em;
            font-weight: bold;
            margin: 0;
        }
        .table-content {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        th {
            background: #f8f9fa;
            font-weight: bold;
            color: #495057;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .customer-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .customer-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #007bff;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9em;
        }
        .customer-details {
            flex: 1;
        }
        .customer-name {
            font-weight: bold;
            color: #007bff;
        }
        .product-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .product-image {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 4px;
        }
        .product-name {
            font-weight: bold;
        }
        .browse-time {
            color: #666;
            font-size: 0.9em;
        }
        .duration {
            color: #28a745;
            font-weight: bold;
        }
        .ip-address {
            font-family: monospace;
            background: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 0.9em;
        }
        .user-agent {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #666;
            font-size: 0.8em;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 1.8em;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
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
        
        <main class="main-content">
            <div class="page-header">
                <h1>客户浏览日志</h1>
                <p>查看客户浏览商品的详细记录</p>
            </div>
            
            <a href="customer-management" class="btn-back">← 返回客户管理</a>
            
            <!-- 统计概览 -->
            <div class="stats-summary">
                <div class="stat-card">
                    <div class="stat-number">${browseLogs.size()}</div>
                    <div class="stat-label">总浏览记录</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="uniqueCustomers" value="0"/>
                        <c:set var="customerIds" value=""/>
                        <c:forEach items="${browseLogs}" var="log">
                            <c:if test="${not empty log.userId and not fn:contains(customerIds, log.userId)}">
                                <c:set var="uniqueCustomers" value="${uniqueCustomers + 1}"/>
                                <c:set var="customerIds" value="${customerIds},${log.userId}"/>
                            </c:if>
                        </c:forEach>
                        ${uniqueCustomers}
                    </div>
                    <div class="stat-label">独立客户数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="uniqueProducts" value="0"/>
                        <c:set var="productIds" value=""/>
                        <c:forEach items="${browseLogs}" var="log">
                            <c:if test="${not empty log.productId and not fn:contains(productIds, log.productId)}">
                                <c:set var="uniqueProducts" value="${uniqueProducts + 1}"/>
                                <c:set var="productIds" value="${productIds},${log.productId}"/>
                            </c:if>
                        </c:forEach>
                        ${uniqueProducts}
                    </div>
                    <div class="stat-label">被浏览商品数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="totalViews" value="0"/>
                        <c:forEach items="${browseLogs}" var="log">
                            <c:set var="totalViews" value="${totalViews + log.durationSeconds}"/>
                        </c:forEach>
                        ${totalViews}
                    </div>
                    <div class="stat-label">总浏览次数</div>
                </div>
            </div>
            
            <!-- 日志列表 -->
            <div class="logs-table">
                <div class="table-header">
                    <div class="logs-header">
                        <h3 class="table-title">浏览记录</h3>
                        <div class="limit-selector">
                            <label>显示数量：</label>
                            <select onchange="changeLimit(this.value)">
                                <option value="20" ${limit == 20 ? 'selected' : ''}>20条</option>
                                <option value="50" ${limit == 50 ? 'selected' : ''}>50条</option>
                                <option value="100" ${limit == 100 ? 'selected' : ''}>100条</option>
                                <option value="200" ${limit == 200 ? 'selected' : ''}>200条</option>
                            </select>
                            <a href="customer-management?action=browse-logs&limit=${limit}" class="btn-refresh">刷新</a>
                        </div>
                    </div>
                </div>
                <div class="table-content">
                    <c:choose>
                        <c:when test="${empty browseLogs}">
                            <div class="empty-state">
                                <p>暂无浏览记录</p>
                                <p style="font-size: 0.9em; margin-top: 10px;">当客户浏览您的商品时，这里将显示相关记录</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th>客户信息</th>
                                        <th>浏览商品</th>
                                        <th>浏览次数</th>
                                        <th>IP地址</th>
                                        <th>设备信息</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${browseLogs}" var="log">
                                        <tr>
                                            <td>
                                                <div class="customer-info">
                                                    <c:if test="${not empty log.user.username}">
                                                        <div class="customer-avatar">
                                                            ${fn:toUpperCase(fn:substring(log.user.username, 0, 1))}
                                                        </div>
                                                        <div class="customer-details">
                                                            <div class="customer-name">${log.user.username}</div>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${empty log.user.username}">
                                                        <div class="customer-avatar">?</div>
                                                        <div class="customer-details">
                                                            <div class="customer-name">匿名用户</div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="product-info">
                                                    <c:if test="${not empty log.product.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}/${log.product.imageUrl}" 
                                                             alt="${log.product.name}" class="product-image">
                                                    </c:if>
                                                    <c:if test="${empty log.product.imageUrl}">
                                                        <div class="product-image" style="background: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #999;">
                                                            暂无图片
                                                        </div>
                                                    </c:if>
                                                    <div class="product-name">${log.product.name}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="browse-count">
                                                    <span class="duration">${log.durationSeconds} 次浏览</span>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="ip-address">${log.ipAddress}</span>
                                            </td>
                                            <td>
                                                <div class="user-agent" title="${log.userAgent}">
                                                    ${log.userAgent}
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
        
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
    </div>
    
    <script>
        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('客户浏览日志页面加载完成');
        });

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

        // 改变显示数量
        function changeLimit(limit) {
            window.location.href = 'customer-management?action=browse-logs&limit=' + limit;
        }
        
        // 自动刷新（可选）
        let autoRefresh = false;
        let refreshInterval;
        
        function toggleAutoRefresh() {
            autoRefresh = !autoRefresh;
            if (autoRefresh) {
                refreshInterval = setInterval(() => {
                    location.reload();
                }, 30000); // 30秒刷新一次
                console.log('自动刷新已开启');
            } else {
                clearInterval(refreshInterval);
                console.log('自动刷新已关闭');
            }
        }
        
        // 可以添加键盘快捷键
        document.addEventListener('keydown', function(e) {
            if (e.key === 'r' && e.ctrlKey) {
                e.preventDefault();
                location.reload();
            }
        });
    </script>
</body>
</html>