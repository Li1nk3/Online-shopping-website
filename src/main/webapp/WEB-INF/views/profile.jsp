<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人信息 - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
</head>
<body>
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
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="home">首页</a> > <span>个人信息</span>
        </div>
        
        <div class="profile-container">
            <h2>个人信息管理</h2>
            
            <!-- 基本信息卡片 -->
            <div class="profile-card">
                <h3 class="card-title">
                    基本信息
                </h3>
                
                <form id="profileForm" class="profile-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username">用户名:</label>
                            <input type="text" id="username" value="${user.username}" disabled>
                            <small>用户名不可修改</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="role">账户类型:</label>
                            <input type="text" id="role" value="${user.role == 'seller' ? '卖家' : user.role == 'admin' ? '管理员' : '买家'}" disabled>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">邮箱地址: <span class="required">*</span></label>
                            <input type="email" id="email" name="email" value="${user.email}" required>
                            <small>用于接收订单通知和找回密码</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">手机号码:</label>
                            <input type="tel" id="phone" name="phone" value="${user.phone}">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">收货地址:</label>
                        <textarea id="address" name="address" rows="3">${user.address}</textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn-save" id="profileSubmitBtn">
                            <span class="btn-text">保存修改</span>
                            <span class="btn-loading" style="display: none;">处理中...</span>
                        </button>
                        <button type="button" class="btn-cancel" onclick="window.history.back()">取消</button>
                    </div>
                </form>
            </div>
            
            <!-- 密码修改卡片 -->
            <div class="profile-card">
                <h3 class="card-title">
                    修改密码
                </h3>
                
                <form id="passwordForm" class="profile-form">
                    <div class="form-group">
                        <label for="currentPassword">当前密码: <span class="required">*</span></label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="newPassword">新密码: <span class="required">*</span></label>
                            <input type="password" id="newPassword" name="newPassword" required minlength="6">
                            <small>密码长度至少6位</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirmPassword">确认新密码: <span class="required">*</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6">
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn-save" id="passwordSubmitBtn">
                            <span class="btn-text">修改密码</span>
                            <span class="btn-loading" style="display: none;">处理中...</span>
                        </button>
                        <button type="reset" class="btn-cancel">重置</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <style>
        .profile-container {
            max-width: 900px;
            margin: 30px auto;
        }
        
        .profile-container h2 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            text-align: center;
        }
        
        .profile-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .card-title {
            color: #333;
            margin-bottom: 25px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .title-icon {
            font-size: 24px;
        }
        
        .profile-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .form-group input,
        .form-group textarea {
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #0F7B0F;
            box-shadow: 0 0 0 3px rgba(15,123,15,0.1);
        }
        
        .form-group input:disabled {
            background: #f5f5f5;
            color: #666;
            cursor: not-allowed;
        }
        
        .form-group small {
            color: #666;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 10px;
        }
        
        .btn-save {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-save:hover {
            background: linear-gradient(45deg, #218838, #1ea080);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40,167,69,0.4);
        }
        
        .btn-save:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .btn-save.loading {
            background: #6c757d;
            cursor: wait;
        }
        
        .btn-save.loading:hover {
            background: #6c757d;
            transform: none;
            box-shadow: none;
        }
        
        .btn-text, .btn-loading {
            transition: opacity 0.3s ease;
        }
        
        .btn-save.loading .btn-text {
            opacity: 0.3;
        }
        
        .btn-save:not(.loading) .btn-loading {
            display: none;
        }
        
        .btn-save.loading .btn-loading {
            display: inline;
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(108,117,125,0.3);
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .profile-card {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-actions button {
                width: 100%;
            }
        }
        
    </style>
    
    <script>
        // 提交个人信息表单
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const address = document.getElementById('address').value.trim();
            const submitBtn = document.getElementById('profileSubmitBtn');
            const btnText = submitBtn.querySelector('.btn-text');
            const btnLoading = submitBtn.querySelector('.btn-loading');
            
            if (!email) {
                showAlert('邮箱地址不能为空', 'warning');
                shakeElement(submitBtn);
                return;
            }
            
            // 验证邮箱格式
            const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
            if (!emailRegex.test(email)) {
                showAlert('邮箱格式不正确', 'warning');
                shakeElement(submitBtn);
                return;
            }
            
            // 设置加载状态
            submitBtn.disabled = true;
            submitBtn.classList.add('loading');
            btnText.style.display = 'none';
            btnLoading.style.display = 'inline';
            
            fetch('profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=updateInfo&email=' + encodeURIComponent(email) +
                      '&phone=' + encodeURIComponent(phone) +
                      '&address=' + encodeURIComponent(address)
            })
            .then(response => response.json())
            .then(data => {
                // 恢复按钮状态
                submitBtn.disabled = false;
                submitBtn.classList.remove('loading');
                btnText.style.display = 'inline';
                btnLoading.style.display = 'none';
                
                if (data.success) {
                    // 成功反馈
                    showSuccessFeedback(submitBtn);
                    showAlert('信息更新成功！', 'success').then(() => {
                        window.location.reload();
                    });
                } else {
                    // 失败反馈
                    shakeElement(submitBtn);
                    showAlert('更新失败: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // 恢复按钮状态
                submitBtn.disabled = false;
                submitBtn.classList.remove('loading');
                btnText.style.display = 'inline';
                btnLoading.style.display = 'none';
                
                shakeElement(submitBtn);
                showAlert('网络错误，请重试', 'error');
            });
        });
        
        // 提交密码修改表单
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const submitBtn = document.getElementById('passwordSubmitBtn');
            const btnText = submitBtn.querySelector('.btn-text');
            const btnLoading = submitBtn.querySelector('.btn-loading');
            
            // 前端验证
            if (!currentPassword || !newPassword || !confirmPassword) {
                showAlert('所有密码字段都不能为空', 'warning');
                shakeElement(submitBtn);
                return;
            }
            
            if (newPassword.length < 6) {
                showAlert('新密码长度至少6位', 'warning');
                shakeElement(submitBtn);
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showAlert('两次输入的新密码不一致', 'warning');
                shakeElement(submitBtn);
                return;
            }
            
            // 设置加载状态
            submitBtn.disabled = true;
            submitBtn.classList.add('loading');
            btnText.style.display = 'none';
            btnLoading.style.display = 'inline';
            
            fetch('profile', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=updatePassword&currentPassword=' + encodeURIComponent(currentPassword) +
                      '&newPassword=' + encodeURIComponent(newPassword) +
                      '&confirmPassword=' + encodeURIComponent(confirmPassword)
            })
            .then(response => response.json())
            .then(data => {
                // 恢复按钮状态
                submitBtn.disabled = false;
                submitBtn.classList.remove('loading');
                btnText.style.display = 'inline';
                btnLoading.style.display = 'none';
                
                if (data.success) {
                    // 成功反馈
                    showSuccessFeedback(submitBtn);
                    showAlert('密码修改成功！', 'success').then(() => {
                        document.getElementById('passwordForm').reset();
                    });
                } else {
                    // 失败反馈
                    shakeElement(submitBtn);
                    showAlert('修改失败: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // 恢复按钮状态
                submitBtn.disabled = false;
                submitBtn.classList.remove('loading');
                btnText.style.display = 'inline';
                btnLoading.style.display = 'none';
                
                shakeElement(submitBtn);
                showAlert('网络错误，请重试', 'error');
            });
        });
        
        // 按钮震动效果
        function shakeElement(element) {
            element.style.animation = 'shake 0.5s';
            setTimeout(() => {
                element.style.animation = '';
            }, 500);
        }
        
        // 成功反馈效果
        function showSuccessFeedback(element) {
            element.style.background = 'linear-gradient(45deg, #28a745, #20c997)';
            element.style.transform = 'scale(1.05)';
            setTimeout(() => {
                element.style.transform = '';
            }, 300);
        }
        
        // 添加震动动画
        const style = document.createElement('style');
        style.textContent = `
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                20%, 40%, 60%, 80% { transform: translateX(5px); }
            }
        `;
        document.head.appendChild(style);
        
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
        
        // 查看商品详情
        function viewProduct(productId) {
            window.location.href = 'products?id=' + productId;
        }
        
        // 清空浏览记录
        function clearBrowseHistory() {
            if (confirm('确定要清空所有浏览记录吗？此操作不可恢复。')) {
                fetch('profile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=clearBrowseHistory'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showAlert('浏览记录已清空', 'success').then(() => {
                            window.location.reload();
                        });
                    } else {
                        showAlert('清空失败: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('网络错误，请重试', 'error');
                });
            }
        }
    </script>
</body>
</html>