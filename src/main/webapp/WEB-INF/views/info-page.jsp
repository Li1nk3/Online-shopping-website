<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=3.0">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="modern-header">
        <div class="nav-container">
            <div class="nav-left">
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <span class="logo-icon">🛒</span>
                    <span class="logo-text">JavaNet</span>
                </a>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/products" class="nav-link">所有商品</a>
                    <a href="${pageContext.request.contextPath}/products?category=电子产品" class="nav-link">电子产品</a>
                    <a href="${pageContext.request.contextPath}/products?category=家居用品" class="nav-link">家居用品</a>
                    <a href="${pageContext.request.contextPath}/products?category=服装鞋帽" class="nav-link">服装鞋帽</a>
                </div>
            </div>
            <div class="nav-right">
                <div class="user-actions">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <a href="${pageContext.request.contextPath}/cart" class="action-btn cart-btn">
                                <span class="btn-icon">🛒</span>
                                <span>购物车</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/orders" class="action-btn">
                                <span class="btn-icon">📋</span>
                                <span>订单</span>
                            </a>
                            <div class="user-menu">
                                <span class="user-name">欢迎, ${sessionScope.user.username}</span>
                                <div class="dropdown">
                                    <c:if test="${sessionScope.user.role == 'seller' || sessionScope.user.role == 'admin'}">
                                        <a href="${pageContext.request.contextPath}/product-management" class="dropdown-item">商品管理</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">退出登录</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="action-btn login-btn">登录</a>
                            <a href="${pageContext.request.contextPath}/register" class="action-btn register-btn">注册</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- 面包屑导航 -->
    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">首页</a> > <span>${title}</span>
        </div>
    </div>

    <!-- 页面内容 -->
    <div class="container">
        <div class="info-page-container">
            <h1 class="page-title">${title}</h1>
            
            <div class="page-content">
                <c:choose>
                    <c:when test="${page == 'about'}">
                        <div class="content-section">
                            <h2>公司简介</h2>
                            <p>JavaNet 在线商城成立于2024年，致力于为用户提供优质的购物体验。我们专注于精选全球优质商品，为消费者带来便捷、安全、可靠的在线购物服务。</p>
                            
                            <h3>我们的使命</h3>
                            <p>让每个人都能享受到高品质的生活，通过技术创新为用户创造价值。</p>
                            
                            <h3>我们的愿景</h3>
                            <p>成为最受信赖的在线购物平台，连接全球优质商品与消费者。</p>
                            
                            <h3>核心价值观</h3>
                            <ul>
                                <li><strong>品质第一</strong> - 严格筛选每一件商品</li>
                                <li><strong>用户至上</strong> - 以用户体验为中心</li>
                                <li><strong>诚信经营</strong> - 透明、公正、可靠</li>
                                <li><strong>持续创新</strong> - 不断优化服务体验</li>
                            </ul>
                        </div>
                    </c:when>
                    
                    <c:when test="${page == 'contact'}">
                        <div class="content-section">
                            <h2>联系方式</h2>
                            <div class="contact-grid">
                                <div class="contact-item">
                                    <h3>📞 客服热线</h3>
                                    <p>400-888-0000</p>
                                    <small>服务时间：周一至周日 9:00-21:00</small>
                                </div>
                                <div class="contact-item">
                                    <h3>📧 邮箱联系</h3>
                                    <p>service@javanet.com</p>
                                    <small>我们会在24小时内回复您的邮件</small>
                                </div>
                                <div class="contact-item">
                                    <h3>📍 公司地址</h3>
                                    <p>北京市朝阳区科技园区创新大厦8楼</p>
                                    <small>邮编：100000</small>
                                </div>
                                <div class="contact-item">
                                    <h3>💬 在线客服</h3>
                                    <p>微信客服：JavaNet_Service</p>
                                    <small>工作日在线时间：9:00-18:00</small>
                                </div>
                            </div>
                            
                            <h3>意见反馈</h3>
                            <p>如果您对我们的服务有任何建议或意见，欢迎通过以上方式联系我们。您的反馈是我们持续改进的动力！</p>
                        </div>
                    </c:when>
                    
                    <c:when test="${page == 'careers'}">
                        <div class="content-section">
                            <h2>加入我们</h2>
                            <p>JavaNet 正在寻找有才华、有激情的人才加入我们的团队！</p>
                            
                            <h3>🚀 开放职位</h3>
                            <div class="job-list">
                                <div class="job-item">
                                    <h4>Java后端开发工程师</h4>
                                    <p><strong>职责：</strong>负责电商平台后端开发，API设计与实现</p>
                                    <p><strong>要求：</strong>3年以上Java开发经验，熟悉Spring框架</p>
                                    <p><strong>薪资：</strong>15K-25K</p>
                                </div>
                                <div class="job-item">
                                    <h4>前端开发工程师</h4>
                                    <p><strong>职责：</strong>负责用户界面开发，提升用户体验</p>
                                    <p><strong>要求：</strong>熟悉React/Vue，有电商项目经验优先</p>
                                    <p><strong>薪资：</strong>12K-20K</p>
                                </div>
                                <div class="job-item">
                                    <h4>产品经理</h4>
                                    <p><strong>职责：</strong>负责产品规划，用户需求分析</p>
                                    <p><strong>要求：</strong>3年以上产品经验，有电商背景优先</p>
                                    <p><strong>薪资：</strong>18K-30K</p>
                                </div>
                            </div>
                            
                            <h3>📧 投递简历</h3>
                            <p>请将简历发送至：<strong>hr@javanet.com</strong></p>
                            <p>邮件标题格式：【应聘职位】-姓名-工作年限</p>
                        </div>
                    </c:when>
                    
                    <c:when test="${page == 'help'}">
                        <div class="content-section">
                            <h2>帮助中心</h2>
                            
                            <h3>❓ 常见问题</h3>
                            <div class="faq-list">
                                <div class="faq-item">
                                    <h4>如何注册账户？</h4>
                                    <p>点击页面右上角的"注册"按钮，填写用户名、邮箱和密码即可完成注册。</p>
                                </div>
                                <div class="faq-item">
                                    <h4>忘记密码怎么办？</h4>
                                    <p>请联系客服重置密码，或发送邮件至 service@javanet.com。</p>
                                </div>
                                <div class="faq-item">
                                    <h4>如何查看订单状态？</h4>
                                    <p>登录后点击"我的订单"即可查看所有订单的详细状态和物流信息。</p>
                                </div>
                                <div class="faq-item">
                                    <h4>支持哪些支付方式？</h4>
                                    <p>我们支持支付宝、微信支付、银行卡等多种支付方式。</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:when test="${page == 'returns'}">
                        <div class="content-section">
                            <h2>退换货政策</h2>
                            
                            <h3>📦 退货条件</h3>
                            <ul>
                                <li>商品收到后7天内可申请退货</li>
                                <li>商品必须保持原包装完整</li>
                                <li>商品无人为损坏</li>
                                <li>提供完整的购买凭证</li>
                            </ul>
                            
                            <h3>🔄 换货条件</h3>
                            <ul>
                                <li>商品质量问题可免费换货</li>
                                <li>尺寸不合适可申请换货（需承担运费）</li>
                                <li>换货申请需在收货后3天内提出</li>
                            </ul>
                            
                            <h3>💰 退款说明</h3>
                            <p>退款将在收到退货商品后3-5个工作日内处理，退款金额将原路返回到您的支付账户。</p>
                        </div>
                    </c:when>
                    
                    <c:when test="${page == 'shipping'}">
                        <div class="content-section">
                            <h2>配送信息</h2>
                            
                            <h3>🚚 配送范围</h3>
                            <p>我们支持全国配送，偏远地区可能需要额外配送时间。</p>
                            
                            <h3>⏰ 配送时间</h3>
                            <ul>
                                <li><strong>标准配送：</strong>3-5个工作日</li>
                                <li><strong>快速配送：</strong>1-2个工作日（需额外费用）</li>
                                <li><strong>次日达：</strong>部分城市支持，当日下单次日送达</li>
                            </ul>
                            
                            <h3>💵 配送费用</h3>
                            <ul>
                                <li>订单满99元免运费</li>
                                <li>标准配送：8元</li>
                                <li>快速配送：15元</li>
                                <li>次日达：20元</li>
                            </ul>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="content-section">
                            <h2>页面建设中</h2>
                            <p>该页面正在建设中，敬请期待！</p>
                            <p><a href="${pageContext.request.contextPath}/home">返回首页</a></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="modern-footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>关于JavaNet</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/info/about">公司介绍</a></li>
                        <li><a href="${pageContext.request.contextPath}/info/contact">联系我们</a></li>
                        <li><a href="${pageContext.request.contextPath}/info/careers">招聘信息</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>客户服务</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/info/help">帮助中心</a></li>
                        <li><a href="${pageContext.request.contextPath}/info/returns">退换货政策</a></li>
                        <li><a href="${pageContext.request.contextPath}/info/shipping">配送信息</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>购物指南</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/info/how-to-buy">如何购买</a></li>
                        <li><a href="${pageContext.request.contextPath}/info/payment">支付方式</a></li>
                        <li><a href="${pageContext.request.contextPath}/info/membership">会员权益</a></li>
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
</body>
</html>