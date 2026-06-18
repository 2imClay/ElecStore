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
    <style>
        .verify-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 6px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }
        .verify-valid { background: #d1fae5; color: #065f46; }
        .verify-tampered { background: #fee2e2; color: #991b1b; }
        .verify-none { background: #f3f4f6; color: #4b5563; }
        .btn-reverify {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 8px;
            padding: 6px 14px;
            border-radius: 6px;
            border: 1px solid #991b1b;
            background: #fff;
            color: #991b1b;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-reverify:hover { background: #fee2e2; }
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
                        <br>
                        <c:choose>
                            <c:when test="${order.verificationStatus == 'VALID'}">
                                <span class="verify-badge verify-valid" title="Dữ liệu đơn hàng còn nguyên vẹn, khớp với chữ ký số đã lưu">
                                    <i class="fas fa-shield-alt"></i> Đã xác thực
                                </span>
                            </c:when>
                            <c:when test="${order.verificationStatus == 'TAMPERED'}">
                                <span class="verify-badge verify-tampered" title="Dữ liệu đơn hàng đã bị thay đổi so với lúc ký, có thể đã bị sửa trực tiếp trong database">
                                    <i class="fas fa-exclamation-triangle"></i> Dữ liệu đã thay đổi - Cần xác thực lại
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="verify-badge verify-none" title="Đơn hàng này chưa từng được xác thực bằng chữ ký số">
                                    <i class="fas fa-shield"></i> Chưa xác thực
                                </span>
                            </c:otherwise>
                        </c:choose>
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
                        <c:if test="${order.verificationStatus == 'TAMPERED'}">
                            <br>
                            <button class="btn-reverify" onclick="openReVerifyModal(${order.id})">
                                <i class="fas fa-redo"></i> Yêu cầu xác thực lại đơn hàng
                            </button>
                        </c:if>
                    </div>
                    <div class="order-footer">

                        <div class="order-total">
                            Tổng:
                            <fmt:formatNumber
                                    value="${order.totalAmount}" />
                            VNĐ
                        </div>

                        <div class="order-actions">

                            <a href="${pageContext.request.contextPath}/download-order?id=${order.id}"
                               class="btn-download-order">

                                <i class="fas fa-download"></i>
                                Tải đơn hàng

                            </a>

                        </div>

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

<!-- Modal Xác Thực Lại Đơn Hàng -->
<div id="reVerifyModal" style="
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
        width: 700px;
        max-width: 95%;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    ">
        <h3 style="text-align: center; margin-bottom: 20px;">Xác Thực Lại Đơn Hàng</h3>

        <div id="reVerifyInfo" style="
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 4px;
            background: #e9ecef;
            font-size: 13px;
            color: #495057;
        ">
            <i class="fa fa-database"></i>
            Dữ liệu đơn hàng hiện tại và Public Key sẽ được hệ thống tự động lấy từ cơ sở dữ liệu.
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display: block; font-weight: bold; margin-bottom: 8px;">
                <i class="fas fa-exchange-alt"></i> So sánh dữ liệu (dòng đỏ là phần đã bị thay đổi):
            </label>
            <div id="reVerifyCompareBox" style="
                border: 1px solid #ddd;
                border-radius: 4px;
                max-height: 280px;
                overflow-y: auto;
                font-family: monospace;
                font-size: 12px;
            ">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: #f8f9fa; position: sticky; top: 0;">
                            <th style="text-align: left; padding: 6px 10px; border-bottom: 1px solid #ddd; width: 50%;">Lúc ký lần trước</th>
                            <th style="text-align: left; padding: 6px 10px; border-bottom: 1px solid #ddd; width: 50%;">Hiện tại trong hệ thống</th>
                        </tr>
                    </thead>
                    <tbody id="reVerifyCompareBody">
                        <tr><td colspan="2" style="padding: 10px; color: #999;">Đang tải dữ liệu...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">Chữ ký số mới (signature.sig):</label>
            <div id="chooseVersionSection">

                <div style="
        padding:15px;
        background:#fff3cd;
        border:1px solid #ffeeba;
        border-radius:6px;
        margin-bottom:20px;
    ">
                    Đơn hàng đã bị thay đổi.
                    Bạn muốn sử dụng dữ liệu nào?
                </div>

                <div style="
        display:flex;
        gap:10px;
        justify-content:center;
        margin-bottom:20px;
    ">

                    <button
                            onclick="useOldOrder()"
                            class="btn btn-danger">

                        Sử dụng đơn hàng cũ

                    </button>

                    <button
                            onclick="useNewOrder()"
                            class="btn btn-success">

                        Sử dụng đơn hàng mới

                    </button>

                </div>

            </div>

            <!-- ẨN TOÀN BỘ PHẦN XÁC THỰC MỚI -->
            <div id="newOrderSection" style="display:none;">

                <div style="margin-bottom:15px">

                    <a id="downloadNewOrderBtn"
                       class="btn btn-primary">

                        <i class="fa fa-download"></i>
                        Tải đơn hàng mới

                    </a>

                </div>

                <input type="file"
                       id="reVerifySignatureFile"
                       class="form-control"
                       accept=".sig">

                <div style="margin-bottom: 15px;">
                    <label style="display:block;
                      font-weight:bold;
                      margin-bottom:5px;">
                        Mã băm (SHA-256) của dữ liệu hiện tại:
                    </label>

                    <textarea id="reVerifyHashDisplay"
                              readonly
                              style="
                    width:100%;
                    height:60px;
                    background:#f8f9fa;
                    border:1px solid #ddd;
                    border-radius:4px;
                    padding:10px;
                    font-family:monospace;
                    font-size:12px;
                    resize:none;
                  ">
        </textarea>
                </div>

                <div id="reVerifyResult"
                     style="
            margin-bottom:20px;
            padding:10px;
            border-radius:4px;
            display:none;
            text-align:center;
            font-weight:bold;
         ">
                </div>

                <div style="
        display:flex;
        gap:10px;
        justify-content:center;
        flex-wrap:wrap;
    ">

                    <button onclick="verifyAndSaveSignature()"
                            style="
                    background-color:#28a745;
                    color:white;
                    border:none;
                    padding:10px 15px;
                    border-radius:5px;
                    cursor:pointer;
                ">

                        <i class="fa fa-check-circle"></i>
                        Xác thực & Lưu lại

                    </button>

                </div>

            </div>
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: bold; margin-bottom: 5px;">Mã băm (SHA-256) của dữ liệu hiện tại:</label>
            <textarea id="reVerifyHashDisplay" readonly style="
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

        <div id="reVerifyResult" style="
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 4px;
            display: none;
            text-align: center;
            font-weight: bold;
        "></div>

        <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;">
            <button onclick="verifyAndSaveSignature()" style="
                background-color: #28a745;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                cursor: pointer;
            ">
                <i class="fa fa-check-circle"></i> Xác thực &amp; Lưu lại
            </button>

            <button onclick="closeReVerifyModal()" style="
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

    // --- Re-verify Logic (cho đơn hàng đã bị TAMPERED) ---

    let reVerifyOrderId = null;
    let reVerifyDocumentContent = null;  // Snapshot hiện tại của đơn hàng, lấy từ DB
    let reVerifyOriginalContent = null;  // Snapshot đã ký lần gần nhất (để so sánh), có thể null
    let reVerifyPublicKey = null;        // Public key (Base64) của user, lấy từ bảng rsa_keys
    let reVerifyHash = null;             // Hash SHA-256 (hex) của snapshot hiện tại

    function openReVerifyModal(orderId) {
        reVerifyOrderId = orderId;
        document.getElementById('reVerifyModal').style.display = 'flex';
        document.getElementById('reVerifySignatureFile').value = '';
        document.getElementById('reVerifyHashDisplay').value = '';
        document.getElementById('reVerifyResult').style.display = 'none';
        document.getElementById('reVerifyCompareBody').innerHTML =
            '<tr><td colspan="2" style="padding: 10px; color: #999;">Đang tải dữ liệu...</td></tr>';
        document.getElementById("chooseVersionSection").style.display = "block";
        document.getElementById("newOrderSection").style.display = "none";
        document.getElementById("downloadNewOrderBtn").href = '${pageContext.request.contextPath}/download-order?id=' + orderId;
        reVerifyDocumentContent = null;
        reVerifyOriginalContent = null;
        reVerifyPublicKey = null;
        reVerifyHash = null;


        loadReVerifyData(orderId);
    }

    function closeReVerifyModal() {
        document.getElementById('reVerifyModal').style.display = 'none';
    }

    // Lấy snapshot HIỆN TẠI của đơn hàng (đọc trực tiếp từ DB) + snapshot đã ký lần trước (nếu có) + public key
    function loadReVerifyData(orderId) {
        const infoBox = document.getElementById('reVerifyInfo');
        infoBox.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang lấy dữ liệu đơn hàng hiện tại và Public Key...';

        $.ajax({
            url: '${pageContext.request.contextPath}/get-order-verification-data',
            type: 'GET',
            data: { orderId: orderId },
            dataType: 'json',
            success: async function(response) {
                if (!response.success) {
                    infoBox.innerHTML = '<i class="fa fa-exclamation-triangle"></i> ' + (response.message || 'Không thể lấy dữ liệu xác thực');
                    return;
                }

                reVerifyDocumentContent = response.documentContent;
                reVerifyOriginalContent = response.originalDocumentContent; // có thể là null
                reVerifyPublicKey = response.publicKey;

                infoBox.innerHTML = '<i class="fa fa-check-circle" style="color:#28a745"></i> Đã lấy dữ liệu đơn hàng hiện tại (RSA ' + response.keySize + ' bit).';

                renderCompareTable(reVerifyOriginalContent, reVerifyDocumentContent);
                await reHashDocument();
            },
            error: function() {
                infoBox.innerHTML = '<i class="fa fa-exclamation-triangle"></i> Lỗi khi lấy dữ liệu xác thực từ server';
            }
        });
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Render bảng so sánh dòng-theo-dòng giữa snapshot đã ký lần trước và snapshot hiện tại.
    // Mỗi dòng trong snapshot có dạng "Nhãn: giá trị" (Dia chi, So dien thoai, Don gia, ...),
    // nên việc so từng dòng giúp người dùng thấy ngay đúng trường nào bị thay đổi.
    function renderCompareTable(original, current) {
        const tbody = document.getElementById('reVerifyCompareBody');
        tbody.innerHTML = '';

        if (!original) {
            tbody.innerHTML =
                '<tr><td colspan="2" style="padding: 10px; color: #999;">' +
                'Không có dữ liệu gốc để so sánh (đơn này được ký trước khi tính năng so sánh được bổ sung). ' +
                'Bên dưới là dữ liệu hiện tại của đơn hàng.</td></tr>';

            const lines = (current || '').split('\n');
            lines.forEach(function(line) {
                tbody.innerHTML +=
                    '<tr><td style="padding: 4px 10px; border-bottom: 1px solid #f1f1f1;"></td>' +
                    '<td style="padding: 4px 10px; border-bottom: 1px solid #f1f1f1;">' + escapeHtml(line) + '</td></tr>';
            });
            return;
        }

        const originalLines = original.split('\n');
        const currentLines = current.split('\n');
        const maxLines = Math.max(originalLines.length, currentLines.length);

        for (let i = 0; i < maxLines; i++) {
            const oldLine = originalLines[i] !== undefined ? originalLines[i] : '';
            const newLine = currentLines[i] !== undefined ? currentLines[i] : '';
            const changed = oldLine !== newLine;

            const rowStyle = changed ? 'background:#fee2e2;' : '';
            const oldCellStyle = changed ? 'color:#991b1b; text-decoration: line-through;' : 'color:#495057;';
            const newCellStyle = changed ? 'color:#991b1b; font-weight:bold;' : 'color:#495057;';

            tbody.innerHTML +=
                '<tr style="' + rowStyle + '">' +
                '<td style="padding: 4px 10px; border-bottom: 1px solid #f1f1f1; ' + oldCellStyle + '">' + escapeHtml(oldLine) + '</td>' +
                '<td style="padding: 4px 10px; border-bottom: 1px solid #f1f1f1; ' + newCellStyle + '">' + escapeHtml(newLine) + '</td>' +
                '</tr>';
        }
    }

    async function reHashDocument() {
        if (!reVerifyDocumentContent) return;
        const msgBuffer = new TextEncoder().encode(reVerifyDocumentContent);
        const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        reVerifyHash = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
        document.getElementById('reVerifyHashDisplay').value = reVerifyHash;
    }

    function reVerifyPemToArrayBuffer(pem) {
        const lines = pem.split('\n');
        let b64 = "";
        for (let line of lines) {
            if (!line.includes("-----") && line.trim() !== "") {
                b64 += line.trim();
            }
        }
        const binaryStr = window.atob(b64);
        const bytes = new Uint8Array(binaryStr.length);
        for (let i = 0; i < binaryStr.length; i++) {
            bytes[i] = binaryStr.charCodeAt(i);
        }
        return bytes.buffer;
    }

    function reVerifyReadFileAsArrayBuffer(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = (e) => resolve(e.target.result);
            reader.onerror = (e) => reject(e);
            reader.readAsArrayBuffer(file);
        });
    }

    // Xác thực chữ ký mới (ký trên dữ liệu HIỆN TẠI) ngay trên trình duyệt,
    // nếu hợp lệ thì gửi lên server để server xác minh lại lần 2 và lưu vào DB.
    async function verifyAndSaveSignature() {
        const sigFile = document.getElementById('reVerifySignatureFile').files[0];
        const resultDiv = document.getElementById('reVerifyResult');

        if (!reVerifyDocumentContent || !reVerifyPublicKey || !reVerifyHash) {
            alert('Chưa lấy được dữ liệu đơn hàng / Public Key từ hệ thống. Vui lòng thử lại.');
            return;
        }
        if (!sigFile) {
            alert('Vui lòng tải lên file chữ ký (.sig) mới ký trên dữ liệu hiện tại.');
            return;
        }

        try {
            const sigBuffer = await reVerifyReadFileAsArrayBuffer(sigFile);

            resultDiv.style.display = 'none';

            let sigRaw;
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

            const binaryDer = reVerifyPemToArrayBuffer(reVerifyPublicKey);
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

            const dataToVerify = new TextEncoder().encode(reVerifyHash);

            const isValid = await window.crypto.subtle.verify(
                "RSASSA-PKCS1-v1_5",
                publicKey,
                sigRaw,
                dataToVerify
            );

            resultDiv.style.display = 'block';

            if (!isValid) {
                resultDiv.style.backgroundColor = '#f8d7da';
                resultDiv.style.color = '#721c24';
                resultDiv.innerHTML = '<i class="fa fa-times"></i> Chữ ký không hợp lệ với dữ liệu đơn hàng hiện tại!';
                return;
            }

            // Chữ ký hợp lệ ở client -> gửi lên server xác minh lại lần 2 và lưu vào DB
            $.post('${pageContext.request.contextPath}/order/re-verify',
            {
                orderId: reVerifyOrderId,
                    action: "USE_NEW_ORDER",
                signature: sigString,
                documentHash: reVerifyHash
            }, function(res) {
                resultDiv.style.display = 'block';
                if (res.success) {
                    resultDiv.style.backgroundColor = '#d4edda';
                    resultDiv.style.color = '#155724';
                    resultDiv.innerHTML = '<i class="fa fa-check"></i> Xác thực lại thành công! Đơn hàng đã được đánh dấu hợp lệ.';
                    setTimeout(function() {
                        closeReVerifyModal();
                        location.reload();
                    }, 1200);
                } else {
                    resultDiv.style.backgroundColor = '#f8d7da';
                    resultDiv.style.color = '#721c24';
                    resultDiv.innerHTML = '<i class="fa fa-times"></i> ' + (res.message || 'Lưu chữ ký thất bại');
                }
            }, 'json').fail(function() {
                resultDiv.style.display = 'block';
                resultDiv.style.backgroundColor = '#f8d7da';
                resultDiv.style.color = '#721c24';
                resultDiv.innerHTML = 'Lỗi kết nối khi lưu chữ ký lên server';
            });

        } catch (err) {
            console.error(err);
            resultDiv.style.display = 'block';
            resultDiv.style.backgroundColor = '#fff3cd';
            resultDiv.innerHTML = 'Lỗi xử lý file (Kiểm tra định dạng file chữ ký .sig)';
        }
    }

    // Đóng modal khi click ra ngoài
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('reVerifyModal');
        if (event.target === modal) closeReVerifyModal();
    });

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
    function useNewOrder() {

        document
            .getElementById("chooseVersionSection")
            .style.display = "none";

        document
            .getElementById("newOrderSection")
            .style.display = "block";
    }
    function useOldOrder() {

        if (!confirm(
            "Khôi phục đơn hàng về trạng thái lúc ký?"
        )) {
            return;
        }

        $.ajax({

            url:
                '${pageContext.request.contextPath}/order/revert',

            type: 'POST',

            data: {
                orderId: reVerifyOrderId
            },

            dataType: 'json',

            success: function(res) {

                if (res.success) {

                    alert(
                        'Đã khôi phục đơn hàng cũ thành công'
                    );

                    closeReVerifyModal();

                    location.reload();

                } else {

                    alert(
                        res.message ||
                        'Khôi phục thất bại'
                    );
                }
            },

            error: function() {

                alert(
                    'Không thể kết nối server'
                );
            }
        });
    }

</script>
</body>
</html>
