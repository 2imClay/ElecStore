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

    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>


</head>
<body>
<!-- HEADER -->
<header>
    <div id="header">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="header-logo">
                        <a href="${pageContext.request.contextPath}/home" class="logo">
                            <img src="${pageContext.request.contextPath}/images/logo.png" alt="">
                        </a>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="header-search">
                        <form id="searchForm" method="get" action="${pageContext.request.contextPath}/store" style="display: flex":>
                            <div style="position: relative; flex: 1; width: 100%">
                                <input class="input" id="searchInput" name="keyword"
                                       placeholder="Nhập từ khóa để tìm sản phẩm"
                                       autocomplete="off"
                                       style="width: 100%; border-radius: 40px 0 0 40px;"
                                >
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

                <div class="col-md-3 clearfix" style="display: flex">
                    <div class="header-ctn" style="display: flex">
                        <div>
                            <a href="#">
                                <i class="fa fa-heart-o"></i>
                                <span>Yêu thích</span>
                            </a>
                        </div>

                        <div class="dropdown">
                            <a href="${pageContext.request.contextPath}/cart" class="dropdown-toggle">
                                <i class="fa fa-shopping-cart"></i>
                                <span>Giỏ hàng</span>
                            </a>
                        </div>

                        <div class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" aria-expanded="true">
                                <i class="fa fa-user-o"></i>
                                <span>Account</span>
                            </a>
                            <div class="acc-dropdown cart-dropdown" style="width: 200%; display: flex; flex-direction: column">
                                <c:if test="${not empty sessionScope.user}">
                                    <button style="background-color: transparent; width: 100%; border: none; border-bottom: 1px solid black; padding-bottom: 10px">
                                        <a href="${pageContext.request.contextPath}/user-information">${sessionScope.userName}</a>
                                        <small style="color: orangered;">${sessionScope.userEmail}</small>
                                    </button>
                                    <button style="background-color: transparent; width: 100%; border: none; padding: 10px 0 10px 0">
                                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                    </button>
                                </c:if>
                                <c:if test="${empty sessionScope.user}">
                                    <button style="background-color: transparent; width: 100%; border: none;">
                                        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
<!-- /HEADER -->

<!-- NAVIGATION -->
<nav id="navigation">
    <!-- container -->
    <div class="container">
        <!-- responsive-nav -->
        <div id="responsive-nav">
            <!-- NAV -->
            <ul class="main-nav nav navbar-nav">
                <li class="active"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/store">Cửa hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
            </ul>
            <!-- /NAV -->
        </div>
        <!-- /responsive-nav -->
    </div>
    <!-- /container -->
</nav>
<!-- /NAVIGATION -->

<%--ADD SECTION HERE--%>

<!-- FOOTER (từ index) -->
<footer id="footer" style="margin-top: 50px">
    <div class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Về chúng tôi</h3>
                        <p>ElecStore - Cửa hàng điện tử trực tuyến hàng đầu với đa dạng sản phẩm chất lượng cao.</p>
                        <ul class="footer-links">
                            <li><a href="#"><i class="fa fa-map-marker"></i>TP. Hồ Chí Minh, VN</a></li>
                            <li><a href="#"><i class="fa fa-phone"></i>+84-28-XXXX-XXXX</a></li>
                            <li><a href="#"><i class="fa fa-envelope-o"></i>support@elecstore.com</a></li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Danh mục</h3>
                        <ul class="footer-links">
                            <li><a href="#">Khuyến mãi</a></li>
                            <li><a href="#">Laptop</a></li>
                            <li><a href="#">Điện thoại</a></li>
                            <li><a href="#">Camera</a></li>
                            <li><a href="#">Phụ kiện</a></li>
                        </ul>
                    </div>
                </div>

                <div class="clearfix visible-xs"></div>

                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Thông tin</h3>
                        <ul class="footer-links">
                            <li><a href="#">Về chúng tôi</a></li>
                            <li><a href="#">Liên hệ</a></li>
                            <li><a href="#">Chính sách bảo mật</a></li>
                            <li><a href="#">Điều khoản sử dụng</a></li>
                            <li><a href="#">Hoàn trả hàng</a></li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-3 col-xs-6">
                    <div class="footer">
                        <h3 class="footer-title">Dịch vụ</h3>
                        <ul class="footer-links">
                            <li><a href="#">Tài khoản của tôi</a></li>
                            <li><a href="#">Xem giỏ hàng</a></li>
                            <li><a href="#">Danh sách yêu thích</a></li>
                            <li><a href="#">Theo dõi đơn hàng</a></li>
                            <li><a href="#">Trợ giúp</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="bottom-footer" class="section">
        <div class="container">
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
                    <span class="copyright">&copy; 2025 ElecStore. All Rights Reserved.</span>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/js/nouislider.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.zoom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

</body>
</html>
