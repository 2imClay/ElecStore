<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ElecStore</title>
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css"/>
</head>
<body>
    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="#" class="sidebar-brand">
                <i class="fas fa-crown"></i>
                <span>ElecStore Admin</span>
            </a>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="#dashboard" class="active" onclick="showSection('dashboard')">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="#users" onclick="showSection('users')">
                    <i class="fas fa-users"></i>
                    <span>Quản lý User</span>
                </a>
            </li>
            <li>
                <a href="#products" onclick="showSection('products')">
                    <i class="fas fa-box"></i>
                    <span>Quản lý Sản phẩm</span>
                </a>
            </li>
            <li>
                <a href="#categories" onclick="showSection('categories')">
                    <i class="fas fa-tags"></i>
                    <span>Quản lý Danh mục</span>
                </a>
            </li>
            <li>
                <a href="#orders" onclick="showSection('orders')">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Quản lý Đơn hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-home"></i>
                    <span>Về Trang chủ</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Đăng xuất</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- ==================== MAIN CONTENT ==================== -->
    <main class="main-content">
        <!-- TOPBAR -->
        <div class="topbar">
            <div class="topbar-left">
                <h1 id="pageTitle">Dashboard</h1>
            </div>
            <div class="topbar-right">
                <div class="topbar-user">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=6366f1&color=fff" alt="Admin">
                    <div class="topbar-user-info">
                        <span class="topbar-user-name">${sessionScope.userName}</span>
                        <span class="topbar-user-role">Administrator</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- CONTENT AREA -->
        <div class="content-area">
            <!-- ==================== DASHBOARD SECTION ==================== -->
            <div id="dashboard-section" class="content-section">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon primary">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-content">
                            <h3>${totalUsers != null ? totalUsers : '0'}</h3>
                            <p>Tổng người dùng</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon success">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="stat-content">
                            <h3>${totalProducts != null ? totalProducts : '0'}</h3>
                            <p>Tổng sản phẩm</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon warning">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stat-content">
                            <h3>${totalOrders != null ? totalOrders : '0'}</h3>
                            <p>Tổng đơn hàng</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon danger">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-content">
                            <h3><fmt:formatNumber value="${totalRevenue != null ? totalRevenue : '0'}"/> VNĐ</h3>
                            <p>Doanh thu</p>
                        </div>
                    </div>
                </div>

                <div class="section-card">
                    <div class="section-header">
                        <h2 class="section-title">Đơn hàng gần đây</h2>
                    </div>
                    <div class="section-body">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="order" begin="0" end="4">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td>${order.customerName}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatNumber value="${order.totalAmount}"/> VNĐ</td>
                                            <td>
                                                <span class="badge-status ${order.status == 'completed' ? 'badge-completed' : order.status == 'processing' ? 'badge-processing' : order.status == 'cancelled' ? 'badge-cancelled' : 'badge-pending'}">
                                                    ${order.status == 'completed' ? 'Hoàn thành' : order.status == 'processing' ? 'Đang xử lý' : order.status == 'cancelled' ? 'Đã hủy' : 'Chờ xử lý'}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================== USERS SECTION ==================== -->
            <div id="users-section" class="content-section" style="display: none;">
                <div class="section-card">
                    <div class="section-header">
                        <h2 class="section-title">Danh sách người dùng</h2>
                    </div>
                    <div class="section-body">
                        <div class="search-filter-bar">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Tìm kiếm người dùng..." id="searchUser">
                            </div>
                            <select class="filter-select" id="filterUserRole">
                                <option value="">Tất cả vai trò</option>
                                <option value="admin">Admin</option>
                                <option value="user">User</option>
                            </select>
                            <select class="filter-select" id="filterUserStatus">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>

                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên</th>
                                        <th>Email</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.firstName} ${user.lastName}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <span class="badge-status ${user.role == 'admin' ? 'badge-admin' : 'badge-user'}">
                                                    ${user.role}
                                                </span>
                                            </td>
                                            <td>
                                                <label class="toggle-switch">
                                                    <input type="checkbox" ${user.status == 'active' ? 'checked' : ''}
                                                           onchange="toggleUserStatus(${user.id}, this.checked)">
                                                    <span class="toggle-slider"></span>
                                                </label>
                                            </td>
                                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <button class="btn-action btn-edit" onclick="editUser(${user.id})">
                                                    <i class="fas fa-edit"></i> Sửa
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================== PRODUCTS SECTION ==================== -->
            <div id="products-section" class="content-section" style="display: none;">
                <div class="section-card">
                    <div class="section-header">
                        <h2 class="section-title">Danh sách sản phẩm</h2>
                        <button class="btn-primary" onclick="showAddProductModal()">
                            <i class="fas fa-plus"></i> Thêm sản phẩm
                        </button>
                    </div>
                    <div class="section-body">
                        <div class="search-filter-bar">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Tìm kiếm sản phẩm..." id="searchProduct">
                            </div>
                            <select class="filter-select" id="filterProductCategory">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Hình ảnh</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
