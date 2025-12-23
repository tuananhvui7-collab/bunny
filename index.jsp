<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bunny Shop - Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-bunny sticky-top">
        <div class="container">
            <a class="navbar-brand" href="home">
                <i class="fa-solid fa-rabbit" style="color: var(--bunny-dark-pink);"></i> Bunny Shop
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="home">Trang Chủ</a></li>
                    <li class="nav-item">
                        <c:choose>
                            <c:when test="${sessionScope.account != null}">
                                <a class="nav-link" href="profile">Tài Khoản</a>
                            </c:when>
                            <c:otherwise>
                                <a class="nav-link" href="login">Tài Khoản</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="cart">Giỏ Hàng <span class="badge bg-danger rounded-pill">${sessionScope.cart == null ? 0 : fn:length(sessionScope.cart)}</span></a></li>
                </ul>

                <form action="home" method="GET" class="d-flex me-3">
                    <input class="form-control me-2 rounded-pill" type="search" name="keyword" value="${searchKeyword}" placeholder="Tìm váy, áo dài...">
                    <button class="btn btn-outline-light" type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>

                <c:if test="${sessionScope.account == null}">
                    <a href="login" class="btn btn-bunny-primary">Đăng Nhập</a>
                </c:if>

                <c:if test="${sessionScope.account != null}">
                    <div class="dropdown">
                        <button class="btn btn-bunny-outline dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            Xin chào, ${sessionScope.account.hoten}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item fw-bold" href="wallet" style="color: var(--bunny-dark-pink);">
                                <i class="fa-solid fa-wallet"></i> Ví của tôi: <fmt:formatNumber value="${sessionScope.balance}" type="number"/> đ
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="profile">Hồ sơ của tôi</a></li>
                            <li><a class="dropdown-item" href="order-history">Đơn mua</a></li>
                            
                            <c:if test="${sessionScope.account.roleID == 2}">
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger fw-bold" href="employee-orders">Trang Quản Lý</a></li>
                            </c:if>
                            
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="logout">Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>
    </nav>

    <div class="container-fluid p-0 mb-5 position-relative">
        <div style="background: url('https://img.freepik.com/free-photo/clothing-rack-with-floral-hawaiian-shirts-hangers-hat_23-2149366018.jpg') no-repeat center center; background-size: cover; height: 400px; width: 100%;">
            <div class="d-flex flex-column justify-content-center align-items-center h-100" style="background: rgba(0,0,0,0.3);">
                <h1 class="text-white display-4 fw-bold">Khám Phá Phong Cách Của Bạn</h1>
                <p class="text-white fs-5">Hàng ngàn trang phục độc đáo cho mọi dịp đặc biệt</p>
                <div class="input-group w-50 mt-3">
                    <input type="text" class="form-control rounded-start-pill py-3 px-4" placeholder="Tìm kiếm áo dài, váy cưới, cosplay...">
                    <button class="btn btn-bunny-primary rounded-end-pill px-4" type="button">Tìm Kiếm</button>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <h3 class="text-center mb-4 fw-bold text-secondary">Danh Mục Nổi Bật</h3>
        <div class="d-flex justify-content-center gap-3">
            <button class="btn btn-outline-secondary rounded-pill px-4">Áo Dài</button>
            <button class="btn btn-outline-secondary rounded-pill px-4">Váy Dạ Hội</button>
            <button class="btn btn-outline-secondary rounded-pill px-4">Cosplay</button>
            <button class="btn btn-outline-secondary rounded-pill px-4">Cổ Trang</button>
            <button class="btn btn-outline-secondary rounded-pill px-4">Lễ Phục Tốt Nghiệp</button>
        </div>
    </div>

    <div class="container my-5">
    <h3 class="section-title">Sản phẩm nổi bật</h3>
    
    <!-- g-2 trên mobile, g-4 trên desktop -->
    <div class="row g-2 g-md-3 g-lg-4">
        
        <c:forEach items="${featuredList}" var="p">
            <!-- col-6 (2 cột mobile), col-md-4 (3 cột tablet), col-lg-3 (4 cột desktop) -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card-product">
                    <div class="card-img-container">
                        <img src="${p.imageURL}" alt="${p.name}">
                        <span class="badge-status bg-success text-white">${p.status}</span>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">${p.name}</h5>
                        <span class="price-tag">${p.rentalPrice} đ</span>
                        <a href="detail?id=${p.productID}" class="btn-bunny-primary">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        
    </div>
</div>
    <footer class="bg-light text-center text-lg-start mt-auto py-4">
        <div class="container text-center">
            <p class="text-muted mb-0">© 2025 Bunny Shop. Designed for Java Web Project.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>