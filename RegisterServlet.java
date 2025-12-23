package com.bunnyshop.controllers;

import com.bunnyshop.dal.UserDAO;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy dữ liệu form
        String hoten = request.getParameter("hoten");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        UserDAO dao = new UserDAO();

        // 2. Validate
        if (dao.checkEmailExist(email)) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Tạo User Object
        User u = new User();
        u.setUserID("U" + System.currentTimeMillis() % 10000); // ID ngẫu nhiên
        u.setEmail(email);
        u.setPassword(pass);
        u.setHoten(hoten);
        u.setPhone(phone);
        u.setAddress(address);
        u.setRoleID(3); // Khách hàng

        // 4. Gọi DAO đăng ký
        if (dao.register(u)) {
            // Thành công -> Chuyển sang login
            // Gửi kèm thông báo thành công (cần sửa login.jsp tí để hiện)
            request.setAttribute("success", "Đăng ký thành công! Bạn được tặng 5.000.000đ vào ví.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}