<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 10/01/2026
  Time: 12:17 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - ElecStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css"/>

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
                            <a data-toggle="dropdown" style="color: white">
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

<!-- ==================== HEADER ==================== -->
<div class="checkout-header">
    <div class="container">
        <a href="${pageContext.request.contextPath}/store" class="btn-back" style="margin-bottom: 20px">
            <i class="fas fa-arrow-left"></i> Quay lại cửa hàng
        </a>
        <h1><i class="fas fa-credit-card"></i> Thanh Toán</h1>
        <div class="breadcrumb-custom">
            <span>Giỏ hàng</span>
            <span><i class="fas fa-chevron-right"></i></span>
            <span class="active">Thanh toán</span>
            <span><i class="fas fa-chevron-right"></i></span>
            <span>Hoàn thành</span>
        </div>
    </div>
</div>

<!-- ==================== MAIN CONTENT ==================== -->
<div class="checkout-container">
    <!-- ==================== LEFT: CART & SHIPPING ==================== -->
    <div>
        <!-- CART ITEMS -->
        <div class="cart-section">
            <h2 class="section-title">
                <i class="fas fa-shopping-bag"></i>
                Đơn hàng của bạn
            </h2>

            <c:if test="${empty cartItems}">
                <div class="empty-cart">
                    <div class="empty-cart-icon"><i class="fas fa-inbox"></i></div>
                    <h3>Giỏ hàng trống</h3>
                    <p>Vui lòng thêm sản phẩm trước khi thanh toán</p>
                    <a href="${pageContext.request.contextPath}/store" class="btn btn-primary">
                        <i class="fas fa-shopping-cart"></i> Tiếp tục mua sắm
                    </a>
                </div>
            </c:if>

            <c:forEach items="${cartItems}" var="item">
                <div class="cart-item">
                    <img src="${item.product.imageUrl}" alt="${item.product.name}" class="item-image">
                    <div class="item-details">
                        <div class="item-name">${item.product.name}</div>
                        <div class="item-meta">
                            <span><strong>Giá:</strong> <fmt:formatNumber value="${item.price}"/> VNĐ</span>
                            <span><strong>Số lượng:</strong> ${item.quantity}</span>
                        </div>
                        <div class="item-price">
                            <fmt:formatNumber value="${item.price * item.quantity}"/> VNĐ
                        </div>
                    </div>
                    <button class="remove-btn" onclick="removeItem(${item.id})">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
            </c:forEach>
        </div>

        <!-- SHIPPING INFO -->
        <c:if test="${not empty cartItems}">
            <div class="shipping-section">
                <h2 class="section-title">
                    <i class="fas fa-map-marker-alt"></i>
                    Thông tin giao hàng
                </h2>

                <form id="shippingForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Họ tên *</label>
                            <input type="text" class="form-control" name="fullName"
                                   value="${user.firstName} ${user.lastName}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại *</label>
                            <input type="tel" class="form-control" name="phone"
                                   value="${user.phone}" pattern="[0-9]{10,11}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email *</label>
                        <input type="email" class="form-control" name="email"
                               value="${user.email}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Địa chỉ *</label>
                        <input type="text" class="form-control" name="address"
                               value="${user.address}" placeholder="Số nhà, đường phố" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Thành phố *</label>
                            <input type="text" class="form-control" name="city"
                                   value="${user.city}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Quốc gia *</label>
                            <input type="text" class="form-control" name="country"
                                   value="${user.country}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ghi chú (tùy chọn)</label>
                        <textarea class="form-control" name="note" rows="3"
                                  placeholder="Ghi chú thêm cho đơn hàng..."></textarea>
                    </div>
                </form>
            </div>
        </c:if>
    </div>

    <!-- ==================== RIGHT: PAYMENT & SUMMARY ==================== -->
    <c:if test="${not empty cartItems}">
        <div class="payment-section">
            <h2 class="section-title">
                <i class="fas fa-credit-card"></i>
                Phương thức thanh toán
            </h2>

            <form id="paymentForm">
                <!-- COD -->
                <label class="payment-method active">
                    <input type="radio" name="paymentMethod" value="cod" checked onchange="updatePaymentMethod('cod')">
                    <div class="payment-icon">
                        <i class="fas fa-money-bill"></i>
                    </div>
                    <div class="payment-info">
                        <div class="payment-name">Thanh toán khi nhận hàng (COD)</div>
                        <div class="payment-desc">Thanh toán trực tiếp với shipper</div>
                    </div>
                </label>

                    <%--                <!-- CREDIT CARD -->--%>
                    <%--                <label class="payment-method">--%>
                    <%--                    <input type="radio" name="paymentMethod" value="card" onchange="updatePaymentMethod('card')">--%>
                    <%--                    <div class="payment-icon">--%>
                    <%--                        <i class="fas fa-credit-card"></i>--%>
                    <%--                    </div>--%>
                    <%--                    <div class="payment-info">--%>
                    <%--                        <div class="payment-name">Thẻ tín dụng / Ghi nợ</div>--%>
                    <%--                        <div class="payment-desc">Visa, Mastercard, JCB</div>--%>
                    <%--                    </div>--%>
                    <%--                </label>--%>

                    <%--                <!-- BANK TRANSFER -->--%>
                    <%--                <label class="payment-method">--%>
                    <%--                    <input type="radio" name="paymentMethod" value="bank" onchange="updatePaymentMethod('bank')">--%>
                    <%--                    <div class="payment-icon">--%>
                    <%--                        <i class="fas fa-university"></i>--%>
                    <%--                    </div>--%>
                    <%--                    <div class="payment-info">--%>
                    <%--                        <div class="payment-name">Chuyển khoản ngân hàng</div>--%>
                    <%--                        <div class="payment-desc">Chuyển khoản trực tiếp</div>--%>
                    <%--                    </div>--%>
                    <%--                </label>--%>

                    <%--                <!-- EWALLET -->--%>
                    <%--                <label class="payment-method">--%>
                    <%--                    <input type="radio" name="paymentMethod" value="ewallet" onchange="updatePaymentMethod('ewallet')">--%>
                    <%--                    <div class="payment-icon">--%>
                    <%--                        <i class="fas fa-mobile-alt"></i>--%>
                    <%--                    </div>--%>
                    <%--                    <div class="payment-info">--%>
                    <%--                        <div class="payment-name">Ví điện tử</div>--%>
                    <%--                        <div class="payment-desc">Momo, Zalopay, VCBPay</div>--%>
                    <%--                    </div>--%>
                    <%--                </label>--%>
            </form>

            <!-- ORDER SUMMARY -->
            <div class="order-summary">
                <div class="summary-row label">
                    <span>Tạm tính:</span>
                    <span><fmt:formatNumber value="${subtotal}"/> VNĐ</span>
                </div>
                <div class="summary-row label">
                    <span>Phí vận chuyển:</span>
                    <span id="shippingFee">+30,000 VNĐ</span>
                </div>
                <div class="summary-row label">
                    <span>Giảm giá:</span>
                    <span id="discount">-0 VNĐ</span>
                </div>
                <div class="summary-row total">
                    <span>Tổng cộng:</span>
                    <span id="totalPrice">
                            <fmt:formatNumber value="${subtotal + 30000}"/> VNĐ
                        </span>
                </div>
            </div>

            <button class="btn-checkout" onclick="submitOrder()">
                <i class="fas fa-check-circle"></i> Đặt hàng ngay
            </button>
            <button class="verify-key-btn" onclick="openVerifyKeyModal()" style="
                        width: 100%;
                        padding: 12px;
                        margin-top: 10px;
                        background-color: #28a745;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: background 0.3s;
