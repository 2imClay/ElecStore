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
            <div style="margin-bottom: 15px;">
                <i class="fa fa-key" style="font-size: 48px; color: #1565c0;"></i>
            </div>
            <h3 style="margin: 0 0 10px; color: #333; font-size: 20px;">Tạo khóa xác thực</h3>
            <p style="color: #666; font-size: 14px; margin-bottom: 25px;">
                Hệ thống sẽ tạo một mã khóa bảo mật cho đơn hàng của bạn.<br>
                Bạn có chắc chắn muốn tiếp tục?
            </p>
            <div style="display: flex; gap: 10px; justify-content: center;">
                <button onclick="closeKeyModal()" style="
                    padding: 10px 25px;
                    border: 1px solid #ccc;
                    background: white;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 14px;
                    color: #555;
                ">
                    <i class="fa fa-times"></i> Hủy
                </button>
                <button onclick="generateKey()" style="
                    padding: 10px 25px;
                    background: #1565c0;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-size: 14px;
                    font-weight: 600;
                ">
                    <i class="fa fa-check"></i> Xác nhận tạo
                </button>
            </div>
        </div>

        <!-- ===== BƯỚC 2: Thành công + Khóa ===== -->
        <div id="stepSuccess" style="display: none;">
            <!-- Icon thành công -->
            <div style="margin-bottom: 15px;">
                <i class="fa fa-check-circle" style="font-size: 52px; color: #27ae60;"></i>
            </div>
            <h3 style="margin: 0 0 5px; color: #27ae60; font-size: 20px;">Tạo khóa thành công!</h3>
            <p style="color: #666; font-size: 14px; margin-bottom: 20px;">
                Mã khóa xác thực của bạn đã được tạo.<br>Vui lòng lưu lại trước khi đóng.
            </p>

            <!-- Hiển thị khóa -->
            <div style="
                background: #f0f7ff;
                border: 2px dashed #1565c0;
                border-radius: 8px;
                padding: 16px;
                margin-bottom: 10px;
            ">
                <small style="color: #999; font-size: 11px; display: block; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 1px;">Mã khóa xác thực</small>
                <span id="generatedKey" style="
                    font-family: monospace;
                    font-size: 20px;
                    color: #1565c0;
                    font-weight: 700;
                    letter-spacing: 3px;
                "></span>
                <div style="margin-top: 10px;">
                    <button onclick="copyKey()" style="
                        background: none;
                        border: 1px solid #1565c0;
                        color: #1565c0;
                        border-radius: 4px;
                        padding: 4px 12px;
                        font-size: 12px;
                        cursor: pointer;
                    ">
                        <i class="fa fa-copy"></i> Sao chép
                    </button>
                </div>
            </div>
            <small style="color: #e53935; font-size: 12px; display: block; margin-bottom: 20px;">
                <i class="fa fa-exclamation-triangle"></i> Mã này chỉ hiển thị một lần, hãy lưu lại ngay!
            </small>

            <!-- Nút lưu khóa -->
            <button onclick="saveAndClose()" style="
                width: 100%;
                padding: 12px;
                background: #27ae60;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 15px;
                font-weight: 600;
            ">
                <i class="fa fa-save"></i> Xác nhận và lưu khóa
            </button>
        </div>

    </div>
</div>


<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
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
    function generateKey() {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        let key = '';
        for (let i = 0; i < 16; i++) {
            if (i > 0 && i % 4 === 0) key += '-';
            key += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        document.getElementById('generatedKey').textContent = key;
        document.getElementById('stepConfirm').style.display = 'none';
        document.getElementById('stepSuccess').style.display = 'block';
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
