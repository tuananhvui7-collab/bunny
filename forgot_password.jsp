<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">

    <div class="card border-0 shadow-lg p-4" style="width: 450px; border-radius: 20px;">
        <div class="card-body">
            <h3 class="text-center fw-bold mb-4" style="color: var(--bunny-dark-pink);">
                <i class="fa-solid fa-key me-2"></i> Quên Mật Khẩu
            </h3>
            
            <%-- Hiển thị lỗi nếu có --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger text-center p-2">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="forgot-password" method="POST">
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">Nhập Email của bạn</label>
                    <input type="email" name="email" class="form-control" placeholder="example@email.com" required>
                    <small class="text-muted d-block mt-2">
                        Chúng tôi sẽ gửi mật khẩu tạm thời đến email này. 
                        Sau khi đăng nhập, vui lòng đổi mật khẩu ngay.
                    </small>
                </div>
                
                <button type="submit" class="btn btn-bunny-primary w-100 py-2 fw-bold mb-3">
                    Gửi Yêu Cầu Reset
                </button>
                
                <div class="text-center">
                    <a href="login.jsp" class="text-decoration-none small" style="color: var(--bunny-dark-pink);">
                        ← Quay lại Đăng Nhập
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>