">
                <i class="fa fa-shield-alt"></i> Xác Thực
            </button>
            <button class="generate-key-btn" onclick="openKeyModal()" style="
                        width: 100%;
                        padding: 12px;
                        margin-top: 10px;
                        background-color: #1565c0;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: background 0.3s;
                    ">
                <i class="fa fa-key"></i> Tạo khóa xác thực
            </button>
            <button class="download-order-btn" onclick="downloadOrderDocument()" style="
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            background-color: #17a2b8; /* Màu xanh cyan biệt lập */
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
">
                <i class="fa fa-download"></i> Tải file đơn hàng (document.txt)
            </button>
        </div>
    </c:if>
</div>

<!-- Modal Tạo Khóa Xác Thực -->
<div id="keyModal" style="
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 9999;
    justify-content: center;
    align-items: center;
">
    <div style="
        background: white;
        border-radius: 10px;
        padding: 30px;
        width: 440px;
        max-width: 90%;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        text-align: center;
    ">

        <!-- ===== BƯỚC 1: Xác nhận ===== -->
        <div id="stepConfirm">
            <div style="margin-bottom:15px;">
                <i class="fa fa-key" style="font-size:48px;color:#1565c0;"></i>
            </div>

            <h3>Tạo khóa RSA</h3>

            <p style="margin-bottom:20px;">
                Chọn kích thước khóa RSA muốn tạo
            </p>

            <div style="text-align:left;margin-bottom:20px;">
                <label style="display:block;padding:8px 0;">
                    <input type="radio" name="keySize" value="1024">
                    RSA 1024 bit
                </label>

                <label style="display:block;padding:8px 0;">
                    <input type="radio" name="keySize" value="2048" checked>
                    RSA 2048 bit (Khuyến nghị)
                </label>

                <label style="display:block;padding:8px 0;">
                    <input type="radio" name="keySize" value="3072">
                    RSA 3072 bit
                </label>

                <label style="display:block;padding:8px 0;">
                    <input type="radio" name="keySize" value="4096">
                    RSA 4096 bit
                </label>
            </div>

            <div style="display:flex;gap:10px;justify-content:center;">
                <button onclick="closeKeyModal()">
                    Hủy
                </button>

                <button onclick="generateRSAKey()">
                    Tạo khóa
                </button>
            </div>
        </div>

        <!-- ===== BƯỚC 2: Thành công + Khóa ===== -->
        <div id="stepSuccess" style="display:none;">

            <div class="success-icon">
                <i class="fa fa-check-circle"></i>
            </div>

            <h3>Tạo khóa RSA thành công</h3>

            <p>
                Hãy tải và lưu trữ Private Key cẩn thận trước khi sử dụng.
            </p>

            <div class="key-section">

                <label>
                    <strong>Public Key</strong>
                </label>

                <textarea
                        id="publicKeyDisplay"
                        readonly>
        </textarea>

            </div>

            <div class="key-section">

                <label>
                    <strong>Private Key</strong>
                </label>

                <textarea
                        id="privateKeyDisplay"
                        readonly>
        </textarea>

            </div>

            <div class="button-group">

                <button onclick="downloadPublicKey()">
                    Tải Public Key
                </button>

                <button onclick="downloadPrivateKey()">
                    Tải Private Key
                </button>

            </div>

            <div class="button-group">

                <button class="btn-success"
                        onclick="useKey()">
                    Sử dụng khóa
                </button>

                <button class="btn-danger"
                        onclick="cancelKey()">
                    Hủy khóa
                </button>

            </div>

            <div class="warning-box">
                Private Key không được lưu trên hệ thống.
                Nếu mất Private Key bạn phải tạo khóa mới.
            </div>

        </div>

    </div>
