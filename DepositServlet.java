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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.bunnyshop.config.DBContext;

/**
 * Servlet xử lý nạp tiền vào ví (U11 - Nạp tiền)
 * GET: Hiển thị trang nạp tiền
 * POST: Xử lý giao dịch nạp tiền
 */
@WebServlet(name = "DepositServlet", urlPatterns = {"/deposit"})
public class DepositServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy số dư ví hiện tại
        UserDAO dao = new UserDAO();
        double currentBalance = dao.getWalletBalance((String) session.getAttribute("customerId"));
        request.setAttribute("currentBalance", currentBalance);
        
        request.getRequestDispatcher("deposit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        String customerId = (String) session.getAttribute("customerId");
        
        if (user == null || customerId == null) {
            response.sendRedirect("login");
            return;
        }

        double depositAmount = 0;
        try {
            depositAmount = Double.parseDouble(request.getParameter("amount"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số tiền không hợp lệ!");
            doGet(request, response);
            return;
        }

        // Kiểm tra số tiền hợp lệ
        if (depositAmount <= 0 || depositAmount > 100000000) {
            request.setAttribute("error", "Số tiền nạp phải từ 1.000đ đến 100.000.000đ!");
            doGet(request, response);
            return;
        }

        // Thực hiện nạp tiền (ghi log giao dịch)
        boolean success = processDeposit(customerId, depositAmount);
        
        if (success) {
            // Cập nhật số dư mới
            UserDAO dao = new UserDAO();
            double newBalance = dao.getWalletBalance(customerId);
            session.setAttribute("balance", newBalance);
            
            request.setAttribute("message", "Nạp tiền thành công! Số tiền: " + 
                String.format("%,.0f", depositAmount) + " VNĐ");
        } else {
            request.setAttribute("error", "Nạp tiền thất bại! Vui lòng thử lại.");
        }
        
        doGet(request, response);
    }

    /**
     * Xử lý nạp tiền: Cộng tiền vào ví + Ghi log giao dịch
     */
    private boolean processDeposit(String customerId, double amount) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Lấy WalletID từ CustomerID
            String getWalletSql = "SELECT WalletID FROM CustomerWallet WHERE CustomerID = ?";
            PreparedStatement psGetWallet = conn.prepareStatement(getWalletSql);
            psGetWallet.setString(1, customerId);
            ResultSet rsWallet = psGetWallet.executeQuery();
            
            String walletId = null;
            if (rsWallet.next()) {
                walletId = rsWallet.getString("WalletID");
            }
            
            if (walletId == null) {
                conn.rollback();
                return false;
            }

            // 2. Cộng tiền vào ví
            String updateWalletSql = "UPDATE CustomerWallet SET Balance = Balance + ? WHERE WalletID = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateWalletSql);
            psUpdate.setDouble(1, amount);
            psUpdate.setString(2, walletId);
            int rowsUpdated = psUpdate.executeUpdate();
            
            if (rowsUpdated == 0) {
                conn.rollback();
                return false;
            }

            // 3. Ghi log giao dịch (FinancialTransaction)
            String transId = "DEP" + (System.currentTimeMillis() % 100000);
            String insertTransSql = "INSERT INTO FinancialTransaction (TransactionID, OrderID, WalletID, Type, Amount, Status) " +
                                   "VALUES (?, NULL, ?, ?, ?, ?)";
            PreparedStatement psTrans = conn.prepareStatement(insertTransSql);
            psTrans.setString(1, transId);
            psTrans.setString(2, walletId);
            psTrans.setString(3, "Nap tien");
            psTrans.setDouble(4, amount);
            psTrans.setString(5, "Thanh cong");
            psTrans.executeUpdate();

            conn.commit();
            return true;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
    }
}