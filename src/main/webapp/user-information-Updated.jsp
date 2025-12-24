<%--
  User Information Page - ElecStore
  Display user profile & settings
  Date: 24/12/2025
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Thông tin tài khoản - ElecStore</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <!-- Slick -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.css"/>
    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <!-- Custom stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-information.css"/>

    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
</head>
<body>
<!-- HEADER -->
<header>
    <div id="header">
        <div class="container">
            <div class="row">
                <!-- LOGO -->
                <div class="col-md-3">
                    <div class="header-logo">
                        <a href="${pageContext.request.contextPath}/home" class="logo">
                            <img src="${pageContext.request.contextPath}/images/logo.png" alt="">
                        </a>
                    </div>
                </div>

                <!-- SEARCH BAR -->
                <div class="col-md-6">
                    <div class="header-search">
                        <form id="searchForm" method="get" action="${pageContext.request.contextPath}/store" style="display: flex">
                            <div style="position: relative; flex: 1; width: 100%">
                                <input class="input" id="searchInput" name="keyword"
                                       placeholder="Nhập từ khóa để tìm sản phẩm"
                                       autocomplete="off"
                                       style="width: 100%; border-radius: 40px 0 0 40px;">
                                <div id="suggestDropdown" style="
                                        display: none;
                                        position: absolute;
                                        top: 100%;
                                        left: 0;
                                        right: 0;
                                        background: white;
                                        border: 1px solid #ddd;
                                        border-top: none;
                                        max-height: 300px;
                                        overflow-y: auto;
                                        z-index: 999;">
                                </div>
                            </div>
                            <button class="search-btn" type="submit">Tìm kiếm</button>
                        </form>
                    </div>
                </div>

                <!-- ACCOUNT -->
                <div class="col-md-3 clearfix" style="display: flex">
                    <div class="header-ctn" style="display: flex">
                        <!-- Account -->
                        <div class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                                <i class="fa fa-user-o"></i>
                                <span>Account</span>
                            </a>
                            <div class="acc-dropdown cart-dropdown" style="width: 150px;">
                                <c:if test="${not empty sessionScope.user}">
                                    <div style="padding: 10px; border-bottom: 1px solid #ddd;">
                                        <p style="margin: 0; font-weight: bold;">${sessionScope.userName}</p>
                                        <small style="color: #999;">${sessionScope.userEmail}</small>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/user-information" style="display: block; padding: 10px; color: #333;">Thông tin tài khoản</a>
                                    <a href="${pageContext.request.contextPath}/logout" style="display: block; padding: 10px; color: #d32f2f; border-top: 1px solid #ddd;">Đăng xuất</a>
                                </c:if>
                                <c:if test="${empty sessionScope.user}">
                                    <a href="${pageContext.request.contextPath}/login" style="display: block; padding: 10px; color: #333;">Đăng nhập</a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Menu Toggle -->
                        <div class="menu-toggle">
                            <a href="#">
                                <i class="fa fa-bars"></i>
                                <span>Menu</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- MAIN CONTENT -->
