<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt Hàng Thành Công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light text-center d-flex flex-column justify-content-center align-items-center" style="height: 100vh;">

    <div class="card border-0 shadow p-5" style="border-radius: 20px;">
        <div class="mb-4">
            <i class="fa-solid fa-circle-check text-success display-1"></i>
        </div>
        <h2 class="fw-bold mb-3" style="color: var(--bunny-dark-pink);">Đặt Thuê Thành Công!</h2>
        <p class="text-muted mb-4">${message}</p>
        
        <div class="d-flex gap-3 justify-content-center">
            <a href="home" class="btn btn-outline-secondary px-4">Về Trang Chủ</a>
            <a href="order-history" class="btn btn-bunny-primary px-4">Xem Đơn Hàng</a>
        </div>
    </div>

</body>
</html>