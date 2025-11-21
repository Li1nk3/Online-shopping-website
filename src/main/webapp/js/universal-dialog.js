// 通用弹窗系统
class UniversalDialog {
    constructor() {
        this.init();
    }

    init() {
        // 创建确认对话框HTML
        this.createConfirmDialog();
        // 创建提示对话框HTML
        this.createAlertDialog();
    }

    // 创建确认对话框
    createConfirmDialog() {
        const confirmHTML = `
            <div id="universalConfirmOverlay" class="universal-confirm-overlay">
                <div class="universal-confirm-dialog">
                    <div class="universal-confirm-header">
                        <h3>确认操作</h3>
                    </div>
                    <div class="universal-confirm-body">
                        <p id="confirmMessage">确定要执行此操作吗？</p>
                    </div>
                    <div class="universal-confirm-actions">
                        <button class="universal-btn-cancel" onclick="universalDialog.cancelConfirm()">取消</button>
                        <button class="universal-btn-confirm" id="confirmBtn" onclick="universalDialog.okConfirm()">确定</button>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', confirmHTML);
    }

    // 创建提示对话框
    createAlertDialog() {
        const alertHTML = `
            <div id="universalAlertOverlay" class="universal-alert-overlay">
                <div class="universal-alert-dialog">
                    <div class="universal-alert-header" id="alertHeader">
                        <h3>提示</h3>
                    </div>
                    <div class="universal-alert-body">
                        <p id="alertMessage">操作完成</p>
                    </div>
                    <div class="universal-alert-actions">
                        <button class="universal-btn-ok" id="alertOkBtn" onclick="universalDialog.closeAlert()">确定</button>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', alertHTML);
    }

    // 显示确认对话框
    showConfirm(message, onConfirm, options = {}) {
        return new Promise((resolve) => {
            this.confirmResolve = resolve;
            this.confirmCallback = onConfirm;
            
            const overlay = document.getElementById('universalConfirmOverlay');
            const messageEl = document.getElementById('confirmMessage');
            const confirmBtn = document.getElementById('confirmBtn');
            
            messageEl.textContent = message;
            
            // 设置按钮样式
            if (options.type === 'danger') {
                confirmBtn.classList.add('danger');
            } else {
                confirmBtn.classList.remove('danger');
            }
            
            // 设置标题
            const header = overlay.querySelector('.universal-confirm-header h3');
            header.textContent = options.title || '确认操作';
            
            overlay.style.display = 'flex';
            setTimeout(() => overlay.classList.add('show'), 10);
        });
    }

    // 确认操作
    okConfirm() {
        this.closeConfirm();
        if (this.confirmCallback) {
            this.confirmCallback();
        }
        if (this.confirmResolve) {
            this.confirmResolve(true);
        }
    }

    // 取消确认
    cancelConfirm() {
        this.closeConfirm();
        if (this.confirmResolve) {
            this.confirmResolve(false);
        }
    }

    // 关闭确认对话框
    closeConfirm() {
        const overlay = document.getElementById('universalConfirmOverlay');
        overlay.classList.remove('show');
        setTimeout(() => {
            overlay.style.display = 'none';
        }, 300);
    }

    // 显示提示对话框
    showAlert(message, type = 'info', options = {}) {
        return new Promise((resolve) => {
            this.alertResolve = resolve;
            
            const overlay = document.getElementById('universalAlertOverlay');
            const messageEl = document.getElementById('alertMessage');
            const header = document.getElementById('alertHeader');
            const okBtn = document.getElementById('alertOkBtn');
            
            messageEl.textContent = message;
            
            // 设置样式
            header.className = 'universal-alert-header ' + type;
            okBtn.className = 'universal-btn-ok ' + type;
            
            // 设置标题
            const titles = {
                'success': '成功',
                'error': '错误',
                'warning': '警告',
                'info': '提示'
            };
            header.querySelector('h3').textContent = options.title || titles[type] || '提示';
            
            overlay.style.display = 'flex';
            setTimeout(() => overlay.classList.add('show'), 10);
        });
    }

    // 关闭提示对话框
    closeAlert() {
        const overlay = document.getElementById('universalAlertOverlay');
        overlay.classList.remove('show');
        setTimeout(() => {
            overlay.style.display = 'none';
            if (this.alertResolve) {
                this.alertResolve();
            }
        }, 300);
    }
}

// 创建全局实例
const universalDialog = new UniversalDialog();

// 替换原生confirm和alert函数
function showConfirm(message, callback, options = {}) {
    return universalDialog.showConfirm(message, callback, options);
}

function showAlert(message, type, options = {}) {
    return universalDialog.showAlert(message, type, options);
}

// 为了兼容性，也提供这些函数名
function universalConfirm(message, callback, options = {}) {
    return showConfirm(message, callback, options);
}

function universalAlert(message, type, options = {}) {
    return showAlert(message, type, options);
}

// 自动初始化（当DOM加载完成时）
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        new UniversalDialog();
    });
} else {
    new UniversalDialog();
}