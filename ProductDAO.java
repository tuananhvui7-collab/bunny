package com.bunnyshop.dal;

import com.bunnyshop.config.DBContext;
import com.bunnyshop.models.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // === 1. LẤY DANH SÁCH TRANG CHỦ (Sắp xếp mới nhất) ===
    public List<Product> getFeaturedProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE Status != 'Đã ngừng kinh doanh' ORDER BY ProductID DESC LIMIT 12";
        
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapProduct(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 2. CHI TIẾT SẢN PHẨM ===
    public Product getProductById(String id) {
        String sql = "SELECT * FROM Product WHERE ProductID = ?";
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return mapProduct(rs);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // === 3. TÌM KIẾM SẢN PHẨM ===
    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        // MySQL không cần N trước chuỗi, chỉ cần COLLATE nếu muốn tìm chính xác tiếng Việt
        String sql = "SELECT * FROM Product WHERE Name LIKE ? AND Status != 'Đã ngừng kinh doanh'";
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, "%" + keyword + "%");
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            list.add(mapProduct(rs));
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 4. LẤY TẤT CẢ (CHO QUẢN LÝ) ===
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product ORDER BY ProductID DESC";
        
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapProduct(rs));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // === 5. THÊM SẢN PHẨM MỚI ===
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Product (ProductID, CategoryID, Name, RentalPrice, QuantityInStock, Status, ImageURL) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, product.getProductID());
                    ps.setInt(2, product.getCategoryID());
                    ps.setString(3, product.getName());
                    ps.setDouble(4, product.getRentalPrice());
                    ps.setInt(5, product.getQuantityInStock());
                    ps.setString(6, product.getStatus()); 
                    ps.setString(7, product.getImageURL());
                    
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // === 6. CẬP NHẬT SẢN PHẨM ===
    public boolean updateProduct(String productId, String name, double rentalPrice, int quantity, String imageURL) {
        String sql = "UPDATE Product SET Name = ?, RentalPrice = ?, QuantityInStock = ?, ImageURL = ? " +
                     "WHERE ProductID = ?";
        
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setDouble(2, rentalPrice);
                    ps.setInt(3, quantity);
                    ps.setString(4, imageURL);
                    ps.setString(5, productId);
                    
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // === 7. XÓA MỀM (SOFT DELETE) ===
    public boolean deleteProduct(String productId) {
        try (Connection conn = DBContext.getConnection()) {
            if (conn != null) {
                // Bước 1: Kiểm tra đơn hàng đang hoạt động
                String checkSql = "SELECT COUNT(*) FROM OrderDetail od " +
                                 "JOIN RentalOrder ro ON od.OrderID = ro.OrderID " +
                                 "WHERE od.ProductID = ? AND ro.Status IN ('Chờ xác nhận', 'Đang thuê')";
                
                try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                    psCheck.setString(1, productId);
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            return false; // Đang có người thuê, không được xóa
                        }
                    }
                }
                
                // Bước 2: Cập nhật trạng thái ngừng kinh doanh
                String deleteSql = "UPDATE Product SET Status = 'Đã ngừng kinh doanh' WHERE ProductID = ?";
                try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
                    psDelete.setString(1, productId);
                    return psDelete.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // === HÀM MAP DỮ LIỆU (Helper) ===
    private Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
            rs.getString("ProductID"),
            rs.getInt("CategoryID"),
            rs.getString("Name"),
            rs.getDouble("RentalPrice"),
            rs.getInt("QuantityInStock"),
            rs.getString("Status"),
            rs.getString("ImageURL")
        );
    }
}