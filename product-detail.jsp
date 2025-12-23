<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product.name} - Bunny Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-bunny sticky-top">
        <div class="container">
            <a class="navbar-brand" href="home"><i class="fa-solid fa-rabbit" style="color: var(--bunny-dark-pink);"></i> Bunny Shop</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="home">Trang Chủ</a></li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart">
                            Giỏ Hàng 
                            <span class="badge bg-danger rounded-pill">
                                ${sessionScope.cart == null ? 0 : fn:length(sessionScope.cart)}
                            </span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <div class="row">
            <!-- Cột trái: Ảnh -->
            <div class="col-md-6 mb-4">
                <div class="card border-0 shadow-sm">
                    <img src="${product.imageURL}" class="card-img-top rounded" alt="${product.name}" 
                         onerror="this.src='https://via.placeholder.com/500?text=Bunny+Shop'">
                </div>
            </div>

            <!-- Cột phải: Thông tin -->
            <div class="col-md-6">
                <h2 class="fw-bold" style="color: var(--text-color);">${product.name}</h2>
                <div class="mb-3">
                    <span class="badge bg-success me-2">${product.status}</span>
                    <!-- HIỂN THỊ SỐ LƯỢNG TỒN KHO TẠI ĐÂY -->
                    <span class="text-danger fw-bold">
                        <i class="fa-solid fa-box-open"></i> Trong kho còn: ${product.quantityInStock} sản phẩm
                    </span>
                </div>

                <h3 class="fw-bold my-4" style="color: var(--bunny-dark-pink);">
                    <fmt:formatNumber value="${product.rentalPrice}" type="currency" currencySymbol="VNĐ"/> / ngày
                </h3>
                
                <p class="text-muted">
                    <i class="fa-solid fa-circle-info"></i> Lưu ý: Tiền cọc bằng 30% giá trị đơn hàng.
                </p>
                <hr>

                <!-- FORM ADD TO CART -->
<form action="add-to-cart" method="POST">
    <input type="hidden" name="productId" value="${product.productID}">
    <input type="hidden" name="size" value="FreeSize">

    <!-- Chọn Số Lượng -->
    <div class="mb-4">
        <label class="fw-bold mb-2">Số Lượng:</label>
        <div class="input-group w-50">
            <!-- Nút Trừ -->
            <button class="btn btn-outline-secondary" type="button" onclick="adjustQty(-1)">
                <i class="fa-solid fa-minus"></i>
            </button>
            
            <!-- Ô nhập liệu (Đã bỏ readonly, thêm sự kiện kiểm tra) -->
            <input type="number" 
                   id="qtyInput" 
                   name="quantity" 
                   value="1" 
                   min="1" 
                   max="${product.quantityInStock}" 
                   class="form-control text-center" 
                   oninput="validateQty()" 
                   onblur="validateQty()">
            
            <!-- Nút Cộng -->
            <button class="btn btn-outline-secondary" type="button" onclick="adjustQty(1)">
                <i class="fa-solid fa-plus"></i>
            </button>
        </div>
        <!-- Thông báo nhỏ nếu nhập lố -->
        <small id="qtyWarning" class="text-danger fw-bold" style="display: none;">
            * Đã điều chỉnh về mức tối đa trong kho!
        </small>
    </div>

    <div class="d-grid gap-2">
        <button type="submit" class="btn btn-bunny-primary btn-lg shadow" ${product.quantityInStock <= 0 ? 'disabled' : ''}>
            <i class="fa-solid fa-cart-plus"></i> 
            ${product.quantityInStock > 0 ? 'Thêm Vào Giỏ Hàng' : 'Tạm Hết Hàng'}
        </button>
        <a href="home" class="btn btn-light btn-lg border">Tiếp Tục Xem Đồ</a>
    </div>
</form>

<!-- SCRIPT XỬ LÝ NHẬP LIỆU THÔNG MINH -->
<script>
    // Hàm xử lý nút Cộng/Trừ
    function adjustQty(delta) {
        let input = document.getElementById('qtyInput');
        let currentVal = parseInt(input.value) || 0; // Nếu ô trống thì coi là 0
        let maxVal = parseInt(input.getAttribute('max'));
        
        let newVal = currentVal + delta;

        // Chỉ cập nhật nếu nằm trong khoảng cho phép [1, Max]
        if (newVal >= 1 && newVal <= maxVal) {
            input.value = newVal;
            document.getElementById('qtyWarning').style.display = 'none';
        } else if (newVal > maxVal) {
            alert("Trong kho chỉ còn " + maxVal + " sản phẩm!");
        }
    }

    // Hàm "Gác cổng" khi người dùng tự nhập tay
    function validateQty() {
        let input = document.getElementById('qtyInput');
        let warning = document.getElementById('qtyWarning');
        
        let val = parseInt(input.value);
        let max = parseInt(input.getAttribute('max'));

        if (isNaN(val) || val < 1) {
            // Nếu xóa trắng hoặc nhập số âm -> Sửa thành 1
            // (Chưa sửa ngay để người dùng nhập xong, xử lý ở onblur)
            if (event.type === 'blur') input.value = 1; 
        } 
        else if (val > max) {
            // Nếu nhập lố -> Sửa về Max ngay lập tức
            input.value = max;
            warning.style.display = 'block'; // Hiện thông báo đỏ
            
            // Tắt thông báo sau 2 giây
            setTimeout(() => {
                warning.style.display = 'none';
            }, 2000);
        } else {
            warning.style.display = 'none';
        }
    }
</script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>