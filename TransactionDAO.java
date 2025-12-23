package com.bunnyshop.dal;

import com.bunnyshop.config.DBContext;
import com.bunnyshop.models.Transaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    public List<Transaction> getTransactionHistory(String userId) {
        List<Transaction> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            
            // 1. Lấy WalletID từ UserID
            String getWalletSql = "SELECT cw.WalletID FROM Users u " +
                                  "JOIN Customer c ON u.UserID = c.UserID " +
                                  "JOIN CustomerWallet cw ON c.CustomerID = cw.CustomerID " +
                                  "WHERE u.UserID = ?";
            
            PreparedStatement psWallet = conn.prepareStatement(getWalletSql);
            psWallet.setString(1, userId);
            ResultSet rsWallet = psWallet.executeQuery();
            
            String walletId = null;
            if (rsWallet.next()) {
                walletId = rsWallet.getString("WalletID");
            }

            // 2. Lấy danh sách giao dịch
            if (walletId != null) {
                String sql = "SELECT * FROM FinancialTransaction WHERE WalletID = ? ORDER BY Timestamp DESC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, walletId);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    Transaction t = new Transaction();
                    
                    // Map các trường cơ bản
                    t.setTransactionID(rs.getString("TransactionID"));
                    t.setType(rs.getString("Type")); 
                    t.setAmount(rs.getDouble("Amount"));
                    t.setTimestamp(rs.getTimestamp("Timestamp"));
                    t.setStatus(rs.getString("Status"));
                    
                    // --- LOGIC XỬ LÝ OrderInfo ---
                    String orderId = rs.getString("OrderID");
                    
                    if (orderId != null) {
                        // Nếu có OrderID -> Đi tìm tên sản phẩm
                        String productNames = getProductNamesByOrderId(conn, orderId);
                        // Gán vào orderInfo: "Đơn #ORD... (Áo A, Quần B...)"
                        t.setOrderInfo("Đơn #" + orderId + " - " + productNames);
                    } else {
                        // Nếu không có OrderID (VD: Nạp tiền) -> Lấy luôn cột Type làm info
                        t.setOrderInfo(rs.getString("Type"));
                    }
                    
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return list;
    }
    
    // Hàm phụ: Lấy tên các sản phẩm trong 1 đơn hàng
    private String getProductNamesByOrderId(Connection conn, String orderId) {
        StringBuilder names = new StringBuilder();
        String sql = "SELECT p.Name FROM OrderDetail d JOIN Product p ON d.ProductID = p.ProductID WHERE d.OrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while(rs.next()) {
                if (!first) names.append(", ");
                names.append(rs.getString("Name"));
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names.length() > 0 ? names.toString() : "Chi tiết đơn hàng";
    }
}