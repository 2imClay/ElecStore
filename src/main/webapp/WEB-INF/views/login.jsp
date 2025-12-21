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
    <title>Đăng nhập - ElecStore</title>

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <!-- Custom stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css"/>

</head>
<body>

<div class="login-container">
    <div class="login-header">
        <div class="logo">Electro<span style="color: #d32f2f;">.</span></div>
        <p>Đăng nhập vào tài khoản của bạn</p>
    </div>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/login">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="example@email.com" required>
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
        </div>

        <div class="remember-forgot">
            <div class="checkbox-wrapper">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember" style="margin: 0; text-transform: none;">Nhớ tôi</label>
            </div>
            <a href="#forgot">Quên mật khẩu?</a>
        </div>

        <button type="submit" class="login-btn">Đăng nhập</button>
    </form>

    <div class="divider">
        <span>hoặc</span>
    </div>

    <div class="signup-link">
        Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>

</body>
</html>
