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
                        <i class="fa fa-shield-alt"></i> Xác Thực Khóa
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
<!-- Modal Xác Thực Khóa -->
<div id="verifyKeyModal" style="
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.6);
    z-index: 9999;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(4px);
">
    <div style="
        background: white;
        border-radius: 12px;
        padding: 35px 40px;
        width: 500px;
        max-width: 94%;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        position: relative;
        animation: slideIn 0.3s ease-out;
    ">

        <!-- Close Button -->
        <button onclick="closeVerifyKeyModal()" style="
            position: absolute;
            top: 15px;
            right: 20px;
            background: none;
            border: none;
            font-size: 24px;
            color: #999;
            cursor: pointer;
            transition: color 0.3s;
            padding: 5px;
            line-height: 1;
        " onmouseover="this.style.color='#333'" onmouseout="this.style.color='#999'">
            ×
        </button>

        <!-- Header -->
        <div style="text-align: center; margin-bottom: 25px;">
            <div style="
                width: 70px;
                height: 70px;
                background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 15px;
            ">
                <i class="fa fa-shield" style="font-size: 32px; color: #2e7d32;"></i>
            </div>
            <h3 style="margin: 0; font-size: 22px; font-weight: 700; color: #1a1a1a;">
                Xác Thực Chữ Ký Số
            </h3>
            <p style="color: #888; font-size: 14px; margin-top: 6px;">
                Tải lên các file cần thiết để xác minh chữ ký số
            </p>
        </div>

        <!-- Upload Files Section -->
        <div style="margin-bottom: 20px;">

            <!-- Tải file tài liệu -->
            <div style="margin-bottom: 14px;">
                <label style="
                    display: block;
                    font-weight: 600;
                    font-size: 13px;
                    color: #333;
                    margin-bottom: 5px;
                ">
                    <i class="fa fa-file-text-o" style="color: #1565c0; margin-right: 6px;"></i>
                    Tải file tài liệu
                </label>
                <div style="
                    border: 2px dashed #d0d7de;
                    border-radius: 8px;
                    padding: 12px 16px;
                    background: #fafbfc;
                    transition: all 0.3s;
                    cursor: pointer;
                " onmouseover="this.style.borderColor='#1565c0'; this.style.background='#f0f7ff'"
                     onmouseout="this.style.borderColor='#d0d7de'; this.style.background='#fafbfc'">
                    <input type="file" id="documentFile" accept=".txt,.pdf,.doc,.docx" style="
                        width: 100%;
                        padding: 4px 0;
                        font-size: 13px;
                        cursor: pointer;
                    ">
                </div>
                <small style="color: #999; font-size: 11px; display: block; margin-top: 3px;">
                    <i class="fa fa-info-circle"></i> Hỗ trợ: .txt, .pdf, .doc, .docx
                </small>
            </div>

            <!-- Tải chữ ký số -->
            <div style="margin-bottom: 14px;">
                <label style="
                    display: block;
                    font-weight: 600;
                    font-size: 13px;
                    color: #333;
                    margin-bottom: 5px;
                ">
                    <i class="fa fa-pencil-square-o" style="color: #e65100; margin-right: 6px;"></i>
                    Tải chữ ký số
                </label>
                <div style="
                    border: 2px dashed #d0d7de;
                    border-radius: 8px;
                    padding: 12px 16px;
                    background: #fafbfc;
                    transition: all 0.3s;
                    cursor: pointer;
                " onmouseover="this.style.borderColor='#e65100'; this.style.background='#fff4f0'"
                     onmouseout="this.style.borderColor='#d0d7de'; this.style.background='#fafbfc'">
                    <input type="file" id="signatureFile" accept=".txt,.sig,.pem" style="
                        width: 100%;
                        padding: 4px 0;
                        font-size: 13px;
                        cursor: pointer;
                    ">
                </div>
                <small style="color: #999; font-size: 11px; display: block; margin-top: 3px;">
                    <i class="fa fa-info-circle"></i> Hỗ trợ: .txt, .sig, .pem
                </small>
            </div>

            <!-- Tải Public Key -->
            <div style="margin-bottom: 0;">
                <label style="
                    display: block;
                    font-weight: 600;
                    font-size: 13px;
                    color: #333;
                    margin-bottom: 5px;
                ">
                    <i class="fa fa-key" style="color: #2e7d32; margin-right: 6px;"></i>
                    Tải Public Key
                </label>
                <div style="
                    border: 2px dashed #d0d7de;
                    border-radius: 8px;
                    padding: 12px 16px;
                    background: #fafbfc;
                    transition: all 0.3s;
                    cursor: pointer;
                " onmouseover="this.style.borderColor='#2e7d32'; this.style.background='#f0f8f0'"
                     onmouseout="this.style.borderColor='#d0d7de'; this.style.background='#fafbfc'">
                    <input type="file" id="publicKeyFile" accept=".pem,.txt" style="
                        width: 100%;
                        padding: 4px 0;
                        font-size: 13px;
                        cursor: pointer;
                    ">
                </div>
                <small style="color: #999; font-size: 11px; display: block; margin-top: 3px;">
                    <i class="fa fa-info-circle"></i> Hỗ trợ: .pem, .txt
                </small>
            </div>
        </div>

        <!-- Hash Button -->
        <div style="margin-bottom: 18px;">
            <button onclick="hashDocument()" style="
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #6c757d, #5a6268);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 15px rgba(108,117,125,0.4)'"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                <i class="fa fa-calculator"></i>
                Bấm dữ liệu (SHA-256)
            </button>
        </div>

        <hr style="border: none; border-top: 1px solid #eee; margin: 18px 0;">

        <!-- Public Key Status -->
        <div style="
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 12px 18px;
            border-radius: 8px;
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        ">
            <span style="font-weight: 600; color: #0d47a1; font-size: 13px;">
                <i class="fa fa-check-circle" style="color: #2e7d32;"></i>
                Đã tải Public Key
            </span>
            <span id="publicKeyStatus" style="
                font-size: 12px;
                color: #0d47a1;
                background: rgba(255,255,255,0.6);
                padding: 3px 12px;
                border-radius: 12px;
                font-weight: 500;
            ">
                Chưa có
            </span>
        </div>

        <!-- Result Hash -->
        <div style="margin-bottom: 14px;">
            <label style="
                font-weight: 600;
                font-size: 13px;
                color: #333;
                display: block;
                margin-bottom: 4px;
            ">
                Kết quả bấm (SHA-256):
            </label>
            <div id="hashResult" style="
                background: #f5f7fa;
                padding: 10px 14px;
                border-radius: 6px;
                font-family: 'Courier New', monospace;
                font-size: 13px;
                word-break: break-all;
                min-height: 42px;
                color: #333;
                border: 1px solid #e9ecef;
            ">
                <span style="color: #aaa; font-style: italic;">Chưa bấm dữ liệu</span>
            </div>
        </div>

        <!-- Digital Signature -->
        <div style="margin-bottom: 14px;">
            <label style="
                font-weight: 600;
                font-size: 13px;
                color: #333;
                display: block;
                margin-bottom: 4px;
            ">
                Chữ ký số:
            </label>
            <div id="signatureResult" style="
                background: #f5f7fa;
                padding: 10px 14px;
                border-radius: 6px;
                font-family: 'Courier New', monospace;
                font-size: 13px;
                word-break: break-all;
                min-height: 42px;
                color: #333;
                border: 1px solid #e9ecef;
            ">
                <span style="color: #aaa; font-style: italic;">Chưa tải chữ ký</span>
            </div>
        </div>

        <!-- Decrypted Signature -->
        <div style="margin-bottom: 20px;">
            <label style="
                font-weight: 600;
                font-size: 13px;
                color: #333;
                display: block;
                margin-bottom: 4px;
            ">
                Giải mã chữ ký số:
            </label>
            <div id="decryptedSignature" style="
                background: #f5f7fa;
                padding: 10px 14px;
                border-radius: 6px;
                font-family: 'Courier New', monospace;
                font-size: 13px;
                word-break: break-all;
                min-height: 42px;
                color: #333;
                border: 1px solid #e9ecef;
            ">
                <span style="color: #aaa; font-style: italic;">Chưa giải mã</span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div style="display: flex; gap: 10px; margin-bottom: 14px;">
            <button onclick="decryptSignature()" style="
                flex: 1;
                padding: 11px;
                background: linear-gradient(135deg, #17a2b8, #138496);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
            " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 15px rgba(23,162,184,0.4)'"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                <i class="fa fa-unlock-alt"></i>
                Giải mã
            </button>
            <button onclick="verifySignature()" style="
                flex: 1;
                padding: 11px;
                background: linear-gradient(135deg, #28a745, #218838);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
            " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 15px rgba(40,167,69,0.4)'"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                <i class="fa fa-check"></i>
                Xác minh
            </button>
        </div>

        <!-- Close Button -->
        <button onclick="closeVerifyKeyModal()" style="
            width: 100%;
            padding: 11px;
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 15px rgba(220,53,69,0.4)'"
                onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
            <i class="fa fa-times"></i>
            Đóng
        </button>

        <!-- Result Message -->
        <div id="verifyResult" style="
            margin-top: 16px;
            padding: 14px 18px;
            border-radius: 8px;
            text-align: center;
            display: none;
            animation: slideIn 0.3s ease-out;
        ">
            <div style="font-size: 28px; margin-bottom: 4px;">
                <i class="fa fa-check-circle" style="color: #28a745;"></i>
            </div>
            <div style="font-weight: 600; font-size: 15px;">
                Xác minh thành công!
            </div>
        </div>

    </div>
</div>

<style>
    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateY(-30px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    /* Custom file input styling */
    #verifyKeyModal input[type="file"] {
        font-size: 13px;
    }

    #verifyKeyModal input[type="file"]::file-selector-button {
        padding: 6px 16px;
        border: none;
        border-radius: 4px;
        background: #e9ecef;
        color: #333;
        font-weight: 500;
        font-size: 12px;
        cursor: pointer;
        transition: background 0.3s;
        margin-right: 12px;
    }

    #verifyKeyModal input[type="file"]::file-selector-button:hover {
        background: #dee2e6;
    }

    /* Scrollbar styling */
    #verifyKeyModal > div::-webkit-scrollbar {
        width: 6px;
    }

    #verifyKeyModal > div::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 3px;
    }

    #verifyKeyModal > div::-webkit-scrollbar-thumb {
        background: #c1c7cd;
        border-radius: 3px;
    }

    #verifyKeyModal > div::-webkit-scrollbar-thumb:hover {
        background: #a8afb6;
    }
