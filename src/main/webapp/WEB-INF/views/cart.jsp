<%--
  Shopping Cart Page - ElecStore
  User: Dell
  Date: 24/12/2025
  Reusing header and footer from index.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Giỏ Hàng - ElecStore</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <!-- Custom stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

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
    <div class="container">
        <div id="responsive-nav">
            <ul class="main-nav nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/store">Cửa hàng</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- CART SECTION -->
<div class="cart-section">
    <div class="container">
        <div class="row">
            <!-- Cart Table -->
            <div class="col-md-8">
                <c:if test="${empty cartItems}">
                    <div class="empty-cart">
                        <i class="fa fa-shopping-cart"></i>
                        <h2>Giỏ hàng của bạn trống</h2>
                        <p>Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm</p>
                        <a href="${pageContext.request.contextPath}/store">Tiếp tục mua sắm</a>
                    </div>
                </c:if>

                <c:if test="${not empty cartItems}">
                    <div class="cart-table">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th style="width: 40%;">Sản phẩm</th>
                                <th style="width: 15%;">Giá</th>
                                <th style="width: 20%;">Số lượng</th>
                                <th style="width: 15%;">Tổng</th>
                                <th style="width: 10%;">Xóa</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${cartItems}" var="item">
                                <c:set var="itemTotal" value="${item.price * item.quantity}"/>
                                <tr>
                                    <td>
                                        <div class="product-info">
                                            <img src="${item.product.imageUrl}" alt="product" class="product-img">
                                            <div>
                                                <p class="product-name">
                                                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}">
                                                            ${item.product.name}
                                                    </a>
                                                </p>
                                                <small style="color: #999;">SKU: ${item.product.id}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="price-col"><fmt:formatNumber value="${item.price}"/> VNĐ</td>
                                    <td>
                                        <div class="quantity-control">
                                            <button type="button" onclick="decreaseQty(${item.id}, ${item.quantity})">-</button>
                                            <input type="text" value="${item.quantity}" readonly>
                                            <button type="button" onclick="increaseQty(${item.id}, ${item.quantity})">+</button>
                                        </div>
                                    </td>
                                    <td class="price-col"><fmt:formatNumber value="${itemTotal}"/> VNĐ</td>
                                    <td>
                                        <button class="remove-btn" onclick="removeItem(${item.id})">
                                            <i class="fa fa-trash-o"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>

            <!-- Cart Summary -->
            <div class="col-md-4">
                <!-- Promo Code -->
                <div class="promo-section">
                    <label for="promoCode">Mã khuyến mãi</label>
                    <div class="promo-input-group">
                        <input type="text" id="promoCode" placeholder="Nhập mã khuyến mãi...">
                        <button type="button" onclick="applyPromo()">Áp dụng</button>
                    </div>
                </div>

                <!-- Summary -->
                <div class="cart-summary">
                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span id="subtotal"><fmt:formatNumber value="${subtotal}"/> VNĐ</span>
                    </div>

                    <%--                    <div class="summary-row">--%>
                    <%--                        <span>Giảm giá:</span>--%>
                    <%--                        <span id="discount" style="color: #27ae60;"><fmt:formatNumber value="${discount}"/> VNĐ</span>--%>
                    <%--                    </div>--%>

                    <div class="summary-row">
                        <span>Giảm giá:</span>
                        <span id="discount" style="color: #27ae60;"><fmt:formatNumber value="0"/> VNĐ</span>
                    </div>

                    <div class="summary-row">
                        <span>Phí vận chuyển:</span>
                        <span id="shipping"><fmt:formatNumber value="${((subtotal < 500000 && subtotal > 0) ? 30000 : 0)}"/> VNĐ</span>
                    </div>

                    <div class="summary-row total">
                        <span>Tổng cộng:</span>
                        <span id="total"><fmt:formatNumber value="${subtotal + ((subtotal < 500000 && subtotal > 0) ? 30000 : 0) - 0}"/> VNĐ</span>
                    </div>

                    <button class="checkout-btn" onclick="checkout()">
                        <i class="fa fa-check"></i> Thanh toán
                    </button>
                    <button class="continue-shopping-btn" onclick="continueShopping()">
                        <i class="fa fa-arrow-left"></i> Tiếp tục mua
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
                </div>

                <!-- Features -->
                <div style="background: white; border-radius: 8px; padding: 20px; margin-top: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    <div style="display: flex; gap: 15px; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #eee;">
                        <i class="fa fa-truck" style="font-size: 20px; color: #d32f2f;"></i>
                        <div>
                            <h4 style="margin: 0; font-size: 14px;">Giao hàng miễn phí</h4>
                            <p style="margin: 0; font-size: 12px; color: #999;">Cho đơn hàng từ 500K</p>
                        </div>
                    </div>

                    <div style="display: flex; gap: 15px;">
                        <i class="fa fa-shield" style="font-size: 20px; color: #d32f2f;"></i>
                        <div>
                            <h4 style="margin: 0; font-size: 14px;">Thanh toán an toàn</h4>
                            <p style="margin: 0; font-size: 12px; color: #999;">Bảo vệ thông tin giao dịch</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Toast Message -->
<div id="toastMessage" class="toast-message"></div>

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

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">1. File đơn hàng (document.txt):</label>
            <input type="file" id="documentFile" class="form-control" accept=".txt">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">2. Chữ ký số (signature.sig):</label>
            <input type="file" id="signatureFile" class="form-control" accept=".sig">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">3. Public Key (public-key.pem):</label>
            <input type="file" id="publicKeyFile" class="form-control" accept=".pem">
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
            <button onclick="processHash()" style="
                background-color: #6c757d;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
            ">
                <i class="fa fa-hashtag"></i> Băm dữ liệu (SHA-256)
            </button>

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



