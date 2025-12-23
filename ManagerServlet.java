package com.bunnyshop.controllers;

import com.bunnyshop.dal.ManagerDAO;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ManagerServlet", urlPatterns = {"/manager-dashboard"})
public class ManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Check quyền Manager (RoleID = 1)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        // Nếu không phải Manager thì đá về Login (Ở đây mình giả định Role 1 là Manager)
        // Lưu ý: Trong dataset mẫu hôm qua mình chưa tạo Manager, lát mình sẽ tạo thêm SQL.
        if (user == null || user.getRoleID() != 1) {
            response.sendRedirect("login"); 
            return;
        }

        // 2. Lấy số liệu thống kê
        ManagerDAO dao = new ManagerDAO();
        int totalOrders = dao.countTotalOrders();
        double totalRevenue = dao.getTotalRevenue();
        int totalCustomers = dao.countCustomers();
        int pendingOrders = dao.countPendingOrders();

        // 3. Gửi sang JSP
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("pendingOrders", pendingOrders);
        
        request.getRequestDispatcher("manager-dashboard.jsp").forward(request, response);
    }
}