<div class="section">
    <!-- CHECK IF USER LOGGED IN -->
    <c:if test="${empty sessionScope.user}">
        <div class="container">
            <div class="alert alert-warning">
                ⚠️ Vui lòng <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để xem thông tin tài khoản
            </div>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.user}">
        <div class="profile-container">
            <div class="profile-wrapper">
                <!-- Sidebar -->
                <aside class="profile-sidebar">
                    <!-- Avatar Section -->
                    <div class="profile-avatar-section">
                        <div class="profile-avatar">
                            ${fn:substring(sessionScope.userName, 0, 1)}
                        </div>
                        <h2 class="profile-name">${sessionScope.userName}</h2>
                        <p class="profile-email">${sessionScope.userEmail}</p>
                        <span class="profile-status">✓ Đã xác thực</span>
                    </div>

                    <!-- Stats -->
                    <div class="profile-stats">
                        <div class="stat-row">
                            <span class="stat-label">📦 Đơn hàng</span>
                            <span class="stat-value">${orderCount}</span>
                        </div>
                        <div class="stat-row">
                            <span class="stat-label">💰 Đã chi</span>
                            <span class="stat-value">${totalSpent} ₫</span>
                        </div>
                        <div class="stat-row">
                            <span class="stat-label">⭐ Điểm</span>
                            <span class="stat-value">${points}</span>
                        </div>
                        <div class="stat-row">
                            <span class="stat-label">📅 Tham gia</span>
                            <span class="stat-value" style="font-size: 12px;">
                                <fmt:formatDate value="${user.createdAt}" pattern="MMM yyyy"/>
                            </span>
                        </div>
                    </div>

                    <!-- Menu -->
                    <div class="profile-menu">
                        <a href="#personal" class="active">👤 Thông tin cá nhân</a>
                        <a href="#address">📍 Địa chỉ giao hàng</a>
                        <a href="#orders">📦 Lịch sử đơn hàng</a>
                        <a href="#security">🔒 Bảo mật</a>
                        <a href="#settings">⚙️ Cài đặt</a>
                    </div>

                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
                </aside>

                <!-- Main Content -->
                <main class="profile-content">
                    <!-- 1. THÔNG TIN CÁ NHÂN -->
                    <div class="profile-card" id="personal">
                        <div class="card-header">
                            <h3>Thông Tin Cá Nhân</h3>
                            <button class="btn-edit" onclick="editPersonal()">Chỉnh sửa</button>
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Tên</label>
                                <p>${user.firstName}</p>
                            </div>
                            <div class="form-group">
                                <label>Họ</label>
                                <p>${user.lastName}</p>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <p>${user.email}</p>
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <p>${userPhone}</p>
                            </div>
                            <div class="form-group full">
                                <label>Ngày tham gia</label>
                                <p>
                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- 2. ĐỊA CHỈ GIAO HÀNG -->
                    <div class="profile-card" id="address">
                        <div class="card-header">
                            <h3>Địa Chỉ Giao Hàng</h3>
                            <button class="btn-edit" onclick="editAddress()">Thay đổi</button>
                        </div>
                        <div class="form-grid">
                            <div class="form-group full">
                                <label>Địa chỉ đầy đủ</label>
                                <p>${userAddress}</p>
                            </div>
                            <div class="form-group">
                                <label>Thành phố</label>
                                <p>${userCity}</p>
                            </div>
                            <div class="form-group">
                                <label>Quốc gia</label>
                                <p>${userCountry}</p>
                            </div>
                        </div>
                        <div class="info-box">
                            <p>💡 Địa chỉ này sẽ được sử dụng mặc định cho tất cả đơn hàng của bạn</p>
                        </div>
                    </div>

                    <!-- 3. LỊCH SỬ ĐƠN HÀNG -->
                    <div class="profile-card" id="orders">
                        <div class="card-header">
                            <h3>Lịch Sử Đơn Hàng</h3>
                            <a href="${pageContext.request.contextPath}/orders" class="btn-edit" style="cursor: pointer;">Xem tất cả</a>
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Không có đơn hàng</label>
                                <p style="color: #999;">Bạn chưa có đơn hàng nào. <a href="${pageContext.request.contextPath}/store">Mua sắm ngay</a></p>
                            </div>
                        </div>
                    </div>

                    <!-- 4. BẢO MẬT & ĐĂNG NHẬP -->
                    <div class="profile-card" id="security">
                        <div class="card-header">
                            <h3>Bảo Mật & Đăng Nhập</h3>
                        </div>
                        <div class="security-grid">
                            <div class="security-item">
                                <div class="security-item-left">
                                    <span class="security-item-label">🔐 Mật khẩu</span>
                                    <span class="security-item-desc">Thay đổi mật khẩu tài khoản</span>
                                </div>
                                <button class="btn-edit" onclick="changePassword()">Đổi</button>
                            </div>
                            <div class="security-item">
                                <div class="security-item-left">
                                    <span class="security-item-label">✉️ Email</span>
                                    <span class="security-item-desc">${user.email}</span>
                                </div>
                                <span class="security-status status-verified">✓ Xác thực</span>
                            </div>
                            <div class="security-item">
                                <div class="security-item-left">
                                    <span class="security-item-label">📱 Xác thực 2 lớp</span>
                                    <span class="security-item-desc">Tăng cường bảo mật tài khoản</span>
                                </div>
                                <span class="security-status status-pending">Chưa kích hoạt</span>
                            </div>
                        </div>
                        <div class="info-box" style="margin-top: 16px;">
                            <p>🔒 Mật khẩu của bạn được mã hóa an toàn. Không bao giờ chia sẻ mật khẩu với ai.</p>
                        </div>
                    </div>

                    <!-- 5. CÀI ĐẶT -->
                    <div class="profile-card" id="settings">
                        <div class="card-header">
                            <h3>Cài Đặt Tài Khoản</h3>
                        </div>
                        <div class="security-grid">
                            <div class="security-item">
                                <div class="security-item-left">
                                    <span class="security-item-label">🔔 Thông báo qua Email</span>
                                    <span class="security-item-desc">Nhận thông báo về đơn hàng, khuyến mãi</span>
                                </div>
                                <label style="cursor: pointer;">
                                    <input type="checkbox" checked style="width: 20px; height: 20px; cursor: pointer;">
                                </label>
                            </div>
                            <div class="security-item">
                                <div class="security-item-left">
                                    <span class="security-item-label">💬 Tiếp nhận tin tức</span>
                                    <span class="security-item-desc">Những tin tức và khuyến mãi mới nhất</span>
                                </div>
                                <label style="cursor: pointer;">
                                    <input type="checkbox" checked style="width: 20px; height: 20px; cursor: pointer;">
                                </label>
                            </div>
                            <div class="security-item">
                                <div class="security-item-left">
                                    <span class="security-item-label">🗑️ Xóa tài khoản</span>
                                    <span class="security-item-desc">Vĩnh viễn xóa toàn bộ dữ liệu</span>
                                </div>
                                <button class="btn-edit" style="border-color: #ffcdd2; background: #fff5f5; color: #c62828;" onclick="deleteAccount()">Xóa</button>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </c:if>