</div>


<!-- Modal Xác Thực Chữ Ký -->
<div id="verifyKeyModal" style="
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 9999;
    justify-content: center;
    align-items: center;
">
    <div style="
        background: white;
        border-radius: 10px;
        padding: 30px;
        width: 500px;
        max-width: 95%;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    ">
        <h3 style="text-align: center; margin-bottom: 20px;">Xác Thực Chữ Ký Số</h3>

        <div id="verifyAutoInfo" style="
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 4px;
            background: #e9ecef;
            font-size: 13px;
            color: #495057;
        ">
            <i class="fa fa-database"></i>
            File đơn hàng (document.txt) và Public Key sẽ được hệ thống tự động lấy từ dữ liệu giỏ hàng và khóa RSA của bạn trong cơ sở dữ liệu.
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">Chữ ký số (signature.sig):</label>
            <input type="file" id="signatureFile" class="form-control" accept=".sig">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">Mã băm (SHA-256):</label>
            <textarea id="hashDisplay" readonly style="
                width: 100%;
                height: 60px;
                background: #f8f9fa;
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 10px;
                font-family: monospace;
                font-size: 12px;
                resize: none;
            " placeholder="Giá trị hash sẽ hiển thị ở đây..."></textarea>
        </div>

        <div id="verificationResult" style="
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 4px;
            display: none;
            text-align: center;
            font-weight: bold;
        "></div>

        <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;">
            <button onclick="verifyDigitalSignature()" style="
                background-color: #28a745;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
            ">
                <i class="fa fa-check-circle"></i> Xác thực chữ ký
            </button>

            <button onclick="closeVerifyKeyModal()" style="
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
            ">
                Đóng
            </button>
        </div>
    </div>
</div>

<!-- Toast Message -->
<div id="toastMessage" class="toast-message"></div>


