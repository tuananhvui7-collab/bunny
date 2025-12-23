package com.bunnyshop.controllers;

import com.bunnyshop.dal.ProductDAO;
import com.bunnyshop.models.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// --- [SỬA LỖI TẠI ĐÂY] ---
// Đổi urlPatterns từ "/product-detail" thành "/detail" cho khớp với file index.jsp
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/detail"}) 
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id"); // Lấy ID từ URL (vd: ?id=AYA01)
        
        if (id != null) {
            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(id);
            
            if (p != null) {
                request.setAttribute("product", p);
                // Chuyển hướng đến file giao diện chi tiết
                request.getRequestDispatcher("product-detail.jsp").forward(request, response);
                return;
            }
        }
        
        // Nếu không tìm thấy ID hoặc sản phẩm không tồn tại -> Về trang chủ
        response.sendRedirect("home");
    }
}