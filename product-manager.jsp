<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="assets/css/style.css" rel="stylesheet">
    
    <style>
        .sidebar { background-color: #1e1e2d; min-height: 100vh; padding: 20px; display: flex; flex-direction: column; border-right: 1px solid #2d2d3f; }
        .sidebar-brand { color: #D9869B; font-weight: 800; margin-bottom: 30px; }
        .nav-link { color: #a2a3b7; padding: 12px 15px; border-left: 3px solid transparent; transition: 0.2s; }
        .nav-link:hover, .nav-link.active { color: #D9869B; border-left-color: #D9869B; font-weight: 700; }
        .main-content { background: #f5f8fa; min-height: 100vh; padding: 20px; }
        .card-header { background-color: white; border-bottom: 2px solid #f0f0f0; }
        .btn-bunny-primary { background-color: #D9869B; color: white; border: none; }
        .btn-bunny-primary:hover { background-color: #c07d92; color: white; }
        .table-hover tbody tr:hover { background-color: #f9f9f9; }
        @media (max-width: 768px) {
            .container-fluid { flex-direction: column; }
            .sidebar { width: 100%; }
            .main-content { width: 100%; }
            .table { font-size: 0.9rem; }
        }
    </style>
</head>
<body>
    <div class="container-fluid d-flex">
        <!-- SIDEBAR -->
        <div class="sidebar" style="width: 220px; flex-shrink: 0;">
            <div class="sidebar-brand">
                <h5 class="m-0"><i class="fa-solid fa-shirt"></i> Bunny Shop</h5>
                <small class="text-muted">Quản Lý SP</small>
            </div>
            <nav class="nav flex-column">
                <a href="employee-orders" class="nav-link">
                    <i class="fa-solid fa-file-invoice me-2"></i> Xử Lý Đơn
                </a>
                <a href="product-manager" class="nav-link active">
                    <i class="fa-solid fa-shirt me-2"></i> Quản Lý SP
                </a>
            </nav>
            <div class="mt-auto">
                <a href="logout" class="text-decoration-none text-muted d-block">
                    <i class="fa-solid fa-right-from-bracket me-2"></i> Đăng xuất
                </a>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content" style="flex: 1;">
            <!-- HEADER -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-dark">Quản Lý Sản Phẩm</h3>
                <button class="btn btn-bunny-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                    <i class="fa-solid fa-plus me-2"></i> Thêm Sản Phẩm Mới
                </button>
            </div>

            <!-- THÔNG BÁO -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-check-circle me-2"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-exclamation-circle me-2"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- BẢNG SẢN PHẨM -->
            <div class="card border-0 shadow-sm">
                <div class="card-header">
                    <h5 class="m-0 fw-bold">Danh Sách Sản Phẩm (${products.size()} cái)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã SP</th>
                                    <th style="width: 40%">Tên Sản Phẩm</th>
                                    <th>Danh Mục</th>
                                    <th class="text-end">Giá Thuê</th>
                                    <th class="text-center">Tồn Kho</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-center">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${products}" var="p">
                                    <tr>
                                        <td class="fw-bold text-primary">${p.productID}</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${p.imageURL}" width="45" height="45" class="rounded me-2" 
                                                     onerror="this.src='https://via.placeholder.com/45'">
                                                <span>${p.name}</span>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-secondary">${p.categoryID}</span></td>
                                        <td class="text-end fw-bold text-danger">
                                            <fmt:formatNumber value="${p.rentalPrice}" type="number"/> đ
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${p.quantityInStock > 0 ? 'bg-success' : 'bg-danger'}">
                                                ${p.quantityInStock}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 'Sẵn sàng'}">
                                                    <span class="badge bg-success">✓ Sẵn sàng</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Đã ngừng kinh doanh'}">
                                                    <span class="badge bg-secondary">✗ Ngừng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">${p.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <!-- Nút Chỉnh Sửa -->
                                            <button class="btn btn-sm btn-outline-primary" 
                                                    onclick="editProduct('${p.productID}', '${p.name}', ${p.rentalPrice}, ${p.quantityInStock}, '${p.imageURL}')">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            
                                            <!-- Nút Xóa (Ngừng Kinh Doanh) -->
                                            <c:if test="${p.status != 'Đã ngừng kinh doanh'}">
                                                <form action="product-manager" method="POST" style="display: inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="productId" value="${p.productID}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" 
                                                            onclick="return confirm('Ngừng kinh doanh sản phẩm này?');">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${p.status == 'Đã ngừng kinh doanh'}">
                                                <span class="text-muted small">Đã xóa</span>
                                            </c:if>
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

    <!-- MODAL: THÊM SẢN PHẨM MỚI -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="product-manager" method="POST">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold">Thêm Sản Phẩm Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mã Sản Phẩm *</label>
                            <input type="text" name="productId" class="form-control" placeholder="VD: AYA01" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Danh Mục *</label>
                                <select name="categoryId" class="form-control" required>
                                    <option value="">-- Chọn --</option>
                                    <option value="1">Cosplay Anime</option>
                                    <option value="2">Dạ Hội / Prom</option>
                                    <option value="3">Đồng Phục / School</option>
                                    <option value="4">Set Couple / Nhóm</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Giá Thuê (đ/ngày) *</label>
                                <input type="number" name="rentalPrice" class="form-control" min="0" step="1000" placeholder="200000" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Sản Phẩm *</label>
                            <input type="text" name="name" class="form-control" placeholder="Aya Oosawa - Prom Đỏ" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Số Lượng *</label>
                                <input type="number" name="quantity" class="form-control" min="1" placeholder="5" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">URL Ảnh</label>
                                <input type="text" name="imageURL" class="form-control" placeholder="assets/img/...">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-bunny-primary">Thêm Sản Phẩm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: CHỈNH SỬA SẢN PHẨM -->
    <div class="modal fade" id="editProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="product-manager" method="POST">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold">Chỉnh Sửa Sản Phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" id="editProductId" name="productId">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Sản Phẩm *</label>
                            <input type="text" id="editName" name="name" class="form-control" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Giá Thuê (đ/ngày) *</label>
                                <input type="number" id="editPrice" name="rentalPrice" class="form-control" min="0" step="1000" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Số Lượng *</label>
                                <input type="number" id="editQuantity" name="quantity" class="form-control" min="0" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">URL Ảnh</label>
                            <input type="text" id="editImageURL" name="imageURL" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-bunny-primary">Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm mở modal chỉnh sửa và điền dữ liệu sản phẩm
        function editProduct(id, name, price, quantity, imageURL) {
            document.getElementById('editProductId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editPrice').value = price;
            document.getElementById('editQuantity').value = quantity;
            document.getElementById('editImageURL').value = imageURL;
            
            var editModal = new bootstrap.Modal(document.getElementById('editProductModal'));
            editModal.show();
        }
    </script>
</body>
</html>