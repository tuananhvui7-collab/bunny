package com.bunnyshop.dal;

import com.bunnyshop.config.DBContext;
import com.bunnyshop.models.User;
import java.sql.*;

public class UserDAO {
    
    // 1. Kiểm tra đăng nhập
    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password); 
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getString("UserID"),
                        rs.getString("Password"),
                        rs.getString("Email"),
                        rs.getString("Hoten"),
                        rs.getInt("RoleID"),
                        rs.getString("Phone"),
                        rs.getString("Address")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // 2. Lấy CustomerID từ UserID
    public String getCustomerIdByUserId(String userId) {
        String sql = "SELECT CustomerID FROM Customer WHERE UserID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("CustomerID");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Kiểm tra email đã tồn tại chưa
    public boolean checkEmailExist(String email) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT UserID FROM Users WHERE Email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // True nếu đã có
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Đăng ký tài khoản mới
    public boolean register(User user) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // A. Insert bảng Users
            String sqlUser = "INSERT INTO Users (UserID, Password, Email, Hoten, RoleID, Phone, Address) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, user.getUserID());
            psUser.setString(2, user.getPassword());
            psUser.setString(3, user.getEmail());
            psUser.setString(4, user.getHoten());
            psUser.setInt(5, 3); // Role 3 = Customer
            psUser.setString(6, user.getPhone());
            psUser.setString(7, user.getAddress());
            psUser.executeUpdate();

            // B. Insert bảng Customer
            String cusId = "C" + System.currentTimeMillis() % 100000;
            String sqlCus = "INSERT INTO Customer (CustomerID, UserID) VALUES (?, ?)";
            PreparedStatement psCus = conn.prepareStatement(sqlCus);
            psCus.setString(1, cusId);
            psCus.setString(2, user.getUserID());
            psCus.executeUpdate();

            // C. Insert bảng Wallet (Tặng luôn 5 triệu Welcome Bonus để test)
            String walletId = "W" + System.currentTimeMillis() % 100000;
            String sqlWallet = "INSERT INTO CustomerWallet (WalletID, CustomerID, Balance) VALUES (?, ?, ?)";
            PreparedStatement psWallet = conn.prepareStatement(sqlWallet);
            psWallet.setString(1, walletId);
            psWallet.setString(2, cusId);
            psWallet.setDouble(3, 5000000); // <--- TẶNG TIỀN ĐỂ TEST
            psWallet.executeUpdate();

            // D. Update lại Customer trỏ vào Wallet
            String sqlUpdate = "UPDATE Customer SET WalletID = ? WHERE CustomerID = ?";
            PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setString(1, walletId);
            psUpdate.setString(2, cusId);
            psUpdate.executeUpdate();

            conn.commit(); // Chốt đơn
            return true;

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    // 5. Cập nhật thông tin cá nhân
    public void updateUser(User user) {
        String sql = "UPDATE Users SET Hoten = ?, Phone = ?, Address = ? WHERE UserID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getHoten());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getUserID());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 6. Lấy số dư ví (Helper)
    public double getWalletBalance(String customerId) {
        String sql = "SELECT Balance FROM CustomerWallet WHERE CustomerID = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble("Balance");
        } catch (Exception e) {}
        return 0; 
    }

    // ================================================================
    // 7. HÀM MỚI QUAN TRỌNG: Lấy User theo ID + Kèm Số dư Ví (Balance)
    // ================================================================
    public User getAccountById(String userId) {
        // Join 3 bảng: Users -> Customer -> CustomerWallet để lấy Balance
        String sql = "SELECT u.*, cw.Balance " +
                     "FROM Users u " +
                     "LEFT JOIN Customer c ON u.UserID = c.UserID " +
                     "LEFT JOIN CustomerWallet cw ON c.CustomerID = cw.CustomerID " +
                     "WHERE u.UserID = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserID(rs.getString("UserID"));
                    u.setPassword(rs.getString("Password"));
                    u.setEmail(rs.getString("Email"));
                    u.setHoten(rs.getString("Hoten"));
                    
                    // --- ĐÃ SỬA LẠI DÒNG NÀY (setRole -> setRoleID) ---
                    u.setRoleID(rs.getInt("RoleID")); 
                    
                    u.setPhone(rs.getString("Phone"));
                    u.setAddress(rs.getString("Address"));
                    
                    // Lấy số dư ví (Nếu null thì = 0)
                    double balance = rs.getObject("Balance") != null ? rs.getDouble("Balance") : 0;
                    u.setBalance(balance); 
                    
                    // Nếu trong DB bảng Users có cột Avatar thì bỏ comment dòng dưới
                    // u.setAvatar(rs.getString("Avatar")); 
                    
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // ===== THÊM CÁC HÀM NÀY VÀO UserDAO.java HIỆN TẠI =====

/**
 * Lấy User theo Email (Để kiểm tra quên mật khẩu)
 */
public User getUserByEmail(String email) {
    String sql = "SELECT * FROM Users WHERE Email = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, email);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new User(
                    rs.getString("UserID"),
                    rs.getString("Password"),
                    rs.getString("Email"),
                    rs.getString("Hoten"),
                    rs.getInt("RoleID"),
                    rs.getString("Phone"),
                    rs.getString("Address")
                );
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

/**
 * Cập nhật mật khẩu (Cho chức năng quên mật khẩu)
 */
public boolean updatePassword(String userId, String newPassword) {
    String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, newPassword);
        ps.setString(2, userId);
        
        int rowsUpdated = ps.executeUpdate();
        return rowsUpdated > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
}