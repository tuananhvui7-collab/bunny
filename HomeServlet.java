package com.bunnyshop.controllers;

import com.bunnyshop.dal.ProductDAO;
import com.bunnyshop.models.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Khi chạy dự án, nó sẽ vào đây đầu tiên (do cấu hình trong web.xml hoặc welcome-file)
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", ""}) 
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trong doGet của HomeServlet
    String keyword = request.getParameter("keyword");
    ProductDAO dao = new ProductDAO();
    List<Product> list;

    if (keyword != null && !keyword.trim().isEmpty()) {
        list = dao.searchProducts(keyword); // Gọi hàm tìm kiếm
        request.setAttribute("searchKeyword", keyword); // Để hiện lại trên ô input
    } else {
        list = dao.getFeaturedProducts(); // Mặc định lấy hàng mới
    }
    
    request.setAttribute("featuredList", list);
    request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}