<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 04/12/2025
  Time: 7:01 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Title</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>ElecStore</title>

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>

    <!-- Slick -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick-theme.min.css"/>

    <!-- nouislider -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/nouislider@15.8.1/dist/nouislider.min.css">

    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">

    <!-- Custom stlylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-information.css"/>

    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>


</head>
<body>
<!-- HEADER -->
<header>

    <!-- MAIN HEADER -->
    <div id="header">
        <!-- container -->
        <div class="container">
            <!-- row -->
            <div class="row">
                <!-- LOGO -->
                <div class="col-md-3">
                    <div class="header-logo">
                        <a href="${pageContext.request.contextPath}/home" class="logo">
                            <img src="${pageContext.request.contextPath}/images/logo.png" alt="">
                        </a>
                    </div>
                </div>
                <!-- /LOGO -->

                <!-- SEARCH BAR -->
                <div class="col-md-6">
                    <div class="header-search">
                        <form id="searchForm" method="get" action="${pageContext.request.contextPath}/store" style="display: flex":>
                            <div style="position: relative; flex: 1; width: 100%">
                                <input class="input" id="searchInput" name="keyword"
                                       placeholder="Nhập từ khóa để tìm sản phẩm"
                                       autocomplete="off"
                                       style="width: 100%; border-radius: 40px 0 0 40px;"
                                >

                                <!-- Dropdown gợi ý -->
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
                                        z-index: 999;
                                    ">
                                </div>
                            </div>
                            <button class="search-btn" type="submit">Tìm kiếm</button>
                        </form>
                    </div>
                </div>
                <!-- /SEARCH BAR -->

                <!-- ACCOUNT -->
                <div class="col-md-3 clearfix" style="display: flex">
                    <div class="header-ctn" style="display: flex">
                        <!-- Wishlist -->
                        <div>
                            <a href="#">
                                <i class="fa fa-heart-o"></i>
                                <span>Yêu thích</span>
                                <div class="qty">0</div>
                            </a>
                        </div>
                        <!-- /Wishlist -->

                        <!-- Cart -->
                        <div class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                                <i class="fa fa-shopping-cart"></i>
                                <span>Giỏ hàng</span>
                                <div class="qty">0</div>
                            </a>
                            <div class="cart-dropdown">
                                <div class="cart-list">
                                    <div class="product-widget">
                                        <div class="product-img">
                                            <img src="${pageContext.request.contextPath}/images/product01.png" alt="">
                                        </div>
                                        <div class="product-body">
                                            <h3 class="product-name"><a href="#">product name goes here</a></h3>
                                            <h4 class="product-price"><span class="qty">1x</span>$980.00</h4>
                                        </div>
                                        <button class="delete"><i class="fa fa-close"></i></button>
                                    </div>

                                    <div class="product-widget">
                                        <div class="product-img">
                                            <img src="${pageContext.request.contextPath}/images/product02.png" alt="">
                                        </div>
                                        <div class="product-body">
                                            <h3 class="product-name"><a href="#">product name goes here</a></h3>
                                            <h4 class="product-price"><span class="qty">3x</span>$980.00</h4>
                                        </div>
                                        <button class="delete"><i class="fa fa-close"></i></button>
                                    </div>
                                </div>
                                <div class="cart-summary">
                                    <small>3 Item(s) selected</small>
                                    <h5>SUBTOTAL: $2940.00</h5>
                                </div>
                                <div class="cart-btns">
                                    <a href="#">View Cart</a>
                                    <a href="#">Checkout  <i class="fa fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                        </div>
                        <!-- /Cart -->

                        <!-- Account -->
                        <div class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                                <i class="fa fa-user-o"></i>
                                <span>Account</span>
                            </a>
                            <div class="acc-dropdown cart-dropdown" style="width: 100px; height: 100px">

                            </div>
                        </div>
                        <!-- /Account -->

                        <!-- Menu Toogle -->
                        <div class="menu-toggle">
                            <a href="#">
                                <i class="fa fa-bars"></i>
                                <span>Menu</span>
                            </a>
                        </div>
                        <!-- /Menu Toogle -->
                    </div>
                </div>
                <!-- /ACCOUNT -->
            </div>
            <!-- row -->
        </div>
        <!-- container -->
    </div>
    <!-- /MAIN HEADER -->
</header>
<!-- /HEADER -->

