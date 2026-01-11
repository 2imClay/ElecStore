<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 11/01/2026
  Time: 12:26 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .forgot-password-container {
            width: 100%;
            max-width: 420px;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0 !important;
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .card-header h4 {
            margin: 0;
            font-weight: 600;
        }

        .step {
            display: none;
        }

        .step.active {
            display: block;
        }

        .form-control {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-primary {
            background: #667eea;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 500;
        }

        .btn-primary:hover {
            background: #5568d3;
        }

        .code-input {
            font-size: 2rem;
            letter-spacing: 10px;
            text-align: center;
            font-weight: bold;
            border-radius: 8px;
        }

        .step-indicator {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .step-number {
            display: inline-block;
            width: 40px;
            height: 40px;
            background: #e9ecef;
            border-radius: 50%;
            line-height: 40px;
            font-weight: bold;
            color: #667eea;
        }

        .step-number.active {
            background: #667eea;
            color: white;
        }

        .alert {
            border-radius: 8px;
            border: none;
        }
    </style>
</head>
<body>
<div class="forgot-password-container">
    <div class="card">
        <div class="card-header">
            <h4><i class="fas fa-lock-open"></i> Quên Mật Khẩu</h4>
        </div>
        <div class="card-body p-4">

            <!-- STEP 1: Email -->
            <div id="step1" class="step active">
                <div class="step-indicator mb-3">
                    <span class="step-number active">1</span>
                    <small class="text-muted">Nhập Email</small>
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ Email *</label>
                    <input type="email" class="form-control" id="emailInput"
                           placeholder="your@email.com" required>
                </div>
                <button class="btn btn-primary w-100" onclick="sendResetCode()">
                    <i class="fas fa-paper-plane"></i> Gửi Mã Xác Thực
                </button>
            </div>

            <!-- STEP 2: Code Verification -->
            <div id="step2" class="step" style="display: none;">
                <div class="step-indicator mb-3">
                    <span class="step-number active">2</span>
                    <small class="text-muted">Xác Thực Mã</small>
                </div>
                <p class="text-muted text-center mb-3">
                    Nhập mã xác thực được gửi đến email của bạn
                </p>
                <div class="mb-3">
                    <input type="text" class="form-control code-input" id="codeInput"
                           placeholder="000000" maxlength="6" required>
                </div>
                <small class="text-muted d-block mb-3">Mã xác thực có hiệu lực trong 5 phút</small>
                <button class="btn btn-primary w-100" onclick="verifyCode()">
                    <i class="fas fa-check"></i> Xác Thực
                </button>
                <button class="btn btn-outline-secondary w-100 mt-2" onclick="goToStep(1)">
                    Quay Lại
                </button>
            </div>

            <!-- STEP 3: New Password -->
            <div id="step3" class="step" style="display: none;">
                <div class="step-indicator mb-3">
                    <span class="step-number active">3</span>
                    <small class="text-muted">Mật Khẩu Mới</small>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu mới *</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="newPasswordInput"
                               placeholder="Min 6 ký tự" required>
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="togglePwd('newPasswordInput')">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Xác nhận mật khẩu *</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="confirmPasswordInput"
                               placeholder="Nhập lại mật khẩu" required>
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="togglePwd('confirmPasswordInput')">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                <button class="btn btn-primary w-100" onclick="resetPassword()">
                    <i class="fas fa-check"></i> Đặt Lại Mật Khẩu
                </button>
            </div>

            <!-- Success Message -->
            <div id="successMsg" style="display: none;">
                <div class="alert alert-success text-center" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <h5>Thành Công!</h5>
                    <p>Mật khẩu của bạn đã được cập nhật</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> Về Trang Đăng Nhập
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
<script>
    function sendResetCode() {
        const email = document.getElementById('emailInput').value;

        if (!email) {
            alert('❌ Vui lòng nhập email!');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/forgot-password',
            method: 'POST',
            dataType: 'json',
            data: { action: 'sendCode', email: email },
            success: function(response) {
                if (response.success) {
                    alert('✅ ' + response.message);
                    goToStep(2);
                } else {
                    alert('❌ ' + response.message);
                }
            },
            error: function() {
                alert('❌ Lỗi kết nối!');
            }
        });
    }

    function verifyCode() {
        const code = document.getElementById('codeInput').value;

        if (code.length !== 6) {
            alert('❌ Mã xác thực phải 6 ký tự!');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/forgot-password',
            method: 'POST',
            dataType: 'json',
            data: { action: 'verifyCode', code: code },
            success: function(response) {
                if (response.success) {
                    goToStep(3);
                } else {
                    alert('❌ ' + response.message);
                }
            }
        });
    }

    function resetPassword() {
        const newPwd = document.getElementById('newPasswordInput').value;
        const confirmPwd = document.getElementById('confirmPasswordInput').value;

        if (!newPwd || !confirmPwd) {
            alert('❌ Vui lòng điền đầy đủ!');
            return;
        }

        if (newPwd !== confirmPwd) {
            alert('❌ Mật khẩu xác nhận không khớp!');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/forgot-password',
            method: 'POST',
            dataType: 'json',
            data: {
                action: 'resetPassword',
                newPassword: newPwd
            },
            success: function(response) {
                if (response.success) {
                    document.querySelectorAll('.step').forEach(s => s.style.display = 'none');
                    document.getElementById('successMsg').style.display = 'block';
                } else {
                    alert('❌ ' + response.message);
                }
            }
        });
    }

    function goToStep(step) {
        document.querySelectorAll('.step').forEach(s => s.style.display = 'none');
        document.getElementById('step' + step).style.display = 'block';
    }

    function togglePwd(fieldId) {
        const input = document.getElementById(fieldId);
        input.type = input.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>
