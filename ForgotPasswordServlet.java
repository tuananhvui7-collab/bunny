package com.bunnyshop.controllers;

import com.bunnyshop.dal.UserDAO;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

/**
 * Servlet xử lý quên mật khẩu
 * Lưu ý: Đây là phiên bản đơn giản. Trong thực tế, cần gửi email với link reset
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang quên mật khẩu
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);
        
        if (user != null) {
            // Tìm thấy user - Tạo password tạm thời hoặc hướng dẫn reset
            // Đây là phiên bản đơn giản: Tạo password ngẫu nhiên và gửi email
            
            String newPassword = generateRandomPassword();
            
            // Cập nhật password mới vào DB
            dao.updatePassword(user.getUserID(), newPassword);
            
            // Trong thực tế, gửi email chứa password này (hoặc link reset)
            // sendPasswordResetEmail(email, newPassword);
            
            request.setAttribute("message", 
                "Mật khẩu tạm thời đã được gửi đến email: " + email + 
                ". (Phiên bản demo: " + newPassword + ") Vui lòng đăng nhập và đổi mật khẩu ngay!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
    
    /**
     * Tạo password ngẫu nhiên (8 ký tự)
     */
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        String password = "";
        for (int i = 0; i < 8; i++) {
            password += chars.charAt((int) (Math.random() * chars.length()));
        }
        return password;
    }
}