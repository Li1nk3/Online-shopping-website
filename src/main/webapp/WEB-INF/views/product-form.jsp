<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty product ? '添加商品' : '编辑商品'} - JavaNet 在线商城</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.svg" type="image/svg+xml">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="modern-header">
        <div class="nav-container">
            <div class="nav-left">
                <a href="home" class="logo">
                    <span class="logo-text">JavaNet</span>
                </a>
                <div class="nav-links">
                    <a href="products" class="nav-link">所有商品</a>
                    <a href="product-management" class="nav-link">商品管理</a>
                </div>
            </div>
            <div class="nav-right">
                <div class="user-actions">
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
                    <div class="user-menu">
                        <span class="user-name" onclick="toggleDropdown()">欢迎, ${sessionScope.user.username} ▼</span>
                        <div class="dropdown" id="userDropdown">
                            <a href="profile" class="dropdown-item">个人信息</a>
                            <a href="product-management" class="dropdown-item">商品管理</a>
                            <a href="logout" class="dropdown-item">退出登录</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container">
            <div class="breadcrumb">
                <a href="home">首页</a> >
                <a href="product-management">商品管理</a> >
                <span>${empty product ? '添加商品' : '编辑商品'}</span>
            </div>
            
            <div class="checkout-section">
                <h2>${empty product ? '添加新商品' : '编辑商品'}</h2>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                
                <form method="post" action="product-management" class="product-form">
                <c:if test="${not empty product}">
                    <input type="hidden" name="productId" value="${product.id}">
                </c:if>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">商品名称 *</label>
                        <input type="text" id="name" name="name" 
                               value="${not empty name ? name : product.name}" 
                               required maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label for="category">商品分类 *</label>
                        <div class="category-input-wrapper">
                            <input type="text" id="category" name="category"
                                   value="${not empty category ? category : product.category}"
                                   required maxlength="50"
                                   placeholder="请选择或输入分类"
                                   autocomplete="off">
                            <div class="category-dropdown" id="categoryDropdown">
                                <c:forEach var="cat" items="${categories}">
                                    <div class="category-option" data-value="${cat}">
                                        <span class="category-option-text">${cat}</span>
                                    </div>
                                </c:forEach>
                                <!-- 默认分类选项，以防数据库为空 -->
                                <c:if test="${empty categories}">
                                    <div class="category-option" data-value="电子产品">
                                        <span class="category-option-text">电子产品</span>
                                    </div>
                                    <div class="category-option" data-value="服装鞋帽">
                                        <span class="category-option-text">服装鞋帽</span>
                                    </div>
                                    <div class="category-option" data-value="家居用品">
                                        <span class="category-option-text">家居用品</span>
                                    </div>
                                    <div class="category-option" data-value="图书文具">
                                        <span class="category-option-text">图书文具</span>
                                    </div>
                                    <div class="category-option" data-value="运动户外">
                                        <span class="category-option-text">运动户外</span>
                                    </div>
                                    <div class="category-option" data-value="美妆护肤">
                                        <span class="category-option-text">美妆护肤</span>
                                    </div>
                                    <div class="category-option" data-value="食品饮料">
                                        <span class="category-option-text">食品饮料</span>
                                    </div>
                                    <div class="category-option" data-value="游戏产品">
                                        <span class="category-option-text">游戏产品</span>
                                    </div>
                                    <div class="category-option" data-value="其他">
                                        <span class="category-option-text">其他</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        <small>可以从列表中选择现有分类，也可以输入自定义分类</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">商品描述 *</label>
                    <textarea id="description" name="description" rows="4" 
                              required maxlength="500">${not empty description ? description : product.description}</textarea>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="price">价格 (元) *</label>
                        <input type="number" id="price" name="price" 
                               value="${not empty price ? price : product.price}" 
                               step="0.01" min="0.01" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="stock">库存数量 *</label>
                        <input type="number" id="stock" name="stock" 
                               value="${not empty stock ? stock : product.stock}" 
                               min="0" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>商品图片 *</label>
                    <div class="images-container" id="imagesContainer">
                        <c:choose>
                            <c:when test="${not empty product.images}">
                                <c:forEach var="image" items="${product.images}" varStatus="status">
                                    <div class="image-input-group">
                                        <input type="url" name="imageUrls" value="${image.imageUrl}"
                                               placeholder="https://example.com/image.jpg" class="image-url-input">
                                        <div class="image-controls">
                                            <label class="primary-checkbox">
                                                <input type="radio" name="primaryImageIndex" value="${status.index}"
                                                       ${image.primary ? 'checked' : ''}>
                                                主图
                                            </label>
                                        </div>
                                        <div class="image-remove-section">
                                            <button type="button" class="btn-remove-image" onclick="removeImageInput(this)">删除</button>
                                        </div>
                                        <div class="image-preview-small">
                                            <img src="${image.imageUrl}" alt="预览" class="preview-img-small">
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="image-input-group">
                                    <input type="url" name="imageUrls" value="${not empty imageUrl ? imageUrl : product.imageUrl}"
                                           placeholder="https://example.com/image.jpg" class="image-url-input">
                                    <div class="image-controls">
                                        <label class="primary-checkbox">
                                            <input type="radio" name="primaryImageIndex" value="0" checked>
                                            主图
                                        </label>
                                    </div>
                                    <div class="image-remove-section">
                                        <button type="button" class="btn-remove-image" onclick="removeImageInput(this)">删除</button>
                                    </div>
                                    <div class="image-preview-small">
                                        <c:if test="${not empty product.imageUrl or not empty imageUrl}">
                                            <img src="${not empty imageUrl ? imageUrl : product.imageUrl}"
                                                 alt="预览" class="preview-img-small">
                                        </c:if>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <button type="button" class="btn-add-image" onclick="addImageInput()" style="margin-top: 15px;">
                        <svg viewBox="0 0 24 24" class="icon-svg" style="width:16px; height:16px; margin-right:8px;"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                        添加图片
                    </button>
                    <small style="display: block; margin-top: 10px; color: var(--text-grey);">
                        第一张图片将作为商品缩略图显示，可以通过"主图"选项指定主图片
                    </small>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-primary btn-full-width">
                        ${empty product ? '添加商品' : '更新商品'}
                    </button>
                    <a href="product-management" class="btn-back" style="display: inline-flex; align-items: center; justify-content: center; margin-top: 15px;">
                        取消并返回
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <style>
        /* 商品分类下拉菜单样式 */
        .category-input-wrapper {
            position: relative;
        }
        
        .category-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 2px solid var(--border-color);
            border-top: none;
            border-radius: 0 0 8px 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }
        
        .category-option {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 15px;
            cursor: pointer;
            transition: background-color 0.2s ease;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .category-option:last-child {
            border-bottom: none;
        }
        
        .category-option:hover,
        .category-option.selected {
            background-color: var(--bg-light);
            color: var(--ikea-blue);
        }
        
        .category-option.selected {
            background-color: rgba(0, 88, 163, 0.1);
            font-weight: 600;
        }
        
        .category-option-icon {
            font-size: 16px;
            width: 20px;
            text-align: center;
        }
        
        .category-option-text {
            font-size: 14px;
            flex: 1;
        }
        
        /* 滚动条样式 */
        .category-dropdown::-webkit-scrollbar {
            width: 6px;
        }
        
        .category-dropdown::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }
        
        .category-dropdown::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }
        
        .category-dropdown::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
    </style>
    
    <script>
        // 添加图片输入框
        function addImageInput() {
            const container = document.getElementById('imagesContainer');
            const index = container.children.length;
            
            const div = document.createElement('div');
            div.className = 'image-input-group';
            div.innerHTML = `
                <input type="url" name="imageUrls" placeholder="https://example.com/image.jpg" class="image-url-input">
                <div class="image-controls">
                    <label class="primary-checkbox">
                        <input type="radio" name="primaryImageIndex" value="${index}">
                        主图
                    </label>
                </div>
                <div class="image-remove-section">
                    <button type="button" class="btn-remove-image" onclick="removeImageInput(this)">删除</button>
                </div>
                <div class="image-preview-small"></div>
            `;
            
            container.appendChild(div);
            
            // 为新添加的输入框绑定预览事件
            const input = div.querySelector('.image-url-input');
            input.addEventListener('input', function() {
                updateImagePreview(this);
            });
        }
        
        // 删除图片输入框
        function removeImageInput(button) {
            const container = document.getElementById('imagesContainer');
            if (container.children.length > 1) {
                button.parentElement.parentElement.remove();
                updateRadioValues();
            } else {
                showAlert('至少需要保留一张图片', 'warning');
            }
        }
        
        // 更新单选按钮的值
        function updateRadioValues() {
            const container = document.getElementById('imagesContainer');
            const radios = container.querySelectorAll('input[name="primaryImageIndex"]');
            radios.forEach((radio, index) => {
                radio.value = index;
            });
        }
        
        // 更新图片预览
        function updateImagePreview(input) {
            const url = input.value;
            const previewDiv = input.parentElement.querySelector('.image-preview-small');
            
            if (url) {
                previewDiv.innerHTML = '<img src="' + url + '" alt="预览" class="preview-img-small">';
            } else {
                previewDiv.innerHTML = '';
            }
        }
        
        // 页面加载时绑定事件
        document.addEventListener('DOMContentLoaded', function() {
            // 为现有的图片输入框绑定预览事件
            const imageInputs = document.querySelectorAll('.image-url-input');
            imageInputs.forEach(input => {
                input.addEventListener('input', function() {
                    updateImagePreview(this);
                });
            });
        });
        
        // 表单验证
        document.querySelector('.product-form').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const description = document.getElementById('description').value.trim();
            const price = parseFloat(document.getElementById('price').value);
            const stock = parseInt(document.getElementById('stock').value);
            const category = document.getElementById('category').value;
            
            if (!name || !description || !category) {
                e.preventDefault();
                showAlert('请填写所有必填字段', 'warning');
                return;
            }
            
            if (price <= 0) {
                e.preventDefault();
                showAlert('价格必须大于0', 'warning');
                return;
            }
            
            if (stock < 0) {
                e.preventDefault();
                showAlert('库存不能为负数', 'warning');
                return;
            }
            
            // 检查是否至少有一张图片
            const imageUrls = document.querySelectorAll('input[name="imageUrls"]');
            let hasImage = false;
            imageUrls.forEach(input => {
                if (input.value.trim()) {
                    hasImage = true;
                }
            });
            
            if (!hasImage) {
                e.preventDefault();
                showAlert('请至少添加一张商品图片', 'warning');
                return;
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
        
        // 商品分类输入框增强交互
        document.addEventListener('DOMContentLoaded', function() {
            const categoryInput = document.getElementById('category');
            const categoryDropdown = document.getElementById('categoryDropdown');
            
            if (categoryInput && categoryDropdown) {
                let selectedIndex = -1;
                const options = categoryDropdown.querySelectorAll('.category-option');
                
                // 显示/隐藏下拉菜单
                function showDropdown() {
                    categoryDropdown.style.display = 'block';
                    filterOptions();
                }
                
                function hideDropdown() {
                    setTimeout(() => {
                        categoryDropdown.style.display = 'none';
                    }, 200); // 延迟隐藏，允许点击选项
                }
                
                // 过滤选项
                function filterOptions() {
                    const value = categoryInput.value.toLowerCase();
                    
                    options.forEach((option, index) => {
                        const text = option.querySelector('.category-option-text').textContent.toLowerCase();
                        
                        if (text.includes(value)) {
                            option.style.display = 'flex';
                        } else {
                            option.style.display = 'none';
                        }
                    });
                    
                    // 重置选中索引
                    selectedIndex = -1;
                }
                
                // 选择选项
                function selectOption(option) {
                    categoryInput.value = option.dataset.value;
                    hideDropdown();
                    categoryInput.focus();
                }
                
                // 键盘导航
                function navigateOptions(direction) {
                    const visibleOptions = Array.from(options).filter(option =>
                        option.style.display !== 'none'
                    );
                    
                    if (direction === 'down') {
                        selectedIndex++;
                        if (selectedIndex >= visibleOptions.length) {
                            selectedIndex = 0;
                        }
                    } else if (direction === 'up') {
                        selectedIndex--;
                        if (selectedIndex < 0) {
                            selectedIndex = visibleOptions.length - 1;
                        }
                    }
                    
                    // 移除所有选中状态
                    options.forEach(option => option.classList.remove('selected'));
                    
                    // 添加选中状态
                    if (visibleOptions[selectedIndex]) {
                        visibleOptions[selectedIndex].classList.add('selected');
                        visibleOptions[selectedIndex].scrollIntoView({ block: 'nearest' });
                    }
                }
                
                // 事件监听器
                categoryInput.addEventListener('focus', function() {
                    showDropdown();
                });
                
                categoryInput.addEventListener('blur', function() {
                    hideDropdown();
                });
                
                categoryInput.addEventListener('input', function() {
                    showDropdown();
                });
                
                categoryInput.addEventListener('keydown', function(e) {
                    switch (e.key) {
                        case 'ArrowDown':
                            e.preventDefault();
                            navigateOptions('down');
                            break;
                        case 'ArrowUp':
                            e.preventDefault();
                            navigateOptions('up');
                            break;
                        case 'Enter':
                            e.preventDefault();
                            const selectedOption = categoryDropdown.querySelector('.category-option.selected');
                            if (selectedOption) {
                                selectOption(selectedOption);
                            }
                            break;
                        case 'Escape':
                            hideDropdown();
                            break;
                    }
                });
                
                // 选项点击事件
                options.forEach(option => {
                    option.addEventListener('click', function() {
                        selectOption(this);
                    });
                    
                    option.addEventListener('mouseenter', function() {
                        options.forEach(opt => opt.classList.remove('selected'));
                        this.classList.add('selected');
                    });
                });
                
                // 点击页面其他地方隐藏下拉菜单
                document.addEventListener('click', function(e) {
                    if (!categoryInput.contains(e.target) && !categoryDropdown.contains(e.target)) {
                        hideDropdown();
                    }
                });
            }
        });
    </script>
</body>
</html>