<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty product ? '添加商品' : '编辑商品'} - JavaNet 在线商城</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/universal-dialog.js"></script>
</head>
<body>
    <div class="header">
        <h1><a href="products" style="color: white; text-decoration: none;">JavaNet 在线商城</a></h1>
        <div class="user-info">
            <span>欢迎, ${sessionScope.user.username}!</span>
            <a href="cart" class="btn-cart-nav">购物车</a>
            <a href="orders" class="btn-cart-nav">我的订单</a>
            <a href="logout" class="btn-link">退出</a>
        </div>
    </div>
    
    <div class="container">
        <div class="breadcrumb">
            <a href="products">商品列表</a> > 
            <a href="product-management">商品管理</a> > 
            <span>${empty product ? '添加商品' : '编辑商品'}</span>
        </div>
        
        <div class="product-form-container">
            <h2>${empty product ? '添加新商品' : '编辑商品'}</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
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
                        <input type="text" id="category" name="category" list="categoryList"
                               value="${not empty category ? category : product.category}"
                               required maxlength="50"
                               placeholder="请选择或输入分类">
                        <datalist id="categoryList">
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}">
                            </c:forEach>
                            <!-- 默认分类选项，以防数据库为空 -->
                            <c:if test="${empty categories}">
                                <option value="电子产品">
                                <option value="服装鞋帽">
                                <option value="家居用品">
                                <option value="图书文具">
                                <option value="运动户外">
                                <option value="美妆护肤">
                                <option value="食品饮料">
                                <option value="游戏产品">
                                <option value="其他">
                            </c:if>
                        </datalist>
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
                    <label>商品图片</label>
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
                    <button type="button" class="btn-add-image" onclick="addImageInput()">添加图片</button>
                    <small>第一张图片将作为商品缩略图显示，可以通过"主图"选项指定主图片</small>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        ${empty product ? '添加商品' : '更新商品'}
                    </button>
                    <a href="product-management" class="btn-cancel">取消</a>
                </div>
            </form>
        </div>
    </div>
    
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
    </script>
</body>
</html>