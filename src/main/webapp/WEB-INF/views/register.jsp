<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 20/12/2025
  Time: 6:12 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - ElecStore</title>

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <!-- Custom stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css"/>

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

<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>

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
