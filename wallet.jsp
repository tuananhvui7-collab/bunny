<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ví Của Tôi - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="assets/css/style.css" rel="stylesheet">

    <style>
        /* --- CSS GIỮ NGUYÊN --- */
        .bunny-dashboard-container { display: flex; max-width: 1200px; margin: 30px auto; gap: 20px; padding: 0 15px; align-items: flex-start; }
        .dashboard-sidebar { width: 180px; flex-shrink: 0; }
        .user-profile-mini { display: flex; align-items: center; padding-bottom: 15px; margin-bottom: 15px; border-bottom: 1px solid #eee; }
        .user-avatar { width: 45px; height: 45px; border-radius: 50%; border: 1px solid #e1e1e1; margin-right: 10px; }
        .sidebar-menu { list-style: none; padding: 0; }
        .sidebar-menu li { margin-bottom: 12px; }
        .sidebar-menu a { text-decoration: none; color: #333; display: flex; align-items: center; font-size: 0.95rem; transition: 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { color: var(--bunny-dark-pink, #D9869B); font-weight: 700; }
        .sidebar-menu i { width: 25px; text-align: center; margin-right: 5px; }
        .dashboard-content { flex-grow: 1; width: 0; }
        .wallet-card-banner { background: linear-gradient(100deg, #ea6ea3 0%, #f48fb1 100%); border-radius: 12px; padding: 30px 40px; color: white; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 8px 20px rgba(234, 110, 163, 0.25); margin-bottom: 25px; }
        .wallet-label { font-size: 0.9rem; text-transform: uppercase; opacity: 0.9; margin-bottom: 5px; }
        .wallet-balance { font-size: 2.5rem; font-weight: 700; letter-spacing: 1px; }
        .btn-deposit { background-color: white; color: #d85c8e; border: none; padding: 10px 25px; border-radius: 8px; font-weight: 700; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); transition: 0.2s; text-decoration: none; }
        .btn-deposit:hover { background-color: #fff0f5; color: #c24675; transform: translateY(-2px); }
        .history-section { background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); border: 1px solid #f0f0f0; overflow: hidden; }
        .history-header { padding: 18px 25px; border-bottom: 1px solid #f0f0f0; font-weight: 700; color: #444; font-size: 1.1rem; }
        
        /* CSS TABLE FIX */
        .table-custom th { font-weight: 600; color: #888; font-size: 0.85rem; border-bottom: 1px solid #eee; padding: 15px 20px; text-transform: uppercase; white-space: nowrap; }
        .table-custom td { padding: 15px 20px; vertical-align: middle; color: #333; font-size: 0.95rem; border-bottom: 1px solid #f9f9f9; }
        .table-custom tr:last-child td { border-bottom: none; }
        
        .col-nowrap { white-space: nowrap; }
        .col-detail { white-space: normal; min-width: 250px; }
        .text-plus { color: #26aa99; font-weight: 700; } 
        .text-minus { color: #ee4d2d; font-weight: 700; } 
        
        .badge-type { padding: 6px 10px; border-radius: 6px; font-weight: 500; font-size: 0.85rem; display: inline-block; white-space: nowrap; }
        .badge-inc { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
        .badge-dec { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
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
                    <div style="font-weight: 700;">Chào, ${sessionScope.account.hoten}</div>
                    <a href="profile" style="font-size: 0.8rem; color: #888; text-decoration: none;"><i class="fas fa-pen"></i> Sửa Hồ Sơ</a>
                </div>
            </div>
            <ul class="sidebar-menu">
                <li><a href="order-history"><i class="fas fa-file-invoice-dollar"></i> Đơn Mua</a></li>
                <li><a href="profile"><i class="fas fa-user"></i> Tài Khoản Của Tôi</a></li>
                <li><a href="wallet" class="active"><i class="fas fa-wallet"></i> Ví Của Tôi</a></li>
                <li><a href="#"><i class="fas fa-bell"></i> Thông Báo</a></li>
            </ul>
        </aside>

        <main class="dashboard-content">
            
            <div class="wallet-card-banner">
                <div>
                    <div class="wallet-label">Số dư hiện tại</div>
                    <div class="wallet-balance">
                        <fmt:formatNumber value="${sessionScope.balance}" type="currency" currencySymbol="VNĐ"/>
                    </div>
                </div>
                <a href="deposit" class="btn-deposit">
                    <i class="fas fa-plus-circle"></i> Nạp Tiền
                </a>
            </div>

            <div class="history-section">
                <div class="history-header">Lịch Sử Giao Dịch</div>
                
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Loại GD</th>
                            <th>Chi tiết / Sản phẩm</th>
                            <th class="text-end">Số tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty history}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <i class="fa-regular fa-folder-open mb-2" style="font-size: 2rem; opacity: 0.5;"></i><br>
                                    Chưa có giao dịch nào.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach items="${history}" var="t">
                            <c:set var="isExpense" value="${t.type.contains('Thanh')}" />
                            
                            <tr>
                                <td class="col-nowrap">
                                    <div style="line-height: 1.2;">
                                        <fmt:formatDate value="${t.timestamp}" pattern="dd-MM-yyyy"/>
                                        <br>
                                        <span class="small text-muted"><fmt:formatDate value="${t.timestamp}" pattern="HH:mm"/></span>
                                    </div>
                                </td> 
                                
                                <td class="col-nowrap">
                                    <c:choose>
                                        <c:when test="${!isExpense}">
                                            <span class="badge-type badge-inc">
                                                <i class="fa-solid fa-arrow-down"></i> ${t.type}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-type badge-dec">
                                                <i class="fa-solid fa-arrow-up"></i> ${t.type}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td class="col-detail text-muted">
                                    <div style="line-height: 1.4;">
                                        ${t.orderInfo}
                                    </div>
                                </td>

                                <td class="text-end fw-bold col-nowrap">
                                    <c:choose>
                                        <c:when test="${!isExpense}">
                                            <span class="text-plus">+ <fmt:formatNumber value="${t.amount}" type="number"/> đ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-minus">- <fmt:formatNumber value="${t.amount}" type="number"/> đ</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="col-nowrap">
                                    <span class="text-success small fw-bold">
                                        <i class="fa-solid fa-check-circle"></i> ${t.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

        </main>
    </div>

</body>
</html>