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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    // GET: Hiển thị form login
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập rồi thì đá về trang chủ hoặc dashboard luôn
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        if (user != null) {
            if (user.getRoleID() == 1) response.sendRedirect("manager-dashboard");
            else if (user.getRoleID() == 2) response.sendRedirect("employee-orders");
            else response.sendRedirect("home");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // POST: Xử lý đăng nhập
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        User user = dao.checkLogin(email, pass);
        
        if (user != null) {
            // Đăng nhập thành công
            HttpSession session = request.getSession();
            
            // --- [SỬA LỖI QUAN TRỌNG TẠI ĐÂY] ---
            // Phải đặt tên là "account" để khớp với tất cả các file JSP
            session.setAttribute("account", user); 
            // -------------------------------------

            // Phân quyền dựa trên RoleID
            if (user.getRoleID() == 3) {
                // 1. KHÁCH HÀNG (Role = 3)
                String cusId = dao.getCustomerIdByUserId(user.getUserID());
                
                if (cusId != null) {
                    session.setAttribute("customerId", cusId);
                    
                    // Lấy số dư ví để hiển thị luôn
                    double balance = dao.getWalletBalance(cusId);
                    session.setAttribute("balance", balance);
                }
                
                // Chuyển về trang chủ
                response.sendRedirect("home");
                
            } else if (user.getRoleID() == 2) {
                // 2. NHÂN VIÊN (Role = 2) -> Trang xử lý đơn
                response.sendRedirect("employee-orders");
                
            } else if (user.getRoleID() == 1) {
                // 3. QUẢN LÝ (Role = 1) -> Trang Dashboard thống kê
                response.sendRedirect("manager-dashboard");
                
            } else {
                // Role không xác định -> Về trang chủ
                response.sendRedirect("home");
            }
            
        } else {
            // Đăng nhập thất bại
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}