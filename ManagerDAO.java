package com.bunnyshop.dal;

import com.bunnyshop.config.DBContext;
import java.sql.*;

public class ManagerDAO {
    
    // 1. Thống kê Tổng số đơn hàng
    public int countTotalOrders() {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM RentalOrder")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }

    // 2. Thống kê Tổng Doanh Thu (Chỉ tính đơn đã hoàn tất hoặc đang thuê)
    // Doanh thu = Tổng tiền cọc (lúc thuê) - Tiền hoàn lại (nếu có) ??? 
    // Theo logic đơn giản: Doanh thu = Tổng giá trị các đơn hàng (TotalAmount)
    public double getTotalRevenue() {
        // Lấy tổng tiền thuê của các đơn đã thanh toán cọc
        String sql = "SELECT SUM(TotalAmount) FROM RentalOrder WHERE Status != 'Chờ xác nhận'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {}
        return 0;
    }

    // 3. Đếm số khách hàng
    public int countCustomers() {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM Customer")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }
    
    // 4. Đếm số đơn đang chờ xử lý (Để nhắc nhở quản lý)
    public int countPendingOrders() {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM RentalOrder WHERE Status = 'Chờ xác nhận'")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }
}