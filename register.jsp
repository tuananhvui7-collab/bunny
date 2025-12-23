<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center py-5">

    <div class="card border-0 shadow-lg p-4" style="width: 500px; border-radius: 20px;">
        <div class="card-body">
            <h3 class="text-center fw-bold mb-4" style="color: var(--bunny-dark-pink);">Đăng Ký Tài Khoản</h3>
            
            <%-- Thông báo lỗi --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger text-center p-2"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="register" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-bold text-muted">Họ và Tên</label>
                    <input type="text" name="hoten" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-muted">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-muted">Mật khẩu</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-muted">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-bold text-muted">Địa chỉ nhận hàng</label>
                    <textarea name="address" class="form-control" rows="2" required></textarea>
                </div>
                
                <button type="submit" class="btn btn-bunny-primary w-100 py-2 fw-bold mb-3">
                    Đăng Ký Ngay
                </button>
                
                <div class="text-center">
                    <span class="text-muted small">Đã có tài khoản? </span>
                    <a href="login.jsp" class="text-decoration-none fw-bold" style="color: var(--bunny-dark-pink);">Đăng nhập</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>