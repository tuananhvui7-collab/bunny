package com.bunnyshop.controllers;

import com.bunnyshop.dal.ProductDAO;
import com.bunnyshop.models.Product;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý quản lý sản phẩm cho nhân viên (U13)
 * GET: Hiển thị danh sách sản phẩm
 * POST: Xử lý thêm/sửa/xóa sản phẩm
 */
@WebServlet(name = "ProductManagerServlet", urlPatterns = {"/product-manager"})
public class ProductManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền: Chỉ nhân viên (RoleID = 2) có thể truy cập
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }

        // Lấy danh sách tất cả sản phẩm từ DAO
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();
        
        // Gửi danh sách sang JSP
        request.setAttribute("products", products);
        request.getRequestDispatcher("product-manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect("login");
            return;
        }

        // Lấy hành động từ form
        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        // === THÊM SẢN PHẨM MỚI ===
        if ("add".equals(action)) {
            String productId = request.getParameter("productId");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            double rentalPrice = Double.parseDouble(request.getParameter("rentalPrice"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String imageURL = request.getParameter("imageURL");

            // Tạo object Product
            Product product = new Product(productId, categoryId, name, rentalPrice, quantity, "Sẵn sàng", imageURL);
            
            // Gọi DAO để insert vào DB
            boolean success = dao.addProduct(product);
            
            if (success) {
                request.setAttribute("message", "Thêm sản phẩm thành công!");
            } else {
                request.setAttribute("error", "Thêm sản phẩm thất bại! Có thể ID đã tồn tại.");
            }
        }

        // === CHỈNH SỬA SẢN PHẨM ===
        else if ("edit".equals(action)) {
            String productId = request.getParameter("productId");
            String name = request.getParameter("name");
            double rentalPrice = Double.parseDouble(request.getParameter("rentalPrice"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String imageURL = request.getParameter("imageURL");

            boolean success = dao.updateProduct(productId, name, rentalPrice, quantity, imageURL);
            
            if (success) {
                request.setAttribute("message", "Cập nhật sản phẩm thành công!");
            } else {
                request.setAttribute("error", "Cập nhật sản phẩm thất bại!");
            }
        }

        // === NGỪNG KINH DOANH (SOFT DELETE) ===
        else if ("delete".equals(action)) {
            String productId = request.getParameter("productId");
            
            boolean success = dao.deleteProduct(productId);
            
            if (success) {
                request.setAttribute("message", "Ngừng kinh doanh sản phẩm thành công!");
            } else {
                request.setAttribute("error", "Sản phẩm đang được sử dụng trong đơn hàng, không thể xóa!");
            }
        }

        // Tải lại danh sách sản phẩm để hiển thị
        List<Product> products = dao.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("product-manager.jsp").forward(request, response);
    }
}