<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Đơn Hàng - Bunny Shop</title>
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

        /* Content */
        .dashboard-content { flex-grow: 1; width: 0; }
        
        /* Tabs (Bo góc 12px) */
        .order-tabs { 
            display: flex; background: #fff; margin-bottom: 20px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); border-radius: 12px; overflow: hidden;
        }
        .tab-item { flex: 1; text-align: center; padding: 15px 0; cursor: pointer; font-size: 1rem; color: #333; border-bottom: 3px solid transparent; text-decoration: none; transition: 0.2s; }
        .tab-item:hover, .tab-item.active { 
            color: var(--bunny-dark-pink, #D9869B); border-bottom: 3px solid var(--bunny-dark-pink, #D9869B); font-weight: 700; background-color: #FFF5F7;
        }
        
        /* Card Đơn hàng (Bo góc 12px) */
        .order-card { 
            background: #fff; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            border: 1px solid #f0f0f0; border-radius: 12px; overflow: hidden; 
        }
        .card-header-custom { padding: 20px 25px; border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between; align-items: center; }
        .card-body-custom { padding: 0 25px; }
        .card-footer-custom { padding: 20px 25px; background: #fffefb; border-top: 1px solid #f5f5f5; }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-bunny sticky-top">
        <div class="container">
            <a class="navbar-brand" href="home"><i class="fa-solid fa-rabbit" style="color: var(--bunny-dark-pink, #D9869B);"></i> Bunny Shop</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="home">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="cart">Giỏ Hàng <span class="badge bg-danger rounded-pill">${sessionScope.cart == null ? 0 : fn:length(sessionScope.cart)}</span></a></li>
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
                <li><a href="order-history" class="active"><i class="fas fa-file-invoice-dollar"></i> Đơn Mua</a></li>
                <li><a href="profile"><i class="fas fa-user"></i> Tài Khoản Của Tôi</a></li>
                <li><a href="wallet"><i class="fas fa-wallet"></i> Ví Của Tôi</a></li>
                <li><a href="#"><i class="fas fa-bell"></i> Thông Báo</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            <div class="order-tabs">
                <a href="order-history?status=all" class="tab-item ${param.status == null || param.status == 'all' ? 'active' : ''}">Tất cả</a>
                <a href="order-history?status=wait" class="tab-item ${param.status == 'wait' ? 'active' : ''}">Chờ xác nhận</a>
                <a href="order-history?status=renting" class="tab-item ${param.status == 'renting' ? 'active' : ''}">Đang thuê</a>
                <a href="order-history?status=return" class="tab-item ${param.status == 'return' ? 'active' : ''}">Đang trả hàng</a>
                <a href="order-history?status=done" class="tab-item ${param.status == 'done' ? 'active' : ''}">Hoàn tất</a>
                <a href="order-history?status=cancel" class="tab-item ${param.status == 'cancel' ? 'active' : ''}">Đã hủy</a>
            </div>

            <c:if test="${empty orders}">
                <div class="text-center py-5 bg-white rounded shadow-sm" style="border-radius: 12px;">
                    <i class="fa-solid fa-box-open fa-3x text-muted mb-3"></i>
                    <p class="text-muted">Không tìm thấy đơn hàng nào.</p>
                    <a href="home" class="btn text-white" style="background: var(--bunny-dark-pink, #D9869B); border-radius: 8px;">Dạo Một Vòng Xem Sao?</a>
                </div>
            </c:if>

            <c:forEach items="${orders}" var="o">
                <div class="order-card">
                    <div class="card-header-custom">
                        <div><span class="fw-bold" style="font-size: 1.05rem;">Đơn hàng #${o.orderID}</span></div>
                        <div>
                            <c:choose>
                                <c:when test="${o.status == 'Chờ xác nhận'}"><span class="text-warning fw-bold text-uppercase"><i class="fa-regular fa-clock"></i> CHỜ XÁC NHẬN</span></c:when>
                                <c:when test="${o.status == 'Đang thuê'}"><span class="text-primary fw-bold text-uppercase"><i class="fa-solid fa-shirt"></i> ĐANG THUÊ</span></c:when>
                                <c:when test="${o.status == 'Đang trả hàng'}"><span class="text-info fw-bold text-uppercase"><i class="fa-solid fa-rotate-left"></i> ĐANG TRẢ HÀNG</span></c:when>
                                <c:when test="${o.status == 'Hoàn tất'}"><span class="text-success fw-bold text-uppercase"><i class="fa-solid fa-check-circle"></i> HOÀN TẤT</span></c:when>
                                <c:when test="${o.status == 'Đã hủy'}"><span class="text-secondary fw-bold text-uppercase"><i class="fa-solid fa-ban"></i> ĐÃ HỦY</span></c:when>
                            </c:choose>
                        </div>
                    </div>
                    <div class="card-body-custom">
                        <c:forEach items="${o.details}" var="d">
                            <div class="d-flex align-items-center py-3 border-bottom">
                                <img src="${d.productImg}" alt="${d.productName}" class="rounded border me-3" style="width: 80px; height: 80px; object-fit: cover;">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1 fw-bold text-dark">${d.productName}</h6>
                                    <div class="text-muted small"><span>Phân loại: ${d.size}</span> <span class="mx-1">|</span> <span>x${d.quantity}</span></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="card-footer-custom">
                        <div class="d-flex justify-content-end align-items-center mb-3">
                            <span class="text-muted me-2">Tiền cọc đã đóng:</span>
                            <span class="text-danger fw-bold fs-5"><fmt:formatNumber value="${o.depositAmount}" type="currency" currencySymbol="VNĐ"/></span>
                        </div>
                        <div class="d-flex justify-content-end gap-2">
                            <a href="home" class="btn btn-outline-secondary" style="border-radius: 8px;">Thuê Lại</a>
                            <c:if test="${o.status == 'Chờ xác nhận'}">
                                <form action="order-history" method="POST" onsubmit="return confirm('Hủy đơn?');">
                                    <input type="hidden" name="orderId" value="${o.orderID}"><input type="hidden" name="action" value="cancel">
                                    <button type="submit" class="btn btn-danger px-4" style="border-radius: 8px;">Hủy Đơn Hàng</button>
                                </form>
                            </c:if>
                            <c:if test="${o.status == 'Đang thuê'}">
                                <form action="order-history" method="POST">
                                    <input type="hidden" name="orderId" value="${o.orderID}"><input type="hidden" name="action" value="return">
                                    <button type="submit" class="btn text-white px-4" style="background-color: #D9869B; border-radius: 8px;">Hoàn Trả Hàng</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </main>
    </div>
</body>
</html>