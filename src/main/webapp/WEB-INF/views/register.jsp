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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #15161D;
            font-family: 'Montserrat', sans-serif;
            padding: 20px;
        }

        .register-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            padding: 40px;
        }

        .register-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .register-header .logo {
            font-size: 36px;
            font-weight: 700;
            color: #d32f2f;
            margin-bottom: 10px;
        }

        .register-header p {
            color: #999;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .form-row .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: 'Montserrat', sans-serif;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #d32f2f;
            box-shadow: 0 0 5px rgba(211, 47, 47, 0.2);
        }

        .form-group input::placeholder {
            color: #ccc;
        }

        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }

        .strength-bar {
            height: 4px;
            background: #ddd;
            border-radius: 2px;
            overflow: hidden;
            margin-bottom: 5px;
        }

        .strength-bar-fill {
            height: 100%;
            width: 0;
            background: #f44336;
            transition: width 0.3s ease;
        }

        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            margin: 25px 0;
            font-size: 13px;
        }

        .terms-checkbox input {
            width: auto !important;
            margin-right: 10px;
            margin-top: 2px;
            cursor: pointer;
        }

        .terms-checkbox label {
            margin: 0;
            text-transform: none;
            font-weight: normal;
            color: #666;
        }

        .terms-checkbox a {
            color: #d32f2f;
            text-decoration: none;
        }

        .terms-checkbox a:hover {
            text-decoration: underline;
        }

        .register-btn {
            width: 100%;
            padding: 13px;
            background: #d32f2f;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
        }

        .register-btn:hover {
            background: #b71c1c;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(211, 47, 47, 0.3);
        }

        .login-link {
            text-align: center;
            font-size: 13px;
            color: #666;
        }

        .login-link a {
            color: #d32f2f;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .alert {
            margin-bottom: 20px;
            padding: 12px 15px;
            border-radius: 5px;
            font-size: 13px;
        }

        .alert-danger {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ef5350;
        }

        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #81c784;
        }

        @media (max-width: 576px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .register-container {
                padding: 25px;
            }
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="register-header">
        <div class="logo">Electro<span style="color: #d32f2f;">.</span></div>
        <p>Tạo tài khoản mới để mua sắm</p>
    </div>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/register" id="registerForm">
        <div class="form-row">
            <div class="form-group">
                <label for="firstName">Họ</label>
                <input type="text" id="firstName" name="firstName" placeholder="Nhập họ" required>
            </div>

            <div class="form-group">
                <label for="lastName">Tên</label>
                <input type="text" id="lastName" name="lastName" placeholder="Nhập tên" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="example@email.com" required>
        </div>

        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <input type="tel" id="phone" name="phone" placeholder="0912345678" pattern="[0-9]{10,11}">
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" placeholder="Tối thiểu 6 ký tự" required>
            <div class="password-strength">
                <div class="strength-bar">
                    <div class="strength-bar-fill" id="strengthBar"></div>
                </div>
                <span id="strengthText" style="color: #f44336;">Yếu</span>
            </div>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Xác nhận mật khẩu</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
        </div>

        <div class="form-group">
            <label for="address">Địa chỉ</label>
            <input type="text" id="address" name="address" placeholder="Nhập địa chỉ" required>
        </div>

        <div class="terms-checkbox">
            <input type="checkbox" id="terms" name="terms" required>
            <label for="terms">
                Tôi đồng ý với <a href="#">Điều khoản dịch vụ</a> và <a href="#">Chính sách bảo mật</a>
            </label>
        </div>

        <button type="submit" class="register-btn">Đăng ký</button>
    </form>

    <div class="login-link">
        Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>

<script>
    // Kiểm tra độ mạnh mật khẩu
    $('#password').on('keyup', function() {
        let password = $(this).val();
        let strength = 0;

        if (password.length >= 6) strength++;
        if (password.match(/[a-z]+/)) strength++;
        if (password.match(/[A-Z]+/)) strength++;
        if (password.match(/[0-9]+/)) strength++;
        if (password.match(/[@$!%*?&]+/)) strength++;

        let strengthBar = $('#strengthBar');
        let strengthText = $('#strengthText');
        let widths = ['0%', '20%', '40%', '60%', '80%', '100%'];
        let colors = ['#f44336', '#ff9800', '#ffc107', '#8bc34a', '#4caf50', '#2e7d32'];
        let texts = ['Yếu', 'Yếu', 'Trung bình', 'Trung bình', 'Mạnh', 'Rất mạnh'];

        strengthBar.css({'width': widths[strength], 'background': colors[strength]});
        strengthText.text(texts[strength]).css('color', colors[strength]);
    });

    // Kiểm tra xác nhận mật khẩu
    $('#registerForm').on('submit', function(e) {
        let password = $('#password').val();
        let confirmPassword = $('#confirmPassword').val();

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Mật khẩu xác nhận không khớp!');
            return false;
        }

        if (password.length < 6) {
            e.preventDefault();
            alert('Mật khẩu phải tối thiểu 6 ký tự!');
            return false;
        }
    });
</script>

</body>
</html>
