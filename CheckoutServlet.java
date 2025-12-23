package com.bunnyshop.controllers;

import com.bunnyshop.dal.OrderDAO;
import com.bunnyshop.dal.UserDAO;
import com.bunnyshop.models.CartItem;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // 1. Validate
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // 2. LẤY DANH SÁCH SẢN PHẨM ĐƯỢC CHỌN từ request parameter
        String[] selectedItems = request.getParameterValues("selectedItems");
        
        List<CartItem> selectedCart = new ArrayList<>();
        if (selectedItems != null && selectedItems.length > 0) {
            // Lọc giỏ hàng chỉ giữ lại những sản phẩm được chọn
            for (String selected : selectedItems) {
                // selected có dạng: "PRODUCTID_SIZE"
                String[] parts = selected.split("_");
                if (parts.length == 2) {
                    String productId = parts[0];
                    String size = parts[1];
                    
                    // Tìm sản phẩm trong giỏ
                    for (CartItem item : cart) {
                        if (item.getProduct().getProductID().equals(productId) 
                            && item.getSize().equals(size)) {
                            selectedCart.add(item);
                            break;
                        }
                    }
                }
            }
        }

        // Nếu không có sản phẩm được chọn, quay lại giỏ hàng
        if (selectedCart.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ít nhất 1 sản phẩm để tiếp tục!");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        // 3. Tính toán hiển thị
        double totalRental = 0;
        for (CartItem item : selectedCart) {
            totalRental += item.getTotalPrice();
        }
        double depositAmount = totalRental * 0.3; // Cọc 30%

        // Cập nhật lại User từ DB để đảm bảo số dư hiển thị là mới nhất
        UserDAO uDao = new UserDAO();
        User currentUser = uDao.getAccountById(user.getUserID());
        session.setAttribute("account", currentUser);
        session.setAttribute("balance", currentUser.getBalance());

        // 4. Gửi dữ liệu sang JSP
        request.setAttribute("selectedCart", selectedCart); // Danh sách sản phẩm được chọn
        request.setAttribute("totalRental", totalRental);
        request.setAttribute("depositAmount", depositAmount);

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        String startDate = request.getParameter("startDate");
        String returnDate = request.getParameter("returnDate");
        
        // --- 1. LẤY DANH SÁCH SẢN PHẨM ĐƯỢC CHỌN ---
        String[] selectedItems = request.getParameterValues("selectedItems");
        
        List<CartItem> selectedCart = new ArrayList<>();
        if (selectedItems != null && selectedItems.length > 0) {
            for (String selected : selectedItems) {
                String[] parts = selected.split("_");
                if (parts.length == 2) {
                    String productId = parts[0];
                    String size = parts[1];
                    
                    for (CartItem item : cart) {
                        if (item.getProduct().getProductID().equals(productId) 
                            && item.getSize().equals(size)) {
                            selectedCart.add(item);
                            break;
                        }
                    }
                }
            }
        }

        // 2. TÍNH TOÁN LẠI TỔNG TIỀN (CHỈ TỪ SẢN PHẨM ĐƯỢC CHỌN)
        double totalRental = 0;
        if (!selectedCart.isEmpty()) {
            for (CartItem item : selectedCart) {
                totalRental += item.getTotalPrice();
            }
        }
        
        double depositAmount = totalRental * 0.3; 
        double totalPayNow = totalRental + depositAmount;

        // 3. KIỂM TRA SỐ DƯ
        UserDAO uDao = new UserDAO();
        User currentUser = uDao.getAccountById(user.getUserID());

        if (currentUser.getBalance() < totalPayNow) {
            request.setAttribute("error", "Số dư không đủ để thanh toán. Cần: " + String.format("%,.0f", totalPayNow) + " đ");
            doGet(request, response);
            return;
        }

        // 4. TẠO ĐƠN HÀ...
        OrderDAO dao = new OrderDAO();
        String errorMessage = dao.createOrder(currentUser, selectedCart, startDate, returnDate, totalRental, depositAmount);
        
        if (errorMessage == null) {
            // Thành công - Xoá các sản phẩm đã chọn khỏi giỏ hàng
            for (CartItem selectedItem : selectedCart) {
                for (CartItem cartItem : cart) {
                    if (cartItem.getProduct().getProductID().equals(selectedItem.getProduct().getProductID()) 
                        && cartItem.getSize().equals(selectedItem.getSize())) {
                        cart.remove(cartItem);
                        break;
                    }
                }
            }
            
            // Cập nhật giỏ hàng và số dư
            session.setAttribute("cart", cart);
            session.setAttribute("cartSize", cart.size());
            
            User updatedUser = uDao.getAccountById(user.getUserID());
            session.setAttribute("account", updatedUser);
            session.setAttribute("balance", updatedUser.getBalance());
            
            request.setAttribute("message", "Thanh toán thành công! Đơn hàng đang chờ xác nhận.");
            request.getRequestDispatcher("order-success.jsp").forward(request, response);
        } else {
            request.setAttribute("error", errorMessage);
            doGet(request, response);
        }
    }
}