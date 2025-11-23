<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>客户购买统计 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .stats-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .stats-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .stats-title {
            font-size: 1.5em;
            font-weight: bold;
            margin: 0;
        }
        .stats-content {
            padding: 20px;
        }
        .customer-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .customer-table th,
        .customer-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .customer-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        .customer-table tr:hover {
            background: #f8f9fa;
        }
        .customer-name {
            font-weight: bold;
            color: #007bff;
        }
        .customer-email {
            color: #666;
            font-size: 0.9em;
        }
        .purchase-amount {
            font-weight: bold;
            color: #28a745;
        }
        .order-count {
            background: #007bff;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8em;
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
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .summary-number {
            font-size: 2em;
            font-weight: bold;
            color: #007bff;
        }
        .summary-label {
            color: #666;
            margin-top: 5px;
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
                <h1>客户购买统计</h1>
                <p>查看所有客户的详细购买统计信息</p>
            </div>
            
            <div class="stats-container">
                <div class="stats-header">
                    <h3 class="stats-title">客户购买明细</h3>
                    <a href="customer-management" class="btn-back">返回客户管理</a>
                </div>
                <div class="stats-content">
                    <c:choose>
                        <c:when test="${empty purchaseStats}">
                            <div class="empty-state">
                                <p>暂无客户购买数据</p>
                                <p>当有客户购买商品后，这里将显示详细的统计信息</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- 汇总统计 -->
                            <div class="summary-stats">
                                <div class="summary-card">
                                    <div class="summary-number">${purchaseStats.size()}</div>
                                    <div class="summary-label">总客户数</div>
                                </div>
                                <div class="summary-card">
                                    <div class="summary-number">
                                        <c:set var="totalRevenue" value="0"/>
                                        <c:forEach items="${purchaseStats}" var="stat">
                                            <c:set var="totalRevenue" value="${totalRevenue + stat.totalAmount}"/>
                                        </c:forEach>
                                        ¥<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                                    </div>
                                    <div class="summary-label">总收入</div>
                                </div>
                                <div class="summary-card">
                                    <div class="summary-number">
                                        <c:set var="totalOrders" value="0"/>
                                        <c:forEach items="${purchaseStats}" var="stat">
                                            <c:set var="totalOrders" value="${totalOrders + stat.totalOrders}"/>
                                        </c:forEach>
                                        ${totalOrders}
                                    </div>
                                    <div class="summary-label">总订单数</div>
                                </div>
                                <div class="summary-card">
                                    <div class="summary-number">
                                        <c:set var="avgAmount" value="0"/>
                                        <c:if test="${purchaseStats.size() > 0}">
                                            <c:set var="avgAmount" value="${totalRevenue / purchaseStats.size()}"/>
                                        </c:if>
                                        ¥<fmt:formatNumber value="${avgAmount}" pattern="#,##0.00"/>
                                    </div>
                                    <div class="summary-label">平均消费</div>
                                </div>
                            </div>
                            
                            <!-- 详细表格 -->
                            <table class="customer-table">
                                <thead>
                                    <tr>
                                        <th>客户信息</th>
                                        <th>总消费金额</th>
                                        <th>订单数量</th>
                                        <th>平均订单金额</th>
                                        <th>最后购买时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${purchaseStats}" var="stat">
                                        <tr>
                                            <td>
                                                <div class="customer-name">${stat.user.username}</div>
                                                <div class="customer-email">
                                                    <c:if test="${not empty stat.user.email}">${stat.user.email}</c:if>
                                                    <c:if test="${not empty stat.user.phone}"> | ${stat.user.phone}</c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="purchase-amount">¥<fmt:formatNumber value="${stat.totalAmount}" pattern="#,##0.00"/></div>
                                            </td>
                                            <td>
                                                <span class="order-count">${stat.totalOrders}</span>
                                            </td>
                                            <td>
                                                <c:if test="${stat.totalOrders > 0}">
                                                    ¥<fmt:formatNumber value="${stat.totalAmount / stat.totalOrders}" pattern="#,##0.00"/>
                                                </c:if>
                                                <c:if test="${stat.totalOrders == 0}">
                                                    ¥0.00
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty stat.lastPurchaseDate}">
                                                    <fmt:formatDate value="${stat.lastPurchaseDate}" pattern="yyyy-MM-dd HH:mm"/>
                                                </c:if>
                                                <c:if test="${empty stat.lastPurchaseDate}">
                                                    暂无购买记录
                                                </c:if>
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
            console.log('客户购买统计页面加载完成');
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
    </script>
</body>
</html>