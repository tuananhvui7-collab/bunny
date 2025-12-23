<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Thuê - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

    <div class="container my-5">
        <h2 class="text-center fw-bold mb-4" style="color: var(--bunny-dark-pink);">Xác Nhận Đơn Thuê</h2>

        <%-- Hiển thị lỗi từ Backend nếu có --%>
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center fw-bold">${error}</div>
        </c:if>

        <div class="row">
            <div class="col-md-7">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white fw-bold">1. Thông tin người nhận</div>
                    <div class="card-body">
                        <p><strong>Họ tên:</strong> ${sessionScope.account.hoten}</p>
                        <p><strong>SĐT:</strong> ${sessionScope.account.phone}</p>
                        <p><strong>Địa chỉ:</strong> ${sessionScope.account.address}</p>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white fw-bold">2. Thời gian thuê</div>
                    <div class="card-body">
                        <form id="checkoutForm" action="checkout" method="POST">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày nhận đồ</label>
                                    <input type="date" id="startDate" name="startDate" class="form-control" required onchange="validateDates()">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày trả đồ (Dự kiến)</label>
                                    <input type="date" id="returnDate" name="returnDate" class="form-control" required onchange="validateDates()">
                                </div>
                            </div>
                            <small class="text-danger" id="dateError" style="display:none;">* Ngày trả phải sau ngày nhận!</small>
                            <small class="text-muted d-block">* Giá thuê được tính theo số ngày thực tế khi trả.</small>
                        </form>

                        <script>
                            document.addEventListener("DOMContentLoaded", function() {
                                const today = new Date().toISOString().split('T')[0];
                                const startInput = document.getElementById("startDate");
                                const returnInput = document.getElementById("returnDate");
                                startInput.setAttribute('min', today);
                                returnInput.setAttribute('min', today);
                            });

                            function validateDates() {
                                const startInput = document.getElementById("startDate");
                                const returnInput = document.getElementById("returnDate");
                                const errorMsg = document.getElementById("dateError");

                                if (startInput.value) {
                                    returnInput.setAttribute('min', startInput.value);
                                }
                                if (startInput.value && returnInput.value) {
                                    if (returnInput.value < startInput.value) {
                                        errorMsg.style.display = 'block';
                                        returnInput.value = ''; 
                                    } else {
                                        errorMsg.style.display = 'none';
                                    }
                                }
                            }
                        </script>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-danger text-white fw-bold text-center">TỔNG THANH TOÁN</div>
                    <div class="card-body">
                        
                        <c:set var="totalPayNow" value="${totalRental + depositAmount}" />

                        <div class="d-flex justify-content-between mb-2">
                            <span>Tổng tiền thuê (Dự kiến):</span>
                            <span class="fw-bold"><fmt:formatNumber value="${totalRental}" type="number"/> đ</span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-danger fw-bold">Tiền Cọc (30%):</span>
                            <span class="text-danger fw-bold"><fmt:formatNumber value="${depositAmount}" type="number"/> đ</span>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex justify-content-between align-items-center mb-0">
                            <span class="fw-bold fs-5">Cần thanh toán ngay:</span>
                            <span class="fw-bold fs-4" style="color: var(--bunny-dark-pink);">
                                <fmt:formatNumber value="${totalPayNow}" type="number"/> đ
                            </span>
                        </div>
                        <div class="text-end mb-3 small text-muted fst-italic">
                            (Gồm Tiền thuê + Tiền cọc)
                        </div>

                        <div class="alert ${sessionScope.balance >= totalPayNow ? 'alert-info' : 'alert-danger'} small">
                            Số dư ví của bạn: 
                            <strong><fmt:formatNumber value="${sessionScope.balance}" type="number"/> đ</strong> 
                            <br>
                            <c:if test="${sessionScope.balance < totalPayNow}">
                                <span class="fw-bold">
                                    <i class="fa-solid fa-circle-exclamation"></i> 
                                    Thiếu: <fmt:formatNumber value="${totalPayNow - sessionScope.balance}" type="number"/> đ
                                </span>
                            </c:if>
                            <c:if test="${sessionScope.balance >= totalPayNow}">
                                <span class="text-success"><i class="fa-solid fa-check-circle"></i> Đủ tiền thanh toán.</span>
                            </c:if>
                        </div>

                        <c:choose>
                            <c:when test="${sessionScope.balance >= totalPayNow}">
                                <button form="checkoutForm" type="submit" class="btn btn-bunny-primary w-100 py-3 fw-bold fs-5 shadow">
                                    XÁC NHẬN & THANH TOÁN
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="wallet" class="btn btn-outline-danger w-100 py-3 fw-bold fs-5">
                                    <i class="fa-solid fa-wallet"></i> NẠP THÊM TIỀN NGAY
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <a href="cart" class="btn btn-link w-100 mt-2 text-muted">Quay lại giỏ hàng</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>