<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%--<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>--%>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    const cartItems = [
        <c:forEach items="${cartItems}" var="item" varStatus="status">
        {
            id: "${item.id}",
            productName: "${item.product.name}",
            quantity: ${item.quantity},
            price: ${item.price},
            total: ${item.price * item.quantity}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const subtotal = ${subtotal};
</script>

<script>
    let isVerified = false;
    let savedSignatureBase64 = "";
    let savedDocumentHash = "";

    function updatePaymentMethod(method) {
        console.log('Selected payment method:', method);
        // Có thể thêm logic để hiển thị form chi tiết thanh toán
    }

    // --- Verification Logic ---

    let verificationDocumentContent = null; // Nội dung document.txt lấy từ server (DB)
    let verificationPublicKey = null;        // Public key (Base64) lấy từ bảng rsa_keys

    function openVerifyKeyModal() {
        document.getElementById('verifyKeyModal').style.display = 'flex';
        document.getElementById('hashDisplay').value = '';
        document.getElementById('verificationResult').style.display = 'none';
        document.getElementById('signatureFile').value = '';
        isVerified = false;
        verificationDocumentContent = null;
        verificationPublicKey = null;

        loadVerificationData();
    }

    // Lấy nội dung đơn hàng (từ giỏ hàng trong DB) + public key (từ bảng rsa_keys) từ server
    function loadVerificationData() {
        const infoBox = document.getElementById('verifyAutoInfo');
        infoBox.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang lấy dữ liệu đơn hàng và Public Key từ hệ thống...';

        $.ajax({
            url: '${pageContext.request.contextPath}/get-verification-data',
            type: 'GET',
            dataType: 'json',
            success: async function(response) {
                if (!response.success) {
                    infoBox.innerHTML = '<i class="fa fa-exclamation-triangle"></i> ' + (response.message || 'Không thể lấy dữ liệu xác thực');
                    showToast(response.message || 'Không thể lấy dữ liệu xác thực', true);
                    return;
                }

                verificationDocumentContent = response.documentContent;
                verificationPublicKey = response.publicKey;

                infoBox.innerHTML = '<i class="fa fa-check-circle" style="color:#28a745"></i> Đã lấy dữ liệu đơn hàng và Public Key (RSA ' + response.keySize + ' bit) từ hệ thống.';

                // Tự động băm dữ liệu ngay khi lấy được nội dung đơn hàng
                await processHash();
            },
            error: function() {
                infoBox.innerHTML = '<i class="fa fa-exclamation-triangle"></i> Lỗi khi lấy dữ liệu xác thực từ server';
                showToast('Lỗi khi lấy dữ liệu xác thực từ server', true);
            }
        });
    }

    function closeVerifyKeyModal() {
        document.getElementById('verifyKeyModal').style.display = 'none';
    }

    // Hàm đọc nội dung file
    async function readFileAsText(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = (e) => resolve(e.target.result);
            reader.onerror = (e) => reject(e);
            reader.readAsText(file);
        });
    }

    // Hàm đọc nội dung file dưới dạng ArrayBuffer (cho chữ ký hoặc dữ liệu nhị phân)
    async function readFileAsArrayBuffer(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = (e) => resolve(e.target.result);
            reader.onerror = (e) => reject(e);
            reader.readAsArrayBuffer(file);
        });
    }

    // Hàm băm dữ liệu SHA-256 (dùng nội dung document lấy từ server/DB)
    async function processHash() {
        if (!verificationDocumentContent) {
            showToast('Chưa có dữ liệu đơn hàng để băm', true);
            return;
        }

        try {
            const msgBuffer = new TextEncoder().encode(verificationDocumentContent);
            const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
            const hashArray = Array.from(new Uint8Array(hashBuffer));
            const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');

            document.getElementById('hashDisplay').value = hashHex;
        } catch (err) {
            showToast('Lỗi khi băm dữ liệu', true);
        }
    }

    function pemToArrayBuffer(pem) {
        const lines = pem.split('\n');
        let b64 = "";
        for (let line of lines) {
            if (!line.includes("-----") && line.trim() !== "") {
                b64 += line.trim();
            }
        }
        const binaryStr = window.atob(b64);
        const len = binaryStr.length;
        const bytes = new Uint8Array(len);
        for (let i = 0; i < len; i++) {
            bytes[i] = binaryStr.charCodeAt(i);
        }
        return bytes.buffer;
    }


    function strToBuffer(str) {
        const buf = new ArrayBuffer(str.length);
        const bufView = new Uint8Array(buf);
        for (let i = 0; i < str.length; i++) {
            bufView[i] = str.charCodeAt(i);
        }
        return buf;
    }

    // Hàm xác thực chữ ký
    async function verifyDigitalSignature() {
        const sigFile = document.getElementById('signatureFile').files[0];
        const hashVal = document.getElementById('hashDisplay').value;

        if (!verificationDocumentContent || !verificationPublicKey) {
            showToast('Chưa lấy được dữ liệu đơn hàng / Public Key từ hệ thống. Vui lòng thử lại.', true);
            return;
        }
        if (!sigFile) {
            showToast('Vui lòng tải lên file chữ ký (.sig)', true);
            return;
        }
        if (!hashVal) {
            showToast('Đang xử lý dữ liệu, vui lòng thử lại sau giây lát', true);
            return;
        }

        try {
            const sigBuffer = await readFileAsArrayBuffer(sigFile);

            const resultDiv = document.getElementById('verificationResult');
            resultDiv.style.display = 'none';

            let sigRaw;
            // Chuyển sigBuffer sang chuỗi để kiểm tra định dạng (Hex hoặc Base64)
            const decoder = new TextDecoder();
            const sigString = decoder.decode(sigBuffer).trim().replace(/\s/g, '');

            // 1. Kiểm tra nếu là Hex
            if (/^[0-9a-fA-F]+$/.test(sigString) && sigString.length % 2 === 0) {
                const bytes = new Uint8Array(sigString.length / 2);
                for (let i = 0; i < sigString.length; i += 2) {
                    bytes[i / 2] = parseInt(sigString.substring(i, i + 2), 16);
                }
                sigRaw = bytes.buffer;
            }
            // 2. Kiểm tra nếu là Base64
            else if (/^[A-Za-z0-9+/=]+$/.test(sigString)) {
                try {
                    const binaryStr = window.atob(sigString);
                    const bytes = new Uint8Array(binaryStr.length);
                    for (let i = 0; i < binaryStr.length; i++) {
                        bytes[i] = binaryStr.charCodeAt(i);
                    }
                    sigRaw = bytes.buffer;
                } catch (e) { sigRaw = sigBuffer; }
            } else {
                sigRaw = sigBuffer;
            }

            // 1. Import Public Key (lấy từ bảng rsa_keys qua server, dạng Base64 thuần)
            const binaryDer = pemToArrayBuffer(verificationPublicKey);
            const publicKey = await window.crypto.subtle.importKey(
                "spki",
                binaryDer,
                {
                    name: "RSASSA-PKCS1-v1_5",
                    hash: "SHA-256",
                },
                false,
                ["verify"]
            );


            const dataToVerify = new TextEncoder().encode(hashVal);

            const isValid = await window.crypto.subtle.verify(
                "RSASSA-PKCS1-v1_5",
                publicKey,
                sigRaw,
                dataToVerify
            );

            // 3. Hiển thị kết quả
            resultDiv.style.display = 'block';
            if (isValid) {
                isVerified = true;
                savedSignatureBase64 = sigString;
                savedDocumentHash = hashVal;
                resultDiv.style.backgroundColor = '#d4edda';
                resultDiv.style.color = '#155724';
                resultDiv.innerHTML = '<i class="fa fa-check"></i> Chữ ký hợp lệ! Tài liệu toàn vẹn.';
                showToast('Xác thực thành công');

                // Tùy chọn: Tự động đóng modal sau 1.5 giây để người dùng tiện bấm đặt hàng
                setTimeout(closeVerifyKeyModal, 1500);
            } else {
                isVerified = false; // <--- Xác thực thất bại
                resultDiv.style.backgroundColor = '#f8d7da';
                resultDiv.style.color = '#721c24';
                resultDiv.innerHTML = '<i class="fa fa-times"></i> Chữ ký không hợp lệ hoặc tài liệu đã bị chỉnh sửa!';
                showToast('Xác thực thất bại', true);
            }

        } catch (err) {
            console.error(err);
            showToast('Lỗi: File chữ ký không đúng định dạng hoặc Public Key không hợp lệ', true);
            const resultDiv = document.getElementById('verificationResult');
            resultDiv.style.display = 'block';
            resultDiv.style.backgroundColor = '#fff3cd';
            resultDiv.innerHTML = 'Lỗi xử lý file (Kiểm tra định dạng file chữ ký .sig)';
        }
    }

    // Đóng modal khi click ra ngoài (cập nhật cho cả 2 modal)
    window.onclick = function(event) {
        const keyModal = document.getElementById('keyModal');
        const verifyModal = document.getElementById('verifyKeyModal');
        if (event.target === keyModal) closeKeyModal();
        if (event.target === verifyModal) closeVerifyKeyModal();
    }

    function removeItem(cartItemId) {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/remove-from-cart',
                method: 'POST',
                data: { cartItemId: cartItemId },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        location.reload(); // Reload page
                    } else {
                        showToast(response.message, true);
                    }
                },
                error: function() {
                    showToast('Lỗi xóa sản phẩm', true);
                }
            });
        }
    }


    function submitOrder() {
        if (!isVerified) {
            alert('⚠️ Bạn chưa xác thực chữ ký số! Vui lòng bấm vào nút "Xác Thực" và tải các file liên quan trước khi đặt hàng.');
            openVerifyKeyModal(); // Tự động mở luôn modal xác thực cho người dùng
            return;
        }
        const fullName = $('input[name="fullName"]').val();
        const phone = $('input[name="phone"]').val();
        const email = $('input[name="email"]').val();
        const address = $('input[name="address"]').val();
        const city = $('input[name="city"]').val();
        const country = $('input[name="country"]').val();
        const paymentMethod = $('input[name="paymentMethod"]:checked').val();
        const note = $('textarea[name="note"]').val();

        if (!fullName || !phone || !email || !address || !city || !country) {
            alert('Vui lòng điền đầy đủ thông tin giao hàng!');
            return;
        }

        $.post('${pageContext.request.contextPath}/checkout/create-order', {
            fullName: fullName,
            phone: phone,
            email: email,
            address: address,
            city: city,
            country: country,
            paymentMethod: paymentMethod,
            note: note,
            signature: savedSignatureBase64,
            documentHash: savedDocumentHash
        }, function(response) {
            if (response.success) {
                alert('✅ Đặt hàng thành công!');
                window.location.href = '${pageContext.request.contextPath}/order-history';
            } else {
                alert('❌ ' + response.message);
            }
        }, 'json');
    }
    function downloadOrderDocument() {

        const fullName = $('input[name="fullName"]').val();
        const phone = $('input[name="phone"]').val();
        const email = $('input[name="email"]').val();
        const address = $('input[name="address"]').val();
        const city = $('input[name="city"]').val();
        const country = $('input[name="country"]').val();
        const paymentMethod = $('input[name="paymentMethod"]:checked').val();
        const note = $('textarea[name="note"]').val();

        let content = "";

        content += "========== DON HANG ==========\n\n";

        content += "===== THONG TIN GIAO HANG =====\n";
        content += "Ho ten: " + fullName + "\n";
        content += "So dien thoai: " + phone + "\n";
        content += "Email: " + email + "\n";
        content += "Dia chi: " + address + "\n";
        content += "Thanh pho: " + city + "\n";
        content += "Quoc gia: " + country + "\n";
        content += "Thanh toan: " + paymentMethod + "\n";
        content += "Ghi chu: " + note + "\n\n";

        content += "===== SAN PHAM =====\n";

        cartItems.forEach(function(item, index){

            content += "San pham " + (index + 1) + "\n";
            content += "Ten: " + item.productName + "\n";
            content += "So luong: " + item.quantity + "\n";
            content += "Don gia: " + item.price + " VND\n";
            content += "Thanh tien: " + item.total + " VND\n";
            content += "--------------------------\n";

        });

        content += "\n===== TONG TIEN =====\n";
        content += "Tam tinh: " + subtotal + " VND\n";
        content += "Phi van chuyen: 30000 VND\n";
        content += "Tong thanh toan: " + (subtotal + 30000) + " VND\n";

        const blob = new Blob([content], {type:"text/plain;charset=utf-8"});

        const link = document.createElement("a");

        link.href = URL.createObjectURL(blob);

        link.download = "document.txt";

        document.body.appendChild(link);

        link.click();

        document.body.removeChild(link);

        URL.revokeObjectURL(link.href);

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

    // Mở modal - reset về bước 1
    function openKeyModal() {

        $.ajax({

            url:
                '${pageContext.request.contextPath}/check-rsa-key',

            type: 'GET',

            dataType: 'json',

            success: function(response) {

                if(response.hasKey){

                    showToast(
                        'Bạn đã tạo khóa RSA trước đó',
                        true
                    );

                    return;
                }

                document.getElementById(
                    'keyModal'
                ).style.display =
                    'flex';
            },

            error: function() {

                showToast(
                    'Không thể kiểm tra khóa RSA',
                    true
                );
            }
        });
    }

    // Đóng modal
    function closeKeyModal() {
        document.getElementById('keyModal').style.display = 'none';
    }

    // Tạo khóa RSA
    function generateRSAKey() {

        const keySize =
            document.querySelector(
                'input[name="keySize"]:checked'
            ).value;

        $.ajax({
            url: '${pageContext.request.contextPath}/generate-rsa-key',
            type: 'POST',
            data: {
                keySize: keySize
            },

            success: function(response) {

                generatedPublicKey = response.publicKey;
                generatedPrivateKey = response.privateKey;

                selectedKeySize =
                    document.querySelector(
                        'input[name="keySize"]:checked'
                    ).value;

                document.getElementById(
                    "publicKeyDisplay"
                ).value = generatedPublicKey;

                document.getElementById(
                    "privateKeyDisplay"
                ).value = generatedPrivateKey;

                document.getElementById(
                    'stepConfirm'
                ).style.display = 'none';

                document.getElementById(
                    'stepSuccess'
                ).style.display = 'block';
            },

            error: function() {
                showToast(
                    'Tạo khóa RSA thất bại',
                    true
                );
            }
        });
    }

    // Tải public key
    function downloadPublicKey() {

        const content =
            document.getElementById(
                "publicKeyDisplay"
            ).value;

        const blob =
            new Blob(
                [content],
                {type:"text/plain"}
            );

        const link =
            document.createElement("a");

        link.href =
            URL.createObjectURL(blob);

        link.download =
            "public-key.pem";

        link.click();
    }

    //Tải private key
    function downloadPrivateKey() {

        const content =
            document.getElementById(
                "privateKeyDisplay"
            ).value;

        const blob =
            new Blob(
                [content],
                {type:"text/plain"}
            );

        const link =
            document.createElement("a");

        link.href =
            URL.createObjectURL(blob);

        link.download =
            "private-key.pem";

        link.click();
    }

    //Xác nhận sử dụng key
    function useKey() {

        if (!generatedPublicKey) {
            showToast(
                "Không tìm thấy khóa",
                true
            );
            return;
        }

        $.ajax({

            url:
                '${pageContext.request.contextPath}/save-rsa-key',

            type: 'POST',

            data: {

                publicKey:
                generatedPublicKey,

                keySize:
                selectedKeySize
            },

            dataType: 'json',

            success: function(response) {

                if(response.success){

                    showToast(
                        "Khóa đã được lưu thành công"
                    );

                    closeKeyModal();

                }else{

                    showToast(
                        "Lưu khóa thất bại",
                        true
                    );
                }
            },

            error: function() {

                showToast(
                    "Lỗi khi lưu khóa",
                    true
                );
            }
        });
    }

    //Hủy xác nhận key
    function cancelKey() {

        if(
            !confirm(
                "Bạn có chắc muốn hủy khóa này?"
            )
        ){
            return;
        }

        generatedPublicKey = "";
        generatedPrivateKey = "";

        document.getElementById(
            "publicKeyDisplay"
        ).value = "";

        document.getElementById(
            "privateKeyDisplay"
        ).value = "";

        document.getElementById(
            "stepSuccess"
        ).style.display = "none";

        document.getElementById(
            "stepConfirm"
        ).style.display = "block";

        showToast(
            "Đã hủy khóa"
        );
    }

    // Sao chép khóa vào clipboard
    function copyKey() {
        const key = document.getElementById('generatedKey').textContent;
        navigator.clipboard.writeText(key).then(() => {
            showToast('Đã sao chép khóa!');
        });
    }

    // Xác nhận lưu và đóng modal
    function saveAndClose() {
        closeKeyModal();
        showToast('Khóa xác thực đã được lưu thành công!');
    }

    // Toast notification
    function showToast(message, isError = false) {
        const toast = document.getElementById('toastMessage');
        toast.textContent = message;
        if (isError) {
            toast.classList.add('error');
        } else {
            toast.classList.remove('error');
        }
        toast.style.display = 'block';
        setTimeout(() => {
            toast.style.display = 'none';
        }, 3000);
    }

</script>
</body>
</html>