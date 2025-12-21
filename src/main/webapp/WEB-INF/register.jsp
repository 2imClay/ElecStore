/* ===== REGISTER.JSP - Trang Đăng Ký ===== */
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - ElecStore</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            display: grid;
            grid-template-columns: 1fr 1fr;
            max-width: 900px;
            width: 100%;
            overflow: hidden;
        }

        /* Left Side - Banner */
        .register-banner {
            background: linear-gradient(135deg, #d32f2f 0%, #b71c1c 100%);
            color: white;
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .register-banner h2 {
            font-size: 36px;
            margin-bottom: 20px;
        }

        .register-banner p {
            font-size: 15px;
            opacity: 0.9;
            line-height: 1.6;
        }

        .banner-icon {
            font-size: 80px;
            margin-bottom: 30px;
            opacity: 0.8;
        }

        /* Right Side - Form */
        .register-form-section {
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .register-form-section h3 {
            font-size: 28px;
            color: #212121;
            margin-bottom: 10px;
        }

        .register-form-section > p {
            color: #999;
            margin-bottom: 30px;
            font-size: 14px;
        }

        /* Form Group */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #666;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 14px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #d32f2f;
            box-shadow: 0 0 0 3px rgba(211, 47, 47, 0.1);
        }

        /* Error Styling */
        .form-group input.error,
        .form-group select.error {
            border-color: #f44336;
            background: #ffebee;
        }

        .error-message {
            color: #f44336;
            font-size: 12px;
            margin-top: 6px;
            display: none;
        }

        .form-group input.error ~ .error-message,
        .form-group select.error ~ .error-message {
            display: block;
        }

        /* Success Message */
        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
            display: none;
        }

        .success-message.show {
            display: block;
        }

        /* Password Strength */
        .password-strength {
            margin-top: 8px;
            height: 4px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            background: #ccc;
            width: 0%;
            transition: all 0.3s ease;
        }

        .password-strength-bar.weak {
            background: #f44336;
            width: 33%;
        }

        .password-strength-bar.medium {
            background: #ff9800;
            width: 66%;
        }

        .password-strength-bar.strong {
            background: #4caf50;
            width: 100%;
        }

        .password-strength-text {
            font-size: 11px;
            margin-top: 4px;
            color: #666;
        }

        /* Two Column Form */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        /* Checkbox */
        .form-checkbox {
            display: flex;
            align-items: flex-start;
            margin: 20px 0;
        }

        .form-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-right: 10px;
            margin-top: 2px;
            cursor: pointer;
            accent-color: #d32f2f;
            flex-shrink: 0;
        }

        .form-checkbox label {
            margin: 0;
            font-size: 13px;
            color: #666;
            text-transform: none;
            letter-spacing: normal;
            font-weight: normal;
            cursor: pointer;
        }

        .form-checkbox a {
            color: #d32f2f;
            text-decoration: none;
        }

        .form-checkbox a:hover {
            text-decoration: underline;
        }

        /* Buttons */
        .form-buttons {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .btn-register {
            flex: 1;
            padding: 14px;
            background: #d32f2f;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .btn-register:hover:not(:disabled) {
            background: #b71c1c;
            box-shadow: 0 4px 12px rgba(211, 47, 47, 0.4);
        }

        .btn-register:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .btn-reset {
            padding: 14px 24px;
            background: transparent;
            color: #d32f2f;
            border: 2px solid #d32f2f;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .btn-reset:hover {
            background: #fff5f5;
        }

        /* Login Link */
        .login-link {
            text-align: center;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid #e0e0e0;
        }

        .login-link p {
            color: #666;
            font-size: 13px;
        }

        .login-link a {
            color: #d32f2f;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        /* Loading Spinner */
        .spinner {
            display: none;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(211, 47, 47, 0.3);
            border-top: 2px solid #d32f2f;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
            margin-right: 8px;
        }

        .btn-register.loading {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-register.loading .spinner {
            display: inline-block;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Alert Messages */
        .alert {
            padding: 12px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            display: none;
        }

        .alert.show {
            display: block;
        }

        .alert.error {
            background: #ffebee;
            color: #f44336;
            border-left: 4px solid #f44336;
        }

        .alert.success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #2e7d32;
        }

        .alert.warning {
            background: #fff3e0;
            color: #e65100;
            border-left: 4px solid #e65100;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .register-container {
                grid-template-columns: 1fr;
            }

            .register-banner {
                padding: 40px 20px;
            }

            .register-form-section {
                padding: 40px 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .register-banner h2 {
                font-size: 24px;
            }

            .register-form-section h3 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <!-- Banner Section -->
        <div class="register-banner">
            <div class="banner-icon">👋</div>
            <h2>Chào Mừng!</h2>
            <p>
                Tạo tài khoản ElecStore để mua sắm dễ dàng hơn.<br>
                Nhận ưu đãi độc quyền, theo dõi đơn hàng, và tiết kiệm thời gian.
            </p>
        </div>

        <!-- Form Section -->
        <div class="register-form-section">
            <h3>Đăng Ký</h3>
            <p>Điền đầy đủ thông tin dưới đây</p>

            <!-- Alert Messages -->
            <div class="alert error" id="alertError"></div>
            <div class="alert success" id="alertSuccess"></div>

            <form id="registerForm" method="POST" action="register" onsubmit="return submitForm(event)">
                <!-- Full Name -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">Tên</label>
                        <input type="text" id="firstName" name="firstName" placeholder="Ví dụ: Thanh" required>
                        <span class="error-message">Tên không được để trống</span>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Họ</label>
                        <input type="text" id="lastName" name="lastName" placeholder="Ví dụ: Nguyễn" required>
                        <span class="error-message">Họ không được để trống</span>
                    </div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
                    <span class="error-message" id="emailError">Email không hợp lệ</span>
                </div>

                <!-- Phone -->
                <div class="form-group">
                    <label for="phone">Số Điện Thoại</label>
                    <input type="tel" id="phone" name="phone" placeholder="0987654321" pattern="[0-9]{10,11}">
                    <span class="error-message">Số điện thoại phải có 10-11 chữ số</span>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="password">Mật Khẩu</label>
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="passwordStrengthBar"></div>
                    </div>
                    <div class="password-strength-text" id="passwordStrengthText"></div>
                    <span class="error-message" id="passwordError">Mật khẩu phải có ít nhất 6 ký tự</span>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword">Xác Nhận Mật Khẩu</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    <span class="error-message" id="confirmPasswordError">Mật khẩu không trùng khớp</span>
                </div>

                <!-- Address -->
                <div class="form-group">
                    <label for="address">Địa Chỉ (Tùy Chọn)</label>
                    <input type="text" id="address" name="address" placeholder="123 Đường ABC, Quận X">
                </div>

                <!-- City -->
                <div class="form-group">
                    <label for="city">Thành Phố (Tùy Chọn)</label>
                    <input type="text" id="city" name="city" placeholder="TP. Hồ Chí Minh">
                </div>

                <!-- Terms & Conditions -->
                <div class="form-checkbox">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">
                        Tôi đồng ý với <a href="#">Điều khoản sử dụng</a> và <a href="#">Chính sách bảo mật</a>
                    </label>
                </div>

                <!-- Buttons -->
                <div class="form-buttons">
                    <button type="submit" class="btn-register" id="submitBtn">
                        <span class="spinner"></span>
                        Đăng Ký
                    </button>
                    <button type="reset" class="btn-reset">Xóa</button>
                </div>

                <!-- Login Link -->
                <div class="login-link">
                    <p>Đã có tài khoản? <a href="login">Đăng nhập tại đây</a></p>
                </div>
            </form>
        </div>
    </div>

    <!-- JavaScript Validation & Submission -->
    <script>
        const form = document.getElementById('registerForm');
        const submitBtn = document.getElementById('submitBtn');
        const alertError = document.getElementById('alertError');
        const alertSuccess = document.getElementById('alertSuccess');

        // Real-time Email Validation
        document.getElementById('email').addEventListener('blur', async function() {
            const email = this.value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!emailRegex.test(email)) {
                this.classList.add('error');
                document.getElementById('emailError').textContent = 'Email không hợp lệ';
                return;
            }

            // Check if email exists in database
            try {
                const response = await fetch('check-email', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'email=' + encodeURIComponent(email)
                });

                const result = await response.json();
                if (result.exists) {
                    this.classList.add('error');
                    document.getElementById('emailError').textContent = 'Email này đã được sử dụng';
                } else {
                    this.classList.remove('error');
                }
            } catch (error) {
                console.error('Error checking email:', error);
            }
        });

        // Password Strength Indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrengthBar');
            const strengthText = document.getElementById('passwordStrengthText');

            if (password.length === 0) {
                strengthBar.className = 'password-strength-bar';
                strengthText.textContent = '';
                return;
            }

            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[!@#$%^&*]/.test(password)) strength++;

            strengthBar.className = 'password-strength-bar';
            if (strength <= 1) {
                strengthBar.classList.add('weak');
                strengthText.textContent = '⚠️ Mật khẩu yếu';
            } else if (strength === 2) {
                strengthBar.classList.add('medium');
                strengthText.textContent = '⚠️ Mật khẩu trung bình';
            } else {
                strengthBar.classList.add('strong');
                strengthText.textContent = '✓ Mật khẩu mạnh';
            }
        });

        // Confirm Password Validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            if (this.value !== document.getElementById('password').value) {
                this.classList.add('error');
            } else {
                this.classList.remove('error');
            }
        });

        // Form Submission with Validation
        function submitForm(event) {
            event.preventDefault();

            // Clear previous alerts
            alertError.classList.remove('show');
            alertSuccess.classList.remove('show');

            // Validate all fields
            let isValid = true;
            const errors = [];

            const firstName = document.getElementById('firstName').value.trim();
            const lastName = document.getElementById('lastName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms').checked;

            // Validation Rules
            if (!firstName) {
                errors.push('Tên không được để trống');
                document.getElementById('firstName').classList.add('error');
            } else if (firstName.length < 2) {
                errors.push('Tên phải có ít nhất 2 ký tự');
                document.getElementById('firstName').classList.add('error');
            }

            if (!lastName) {
                errors.push('Họ không được để trống');
                document.getElementById('lastName').classList.add('error');
            } else if (lastName.length < 2) {
                errors.push('Họ phải có ít nhất 2 ký tự');
                document.getElementById('lastName').classList.add('error');
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                errors.push('Email không hợp lệ');
                document.getElementById('email').classList.add('error');
            }

            if (phone && !/^\d{10,11}$/.test(phone)) {
                errors.push('Số điện thoại phải có 10-11 chữ số');
                document.getElementById('phone').classList.add('error');
            }

            if (password.length < 6) {
                errors.push('Mật khẩu phải có ít nhất 6 ký tự');
                document.getElementById('password').classList.add('error');
            }

            if (password !== confirmPassword) {
                errors.push('Mật khẩu xác nhận không trùng khớp');
                document.getElementById('confirmPassword').classList.add('error');
            }

            if (!terms) {
                errors.push('Bạn phải đồng ý với Điều khoản sử dụng');
            }

            // Show errors if any
            if (errors.length > 0) {
                alertError.classList.add('show');
                alertError.innerHTML = '❌ ' + errors.join('<br>');
                return false;
            }

            // Show loading state
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;

            // Submit form
            setTimeout(() => {
                form.submit();
            }, 500);

            return false;
        }

        // Remove error class on input
        form.querySelectorAll('input, select').forEach(field => {
            field.addEventListener('input', function() {
                if (this.value.trim() !== '' || this.type === 'checkbox') {
                    this.classList.remove('error');
                }
            });
        });
    </script>
</body>
</html>