<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    let generatedPublicKey = "";
    let generatedPrivateKey = "";
    let selectedKeySize = 2048;
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

    // Increase quantity
    function increaseQty(cartItemId, currentQty) {
        const newQty = currentQty + 1;
        updateQuantity(cartItemId, newQty);
    }

    // Decrease quantity
    function decreaseQty(cartItemId, currentQty) {
        if (currentQty > 1) {
            const newQty = currentQty - 1;
            updateQuantity(cartItemId, newQty);
        } else {
            showToast('Số lượng phải >= 1', true);
        }
    }

    // Update quantity via AJAX
    function updateQuantity(cartItemId, newQuantity) {
        $.ajax({
            url: '${pageContext.request.contextPath}/update-cart',
            method: 'POST',
            data: {
                cartItemId: cartItemId,
                quantity: newQuantity
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    location.reload(); // Reload page to update totals
                } else {
                    showToast(response.message, true);
                }
            },
            error: function() {
                showToast('Lỗi cập nhật giỏ hàng', true);
            }
        });
    }

    // Remove item
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

    // Apply promo code
    function applyPromo() {
        const promoCode = document.getElementById('promoCode').value.trim();
        if (!promoCode) {
            showToast('Vui lòng nhập mã khuyến mãi', true);
            return;
        }

        // TODO: Implement promo code validation
        showToast('Đã áp dụng mã: ' + promoCode);
    }

    // Mở modal - reset về bước 1
    function openKeyModal() {
        document.getElementById('stepConfirm').style.display = 'block';
        document.getElementById('stepSuccess').style.display = 'none';
        document.getElementById('keyModal').style.display = 'flex';
    }

    // Đóng modal
    function closeKeyModal() {
        document.getElementById('keyModal').style.display = 'none';
    }

    // --- Verification Logic ---

    function openVerifyKeyModal() {
        document.getElementById('verifyKeyModal').style.display = 'flex';
        // Reset fields
        document.getElementById('hashDisplay').value = '';
        document.getElementById('verificationResult').style.display = 'none';
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

    // Hàm băm dữ liệu SHA-256
    async function processHash() {
        const docFile = document.getElementById('documentFile').files[0];
        if (!docFile) {
            showToast('Vui lòng chọn file tài liệu', true);
            return;
        }

        try {
            const msgBuffer = await readFileAsArrayBuffer(docFile); // Đọc nhị phân để đảm bảo tính toàn vẹn tuyệt đối
            const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
            const hashArray = Array.from(new Uint8Array(hashBuffer));
            const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
            
            document.getElementById('hashDisplay').value = hashHex;
            showToast('Đã băm dữ liệu thành công');
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
        const docFile = document.getElementById('documentFile').files[0];
        const sigFile = document.getElementById('signatureFile').files[0];
        const pubKeyFile = document.getElementById('publicKeyFile').files[0];
        const hashVal = document.getElementById('hashDisplay').value;

        if (!docFile || !sigFile || !pubKeyFile) {
            showToast('Vui lòng tải lên đủ 3 file', true);
            return;
        }
        if (!hashVal) {
            showToast('Vui lòng băm dữ liệu trước khi xác thực', true);
            return;
        }

        try {
            const sigBuffer = await readFileAsArrayBuffer(sigFile);
            const pubKeyContent = await readFileAsText(pubKeyFile);

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

            // 1. Import Public Key
            const binaryDer = pemToArrayBuffer(pubKeyContent);
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
                resultDiv.style.backgroundColor = '#d4edda';
                resultDiv.style.color = '#155724';
                resultDiv.innerHTML = '<i class="fa fa-check"></i> Chữ ký hợp lệ! Tài liệu toàn vẹn.';
                showToast('Xác thực thành công');
            } else {
                resultDiv.style.backgroundColor = '#f8d7da';
                resultDiv.style.color = '#721c24';
                resultDiv.innerHTML = '<i class="fa fa-times"></i> Chữ ký không hợp lệ hoặc tài liệu đã bị chỉnh sửa!';
                showToast('Xác thực thất bại', true);
            }

        } catch (err) {
            console.error(err);
            showToast('Lỗi: File không đúng định dạng hoặc Public Key sai', true);
            const resultDiv = document.getElementById('verificationResult');
            resultDiv.style.display = 'block';
            resultDiv.style.backgroundColor = '#fff3cd';
            resultDiv.innerHTML = 'Lỗi xử lý file (Kiểm tra định dạng Public Key .pem)';
        }
    }

    // Đóng modal khi click ra ngoài (cập nhật cho cả 2 modal)
    window.onclick = function(event) {
        const keyModal = document.getElementById('keyModal');
        const verifyModal = document.getElementById('verifyKeyModal');
        if (event.target === keyModal) closeKeyModal();
        if (event.target === verifyModal) closeVerifyKeyModal();
    }

    // --- End Verification Logic ---

    // Bước 1 → Bước 2: Tạo khóa và chuyển sang màn thành công
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

    // Checkout
    function checkout() {
        window.location.href = '${pageContext.request.contextPath}/checkout';
    }

    // Continue shopping
    function continueShopping() {
        window.location.href = '${pageContext.request.contextPath}/store';
    }

    // Search functionality (from index)
    $(document).ready(function() {
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

        $(document).on('click', function(e) {
            if (!$(e.target).closest('.header-search').length) {
                $('#suggestDropdown').hide();
            }
        });

        $('#searchForm').on('submit', function() {
            $('#suggestDropdown').hide();
        });
    });
</script>

</body>
</html>