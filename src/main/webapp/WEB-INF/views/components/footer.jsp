<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="modern-footer">
    <div class="footer-container">
        <div class="footer-content">
            <div class="footer-section">
                <h4>关于JavaNet</h4>
                <p>JavaNet是一个专业的在线购物平台，为您提供优质的商品和服务。</p>
                <div class="contact-info">
                    <p>📧 contact@javanet.com</p>
                    <p>📞 400-123-4567</p>
                </div>
            </div>
            
            <div class="footer-section">
                <h4>客户服务</h4>
                <ul class="footer-links">
                    <li><a href="info-page?page=help">帮助中心</a></li>
                    <li><a href="info-page?page=returns">退换货政策</a></li>
                    <li><a href="info-page?page=shipping">配送信息</a></li>
                    <li><a href="info-page?page=payment">支付方式</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h4>购物指南</h4>
                <ul class="footer-links">
                    <li><a href="info-page?page=how-to-buy">如何购买</a></li>
                    <li><a href="info-page?page=payment">支付方式</a></li>
                    <li><a href="info-page?page=membership">会员权益</a></li>
                    <li><a href="info-page?page=faq">常见问题</a></li>
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

<style>
.modern-footer {
    background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
    color: white;
    margin-top: 50px;
}

.footer-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

.footer-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 40px;
    padding: 50px 0;
}

.footer-section h4 {
    color: #ecf0f1;
    margin-bottom: 20px;
    font-size: 18px;
    border-bottom: 2px solid #3498db;
    padding-bottom: 10px;
}

.footer-section p {
    color: #bdc3c7;
    line-height: 1.6;
    margin-bottom: 15px;
}

.contact-info p {
    margin-bottom: 8px;
}

.footer-links {
    list-style: none;
    padding: 0;
}

.footer-links li {
    margin-bottom: 10px;
}

.footer-links a {
    color: #bdc3c7;
    text-decoration: none;
    transition: color 0.3s ease;
}

.footer-links a:hover {
    color: #3498db;
}

.social-links {
    display: flex;
    gap: 15px;
}

.social-link {
    background: rgba(52, 152, 219, 0.2);
    color: #ecf0f1;
    padding: 10px 20px;
    border-radius: 20px;
    text-decoration: none;
    transition: all 0.3s ease;
    border: 1px solid rgba(52, 152, 219, 0.3);
}

.social-link:hover {
    background: #3498db;
    color: white;
    transform: translateY(-2px);
}

.footer-bottom {
    border-top: 1px solid rgba(255,255,255,0.1);
    padding: 20px 0;
    text-align: center;
}

.footer-bottom p {
    color: #95a5a6;
    margin: 0;
}

@media (max-width: 768px) {
    .footer-content {
        grid-template-columns: 1fr;
        gap: 30px;
        padding: 30px 0;
    }
    
    .social-links {
        justify-content: center;
    }
}
</style>