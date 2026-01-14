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
        </div>
    </c:if>
</div>


<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%--<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>--%>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    function updatePaymentMethod(method) {
        console.log('Selected payment method:', method);
        // Có thể thêm logic để hiển thị form chi tiết thanh toán
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
            note: note
        }, function(response) {
            if (response.success) {
                alert('✅ Đặt hàng thành công!');
                window.location.href = '${pageContext.request.contextPath}/order-history';
            } else {
                alert('❌ ' + response.message);
            }
        }, 'json');
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
                            <small style="color: #999;">$` + product.price + `</small>
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
</body>
</html>
