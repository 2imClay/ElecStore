<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 14/01/2026
  Time: 11:10 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Yêu Thích - ElecStore</title>

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Bootstrap -->
<%--        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>--%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Slick -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.css"/>
    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">
    <!-- Custom stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <style>
        .favourite-card { transition: all 0.3s; }
        .favourite-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .empty-state { text-align: center; padding: 100px 20px; color: #6c757d; }
        .btn-favourite { background: linear-gradient(45deg, #ff6b6b, #ee5a52); border: none; }
        .item-count { background: #ff6b6b; color: white; border-radius: 50%; width: 24px; height: 24px; font-size: 12px; }
    </style>
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

<div class="container my-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-heart text-danger me-2"></i> Danh sách yêu thích</h2>
                <span class="badge bg-danger fs-6">${favouriteItemCount} sản phẩm</span>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty favourite}">
            <div class="empty-state">
                <i class="fas fa-heart-broken fa-5x text-muted mb-4"></i>
                <h4>Chưa có sản phẩm yêu thích</h4>
                <p class="mb-4">Thêm sản phẩm yêu thích để lưu lại những món đồ bạn quan tâm!</p>
                <a href="${pageContext.request.contextPath}/store" class="btn btn-primary btn-lg">
                    <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="item" items="${favouriteItems}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card h-100 favourite-card shadow-sm">
                            <img src="${item.product.imageUrl}"
                                 class="card-img-top" alt="${item.product.name}"
                                 style="height: 200px; object-fit: cover;">

                            <div class="card-body d-flex flex-column">
<%--                                <h6 class="card-title fw-bold">${item.product.name}</h6>--%>
                                <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}"
                                style="text-decoration: none">
                                    <h6 class="card-title fw-bold">${item.product.name}</h6>
                                </a>
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <div>
                                        <div class="fw-bold text-danger fs-5">
                                            <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                        </div>
                                        <small class="text-muted">SL ${item.quantity}</small>
                                    </div>

                                    <div class="btn-group" role="group">
                                        <button class="btn btn-sm btn-outline-danger add-cart"
                                                data-product-id="${item.product.id}"
                                                onclick="addToCart(${item.product.id},${item.quantity})">
                                            <i class="fas fa-shopping-cart"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger remove-favourite"
                                                data-product-id="${item.product.id}"
                                                onclick="removeItem(${item.id})">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>


<!-- Scripts -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    function addToCart(productId, quantity) {
        // Check if user is logged in
        <c:if test="${empty sessionScope.user}">
        alert('Vui lòng đăng nhập để thêm vào giỏ hàng');
        window.location.href = '${pageContext.request.contextPath}/login';
        return;
        </c:if>

        // Show loading indicator
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang thêm...';
        btn.disabled = true;

        // AJAX request to add to cart
        $.ajax({
            url: '${pageContext.request.contextPath}/add-to-cart',
            method: 'POST',
            data: {
                productId: productId,
                quantity: quantity
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    // Show success toast
                    showCartToast(response.message, true);

                    // Restore button
                    btn.innerHTML = originalText;
                    btn.disabled = false;

                } else {
                    alert('Lỗi: ' + response.message);
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }
            },
            error: function(xhr) {
                if (xhr.status === 401) {
                    alert('Vui lòng đăng nhập');
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert('Lỗi thêm vào giỏ hàng');
                }
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
        });
    }
    function showCartToast(message, success = true) {
        const toast = document.createElement('div');
        toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        border-radius: 5px;
        color: white;
        background-color: ${success ? '#27ae60' : '#e74c3c'};
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        z-index: 9999;
        font-size: 14px;
    `;

        toast.textContent = message;
        document.body.appendChild(toast);

        setTimeout(() => {
            toast.remove();
        }, 3000);
    }

    function removeItem(favouriteItemId) {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/remove-from-favourite',
                method: 'POST',
                data: { favouriteItemId: favouriteItemId },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        location.reload();
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
