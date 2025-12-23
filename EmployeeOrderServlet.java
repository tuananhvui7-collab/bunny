package com.bunnyshop.controllers;

import com.bunnyshop.dal.OrderDAO;
import com.bunnyshop.models.RentalOrder;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployeeOrderServlet", urlPatterns = {"/employee-orders"})
public class EmployeeOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check quyền nhân viên (RoleID = 2)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect("login"); // Không phải NV thì đá ra
            return;
        }

        OrderDAO dao = new OrderDAO();
        List<RentalOrder> list = dao.getAllOrders();
        
        request.setAttribute("orders", list);
        request.getRequestDispatcher("employee-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        OrderDAO dao = new OrderDAO();

        if ("confirm".equals(action)) {
            // 1. Xác nhận giao hàng -> Đổi thành Đang thuê
            dao.updateOrderStatus(orderId, "Đang thuê");
        
        } else if ("refund".equals(action)) {
            // 2. Xử lý hoàn tiền
            double penalty = 0;
            try {
                penalty = Double.parseDouble(request.getParameter("penalty"));
            } catch (Exception e) {}
            
            dao.processReturnAndRefund(orderId, penalty);
        }

        response.sendRedirect("employee-orders");
    }
}