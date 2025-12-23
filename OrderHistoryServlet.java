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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        String customerId = (String) session.getAttribute("customerId");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // 2. Lấy dữ liệu từ DAO
        OrderDAO dao = new OrderDAO();
        // Lấy TOÀN BỘ đơn hàng của khách
        List<RentalOrder> allOrders = dao.getOrdersByCustomerId(customerId);
        
        // 3. Xử lý LỌC theo trạng thái (status)
        String statusParam = request.getParameter("status");
        List<RentalOrder> filteredList = new ArrayList<>();

        // Nếu không có param hoặc chọn "all" thì lấy hết
        if (statusParam == null || statusParam.equals("all") || statusParam.trim().isEmpty()) {
            filteredList = allOrders;
        } else {
            // Lọc thủ công bằng vòng lặp Java
            for (RentalOrder o : allOrders) {
                // So sánh tham số URL (wait, renting...) với dữ liệu trong DB (Tiếng Việt)
                if ("wait".equals(statusParam) && "Chờ xác nhận".equals(o.getStatus())) {
                    filteredList.add(o);
                } else if ("renting".equals(statusParam) && "Đang thuê".equals(o.getStatus())) {
                    filteredList.add(o);
                } else if ("return".equals(statusParam) && "Đang trả hàng".equals(o.getStatus())) {
                    filteredList.add(o);
                } else if ("done".equals(statusParam) && "Hoàn tất".equals(o.getStatus())) {
                    filteredList.add(o);
                } else if ("cancel".equals(statusParam) && "Đã hủy".equals(o.getStatus())) {
                    filteredList.add(o);
                }
            }
        }
        
        // 4. Gửi list đã lọc sang JSP
        request.setAttribute("orders", filteredList);
        request.getRequestDispatcher("order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        OrderDAO dao = new OrderDAO();

        if (orderId != null) {
            if ("return".equals(action)) {
                dao.updateOrderStatus(orderId, "Đang trả hàng");
            } else if ("cancel".equals(action)) {
                dao.cancelOrder(orderId); // Hoặc hàm updateOrderStatus(orderId, "Đã hủy") tùy DAO của bạn
            }
        }
        
        // Load lại trang sau khi xử lý (mặc định về tab Tất cả)
        response.sendRedirect("order-history");
    }
}