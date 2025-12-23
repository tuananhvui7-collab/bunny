package com.bunnyshop.dal;

import com.bunnyshop.config.DBContext;
import com.bunnyshop.models.CartItem;
import com.bunnyshop.models.User;
import com.bunnyshop.models.OrderDetail;
import com.bunnyshop.models.RentalOrder;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OrderDAO {

    // ==================================================================
    // 1. HÀM TẠO ĐƠN HÀNG (TRANSACTION) - KHỚP 100% DB GỐC
    // ==================================================================
    public String createOrder(User user, List<CartItem> cart, String startDate, String returnDate, double totalRental, double depositAmount) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // A. Lấy CustomerID và WalletID từ UserID
            String customerId = null;
            String walletId = null;
            
            // Join bảng để lấy thông tin
            String getInfoSql = "SELECT c.CustomerID, cw.WalletID " +
                                "FROM Users u " +
                                "JOIN Customer c ON u.UserID = c.UserID " +
                                "LEFT JOIN CustomerWallet cw ON c.CustomerID = cw.CustomerID " +
                                "WHERE u.UserID = ?";
                                
            PreparedStatement psInfo = conn.prepareStatement(getInfoSql);
            psInfo.setString(1, user.getUserID());
            ResultSet rsInfo = psInfo.executeQuery();
            
            if (rsInfo.next()) {
                customerId = rsInfo.getString("CustomerID");
                walletId = rsInfo.getString("WalletID");
            }
            
            if (customerId == null) return "Lỗi: Không tìm thấy thông tin khách hàng.";
            if (walletId == null) return "Lỗi: Khách hàng chưa kích hoạt ví.";

            // B. Tính tổng tiền cần thanh toán ngay (Thuê + Cọc)
            double totalPayNow = totalRental + depositAmount;

            // C. Trừ tiền trong ví (Bảng CustomerWallet)
            String updateWalletSql = "UPDATE CustomerWallet SET Balance = Balance - ? WHERE WalletID = ? AND Balance >= ?";
            PreparedStatement psWallet = conn.prepareStatement(updateWalletSql);
            psWallet.setDouble(1, totalPayNow);
            psWallet.setString(2, walletId);
            psWallet.setDouble(3, totalPayNow); // Kiểm tra đủ tiền
            
            int rowsWallet = psWallet.executeUpdate();
            if (rowsWallet == 0) {
                conn.rollback();
                return "Giao dịch thất bại: Số dư ví không đủ.";
            }

            // D. Tạo Đơn Hàng (Bảng RentalOrder)
            // SỬA CHUẨN: Chỉ dùng các cột có trong DB của bạn
            String orderId = "ORD" + (System.currentTimeMillis() % 100000); 
            
            String insertOrderSql = "INSERT INTO RentalOrder (OrderID, CustomerID, StartDate, ExpectedReturnDate, Status, DepositAmount, TotalAmount, CompensationFee) VALUES (?, ?, ?, ?, ?, ?, ?, 0)";
            PreparedStatement psOrder = conn.prepareStatement(insertOrderSql);
            psOrder.setString(1, orderId);
            psOrder.setString(2, customerId);
            psOrder.setString(3, startDate);
            psOrder.setString(4, returnDate);
            psOrder.setString(5, "Chờ xác nhận");
            psOrder.setDouble(6, depositAmount); 
            psOrder.setDouble(7, totalRental);   
            psOrder.executeUpdate();

            // E. Lưu Chi Tiết (OrderDetail) & Trừ Kho (Product)
            String insertDetailSql = "INSERT INTO OrderDetail (DetailID, OrderID, ProductID, Quantity, PriceAtTime, Size) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psDetail = conn.prepareStatement(insertDetailSql);
            
            String updateStockSQL = "UPDATE Product SET QuantityInStock = QuantityInStock - ? WHERE ProductID = ?";
            PreparedStatement psStock = conn.prepareStatement(updateStockSQL);
            
            for (CartItem item : cart) {
                // Tạo ID chi tiết
                String detailId = "D" + (System.nanoTime() % 100000000); 
                
                // Insert chi tiết
                psDetail.setString(1, detailId);
                psDetail.setString(2, orderId);
                psDetail.setString(3, item.getProduct().getProductID());
                psDetail.setInt(4, item.getQuantity());
                psDetail.setDouble(5, item.getProduct().getRentalPrice()); // PriceAtTime
                psDetail.setString(6, item.getSize());
                psDetail.addBatch();

                // Trừ kho
                psStock.setInt(1, item.getQuantity());
                psStock.setString(2, item.getProduct().getProductID());
                psStock.addBatch();
            }
            psDetail.executeBatch();
            psStock.executeBatch();

            // F. Lưu Lịch Sử Giao Dịch (FinancialTransaction)
            // SỬA CHUẨN: Bỏ Description, Bỏ TransactionDate (để tự sinh)
            String transId = "TR" + (System.currentTimeMillis() % 100000);
            String insertTransSql = "INSERT INTO FinancialTransaction (TransactionID, OrderID, WalletID, Type, Amount, Status) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psTrans = conn.prepareStatement(insertTransSql);
            psTrans.setString(1, transId);
            psTrans.setString(2, orderId);
            psTrans.setString(3, walletId);
            psTrans.setString(4, "Thanh toan don " + orderId); // Lưu nội dung vào cột Type
            psTrans.setDouble(5, totalPayNow);
            psTrans.setString(6, "Thanh cong");
            psTrans.executeUpdate();

            conn.commit();
            return null; // Thành công

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return "Lỗi hệ thống: " + e.getMessage();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    // ==================================================================
    // 2. HÀM CẬP NHẬT TRẠNG THÁI (CHO SERVLET NHÂN VIÊN)
    // ==================================================================
    public void updateOrderStatus(String orderId, String status) {
        String sql = "UPDATE RentalOrder SET Status = ? WHERE OrderID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ==================================================================
    // 3. CÁC HÀM GET LIST
    // ==================================================================

    public List<RentalOrder> getOrdersByCustomerId(String customerId) {
        List<RentalOrder> list = new ArrayList<>();
        // Sắp xếp theo OrderID giảm dần
        String sql = "SELECT * FROM RentalOrder WHERE CustomerID = ? ORDER BY OrderID DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalOrder o = mapOrder(rs);
                o.setDetails(getOrderDetails(conn, o.getOrderID()));
                list.add(o);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<RentalOrder> getAllOrders() {
        List<RentalOrder> list = new ArrayList<>();
        String sql = "SELECT * FROM RentalOrder ORDER BY OrderID DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RentalOrder o = mapOrder(rs);
                o.setDetails(getOrderDetails(conn, o.getOrderID()));
                list.add(o);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==================================================================
    // 4. XỬ LÝ HOÀN TIỀN & HỦY
    // ==================================================================

    public boolean processReturnAndRefund(String orderId, double compensationFee) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            String getOrderSQL = "SELECT CustomerID, DepositAmount FROM RentalOrder WHERE OrderID = ?";
            PreparedStatement psOrder = conn.prepareStatement(getOrderSQL);
            psOrder.setString(1, orderId);
            ResultSet rs = psOrder.executeQuery();
            if (!rs.next()) return false;

            String customerId = rs.getString("CustomerID");
            double deposit = rs.getDouble("DepositAmount");
            
            // Chỉ hoàn cọc (trừ phí phạt)
            double refundAmount = Math.max(0, deposit - compensationFee);

            String updateOrderSQL = "UPDATE RentalOrder SET Status = N'Hoàn tất', CompensationFee = ? WHERE OrderID = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateOrderSQL);
            psUpdate.setDouble(1, compensationFee);
            psUpdate.setString(2, orderId);
            psUpdate.executeUpdate();

            restockInventory(conn, orderId);

            if (refundAmount > 0) {
                refundToWallet(conn, customerId, orderId, refundAmount, "Hoan tien coc");
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }

    public boolean cancelOrder(String orderId) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            String getInfoSQL = "SELECT CustomerID, DepositAmount, Status, TotalAmount FROM RentalOrder WHERE OrderID = ?";
            PreparedStatement psInfo = conn.prepareStatement(getInfoSQL);
            psInfo.setString(1, orderId);
            ResultSet rs = psInfo.executeQuery();
            
            if (!rs.next()) return false;
            String status = rs.getString("Status");
            // Cho phép hủy nếu có chữ "Chờ" hoặc "cho"
            if (!status.toLowerCase().contains("chờ") && !status.toLowerCase().contains("cho")) return false;

            String customerId = rs.getString("CustomerID");
            double deposit = rs.getDouble("DepositAmount");
            double total = rs.getDouble("TotalAmount");
            
            // Hoàn lại TẤT CẢ (Thuê + Cọc)
            double refundTotal = total + deposit;

            PreparedStatement psUpdate = conn.prepareStatement("UPDATE RentalOrder SET Status = N'Đã hủy' WHERE OrderID = ?");
            psUpdate.setString(1, orderId);
            psUpdate.executeUpdate();

            restockInventory(conn, orderId);
            
            refundToWallet(conn, customerId, orderId, refundTotal, "Hoan tien huy don");

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
    
    // --- PRIVATE HELPERS ---

    private RentalOrder mapOrder(ResultSet rs) throws SQLException {
        RentalOrder o = new RentalOrder();
        o.setOrderID(rs.getString("OrderID"));
        o.setCustomerID(rs.getString("CustomerID"));
        o.setStartDate(rs.getDate("StartDate").toString());
        o.setExpectedReturnDate(rs.getDate("ExpectedReturnDate").toString());
        o.setStatus(rs.getString("Status"));
        o.setDepositAmount(rs.getDouble("DepositAmount"));
        o.setTotalAmount(rs.getDouble("TotalAmount"));
        o.setCompensationFee(rs.getDouble("CompensationFee"));
        return o;
    }

    private List<OrderDetail> getOrderDetails(Connection conn, String orderId) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT d.Quantity, d.Size, p.Name, p.ImageURL FROM OrderDetail d JOIN Product p ON d.ProductID = p.ProductID WHERE d.OrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                details.add(new OrderDetail(rs.getString("Name"), rs.getString("ImageURL"), rs.getInt("Quantity"), rs.getString("Size")));
            }
        }
        return details;
    }

    private void restockInventory(Connection conn, String orderId) throws SQLException {
        String sql = "SELECT ProductID, Quantity FROM OrderDetail WHERE OrderID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            PreparedStatement psStock = conn.prepareStatement("UPDATE Product SET QuantityInStock = QuantityInStock + ? WHERE ProductID = ?");
            while(rs.next()) {
                psStock.setInt(1, rs.getInt("Quantity"));
                psStock.setString(2, rs.getString("ProductID"));
                psStock.executeUpdate();
            }
        }
    }

    private void refundToWallet(Connection conn, String customerId, String orderId, double amount, String typeDesc) throws SQLException {
        if (amount <= 0) return;
        
        String getWallet = "SELECT WalletID FROM CustomerWallet WHERE CustomerID = ?";
        PreparedStatement psGet = conn.prepareStatement(getWallet);
        psGet.setString(1, customerId);
        ResultSet rs = psGet.executeQuery();
        
        if (rs.next()) {
            String walletId = rs.getString("WalletID");
            
            // Cộng tiền
            PreparedStatement psUp = conn.prepareStatement("UPDATE CustomerWallet SET Balance = Balance + ? WHERE WalletID = ?");
            psUp.setDouble(1, amount);
            psUp.setString(2, walletId);
            psUp.executeUpdate();
            
            // Ghi log
            String transId = "RF" + (System.currentTimeMillis() % 100000);
            String logSql = "INSERT INTO FinancialTransaction (TransactionID, OrderID, WalletID, Type, Amount, Status) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement psLog = conn.prepareStatement(logSql);
            psLog.setString(1, transId);
            psLog.setString(2, orderId);
            psLog.setString(3, walletId);
            psLog.setString(4, typeDesc); 
            psLog.setDouble(5, amount);
            psLog.setString(6, "Thanh cong");
            psLog.executeUpdate();
        }
    }
}