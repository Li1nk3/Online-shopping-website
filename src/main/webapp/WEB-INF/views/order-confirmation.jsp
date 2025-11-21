<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单确认 - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="cart" class="btn-cart-nav">购物车</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="order-confirmation">
            <div class="success-icon">
                <div class="checkmark">✓</div>
            </div>
            
            <h2>订单提交成功！</h2>
            
            <div class="order-info">
                <p class="order-number">订单号：<strong>${orderNumber}</strong></p>
                <p class="message">${message}</p>
            </div>
            
            <div class="next-steps">
                <h3>接下来您可以：</h3>
                <ul>
                    <li>立即付款以便我们尽快为您发货</li>
                    <li>查看订单详情和物流信息</li>
                    <li>我们将通过邮件通知您订单状态</li>
                    <li>如有问题，请联系客服</li>
                </ul>
            </div>
            
            <div class="action-buttons">
                <a href="payment?orderNumber=${orderNumber}" class="btn-pay-now-link">立即付款</a>
                <a href="orders" class="btn-view-orders">查看我的订单</a>
                <a href="products" class="btn-continue-shopping">继续购物</a>
            </div>
        </div>
    </div>
    
    <style>
        .order-confirmation {
            max-width: 600px;
            margin: 50px auto;
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .success-icon {
            margin-bottom: 30px;
        }
        
        .checkmark {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            font-size: 40px;
            line-height: 80px;
            margin: 0 auto;
            animation: bounce 0.6s ease-in-out;
        }
        
        @keyframes bounce {
            0%, 20%, 60%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-20px);
            }
            80% {
                transform: translateY(-10px);
            }
        }
        
        .order-confirmation h2 {
            color: #28a745;
            margin-bottom: 20px;
            font-size: 28px;
        }
        
        .order-info {
            margin: 30px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .order-number {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .message {
            color: #666;
            font-size: 16px;
        }
        
        .next-steps {
            text-align: left;
            margin: 30px 0;
        }
        
        .next-steps h3 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .next-steps ul {
            color: #666;
            line-height: 1.8;
        }
        
        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn-view-orders {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-pay-now-link {
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-pay-now-link:hover {
            background: linear-gradient(45deg, #ff5252, #e55100);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255,107,107,0.4);
            text-decoration: none;
            color: white;
        }
        
        .btn-view-orders:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102,126,234,0.4);
            text-decoration: none;
        }
        
        .btn-continue-shopping {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-continue-shopping:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40,167,69,0.4);
            text-decoration: none;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
            
            .action-buttons a {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</body>
</html>