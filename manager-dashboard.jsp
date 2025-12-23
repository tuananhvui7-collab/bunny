<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Trị Hệ Thống - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="assets/css/style.css" rel="stylesheet">
    
    <style>
        /* 1. Header Admin: Tối giản, sang trọng */
        .bg-header-dark {
            background-color: #1a1d20; 
            border-bottom: 3px solid var(--bunny-dark-pink); /* Viền hồng tạo điểm nhấn */
        }
        
        .text-bunny-brand {
            color: var(--bunny-dark-pink) !important;
            font-weight: 800;
            letter-spacing: 1px;
        }

        /* 2. STATS CARD: MÀU TƯƠI SÁNG (VIBRANT GRADIENTS) */
        .card-stat {
            border: none;
            border-radius: 15px; /* Bo tròn mềm mại hơn */
            color: #ffffff !important; /* BẮT BUỘC CHỮ TRẮNG */
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1); /* Đổ bóng nổi */
            overflow: hidden;
            position: relative;
        }
        
        .card-stat:hover { 
            transform: translateY(-5px); 
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }

        /* Icon trang trí mờ phía sau */
        .stat-icon {
            font-size: 3.5rem;
            opacity: 0.2; /* Mờ đi để không rối mắt */
            position: absolute;
            right: 15px;
            bottom: 10px;
            color: #fff;
            transform: rotate(-15deg); /* Nghiêng nhẹ tạo kiểu */
        }

        /* --- BẢNG MÀU MỚI: TƯƠI & SẮC NÉT --- */
        
        /* Xanh lá (Doanh thu): Emerald to Teal */
        .bg-stat-green { 
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); 
        } 
        
        /* Xanh dương (Đơn hàng): Royal Blue */
        .bg-stat-blue { 
            background: linear-gradient(135deg, #3a7bd5 0%, #3a6073 100%); 
        }  
        
        /* Xanh ngọc (Khách hàng): Cyan to Blue */
        .bg-stat-cyan { 
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%); 
        }  
        
        /* Cam vàng (Chờ xử lý): Orange to Yellow (Rực rỡ) */
        .bg-stat-warning { 
            background: linear-gradient(135deg, #f12711 0%, #f5af19 100%); 
        }

        /* 3. Icon chức năng quản lý */
        .icon-manage {
            font-size: 3rem;
            color: var(--bunny-dark-pink);
            margin-bottom: 15px;
            transition: 0.3s;
        }
        
        .card-manage:hover .icon-manage {
            transform: scale(1.1);
        }
    </style>
</head>
<body style="background-color: #f8f9fa;">

    <nav class="navbar navbar-dark bg-header-dark sticky-top">
        <div class="container-fluid px-5 py-2">
            <a class="navbar-brand d-flex align-items-center gap-2" href="#">
                <i class="fa-solid fa-user-tie fs-3 text-bunny-brand"></i>
                <span class="fs-4 text-bunny-brand">MANAGER DASHBOARD</span>
            </a>
            
            <div class="d-flex align-items-center gap-3">
                <span class="text-white fw-bold">Xin chào, ${sessionScope.account.hoten}</span>
                <a href="logout" class="btn btn-sm btn-outline-light px-3 rounded-pill">Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h4 class="fw-bold mb-4" style="color: #4a4a4a; border-left: 5px solid var(--bunny-dark-pink); padding-left: 10px;">
            Tổng Quan Kinh Doanh
        </h4>
        
        <div class="row mb-5">
            <div class="col-md-3 mb-3">
                <div class="card card-stat bg-stat-green h-100">
                    <div class="card-body p-4">
                        <div class="position-relative z-1">
                            <h6 class="text-uppercase fw-bold opacity-75 mb-1">Doanh Thu</h6>
                            <h3 class="fw-bolder mb-0">
                                <fmt:formatNumber value="${totalRevenue}" type="number"/> đ
                            </h3>
                        </div>
                        <i class="fa-solid fa-sack-dollar stat-icon"></i>
                    </div>
                </div>
            </div>

            <div class="col-md-3 mb-3">
                <div class="card card-stat bg-stat-blue h-100">
                    <div class="card-body p-4">
                        <div class="position-relative z-1">
                            <h6 class="text-uppercase fw-bold opacity-75 mb-1">Tổng Đơn Hàng</h6>
                            <h3 class="fw-bolder mb-0">${totalOrders}</h3>
                        </div>
                        <i class="fa-solid fa-file-invoice stat-icon"></i>
                    </div>
                </div>
            </div>

            <div class="col-md-3 mb-3">
                <div class="card card-stat bg-stat-cyan h-100">
                    <div class="card-body p-4">
                        <div class="position-relative z-1">
                            <h6 class="text-uppercase fw-bold opacity-75 mb-1">Khách Hàng</h6>
                            <h3 class="fw-bolder mb-0">${totalCustomers}</h3>
                        </div>
                        <i class="fa-solid fa-users stat-icon"></i>
                    </div>
                </div>
            </div>

            <div class="col-md-3 mb-3">
                <div class="card card-stat bg-stat-warning h-100">
                    <div class="card-body p-4">
                        <div class="position-relative z-1">
                            <h6 class="text-uppercase fw-bold opacity-75 mb-1">Chờ Xử Lý</h6>
                            <h3 class="fw-bolder mb-0">${pendingOrders}</h3>
                        </div>
                        <i class="fa-solid fa-bell stat-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="fw-bold mb-3" style="color: #4a4a4a; border-left: 5px solid var(--bunny-dark-pink); padding-left: 10px;">
            Menu Quản Lý
        </h4>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-0 h-100 card-manage">
                    <div class="card-body text-center p-4">
                        <i class="fa-solid fa-shirt icon-manage"></i>
                        <h5 class="fw-bold mt-2">Quản Lý Sản Phẩm</h5>
                        <p class="text-muted small">Thêm mới, sửa giá, nhập kho...</p>
                        <a href="product-manager" class="btn btn-bunny-outline w-100 mt-2">Truy cập</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-0 h-100 card-manage">
                    <div class="card-body text-center p-4">
                        <i class="fa-solid fa-users-gear icon-manage"></i>
                        <h5 class="fw-bold mt-2">Quản Lý Nhân Viên</h5>
                        <p class="text-muted small">Tạo tài khoản, phân quyền...</p>
                        <a href="employee-manager" class="btn btn-bunny-outline w-100 mt-2">Truy cập</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-0 h-100 card-manage">
                    <div class="card-body text-center p-4">
                        <i class="fa-solid fa-chart-line icon-manage"></i>
                        <h5 class="fw-bold mt-2">Báo Cáo Chi Tiết</h5>
                        <p class="text-muted small">Xuất file Excel, biểu đồ...</p>
                        <a href="reports" class="btn btn-bunny-outline w-100 mt-2">Truy cập</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>