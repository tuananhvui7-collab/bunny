package com.bunnyshop.controllers;

import com.bunnyshop.dal.UserDAO;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user != null) {
            // Lấy dữ liệu mới từ form
            String hoten = request.getParameter("hoten");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Cập nhật object User
            user.setHoten(hoten);
            user.setPhone(phone);
            user.setAddress(address);
            
            // Lưu xuống DB
            UserDAO dao = new UserDAO();
            dao.updateUser(user);
            
            // Cập nhật lại Session
            session.setAttribute("account", user);
            
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}