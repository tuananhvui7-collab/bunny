package com.bunnyshop.controllers;

import com.bunnyshop.dal.UserDAO;
import com.bunnyshop.dal.WalletDAO;
import com.bunnyshop.models.Transaction;
import com.bunnyshop.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "WalletServlet", urlPatterns = {"/wallet"})
public class WalletServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        String customerId = (String) session.getAttribute("customerId");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // 1. Cập nhật số dư mới nhất (Real-time update)
        UserDAO userDAO = new UserDAO();
        double currentBalance = userDAO.getWalletBalance(customerId);
        session.setAttribute("balance", currentBalance); // Update lại session

        // 2. Lấy lịch sử giao dịch
        WalletDAO walletDAO = new WalletDAO();
        List<Transaction> history = walletDAO.getTransactionHistory(customerId);
        
        request.setAttribute("history", history);
        request.getRequestDispatcher("wallet.jsp").forward(request, response);
    }
}