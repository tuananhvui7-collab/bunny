<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ Hàng - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-bunny">
        <div class="container">
            <a class="navbar-brand" href="home"><i class="fa-solid fa-rabbit" style="color: var(--bunny-dark-pink);"></i> Bunny Shop</a>
            <a href="home" class="btn btn-outline-secondary btn-sm">Tiếp tục chọn đồ</a>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="text-center mb-4 fw-bold">Giỏ Hàng Của Bạn</h2>

        <c:if test="${empty sessionScope.cart}">
            <div class="alert alert-warning text-center">
                Giỏ hàng đang trống! <a href="home">Quay lại thuê đồ đi nào.</a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.cart}">
            <!-- BẢNG GIỎ HÀNG VỚI CHECKBOX CHỌN -->
            <form id="cartForm" action="checkout" method="GET">
                <table class="table table-bordered align-middle">
                    <thead class="table-light text-center">
                        <tr>
                            <th width="5%">
                                <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                            </th>
                            <th>Sản phẩm</th>
                            <th>Size</th>
                            <th>Giá thuê (Ngày)</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                            <th width="8%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="grandTotal" value="0"/>
                        <c:forEach items="${sessionScope.cart}" var="item" varStatus="loop">
                            <tr>
                                <!-- CHECKBOX CHỌN -->
                                <td class="text-center">
                                    <input type="checkbox" class="item-checkbox" 
                                           name="selectedItems" 
                                           value="${item.product.productID}_${item.size}"
                                           onchange="calculateTotal()">
                                </td>

                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${item.product.imageURL}" width="60" class="me-2 rounded">
                                        <span class="fw-bold">${item.product.name}</span>
                                    </div>
                                </td>
                                <td class="text-center"><span class="badge bg-secondary">${item.size}</span></td>
                                <td class="text-end"><fmt:formatNumber value="${item.product.rentalPrice}" type="number"/> đ</td>
                                <td class="text-center">${item.quantity}</td>
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber value="${item.totalPrice}" type="number"/> đ
                                </td>
                                <td class="text-center">
                                    <!-- NÚT XOÁ - GỌI SERVLET -->
                                    <a href="remove-from-cart?productId=${item.product.productID}&size=${item.size}" 
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá sản phẩm này?');">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <c:set var="grandTotal" value="${grandTotal + item.totalPrice}"/>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="row justify-content-end mt-4">
                    <div class="col-md-4">
                        <div class="card p-3 bg-light border-0">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tổng tiền thuê dự kiến:</span>
                                <span class="fw-bold" id="totalDisplay">
                                    <fmt:formatNumber value="${grandTotal}" type="number"/> đ
                                </span>
                            </div>
                            <div class="alert alert-info small">
                                <i class="fa-solid fa-circle-info"></i> <strong>Lưu ý:</strong> Chỉ các sản phẩm được <strong>chọn</strong> mới được đưa vào đơn thuê.
                            </div>
                            <button type="submit" class="btn btn-bunny-primary w-100 py-2 fw-bold" 
                                    id="checkoutBtn"
                                    onclick="return validateSelection()">
                                TIẾN HÀNH ĐẶT CỌC
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <!-- SCRIPT XỬ LÝ CHECKBOX -->
            <script>
                // Lưu giỏ hàng gốc vào biến (để tính toán)
                const allItems = [
                    <c:forEach items="${sessionScope.cart}" var="item" varStatus="loop">
                        {
                            id: "${item.product.productID}_${item.size}",
                            price: ${item.totalPrice}
                        }
                        <c:if test="${!loop.last}">,</c:if>
                    </c:forEach>
                ];

                // Hàm: Tính tổng tiền dựa trên item được chọn
                function calculateTotal() {
                    const checkboxes = document.querySelectorAll('.item-checkbox:checked');
                    let total = 0;
                    
                    checkboxes.forEach(checkbox => {
                        const itemId = checkbox.value;
                        const item = allItems.find(i => i.id === itemId);
                        if (item) total += item.price;
                    });

                    // Cập nhật hiển thị tổng tiền
                    const formatted = new Intl.NumberFormat('vi-VN').format(total);
                    document.getElementById('totalDisplay').textContent = formatted + ' đ';
                }

                // Hàm: Chọn/Bỏ chọn tất cả
                function toggleSelectAll() {
                    const selectAllCheckbox = document.getElementById('selectAll');
                    const itemCheckboxes = document.querySelectorAll('.item-checkbox');
                    
                    itemCheckboxes.forEach(checkbox => {
                        checkbox.checked = selectAllCheckbox.checked;
                    });
                    
                    calculateTotal();
                }

                // Hàm: Kiểm tra xem có sản phẩm được chọn không
                function validateSelection() {
                    const selectedItems = document.querySelectorAll('.item-checkbox:checked');
                    
                    if (selectedItems.length === 0) {
                        alert('Vui lòng chọn ít nhất 1 sản phẩm để thuê!');
                        return false;
                    }
                    
                    return true; // Cho phép form submit
                }

                // Khi trang load xong, tính tổng tiền (mặc định chọn tất cả)
                document.addEventListener('DOMContentLoaded', function() {
                    // Mặc định chọn tất cả các item
                    document.querySelectorAll('.item-checkbox').forEach(cb => cb.checked = true);
                    document.getElementById('selectAll').checked = true;
                    
                    calculateTotal();
                });
            </script>
        </c:if>
    </div>
</body>
</html>