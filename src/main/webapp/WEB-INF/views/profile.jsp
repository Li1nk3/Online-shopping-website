<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人信息 - JavaNet 在线商城</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛒</text></svg>">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="cart" class="btn-cart-nav">购物车</a>
            <a href="orders" class="btn-link">我的订单</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > <span>个人信息</span>
        </div>
        
        <div class="profile-container">
            <h2>个人信息管理</h2>
            
            <!-- 基本信息卡片 -->
            <div class="profile-card">
                <h3 class="card-title">
                    <span class="title-icon">👤</span>
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
                        <button type="submit" class="btn-save">保存修改</button>
                        <button type="button" class="btn-cancel" onclick="window.history.back()">取消</button>
                    </div>
                </form>
            </div>
            
            <!-- 密码修改卡片 -->
            <div class="profile-card">
                <h3 class="card-title">
                    <span class="title-icon">🔒</span>
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
                        <button type="submit" class="btn-save">修改密码</button>
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
        }
        
        .btn-save:hover {
            background: linear-gradient(45deg, #218838, #1ea080);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40,167,69,0.4);
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
            
            if (!email) {
                showAlert('邮箱地址不能为空', 'warning');
                return;
            }
            
            // 验证邮箱格式
            const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
            if (!emailRegex.test(email)) {
                showAlert('邮箱格式不正确', 'warning');
                return;
            }
            
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
                if (data.success) {
                    showAlert('信息更新成功！', 'success').then(() => {
                        window.location.reload();
                    });
                } else {
                    showAlert('更新失败: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('网络错误，请重试', 'error');
            });
        });
        
        // 提交密码修改表单
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!currentPassword || !newPassword || !confirmPassword) {
                showAlert('所有密码字段都不能为空', 'warning');
                return;
            }
            
            if (newPassword.length < 6) {
                showAlert('新密码长度至少6位', 'warning');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showAlert('两次输入的新密码不一致', 'warning');
                return;
            }
            
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
                if (data.success) {
                    showAlert('密码修改成功！', 'success').then(() => {
                        document.getElementById('passwordForm').reset();
                    });
                } else {
                    showAlert('修改失败: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('网络错误，请重试', 'error');
            });
        });
    </script>
</body>
</html>