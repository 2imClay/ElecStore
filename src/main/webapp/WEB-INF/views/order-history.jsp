<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 10/01/2026
  Time: 12:20 CH
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
    <title>Lịch sử đặt hàng - ElecStore</title>
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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-history.css"/>
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

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="container">
        <h1><i class="fas fa-history"></i> Lịch Sử Đặt Hàng</h1>
        <p>Xem tất cả các đơn hàng của bạn</p>
    </div>
</div>

<div class="center" style="display: flex; justify-content: center; align-items: center">
    <div class="container-list" style="max-width: 1000px; width: 1000px">
        <!-- FILTERS -->
        <div class="filters">
            <select class="filter-select" onchange="filterOrders(this.value)">
                <option value="">📊 Tất cả trạng thái</option>
                <option value="pending">⏳ Chờ xử lý</option>
                <option value="processing">📦 Đang xử lý</option>
                <option value="completed">✅ Hoàn thành</option>
                <option value="cancelled">❌ Đã hủy</option>
            </select>

            <select class="filter-select" onchange="sortOrders(this.value)">
                <option value="">⏰ Sắp xếp</option>
                <option value="newest">Mới nhất</option>
                <option value="oldest">Cũ nhất</option>
                <option value="highest">💰 Giá cao nhất</option>
                <option value="lowest">💰 Giá thấp nhất</option>
            </select>

            <input type="text" class="filter-select" placeholder="🔍 Tìm mã đơn hàng..."
                   onkeyup="searchOrders(this.value)" style="flex: 1; min-width: 200px;">
        </div>

        <!-- ORDERS LIST -->
        <c:if test="${empty orders}">
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-inbox"></i></div>
                <h3>Chưa có đơn hàng nào</h3>
                <p>Bạn chưa đặt hàng lần nào. Hãy bắt đầu mua sắm ngay!</p>
                <a href="${pageContext.request.contextPath}/store" class="btn-shop">
                    <i class="fas fa-shopping-bag"></i> Bắt đầu mua sắm
                </a>
            </div>
        </c:if>

        <c:forEach items="${orders}" var="order">
            <div class="order-card" data-status="${order.status}" data-total="${order.totalAmount}">
                <!-- HEADER -->
                <div class="order-header">
                    <div>
                        <div class="order-id">#${order.id} - ${order.customerName}</div>
                        <div class="order-date">
                            <i class="fas fa-calendar"></i>
                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>
                    <div>
                        <span class="order-status status-${order.status}">
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">⏳ Chờ xử lý</c:when>
                                <c:when test="${order.status == 'processing'}">📦 Đang xử lý</c:when>
                                <c:when test="${order.status == 'completed'}">✅ Hoàn thành</c:when>
                                <c:when test="${order.status == 'cancelled'}">❌ Đã hủy</c:when>
                            </c:choose>
                        </span>
                    </div>
                    <div>
                        <strong>Địa chỉ:</strong><br>
                            ${order.address},
                    </div>
                    <div>
                        <strong>Điện thoại:</strong><br>
                            ${order.phone}
                    </div>
                </div>

                <!-- ITEMS -->
                <div class="order-items">
                    <c:forEach items="${order.items}" var="item">
                        <div class="item-row">
                            <span class="item-name">
                                <img src="${item.productImage}" style="width: 30px; height: 30px; border-radius: 4px; margin-right: 8px;">
                                ${item.productName} <span style="color: #9ca3af;">x${item.quantity}</span>
                            </span>
                            <span><fmt:formatNumber value="${item.price * item.quantity}"/> VNĐ</span>
                        </div>
                    </c:forEach>
                </div>

                <!-- FOOTER -->
                <div class="order-footer">
                    <div>
                        <strong>Phương thức:</strong> ${order.paymentMethod}
                    </div>
                    <div class="order-total">
                        Tổng: <fmt:formatNumber value="${order.totalAmount}" /> VNĐ
                    </div>
<%--                    <div class="order-actions">--%>
<%--                            &lt;%&ndash;                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}" class="btn-detail">&ndash;%&gt;--%>
<%--                            &lt;%&ndash;                        <i class="fas fa-eye"></i> Chi tiết&ndash;%&gt;--%>
<%--                            &lt;%&ndash;                    </a>&ndash;%&gt;--%>
<%--                        <c:if test="${order.status == 'completed'}">--%>
<%--                            <button class="btn-reorder" onclick="reorder(${order.id})">--%>
<%--                                <i class="fas fa-redo"></i> Mua lại--%>
<%--                            </button>--%>
<%--                        </c:if>--%>
<%--                    </div>--%>
                </div>
            </div>
        </c:forEach>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
    function filterOrders(status) {
        const cards = document.querySelectorAll('.order-card');
        cards.forEach(card => {
            if (status === '' || card.dataset.status === status) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function sortOrders(type) {
        const container = document.querySelector('.container-list');
        const cards = Array.from(document.querySelectorAll('.order-card'));

        cards.sort((a, b) => {
            const aTotal = parseFloat(a.dataset.total);
            const bTotal = parseFloat(b.dataset.total);

            if (type === 'newest') return b.dataset.id - a.dataset.id;
            if (type === 'oldest') return a.dataset.id - b.dataset.id;
            if (type === 'highest') return bTotal - aTotal;
            if (type === 'lowest') return aTotal - bTotal;
        });

        cards.forEach(card => container.appendChild(card));
    }

    function searchOrders(value) {
        const cards = document.querySelectorAll('.order-card');
        cards.forEach(card => {
            const orderId = card.querySelector('.order-id').textContent;
            if (orderId.toLowerCase().includes(value.toLowerCase())) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function reorder(orderId) {
        if (confirm('Bạn muốn mua lại các sản phẩm từ đơn này?')) {
            $.post('${pageContext.request.contextPath}/checkout/reorder',
                { orderId: orderId },
                function(response) {
                    if (response.success) {
                        window.location.href = '${pageContext.request.contextPath}/checkout';
                    }
                }, 'json');
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