<%--                                        <th>Tồn kho</th>--%>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${products}" var="product">
                                        <tr>
                                            <td>${product.id}</td>
                                            <td>
                                                <img src="${product.imageUrl}" alt="${product.name}" 
                                                     style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px;">
                                            </td>
                                            <td>${product.name}</td>
                                            <td>${product.categoryName}</td>
                                            <td><fmt:formatNumber value="${product.price}"/> VNĐ</td>
<%--                                            <td>${product.stock}</td>--%>
                                            <td>
                                                <label class="toggle-switch">
                                                    <input type="checkbox" ${product.status == 'active' ? 'checked' : ''}
                                                           onchange="toggleProductStatus(${product.id}, this.checked)">
                                                    <span class="toggle-slider"></span>
                                                </label>
                                            </td>
                                            <td>
                                                <button class="btn-action btn-edit" onclick="editProduct(${product.id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn-action btn-delete" onclick="deleteProduct(${product.id})">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================== CATEGORIES SECTION ==================== -->
            <div id="categories-section" class="content-section" style="display: none;">
                <div class="section-card">
                    <div class="section-header">
                        <h2 class="section-title">Danh sách danh mục</h2>
                        <button class="btn-primary" onclick="showAddCategoryModal()">
                            <i class="fas fa-plus"></i> Thêm danh mục
                        </button>
                    </div>
                    <div class="section-body">
                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên danh mục</th>
<%--                                        <th>Mô tả</th>--%>
<%--                                        <th>Số sản phẩm</th>--%>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${categories}" var="category">
                                        <tr>
                                            <td>${category.id}</td>
                                            <td>${category.name}</td>
