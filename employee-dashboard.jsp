<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Đơn Hàng - Nhân Viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="assets/css/style.css" rel="stylesheet">
    
    <style>
        /* === 1. SIDEBAR (SỬA LẠI MÀU SẮC CHO RÕ NÉT) === */
        .sidebar {
            background-color: #1e1e2d; /* Màu đen tím than sang trọng hơn đen tuyền */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #2d2d3f;
        }
        
        /* Logo & Brand */
        .sidebar-brand {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            background-color: #1b1b28;
        }
        
        .sidebar-brand h4 {
            color: #D9869B !important; /* <--- Đã đổi thành màu Hồng Đất (Bunny Pink) */
            font-weight: 800;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }
        
        .sidebar-brand small {
            color: #888; /* Màu xám sáng cho dòng phụ */
            font-size: 0.85rem;
        }
        
        /* Menu Items */
        .nav-link {
            color: #a2a3b7 !important; /* QUAN TRỌNG: Màu chữ xám sáng (Dễ đọc trên nền đen) */
            padding: 16px 25px;
            font-weight: 500;
            font-size: 0.95rem;
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }
        
        .nav-link i {
            width: 25px; /* Cố định chiều rộng icon để chữ thẳng hàng */
            font-size: 1.1rem;
        }
        
        /* Hover: Sáng lên */
        .nav-link:hover {
            color: #ffffff !important;
            background-color: rgba(255,255,255,0.03);
        }
        
        /* ACTIVE: Đổi nền sang màu hồng nhạt, chữ hồng đậm hoặc trắng */
        .nav-link.active {
            background-color: #2b2b40; /* Nền active sáng hơn nền sidebar chút */
            color: #D9869B !important; /* Chữ màu Hồng Bunny */
            border-left-color: #D9869B; /* Viền trái màu Hồng */
            font-weight: 700;
        }

        /* Nút đăng xuất ở dưới cùng */
        .logout-area {
            margin-top: auto;
            border-top: 1px solid rgba(255,255,255,0.05);
            padding: 20px;
        }
        
        /* Sửa màu link đăng xuất cho rõ */
        .logout-area a {
            color: #a2a3b7 !important; 
            text-decoration: none;
            display: block;
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            transition: 0.3s;
        }
        .logout-area a:hover {
            background-color: #2b2b40;
            color: #ff6b6b !important; /* Hover ra màu đỏ nhạt báo hiệu logout */
        }

        /* === 2. MAIN CONTENT (GIỮ NGUYÊN) === */
        .main-content { background-color: #f5f8fa; min-height: 100vh; }
        
        .main-header {
            background: white;
            padding: 15px 30px;
            box-shadow: 0 0 20px rgba(76, 103, 147, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .card-table {
            border: none;
            box-shadow: 0 0 20px rgba(76, 103, 147, 0.03);
            border-radius: 12px;
            background: white;
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .card-header-bunny {
            background-color: white;
            border-bottom: 1px solid #f0f2f5;
            padding: 20px 25px;
        }

        .table thead th {
            background-color: #f9f9f9;
            color: #5e6278;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #f0f2f5;
            padding: 15px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            color: #3f4254;
            font-weight: 500;
        }
        
        /* Style cho chi tiết sản phẩm */
        .product-item {
            background: #fff;
            border: 1px dashed #e4e6ef;
            border-radius: 6px;
            padding: 8px;
            margin-bottom: 5px;
        }
    </style>    
</head>
<body>

<div class="container-fluid">
    <div class="row">
        
        <div class="col-md-2 p-0 sidebar">
            <div class="sidebar-brand">
                <h4 class="fw-bold mb-0" style="color: var(--bunny-dark-pink);">Bunny Shop</h4>
                <small class="text-muted">Employee Panel</small>
            </div>
            
            <nav class="nav flex-column mt-3">
                <a class="nav-link active" href="employee-orders">
                    <i class="fa-solid fa-file-invoice me-2"></i> Xử lý Đơn hàng
                </a>
                <a class="nav-link" href="product-manager">
                    <i class="fa-solid fa-shirt me-2"></i> Quản lý Sản phẩm
                </a>
                <a class="nav-link" href="#">
                    <i class="fa-solid fa-rotate-left me-2"></i> Tiếp nhận Trả hàng
                </a>
                <a class="nav-link" href="#">
                    <i class="fa-solid fa-headset me-2"></i> Phản hồi Khách hàng
                </a>
            </nav>            
            <div class="mt-auto p-3 border-top border-secondary">
                <a href="logout" class="text-decoration-none text-secondary d-block text-center hover-white">
                    <i class="fa-solid fa-right-from-bracket me-2"></i> Đăng xuất
                </a>
            </div>
        </div>

        <div class="col-md-10 p-0 main-content">
            <div class="main-header">
                <h4 class="fw-bold m-0 text-dark">Xử lý Đơn hàng</h4>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-secondary fw-bold">Xin chào, ${sessionScope.account.hoten}</span>
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.account.hoten}&background=D9869B&color=fff" class="rounded-circle" width="40">
                </div>
            </div>

            <div class="container-fluid p-4">
                
                <div class="card card-table">
                    <div class="card-header-bunny">
                        <h5 class="fw-bold m-0 text-primary"><i class="fa-solid fa-clock me-2"></i>Đơn hàng chờ xử lý</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4">Mã Đơn</th>
                                    <th style="width: 35%;">Chi tiết kiểm hàng</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày Thuê - Trả</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="o">
                                    <c:if test="${o.status != 'Hoàn tất' && o.status != 'Đã hủy'}">
                                        <tr>
                                            <td class="ps-4 fw-bold text-primary">#${o.orderID}</td>
                                            
                                            <td>
                                                <div class="d-flex flex-column">
                                                    <c:forEach items="${o.details}" var="d">
                                                        <div class="d-flex align-items-center product-item">
                                                            <img src="${d.productImg}" width="40" height="40" class="rounded me-2" style="object-fit: cover;">
                                                            <div class="small" style="line-height: 1.2;">
                                                                <strong class="text-dark">${d.productName}</strong> <br>
                                                                <span class="text-muted" style="font-size: 0.85rem;">Size: ${d.size} | SL: ${d.quantity}</span>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                    <div class="text-danger small fw-bold mt-1">
                                                        Cọc: <fmt:formatNumber value="${o.depositAmount}" type="number"/> đ
                                                    </div>
                                                </div>
                                            </td>

                                            <td>${o.customerID}</td>
                                            <td class="small">
                                                <div class="text-success"><i class="fa-solid fa-calendar-check me-1"></i>${o.startDate}</div>
                                                <div class="text-danger mt-1"><i class="fa-solid fa-calendar-xmark me-1"></i>${o.expectedReturnDate}</div>
                                            </td>
                                            
                                            <td>
                                                <c:choose>
                                                    <c:when test="${o.status == 'Chờ xác nhận'}"><span class="badge bg-warning text-dark">Mới</span></c:when>
                                                    <c:when test="${o.status == 'Đang thuê'}"><span class="badge bg-primary">Đang thuê</span></c:when>
                                                    <c:when test="${o.status == 'Đang trả hàng'}"><span class="badge bg-info text-dark">Khách trả đồ</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">${o.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:if test="${o.status == 'Chờ xác nhận'}">
                                                    <form action="employee-orders" method="POST" class="d-inline">
                                                        <input type="hidden" name="action" value="confirm">
                                                        <input type="hidden" name="orderId" value="${o.orderID}">
                                                        <button class="btn btn-sm btn-bunny-primary text-white">
                                                            <i class="fa-solid fa-check"></i> Xác nhận
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <c:if test="${o.status == 'Đang trả hàng'}">
                                                    <button class="btn btn-sm btn-success text-white" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#refundModal"
                                                            onclick="setRefundData('${o.orderID}', ${o.depositAmount})">
                                                        <i class="fa-solid fa-hand-holding-dollar"></i> Hoàn tiền
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card card-table">
                    <div class="card-header-bunny">
                        <h5 class="fw-bold m-0 text-secondary"><i class="fa-solid fa-history me-2"></i>Đơn hàng đã hoàn thành / hủy</h5>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="ps-4">Mã Đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày Trả Thực Tế</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="o">
                                    <c:if test="${o.status == 'Hoàn tất' || o.status == 'Đã hủy'}">
                                        <tr>
                                            <td class="ps-4 text-muted">#${o.orderID}</td>
                                            <td>${o.customerID}</td>
                                            <td>${o.expectedReturnDate}</td> <td>
                                                <c:choose>
                                                    <c:when test="${o.status == 'Hoàn tất'}"><span class="badge bg-success">Hoàn tất</span></c:when>
                                                    <c:when test="${o.status == 'Đã hủy'}"><span class="badge bg-secondary">Đã hủy</span></c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${o.status == 'Hoàn tất'}">
                                                    <small class="text-danger fw-bold">Phạt: <fmt:formatNumber value="${o.compensationFee}" type="number"/> đ</small>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="refundModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="employee-orders" method="POST">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold">Xử Lý Trả Hàng & Hoàn Tiền</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="refund">
                    <input type="hidden" name="orderId" id="modalOrderId">
                    
                    <div class="alert alert-info">
                        <i class="fa-solid fa-info-circle"></i> Kiểm tra kỹ sản phẩm trước khi hoàn cọc.
                    </div>

                    <div class="mb-3">
                        <label class="fw-bold">Tiền cọc ban đầu:</label>
                        <input type="text" class="form-control fw-bold text-success" id="modalDeposit" readonly style="background: #f8f9fa;">
                    </div>
                    
                    <div class="mb-3">
                        <label class="fw-bold text-danger">Chi phí bồi thường / Hư hỏng (nếu có):</label>
                        <div class="input-group">
                            <input type="number" name="penalty" class="form-control border-danger" value="0" min="0">
                            <span class="input-group-text">VNĐ</span>
                        </div>
                        <small class="text-muted">Nhập 0 nếu hàng nguyên vẹn.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-success fw-bold">Xác Nhận Hoàn Tiền</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Script gán dữ liệu vào Modal (Giữ nguyên)
    function setRefundData(id, deposit) {
        document.getElementById('modalOrderId').value = id;
        document.getElementById('modalDeposit').value = new Intl.NumberFormat('vi-VN').format(deposit) + " đ";
    }
</script>

</body>
</html>