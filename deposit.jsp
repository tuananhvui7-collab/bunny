<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nạp Tiền - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="assets/css/style.css" rel="stylesheet">
    
    <style>
        .bunny-dashboard-container { display: flex; max-width: 1200px; margin: 30px auto; gap: 20px; padding: 0 15px; }
        .dashboard-sidebar { width: 180px; flex-shrink: 0; }
        .dashboard-content { flex-grow: 1; width: 0; }
        .user-profile-mini { display: flex; align-items: center; padding-bottom: 15px; margin-bottom: 15px; border-bottom: 1px solid #eee; }
        .user-avatar { width: 45px; height: 45px; border-radius: 50%; border: 1px solid #e1e1e1; margin-right: 10px; }
        .sidebar-menu { list-style: none; padding: 0; }
        .sidebar-menu li { margin-bottom: 12px; }
        .sidebar-menu a { text-decoration: none; color: #333; display: flex; align-items: center; font-size: 0.95rem; transition: 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { color: var(--bunny-dark-pink); font-weight: 700; }
        .sidebar-menu i { width: 25px; text-align: center; margin-right: 5px; }
        
        .deposit-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 15px; padding: 30px; margin-bottom: 25px; box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2); }
        .deposit-label { font-size: 0.9rem; text-transform: uppercase; opacity: 0.9; margin-bottom: 5px; }
        .deposit-amount { font-size: 2.5rem; font-weight: 700; letter-spacing: 1px; }
        
        .preset-button { width: 100%; padding: 10px; margin-bottom: 10px; border: 2px solid #ddd; background: white; color: #333; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .preset-button:hover { border-color: var(--bunny-dark-pink); color: var(--bunny-dark-pink); }
        .preset-button.active { background: var(--bunny-dark-pink); color: white; border-color: var(--bunny-dark-pink); }
        
        @media (max-width: 768px) {
            .bunny-dashboard-container { flex-direction: column; }
            .dashboard-sidebar { width: 100%; }
            .deposit-card { padding: 20px; }
            .deposit-amount { font-size: 1.8rem; }
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-bunny sticky-top">
        <div class="container">
            <a class="navbar-brand" href="home"><i class="fa-solid fa-rabbit" style="color: var(--bunny-dark-pink);"></i> Bunny Shop</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="home">Trang chủ</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="bunny-dashboard-container">
        <aside class="dashboard-sidebar">
            <div class="user-profile-mini">
                <img src="https://via.placeholder.com/50" alt="Avatar" class="user-avatar">
                <div style="overflow: hidden;">
                    <div style="font-weight: 700;">Chào bạn</div>
                    <a href="profile" style="font-size: 0.8rem; color: #888; text-decoration: none;"><i class="fas fa-pen"></i> Sửa Hồ Sơ</a>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="order-history"><i class="fas fa-file-invoice-dollar"></i> Đơn Mua</a></li>
                <li><a href="profile"><i class="fas fa-user"></i> Tài Khoản Của Tôi</a></li>
                <li><a href="wallet"><i class="fas fa-wallet"></i> Ví Của Tôi</a></li>
                <li><a href="deposit" class="active"><i class="fas fa-plus-circle"></i> Nạp Tiền</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <!-- CARD SỐ DƯ HIỆN TẠI -->
            <div class="deposit-card">
                <div class="deposit-label">Số dư hiện tại</div>
                <div class="deposit-amount">
                    <fmt:formatNumber value="${currentBalance}" type="currency" currencySymbol="VNĐ"/>
                </div>
                <small style="opacity: 0.9;">Cập nhật lúc: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="HH:mm:ss"/></small>
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

            <!-- FORM NẠP TIỀN -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-bottom">
                    <h5 class="m-0 fw-bold">Nạp Tiền Vào Ví</h5>
                </div>
                <div class="card-body p-4">
                    <form id="depositForm" action="deposit" method="POST">
                        <!-- CHỌN SỐ TIỀN NHANH -->
                        <h6 class="fw-bold mb-3">Chọn số tiền</h6>
                        <div class="row mb-4">
                            <div class="col-md-6 mb-2">
                                <button type="button" class="preset-button" onclick="setAmount(100000)">
                                    <i class="fa-solid fa-plus me-2"></i> 100.000 đ
                                </button>
                            </div>
                            <div class="col-md-6 mb-2">
                                <button type="button" class="preset-button" onclick="setAmount(500000)">
                                    <i class="fa-solid fa-plus me-2"></i> 500.000 đ
                                </button>
                            </div>
                            <div class="col-md-6 mb-2">
                                <button type="button" class="preset-button" onclick="setAmount(1000000)">
                                    <i class="fa-solid fa-plus me-2"></i> 1.000.000 đ
                                </button>
                            </div>
                            <div class="col-md-6 mb-2">
                                <button type="button" class="preset-button" onclick="setAmount(5000000)">
                                    <i class="fa-solid fa-plus me-2"></i> 5.000.000 đ
                                </button>
                            </div>
                        </div>

                        <!-- NHẬP SỐ TIỀN TỰ DO -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Hoặc nhập số tiền khác</label>
                            <div class="input-group">
                                <input type="number" 
                                       id="amountInput" 
                                       name="amount" 
                                       class="form-control form-control-lg" 
                                       placeholder="10000" 
                                       min="1000" 
                                       max="100000000" 
                                       step="1000"
                                       onchange="formatAmount()"
                                       required>
                                <span class="input-group-text fw-bold">VNĐ</span>
                            </div>
                            <small class="text-muted">Tối thiểu: 1.000đ | Tối đa: 100.000.000đ</small>
                        </div>

                        <!-- HIỂN THỊ SỐ TIỀN FORMATTED -->
                        <div class="alert alert-info mb-4">
                            <strong>Số tiền sẽ nạp:</strong> 
                            <span class="fw-bold fs-5" id="displayAmount">0 đ</span>
                        </div>

                        <!-- NÚT NẠP TIỀN -->
                        <button type="submit" class="btn btn-bunny-primary w-100 py-3 fw-bold fs-5">
                            <i class="fa-solid fa-wallet me-2"></i> TIẾN HÀNH NẠP TIỀN
                        </button>

                        <a href="wallet" class="btn btn-light w-100 mt-2">
                            <i class="fa-solid fa-arrow-left me-2"></i> Quay Lại Ví
                        </a>
                    </form>
                </div>
            </div>

            <!-- THÔNG TIN HƯỚNG DẪN -->
            <div class="card border-0 shadow-sm mt-4">
                <div class="card-header bg-white border-bottom">
                    <h5 class="m-0 fw-bold">Thông Tin Nạp Tiền</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold text-success"><i class="fa-solid fa-circle-check me-2"></i> Ưu điểm</h6>
                            <ul class="small">
                                <li>Nạp tiền ngay lập tức</li>
                                <li>Không tính phí nạp</li>
                                <li>An toàn và bảo mật</li>
                                <li>Dễ dàng thanh toán</li>
                            </ul>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h6 class="fw-bold text-info"><i class="fa-solid fa-circle-info me-2"></i> Cách sử dụng</h6>
                            <ul class="small">
                                <li>Chọn số tiền cần nạp</li>
                                <li>Nhập hoặc chọn phương thức</li>
                                <li>Xác nhận giao dịch</li>
                                <li>Tiền sẽ cập nhật ngay</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm: Đặt số tiền từ nút preset
        function setAmount(value) {
            document.getElementById('amountInput').value = value;
            formatAmount();
            
            // Highlight nút được chọn
            document.querySelectorAll('.preset-button').forEach(btn => btn.classList.remove('active'));
            event.target.closest('.preset-button').classList.add('active');
        }

        // Hàm: Format lại hiển thị số tiền
        function formatAmount() {
            const amount = parseInt(document.getElementById('amountInput').value) || 0;
            const formatted = new Intl.NumberFormat('vi-VN').format(amount) + ' đ';
            document.getElementById('displayAmount').textContent = formatted;
        }

        // Gọi lại khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            formatAmount();
        });
    </script>
</body>
</html>