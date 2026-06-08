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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Bootstrap -->
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>--%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
<!-- HEADER from index-->
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
                            <a href="${pageContext.request.contextPath}/favourite">
                                <i class="fa fa-heart-o"></i>
                                <span>Yêu thích</span>
                            </a>
                        </div>

                        <div class="dropdown">
                            <a href="${pageContext.request.contextPath}/cart" >
                                <i class="fa fa-shopping-cart"></i>
                                <span>Giỏ hàng</span>
                            </a>
                        </div>

                        <div class="dropdown">
                            <a data-toggle="dropdown" data-toggle="dropdown" style="color: white">
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
                            <span class="stat-value"><fmt:formatNumber value="${totalSpent}"/> VNĐ</span>
                        </div>
                        <div class="stat-row">
                            <span class="stat-label">⭐ Điểm</span>
                            <span class="stat-value"><fmt:formatNumber value="${points}"/></span>
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
<%--                            <button class="btn-edit" onclick="editPersonal()">Chỉnh sửa</button>--%>
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
<%--                            <button class="btn-edit" onclick="editAddress()">Thay đổi</button>--%>
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
                            <a href="${pageContext.request.contextPath}/order-history" class="btn-edit" style="cursor: pointer;">Xem tất cả</a>
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Bạn có ${orderCount} đơn hàng</label>
                                <p><a href="${pageContext.request.contextPath}/store">Mua sắm ngay</a></p>
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
                                <button class="btn-edit" data-bs-toggle="modal"
                                        data-bs-target="#changePasswordModal"
                                        >
                                    Đổi
                                </button>

                                <!-- Modal Form -->
                                <div class="modal fade" id="changePasswordModal" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow-lg">
                                            <div class="modal-header bg-gradient text-white border-0">
                                                <h5 class="modal-title">
                                                    <i class="fas fa-lock"></i> Đổi Mật Khẩu
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body p-4">
                                                <form id="changePasswordForm">
                                                    <div class="mb-3">
                                                        <label class="form-label">Mật khẩu cũ *</label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control" id="oldPassword"
                                                                   placeholder="Nhập mật khẩu cũ" required>
                                                            <button class="btn btn-outline-secondary toggle-password" type="button"
                                                                    data-bs-target="#oldPassword">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Mật khẩu mới *</label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control" id="newPassword"
                                                                   placeholder="Nhập mật khẩu mới (min 6 ký tự)" required>
                                                            <button class="btn btn-outline-secondary toggle-password" type="button"
                                                                    data-bs-target="#newPassword">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </div>
                                                        <small class="text-muted">Mật khẩu phải từ 6 ký tự trở lên</small>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Xác nhận mật khẩu *</label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control" id="confirmPassword"
                                                                   placeholder="Nhập lại mật khẩu mới" required>
                                                            <button class="btn btn-outline-secondary toggle-password" type="button"
                                                                    data-bs-target="#confirmPassword">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer border-0 bg-light">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-primary" onclick="submitChangePassword()">
                                                    <i class="fas fa-check"></i> Đổi Mật Khẩu
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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


<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    $(document).ready(function() {
        // Menu navigation
        $('.profile-menu a').click(function(e) {
            e.preventDefault();
            $('.profile-menu a').removeClass('active');
            $(this).addClass('active');
        });

        // Toggle password visibility
        $(document).on('click', '.toggle-password', function() {
            var input = $($(this).data('bs-target'));
            input.attr('type', input.attr('type') === 'password' ? 'text' : 'password');
        });
    });

    // ✅ Submit Change Password
    function submitChangePassword() {
        const oldPassword = $('#oldPassword').val();
        const newPassword = $('#newPassword').val();
        const confirmPassword = $('#confirmPassword').val();

        if (!oldPassword || !newPassword || !confirmPassword) {
            alert('❌ Vui lòng điền đầy đủ thông tin!');
            return;
        }

        if (newPassword.length < 6) {
            alert('❌ Mật khẩu mới phải từ 6 ký tự!');
            return;
        }

        if (newPassword !== confirmPassword) {
            alert('❌ Mật khẩu xác nhận không khớp!');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/change-password',
            method: 'POST',
            dataType: 'json',
            data: {
                oldPassword: oldPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            },
            success: function(response) {
                if (response.success) {
                    alert('✅ ' + response.message);
                    $('#changePasswordModal').modal('hide');
                    $('#changePasswordForm')[0].reset();
                } else {
                    alert('❌ ' + response.message);
                }
            },
            error: function(xhr, status, error) {
                alert('❌ Lỗi kết nối: ' + error);
            }
        });
    }

    $(document).ready(function() {
        // AJAX gợi ý tìm kiếm
        $('#searchInput').on('keyup', function() {
            let keyword = $(this).val().trim();
            let dropdown = $('#suggestDropdown');

            if (keyword.length < 2) {
                dropdown.hide();
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/search',
                method: 'GET',
                data: { keyword: keyword },
                dataType: 'json',
                success: function(data) {
                    dropdown.empty();

                    if (data.length === 0) {
                        dropdown.html('<div style="padding: 10px; color: #999;">No results</div>');
                        dropdown.show();
                        return;
                    }

                    data.forEach(function(product) {
                        let html = `
                        <a href="${pageContext.request.contextPath}/product-detail?id=` + product.id + `"
                           style="
                               display: block;
                               padding: 10px 15px;
                               color: #333;
                               text-decoration: none;
                               border-bottom: 1px solid #eee;
                           "
                           onmouseover="this.style.backgroundColor='#f5f5f5'"
                           onmouseout="this.style.backgroundColor='white'"
                        >
                            <strong>` + product.name + `</strong>
                            <br>
                            <small style="color: #999;">` + product.price + `</small>
                        </a>
                    `;
                        dropdown.append(html);
                    });

                    dropdown.show();
                }
            });
        });

        // Đóng dropdown khi click bên ngoài
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.header-search').length) {
                $('#suggestDropdown').hide();
            }
        });

        // Đóng dropdown khi submit form
        $('#searchForm').on('submit', function() {
            $('#suggestDropdown').hide();
        });
    });

</script>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

</body>
</html>
