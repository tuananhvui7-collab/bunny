<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">

    <div class="card border-0 shadow-lg p-4" style="width: 400px; border-radius: 20px;">
        <div class="card-body">
            <h3 class="text-center fw-bold mb-4" style="color: var(--bunny-dark-pink);">Đăng Nhập</h3>
            
            <%-- Hiển thị thông báo lỗi nếu có --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger text-center p-2">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <%-- Hiển thị thông báo thành công nếu có (Từ đăng ký hoặc quên mật khẩu) --%>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success text-center p-2">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="login" method="POST">
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">Email hoặc Tên đăng nhập</label>
                    <input type="email" name="email" class="form-control" placeholder="Nhập email" required>
                </div>
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                </div>
                
                <button type="submit" class="btn btn-bunny-primary w-100 py-2 fw-bold mb-3">
                    Đăng Nhập
                </button>
                
                <div class="text-center">
                    <a href="forgot-password" class="text-decoration-none small text-muted">Quên mật khẩu?</a> | 
                    <a href="register.jsp" class="text-decoration-none small" style="color: var(--bunny-dark-pink);">Đăng ký</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>