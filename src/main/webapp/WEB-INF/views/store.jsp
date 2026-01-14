<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 04/12/2025
  Time: 7:42 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Store</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Google font -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>


    <!-- Slick -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick-theme.min.css"/>

    <!-- nouislider -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/nouislider@15.8.1/dist/nouislider.min.css">

    <!-- Font Awesome Icon -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">

    <!-- Custom stlylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/store.css"/>


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
    <!-- container -->
    <div class="container">
        <!-- responsive-nav -->
        <div id="responsive-nav">
            <!-- NAV -->
            <ul class="main-nav nav navbar-nav">
                <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/store">Cửa hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
            </ul>
            <!-- /NAV -->
        </div>
        <!-- /responsive-nav -->
    </div>
    <!-- /container -->
</nav>
<!-- /NAVIGATION -->

<!-- ==================== MAIN CONTENT ==================== -->
<div class="container">
    <div class="store-container">
        <!-- ==================== SIDEBAR ==================== -->
        <aside class="sidebar">
            <!-- Danh mục -->
            <div class="filter-group">
                <h5 class="sidebar-title">
                    <i class="fas fa-list"></i> Danh mục
                </h5>
                <c:forEach items="${categories}" var="c">
                    <div class="filter-item">
<%--                        <input type="radio" id="cat-${c.id}" name="category" value="${c.id}" onclick="window.location.href='${pageContext.request.contextPath}/store?categoryId=${c.id}'">--%>
                        <label for="cat-${c.id}">
                                 <a href="${pageContext.request.contextPath}/store?categoryId=${c.id}">${c.name}</a>
                        </label>
                    </div>
                </c:forEach>
            </div>

            <!-- Khoảng giá -->
<%--            <div class="filter-group">--%>
<%--                <h5 class="sidebar-title">--%>
<%--                    <i class="fas fa-tag"></i> Giá--%>
<%--                </h5>--%>
<%--                <div class="price-range">--%>
<%--                    <input type="number" id="priceMin" class="price-input" placeholder="Từ">--%>
<%--                    <span>-</span>--%>
<%--                    <input type="number" id="priceMax" class="price-input" placeholder="Đến">--%>
<%--                </div>--%>
<%--                <button style="margin-top: 20px; background-color: #d32f2f; color: white; padding: 5px; border-radius: 5px; border: none">Lọc</button>--%>
<%--            </div>--%>

            <!-- Thương hiệu -->
<%--            <div class="filter-group">--%>
<%--                <h5 class="sidebar-title">--%>
<%--                    <i class="fas fa-trademark"></i> Thương hiệu--%>
<%--                </h5>--%>
<%--                <div class="filter-item">--%>
<%--                    <label for="brand-samsung">Samsung (578)</label>--%>
<%--                </div>--%>
<%--                <div class="filter-item">--%>
<%--                    <label for="brand-apple">Apple (342)</label>--%>
<%--                </div>--%>
<%--                <div class="filter-item">--%>
<%--                    <label for="brand-lenovo">Lenovo (295)</label>--%>
<%--                </div>--%>
<%--            </div>--%>
        </aside>

        <!-- ==================== PRODUCTS ==================== -->
        <section class="products-section">
            <!-- Header -->
            <div class="products-header">
                <h2 class="products-title">
                    <i class="fas fa-box"></i> Sản phẩm
                </h2>
<%--                <div class="products-toolbar">--%>
<%--                    <form method="GET" class="d-flex gap-2">--%>
<%--                        <select class="toolbar-select" name="sort">--%>
<%--                            <option value="">--%>
<%--                                Sắp xếp: Phổ biến</option>--%>
<%--                            <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>--%>
<%--                                Giá: Thấp đến cao</option>--%>
<%--                            <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>--%>
<%--                                Giá: Cao đến thấp</option>--%>
<%--                        </select>--%>
<%--                    </form>--%>
<%--                </div>--%>
            </div>

            <!-- Products Grid -->
            <div class="products-grid">
                <c:forEach items="${products}" var="p" >
                    <div class="product-card">
                        <!-- Image -->
                        <div class="product-image">
                            <img src="${p.imageUrl}" alt="${p.name}">
                            <div class="product-badges">
                                <span class="badge sale">-30%</span>
                                <span class="badge new">NEW</span>
                            </div>
                        </div>

                        <!-- Info -->
                        <div class="product-info">
                            <p class="product-category">${p.categoryName}</p>
                            <h3 class="product-name">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                                        ${p.name}
                                </a>
                            </h3>

<%--                            <div class="product-rating">--%>
<%--                                <i class="fas fa-star"></i>--%>
<%--                                <i class="fas fa-star"></i>--%>
<%--                                <i class="fas fa-star"></i>--%>
<%--                                <i class="fas fa-star"></i>--%>
<%--                                <i class="fas fa-star-half-alt"></i>--%>
<%--                            </div>--%>

                            <div class="product-price">
                                <fmt:formatNumber value="${p.price}"/> VNĐ
                            </div>

                            <div class="product-actions">
                                <button class="btn-action btn-view"
                                        onclick="window.location.href='${pageContext.request.contextPath}/product-detail?id=${p.id}'">
                                    <i class="fa fa-eye"></i>
                                </button>
                                <button class="btn-action btn-view"
                                        onclick="addToFavourite(${p.id})">
                                    <i class="fa fa-heart-o"></i>
                                </button>
                                <button class="btn-action btn-cart" onclick="addToCart(${p.id}, 1)">
                                    <i class="fa fa-shopping-cart"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
<%--            <div class="pagination-section">--%>
<%--                <span>Hiển thị 12 sản phẩm</span>--%>
<%--                <ul class="pagination">--%>
<%--                    <li><span class="active">1</span></li>--%>
<%--                    <li><a href="#">2</a></li>--%>
<%--                    <li><a href="#">3</a></li>--%>
<%--                    <li><a href="#"><i class="fas fa-chevron-right"></i></a></li>--%>
<%--                </ul>--%>
<%--            </div>--%>
        </section>
    </div>
</div>


<!-- jQuery Plugins -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
<script src="${pageContext.request.contextPath}/js/nouislider.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.zoom.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>

    function addToFavourite(productId, quantity) {
        // Check if user is logged in
        <c:if test="${empty sessionScope.user}">
        alert('Vui lòng đăng nhập để thêm vào yêu thích');
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
            url: '${pageContext.request.contextPath}/add-to-favourite',
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
                    alert('Lỗi thêm vào yêu thích');
                }
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
        });
    }

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

                    // Update cart count in header
                    updateCartCountInHeader();

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

    // Toast notification for cart
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

    // Update cart count in header
    function updateCartCountInHeader() {
        // Optionally fetch and update cart count
        // For now, you can leave empty or implement AJAX to get count
    }
</script>

<script>
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