<%--ADD SECTION HERE--%>
<div class="section">
    <div class="profile-container">
        <div class="profile-wrapper">
            <!-- Sidebar -->
            <aside class="profile-sidebar">
                <!-- Avatar Section -->
                <div class="profile-avatar-section">
                    <div class="profile-avatar">
                        USER
                    </div>
                    <h2 class="profile-name">Nguyễn Thanh</h2>
                    <p class="profile-email">nguyenthanh@example.com</p>
                    <span class="profile-status">✓ Đã xác thực</span>
                </div>

                <!-- Stats -->
                <div class="profile-stats">
                    <div class="stat-row">
                        <span class="stat-label">📦 Đơn hàng</span>
                        <span class="stat-value">5</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">💰 Đã chi</span>
                        <span class="stat-value">15.5M ₫</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">⭐ Điểm</span>
                        <span class="stat-value">450</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">📅 Tham gia</span>
                        <span class="stat-value" style="font-size: 12px;">Dec 2024</span>
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

                <button class="btn-logout" onclick="alert('Đã đăng xuất')">Đăng xuất</button>
            </aside>

            <!-- Main Content -->
            <main class="profile-content">
                <!-- 1. Thông Tin Cá Nhân -->
                <div class="profile-card" id="personal">
                    <div class="card-header">
                        <h3>Thông Tin Cá Nhân</h3>
                        <button class="btn-edit">Chỉnh sửa</button>
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Tên</label>
                            <p>Thanh</p>
                        </div>
                        <div class="form-group">
                            <label>Họ</label>
                            <p>Nguyễn</p>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <p>nguyenthanh@example.com</p>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <p>0987654321</p>
                        </div>
                        <div class="form-group full">
                            <label>Ngày tham gia</label>
                            <p>20/12/2024 10:30</p>
                        </div>
                    </div>
                </div>

                <!-- 2. Địa Chỉ Giao Hàng -->
                <div class="profile-card" id="address">
                    <div class="card-header">
                        <h3>Địa Chỉ Giao Hàng</h3>
                        <button class="btn-edit">Thay đổi</button>
                    </div>
                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Địa chỉ đầy đủ</label>
                            <p>123 Đường Nguyễn Huệ, Quận 1</p>
                        </div>
                        <div class="form-group">
                            <label>Thành phố</label>
                            <p>TP. Hồ Chí Minh</p>
                        </div>
                        <div class="form-group">
                            <label>Mã bưu chính</label>
                            <p>70000</p>
                        </div>
                        <div class="form-group">
                            <label>Quốc gia</label>
                            <p>Việt Nam</p>
                        </div>
                    </div>
                    <div class="info-box">
                        <p>💡 Địa chỉ này sẽ được sử dụng mặc định cho tất cả đơn hàng của bạn</p>
                    </div>
                </div>

                <!-- 3. Lịch Sử Đơn Hàng -->
                <div class="profile-card" id="orders">
                    <div class="card-header">
                        <h3>Lịch Sử Đơn Hàng</h3>
                        <button class="btn-edit">Xem tất cả</button>
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Đơn hàng #1001</label>
                            <p style="color: #d32f2f; font-weight: 700;">3,500,000 ₫</p>
                            <p class="value-secondary">15/12/2024 - Đã giao</p>
                        </div>
                        <div class="form-group">
                            <label>Đơn hàng #1002</label>
                            <p style="color: #d32f2f; font-weight: 700;">2,100,000 ₫</p>
                            <p class="value-secondary">18/12/2024 - Đang giao</p>
                        </div>
                        <div class="form-group">
                            <label>Đơn hàng #1003</label>
                            <p style="color: #d32f2f; font-weight: 700;">5,900,000 ₫</p>
                            <p class="value-secondary">20/12/2024 - Chờ xác nhận</p>
                        </div>
                    </div>
                </div>

                <!-- 4. Bảo Mật & Đăng Nhập -->
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
                            <button class="btn-edit">Đổi</button>
                        </div>
                        <div class="security-item">
                            <div class="security-item-left">
                                <span class="security-item-label">✉️ Email</span>
                                <span class="security-item-desc">nguyenthanh@example.com</span>
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

                <!-- 5. Cài Đặt -->
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
                            <button class="btn-edit" style="border-color: #ffcdd2; background: #fff5f5; color: #c62828;" onclick="alert('Xóa tài khoản')">Xóa</button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer id="footer" style="margin-top: 30px">
    <!-- top footer -->
    <div class="section">
        <!-- container -->
        <div class="container">
            <!-- row -->
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

                <div class="clearfix visible-xs"></div>

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
            <!-- /row -->
        </div>
        <!-- /container -->
    </div>
    <!-- /top footer -->

    <!-- bottom footer -->
    <div id="bottom-footer" class="section">
        <div class="container">
            <!-- row -->
            <div class="row">
                <div class="col-md-12 text-center">
                    <ul class="footer-payments">
                        <li><a href="#"><i class="fa fa-cc-visa"></i></a></li>
                        <li><a href="#"><i class="fa fa-credit-card"></i></a></li>
                        <li><a href="#"><i class="fa fa-cc-paypal"></i></a></li>
                        <li><a href="#"><i class="fa fa-cc-mastercard"></i></a></li>
                        <li><a href="#"><i class="fa fa-cc-discover"></i></a></li>
                        <li><a href="#"><i class="fa fa-cc-amex"></i></a></li>
                    </ul>
                    <span class="copyright"></span>
                </div>
            </div>
            <!-- /row -->
        </div>
        <!-- /container -->
    </div>
    <!-- /bottom footer -->
</footer>
<!-- /FOOTER -->

<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/js/nouislider.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.zoom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    // Menu active
    document.querySelectorAll('.profile-menu a').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelectorAll('.profile-menu a').forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });
</script>

</body>
</html>