</div>

<!-- FOOTER -->
<footer id="footer" style="margin-top: 30px">
    <!-- top footer -->
    <div class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">About Us</h3>
                        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut.</p>
                        <ul class="footer-links">
                            <li><a href="#"><i class="fa fa-map-marker"></i>1734 Stonecoal Road</a></li>
                            <li><a href="#"><i class="fa fa-phone"></i>+021-95-51-84</a></li>
                            <li><a href="#"><i class="fa fa-envelope-o"></i>email@email.com</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Categories</h3>
                        <ul class="footer-links">
                            <li><a href="#">Hot deals</a></li>
                            <li><a href="#">Laptops</a></li>
                            <li><a href="#">Smartphones</a></li>
                            <li><a href="#">Cameras</a></li>
                            <li><a href="#">Accessories</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Information</h3>
                        <ul class="footer-links">
                            <li><a href="#">About Us</a></li>
                            <li><a href="#">Contact Us</a></li>
                            <li><a href="#">Privacy Policy</a></li>
                            <li><a href="#">Orders and Returns</a></li>
                            <li><a href="#">Terms & Conditions</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Service</h3>
                        <ul class="footer-links">
                            <li><a href="#">My Account</a></li>
                            <li><a href="#">View Cart</a></li>
                            <li><a href="#">Wishlist</a></li>
                            <li><a href="#">Track My Order</a></li>
                            <li><a href="#">Help</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    // Menu navigation
    document.querySelectorAll('.profile-menu a').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelectorAll('.profile-menu a').forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });

    function editPersonal() {
        alert('Sẽ mở trang chỉnh sửa thông tin cá nhân');
    }

    function editAddress() {
        alert('Sẽ mở trang chỉnh sửa địa chỉ');
    }

    function changePassword() {
        alert('Sẽ mở trang đổi mật khẩu');
    }

    function deleteAccount() {
        if (confirm('⚠️ Bạn chắc chắn muốn xóa tài khoản? Điều này không thể hoàn tác!')) {
            alert('Tài khoản sẽ được xóa');
        }
    }
</script>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

</body>
</html>