<%--                                            <td>${category.description}</td>--%>
<%--                                            <td>${category.productCount}</td>--%>
                                            <td>
                                                <label class="toggle-switch">
                                                    <input type="checkbox" ${category.status == 'active' ? 'checked' : ''}
                                                           onchange="toggleCategoryStatus(${category.id}, this.checked)">
                                                    <span class="toggle-slider"></span>
                                                </label>
                                            </td>
                                            <td>
                                                <button class="btn-action btn-edit" onclick="editCategory(${category.id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn-action btn-delete" onclick="deleteCategory(${category.id})">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================== ORDERS SECTION ==================== -->
            <div id="orders-section" class="content-section" style="display: none;">
                <div class="section-card">
                    <div class="section-header">
                        <h2 class="section-title">Danh sách đơn hàng</h2>
                    </div>
                    <div class="section-body">
                        <div class="search-filter-bar">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" placeholder="Tìm kiếm đơn hàng..." id="searchOrder">
                            </div>
                            <select class="filter-select" id="filterOrderStatus">
                                <option value="">Tất cả trạng thái</option>
                                <option value="pending">Chờ xử lý</option>
                                <option value="processing">Đang xử lý</option>
                                <option value="completed">Hoàn thành</option>
                                <option value="cancelled">Đã hủy</option>
                            </select>
                        </div>

                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="order">
                                        <tr>
                                            <td>#${order.id}</td>
                                            <td>${order.customerName}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatNumber value="${order.totalAmount}"/> VNĐ</td>
                                            <td>
                                                <select class="form-select form-select-sm" 
                                                        onchange="updateOrderStatus(${order.id}, this.value)"
                                                        style="width: auto;">
                                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Đang xử lý</option>
                                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                                </select>
                                            </td>
                                            <td>
                                                <button class="btn-action btn-view" onclick="viewOrder(${order.id})">
                                                    <i class="fas fa-eye"></i> Xem
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- ==================== MODALS ==================== -->
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa người dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" id="editUserId">
                        <div class="mb-3">
                            <label class="form-label">Tên</label>
                            <input type="text" class="form-control" id="userName" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="userEmail" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vai trò</label>
                            <select class="form-select" id="userRole">
                                <option value="user">User</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveUser()">Lưu thay đổi</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add/Edit Product Modal -->
    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalTitle">Thêm sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="productForm">
                        <input type="hidden" id="productId">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tên sản phẩm *</label>
                                <input type="text" class="form-control" id="productName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Danh mục *</label>
                                <select class="form-select" id="productCategory" required>
                                    <option value="">Chọn danh mục</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giá *</label>
                                <input type="number" class="form-control" id="productPrice" step="0.01" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tồn kho *</label>
                                <input type="number" class="form-control" id="productStock" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" id="productDescription" rows="3"></textarea>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label">URL hình ảnh</label>
                                <input type="text" class="form-control" id="productImage" placeholder="https://...">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveProduct()">Lưu</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add/Edit Category Modal -->
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="categoryModalTitle">Thêm danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="categoryForm">
                        <input type="hidden" id="categoryId">
                        <div class="mb-3">
                            <label class="form-label">Tên danh mục *</label>
                            <input type="text" class="form-control" id="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" id="categoryDescription" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="saveCategory()">Lưu</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Order Modal -->
    <div class="modal fade" id="viewOrderModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết đơn hàng #<span id="orderNumber"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="orderDetails">
                        <p>Đang tải...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Show section
        function showSection(section) {
            document.querySelectorAll('.content-section').forEach(el => el.style.display = 'none');
            document.getElementById(section + '-section').style.display = 'block';

            document.querySelectorAll('.sidebar-menu a').forEach(el => el.classList.remove('active'));
            event.target.closest('a').classList.add('active');

            const titles = {
                'dashboard': 'Dashboard',
                'users': 'Quản lý User',
                'products': 'Quản lý Sản phẩm',
                'categories': 'Quản lý Danh mục',
                'orders': 'Quản lý Đơn hàng'
            };
            document.getElementById('pageTitle').textContent = titles[section];
        }

        // ==================== USER FUNCTIONS ====================
        function toggleUserStatus(userId, isActive) {
            const status = isActive ? 'active' : 'inactive';
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/dashboard',
                method: 'POST',
                dataType: 'json',
                data: {
                    action: 'toggleUserStatus',
                    userId: userId,
                    status: status
                },
                success: function(response) {
                    console.log('Response:', response);
                    if (response.success) {
                        alert('Cập nhật thành công!');
                    } else {
                        alert('Lỗi' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error:', xhr.responseText, error);
                    alert('Lỗi: ' + error);
                }
            });
        }

        function editUser(userId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/user/detail?id=' + userId,
                method: 'GET',
                success: function(user) {
                    $('#editUserId').val(user.id);
                    $('#userName').val(user.name);
                    $('#userEmail').val(user.email);
                    $('#userRole').val(user.role);
                    new bootstrap.Modal(document.getElementById('editUserModal')).show();
                }
            });
        }

        function saveUser() {
            const userId = $('#editUserId').val();
            const role = $('#userRole').val();

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/user/save',
                method: 'POST',
                data: { userId: userId, role: role },
                success: function(response) {
                    if (response.success) {
                        alert('Lưu thành công!');
                        bootstrap.Modal.getInstance(document.getElementById('editUserModal')).hide();
                        location.reload();
                    }
                }
            });
        }

        // ==================== PRODUCT FUNCTIONS ====================
        function showAddProductModal() {
            $('#productModalTitle').text('Thêm sản phẩm');
            $('#productForm')[0].reset();
            $('#productId').val('');
            new bootstrap.Modal(document.getElementById('productModal')).show();
        }

        function editProduct(productId) {
            $('#productModalTitle').text('Chỉnh sửa sản phẩm');
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/product/detail?id=' + productId,
                method: 'GET',
                success: function(product) {
                    $('#productId').val(product.id);
                    $('#productName').val(product.name);
                    $('#productCategory').val(product.categoryId);
                    $('#productPrice').val(product.price);
                    $('#productStock').val(product.stock);
                    $('#productDescription').val(product.description);
                    $('#productImage').val(product.imageUrl);
                    new bootstrap.Modal(document.getElementById('productModal')).show();
                }
            });
        }

        function deleteProduct(productId) {
            if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/product/delete',
                    method: 'POST',
                    data: { productId: productId },
                    success: function(response) {
                        if (response.success) {
                            alert('Xóa thành công!');
                            location.reload();
                        }
                    }
                });
            }
        }

        function toggleProductStatus(productId, isActive) {
            const status = isActive ? 'active' : 'inactive';
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/dashboard',
                method: 'POST',
                dataType: 'json',
                data: {
                    action: 'toggleProductStatus',
                    productId: productId, status: status },
                success: function(response) {
                    console.log('Response:', response);
                    if (response.success) {
                        alert('Cập nhật thành công!');
                    } else {
                        alert('Lỗi' + response.message);
                    }
                },
            });
        }

        function saveProduct() {
            const formData = {
                id: $('#productId').val(),
                name: $('#productName').val(),
                categoryId: $('#productCategory').val(),
                price: $('#productPrice').val(),
                stock: $('#productStock').val(),
                description: $('#productDescription').val(),
                image: $('#productImage').val()
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/product/save',
                method: 'POST',
                data: formData,
                success: function(response) {
                    if (response.success) {
                        alert('Lưu thành công!');
                        bootstrap.Modal.getInstance(document.getElementById('productModal')).hide();
                        location.reload();
                    }
                }
            });
        }

        // ==================== CATEGORY FUNCTIONS ====================
        function showAddCategoryModal() {
            $('#categoryModalTitle').text('Thêm danh mục');
            $('#categoryForm')[0].reset();
            $('#categoryId').val('');
            new bootstrap.Modal(document.getElementById('categoryModal')).show();
        }

        function editCategory(categoryId) {
            $('#categoryModalTitle').text('Chỉnh sửa danh mục');
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/category/detail?id=' + categoryId,
                method: 'GET',
                success: function(category) {
                    $('#categoryId').val(category.id);
                    $('#categoryName').val(category.name);
                    $('#categoryDescription').val(category.description);
                    new bootstrap.Modal(document.getElementById('categoryModal')).show();
                }
            });
        }

        function deleteCategory(categoryId) {
            if (confirm('Bạn có chắc muốn xóa danh mục này?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/category/delete',
                    method: 'POST',
                    data: { categoryId: categoryId },
                    success: function(response) {
                        if (response.success) {
                            alert('Xóa thành công!');
                            location.reload();
                        }
                    }
                });
            }
        }

        function toggleCategoryStatus(categoryId, isActive) {
            const status = isActive ? 'active' : 'inactive';
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/dashboard',
                method: 'POST',
                dataType: 'json',
                data: {
                    action: 'toggleCategoryStatus',
                    categoryId: categoryId, status: status },
                success: function(response) {
                    console.log('Response:', response);
                    if (response.success) {
                        alert('Cập nhật thành công!');
                    } else {
                        alert('Lỗi' + response.message);
                    }
                },
            });
        }

        function saveCategory() {
            const formData = {
                id: $('#categoryId').val(),
                name: $('#categoryName').val(),
                description: $('#categoryDescription').val()
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/admin/category/save',
                method: 'POST',
                data: formData,
                success: function(response) {
                    if (response.success) {
                        alert('Lưu thành công!');
                        bootstrap.Modal.getInstance(document.getElementById('categoryModal')).hide();
                        location.reload();
                    }
                }
            });
        }

        // ==================== ORDER FUNCTIONS ====================
        function updateOrderStatus(orderId, status) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/dashboard',
                method: 'POST',
                dataType: 'json',
                data: {
                    action: 'updateOrderStatus',
                    orderId: orderId, status: status },
                success: function(response) {
                    console.log('Response:', response);
                    if (response.success) {
                        alert('Cập nhật thành công!');
                    } else {
                        alert('Lỗi' + response.message);
                    }
                },
            });
        }

        function viewOrder(orderId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/order/detail?id=' + orderId,
                method: 'GET',
                success: function(order) {
                    $('#orderNumber').text(order.id);
                    let html = '<div class="mb-3"><strong>Khách hàng:</strong> ' + order.customerName + '</div>';
                    html += '<div class="mb-3"><strong>Địa chỉ:</strong> ' + order.address + '</div>';
                    html += '<div class="mb-3"><strong>Số điện thoại:</strong> ' + order.phone + '</div>';
                    html += '<h6 class="mt-4">Sản phẩm:</h6>';
                    html += '<table class="table"><thead><tr><th>Tên</th><th>Số lượng</th><th>Giá</th></tr></thead><tbody>';
                    if (order.items) {
                        order.items.forEach(item => {
                            html += '<tr><td>' + item.productName + '</td><td>' + item.quantity + '</td><td>$' + item.price + '</td></tr>';
                        });
                    }
                    html += '</tbody></table>';
                    html += '<div class="mt-3"><strong>Tổng cộng: $' + order.totalAmount + '</strong></div>';
                    $('#orderDetails').html(html);
                    new bootstrap.Modal(document.getElementById('viewOrderModal')).show();
                }
            });
        }
    </script>
</body>
</html>