</style>


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

    // Đóng modal khi click ra ngoài
    document.getElementById('keyModal').addEventListener('click', function(e) {
        if (e.target === this) closeKeyModal();
    });
    // ===== XÁC THỰC KHÓA =====

    // Biến lưu dữ liệu
    let uploadedDocument = null;
    let uploadedSignature = null;
    let uploadedPublicKey = null;
    let documentHash = '';
    let signatureContent = '';
    let decryptedContent = '';

    // Mở modal xác thực
    function openVerifyKeyModal() {
        const modal = document.getElementById('verifyKeyModal');
        modal.style.display = 'flex';
        resetVerifyModal();
        // Thêm animation
        modal.querySelector('div > div').style.animation = 'none';
        setTimeout(() => {
            modal.querySelector('div > div').style.animation = 'slideIn 0.3s ease-out';
        }, 10);
    }

    // Đóng modal xác thực
    function closeVerifyKeyModal() {
        document.getElementById('verifyKeyModal').style.display = 'none';
        resetVerifyModal();
    }

    // Reset modal xác thực
    function resetVerifyModal() {
        uploadedDocument = null;
        uploadedSignature = null;
        uploadedPublicKey = null;
        documentHash = '';
        signatureContent = '';
        decryptedContent = '';

        document.getElementById('documentFile').value = '';
        document.getElementById('signatureFile').value = '';
        document.getElementById('publicKeyFile').value = '';
        document.getElementById('publicKeyStatus').textContent = 'Chưa có';
        document.getElementById('hashResult').innerHTML = '<span style="color: #aaa; font-style: italic;">Chưa bấm dữ liệu</span>';
        document.getElementById('signatureResult').innerHTML = '<span style="color: #aaa; font-style: italic;">Chưa tải chữ ký</span>';
        document.getElementById('decryptedSignature').innerHTML = '<span style="color: #aaa; font-style: italic;">Chưa giải mã</span>';

        const resultDiv = document.getElementById('verifyResult');
        resultDiv.style.display = 'none';
        resultDiv.style.background = '';
        resultDiv.style.border = '';
        resultDiv.style.color = '';
    }

    // Xử lý upload file
    document.addEventListener('DOMContentLoaded', function() {
        // File tài liệu
        document.getElementById('documentFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                uploadedDocument = file;
                showToast('✅ Đã tải file: ' + file.name);
            }
        });

        // File chữ ký
        document.getElementById('signatureFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    signatureContent = event.target.result.trim();
                    uploadedSignature = file;
                    const displayText = signatureContent.length > 60
                        ? signatureContent.substring(0, 60) + '...'
                        : signatureContent;
                    document.getElementById('signatureResult').innerHTML =
                        '<span style="color: #2d3748; font-weight: 500;">' + displayText + '</span>';
                    showToast('✅ Đã tải chữ ký số');
                };
                reader.readAsText(file);
            }
        });

        // File Public Key
        document.getElementById('publicKeyFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    uploadedPublicKey = event.target.result;
                    document.getElementById('publicKeyStatus').textContent = '✅ ' + file.name;
                    document.getElementById('publicKeyStatus').style.color = '#2e7d32';
                    showToast('✅ Đã tải Public Key');
                };
                reader.readAsText(file);
            }
        });
    });

    // Bấm dữ liệu SHA-256
    function hashDocument() {
        if (!uploadedDocument) {
            showToast('⚠️ Vui lòng tải file tài liệu trước', true);
            return;
        }

        const reader = new FileReader();
        reader.onload = function(event) {
            const content = event.target.result;

            // Sử dụng Web Crypto API để tạo SHA-256
            crypto.subtle.digest('SHA-256', new TextEncoder().encode(content))
                .then(hashBuffer => {
                    const hashArray = Array.from(new Uint8Array(hashBuffer));
                    documentHash = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
                    document.getElementById('hashResult').innerHTML =
                        '<span style="color: #0d47a1; font-weight: 600; font-size: 14px;">' +
                        documentHash + '</span>';
                    showToast('✅ Đã tạo mã hash SHA-256 thành công');
                })
                .catch(error => {
                    showToast('❌ Lỗi tạo hash: ' + error.message, true);
                });
        };
        reader.readAsText(uploadedDocument);
    }

    // Giải mã chữ ký số
    function decryptSignature() {
        if (!signatureContent) {
            showToast('⚠️ Vui lòng tải chữ ký số trước', true);
            return;
        }

        if (!uploadedPublicKey) {
            showToast('⚠️ Vui lòng tải Public Key trước', true);
            return;
        }

        // Giả lập giải mã với RSA (trong thực tế gọi API backend)
        const mockDecrypted = 'decrypted_' + signatureContent.substring(0, 8) + '_' +
            Math.random().toString(36).substring(2, 8);

        decryptedContent = mockDecrypted;
        document.getElementById('decryptedSignature').innerHTML =
            '<span style="color: #0d47a1; font-weight: 500;">' + mockDecrypted + '</span>';
        showToast('✅ Đã giải mã chữ ký số thành công');
    }

    // Xác minh chữ ký số
    function verifySignature() {
        if (!documentHash) {
            showToast('⚠️ Vui lòng bấm dữ liệu SHA-256 trước', true);
            return;
        }

        if (!decryptedContent) {
            showToast('⚠️ Vui lòng giải mã chữ ký số trước', true);
            return;
        }

        const resultDiv = document.getElementById('verifyResult');

        // Giả lập xác minh (trong thực tế gọi API backend)
        const isVerified = documentHash.substring(0, 10) === decryptedContent.substring(0, 10) ||
            Math.random() > 0.3;

        if (isVerified) {
            resultDiv.style.display = 'block';
            resultDiv.style.background = 'linear-gradient(135deg, #d4edda, #c3e6cb)';
            resultDiv.style.border = '1px solid #b8daff';
            resultDiv.style.color = '#155724';
            resultDiv.innerHTML = `
            <div style="font-size: 28px; margin-bottom: 4px;">
                <i class="fa fa-check-circle" style="color: #28a745;"></i>
            </div>
            <div style="font-weight: 600; font-size: 16px;">
                ✅ Xác minh thành công!
            </div>
            <div style="font-size: 12px; color: #155724; margin-top: 4px; opacity: 0.8;">
                Chữ ký số hợp lệ
            </div>
        `;
            showToast('✅ Xác minh thành công!');
        } else {
            resultDiv.style.display = 'block';
            resultDiv.style.background = 'linear-gradient(135deg, #f8d7da, #f5c6cb)';
            resultDiv.style.border = '1px solid #f5c6cb';
            resultDiv.style.color = '#721c24';
            resultDiv.innerHTML = `
            <div style="font-size: 28px; margin-bottom: 4px;">
                <i class="fa fa-times-circle" style="color: #dc3545;"></i>
            </div>
            <div style="font-weight: 600; font-size: 16px;">
                ❌ Xác minh thất bại!
            </div>
            <div style="font-size: 12px; color: #721c24; margin-top: 4px; opacity: 0.8;">
                Chữ ký số không hợp lệ
            </div>
        `;
            showToast('❌ Xác minh thất bại!', true);
        }
    }

    // Đóng modal khi click ra ngoài
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('verifyKeyModal').addEventListener('click', function(e) {
            if (e.target === this) closeVerifyKeyModal();
        });

        // ESC key to close
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeVerifyKeyModal();
            }
        });
    });

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
