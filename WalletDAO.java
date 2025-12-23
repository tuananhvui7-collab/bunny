package com.bunnyshop.dal;

import com.bunnyshop.config.DBContext;
import com.bunnyshop.models.Transaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WalletDAO {

    public List<Transaction> getTransactionHistory(String customerId) {
        List<Transaction> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            
            String getWalletSql = "SELECT WalletID FROM CustomerWallet WHERE CustomerID = ?";
            PreparedStatement psWallet = conn.prepareStatement(getWalletSql);
            psWallet.setString(1, customerId);
            ResultSet rsWallet = psWallet.executeQuery();
            
            String walletId = null;
            if (rsWallet.next()) {
                walletId = rsWallet.getString("WalletID");
            }

            if (walletId != null) {
                String sql = "SELECT * FROM FinancialTransaction WHERE WalletID = ? ORDER BY Timestamp DESC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, walletId);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setTransactionID(rs.getString("TransactionID"));
                    t.setAmount(rs.getDouble("Amount"));
                    t.setTimestamp(rs.getTimestamp("Timestamp"));
                    
                    // --- 1. XỬ LÝ LOẠI GIAO DỊCH (Làm gọn text) ---
                    String rawType = rs.getString("Type"); // VD: "Thanh toan don ORD..."
                    if (rawType != null) {
                        String lowerType = rawType.toLowerCase();
                        if (lowerType.contains("thanh toan")) {
                            t.setType("Thanh toán đơn");
                        } else if (lowerType.contains("hoan tien")) {
                            t.setType("Hoàn tiền cọc");
                        } else if (lowerType.contains("nap tien")) {
                            t.setType("Nạp tiền");
                        } else {
                            t.setType(rawType); // Giữ nguyên nếu là loại khác
                        }
                    }

                    // --- 2. XỬ LÝ TRẠNG THÁI (Đồng bộ tiếng Việt có dấu) ---
                    String rawStatus = rs.getString("Status");
                    if (rawStatus != null && (rawStatus.equalsIgnoreCase("Thanh cong") || rawStatus.equalsIgnoreCase("Success"))) {
                        t.setStatus("Thành công");
                    } else if (rawStatus != null && rawStatus.equalsIgnoreCase("That bai")) {
                        t.setStatus("Thất bại");
                    } else {
                        t.setStatus(rawStatus);
                    }
                    
                    // --- 3. LẤY CHI TIẾT SẢN PHẨM ---
                    String orderId = rs.getString("OrderID");
                    if (orderId != null) {
                        String productNames = getProductNamesByOrderId(conn, orderId);
                        t.setOrderInfo("Đơn #" + orderId + " (" + productNames + ")");
                    } else {
                        // Nếu là nạp tiền thì hiển thị nội dung gốc
                        t.setOrderInfo(t.getType());
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