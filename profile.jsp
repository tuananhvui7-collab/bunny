<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Của Tôi - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="assets/css/style.css" rel="stylesheet">

    <style>
        /* --- COPY CSS CHUẨN TỪ WALLET SANG --- */
        .bunny-dashboard-container { display: flex; max-width: 1200px; margin: 30px auto; gap: 20px; padding: 0 15px; align-items: flex-start; }
        
        /* Sidebar */
        .dashboard-sidebar { width: 180px; flex-shrink: 0; }
        .user-profile-mini { display: flex; align-items: center; padding-bottom: 15px; margin-bottom: 15px; border-bottom: 1px solid #eee; }
        .user-avatar { width: 45px; height: 45px; border-radius: 50%; border: 1px solid #e1e1e1; margin-right: 10px; }
        .sidebar-menu { list-style: none; padding: 0; }
        .sidebar-menu li { margin-bottom: 12px; }
        .sidebar-menu a { text-decoration: none; color: #333; display: flex; align-items: center; font-size: 0.95rem; transition: 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { color: var(--bunny-dark-pink, #D9869B); font-weight: 700; }
        .sidebar-menu i { width: 25px; text-align: center; margin-right: 5px; }

        /* Content Card Profile (Bo góc 12px) */
        .dashboard-content { 
            flex-grow: 1; width: 0; background: #fff; box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            border-radius: 12px; padding: 30px; border: 1px solid #f0f0f0;
        }

        /* Form Style */
        .profile-header { border-bottom: 1px solid #efefef; padding-bottom: 18px; margin-bottom: 30px; }
        .profile-header h5 { margin: 0; font-size: 1.25rem; font-weight: 600; color: #333; }
        .profile-header p { margin: 3px 0 0; font-size: 0.9rem; color: #555; }
        .profile-form-row { display: flex; align-items: center; margin-bottom: 25px; }
        .profile-label { width: 20%; text-align: right; color: #555555cc; margin-right: 20px; font-size: 0.95rem; }
        .profile-input-group { flex-grow: 1; max-width: 450px; } 
        .form-control-bunny { width: 100%; padding: 10px 15px; border: 1px solid #e0e0e0; border-radius: 8px; outline: none; transition: 0.2s; }
        .form-control-bunny:focus { border-color: #888; box-shadow: 0 0 4px rgba(0,0,0,0.05); }
        .profile-avatar-section { border-left: 1px solid #efefef; display: flex; flex-direction: column; align-items: center; justify-content: center; padding-left: 40px; height: 100%; }
        .avatar-big { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 1px solid #eee; margin-bottom: 20px; }
        .btn-save { background-color: var(--bunny-dark-pink, #D9869B); color: white; border: none; padding: 10px 30px; border-radius: 8px; font-weight: 500; }
        .btn-upload { background: #fff; border: 1px solid #ddd; color: #555; font-size: 0.9rem; padding: 8px 20px; border-radius: 4px; }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-bunny sticky-top">
        <div class="container">
            <a class="navbar-brand" href="home"><i class="fa-solid fa-rabbit" style="color: var(--bunny-dark-pink, #D9869B);"></i> Bunny Shop</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="home">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="cart">Giỏ Hàng <span class="badge bg-danger rounded-pill">${sessionScope.cart == null ? 0 : sessionScope.cart.size()}</span></a></li>
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
                <li><a href="profile" class="active"><i class="fas fa-user"></i> Tài Khoản Của Tôi</a></li>
                <li><a href="wallet"><i class="fas fa-wallet"></i> Ví Của Tôi</a></li>
                <li><a href="#"><i class="fas fa-bell"></i> Thông Báo</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <div class="profile-header">
                <h5>Hồ Sơ Của Tôi</h5>
                <p>Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
            </div>
            <c:if test="${not empty message}">
                <div class="alert alert-success mb-4" role="alert"><i class="fa-solid fa-check-circle me-2"></i> ${message}</div>
            </c:if>

            <form action="profile" method="POST">
                <div class="row">
                    <div class="col-md-8">
                        <div class="profile-form-row">
                            <label class="profile-label">Email</label>
                            <div class="profile-input-group"><span style="font-weight: 500;">${sessionScope.account.email}</span></div>
                        </div>
                        <div class="profile-form-row">
                            <label class="profile-label">Họ và tên</label>
                            <div class="profile-input-group"><input type="text" name="hoten" class="form-control-bunny" value="${sessionScope.account.hoten}" required></div>
                        </div>
                        <div class="profile-form-row">
                            <label class="profile-label">Số điện thoại</label>
                            <div class="profile-input-group"><input type="text" name="phone" class="form-control-bunny" value="${sessionScope.account.phone}" required></div>
                        </div>
                        <div class="profile-form-row">
                            <label class="profile-label">Địa chỉ</label>
                            <div class="profile-input-group"><input type="text" name="address" class="form-control-bunny" value="${sessionScope.account.address}"></div>
                        </div>
                        <div class="profile-form-row">
                            <label class="profile-label">Giới tính</label>
                            <div class="profile-input-group d-flex gap-3">
                                <div class="form-check"><input class="form-check-input" type="radio" name="gender" id="g1" value="Nam"><label class="form-check-label" for="g1">Nam</label></div>
                                <div class="form-check"><input class="form-check-input" type="radio" name="gender" id="g2" value="Nữ" checked><label class="form-check-label" for="g2">Nữ</label></div>
                                <div class="form-check"><input class="form-check-input" type="radio" name="gender" id="g3" value="Khác"><label class="form-check-label" for="g3">Khác</label></div>
                            </div>
                        </div>
                        <div class="profile-form-row">
                            <label class="profile-label"></label>
                            <div class="profile-input-group"><button type="submit" class="btn-save">Lưu</button></div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="profile-avatar-section">
                            <img src="https://via.placeholder.com/150" alt="Avatar" class="avatar-big">
                            <button type="button" class="btn-upload mb-3">Chọn Ảnh</button>
                            <div class="text-muted text-center small">Dụng lượng file tối đa 1 MB<br>Định dạng:.JPEG, .PNG</div>
                        </div>
                    </div>
                </div>
            </form>
        </main>
    </div>
</body>
</html>