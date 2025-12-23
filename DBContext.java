package com.bunnyshop.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    
    // Thông tin cấu hình Database
    private static final String SERVER = "localhost";
    private static final String PORT = "3306";
    private static final String DB_NAME = "BunnyShopDB";
    private static final String USER = "root";     // <--- TESTER SỬA Ở ĐÂY
    private static final String PASS = "root"; // <--- TESTER SỬA Ở ĐÂY

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load Driver cho MySQL 8+
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Chuỗi kết nối có hỗ trợ tiếng Việt và timezone
            String dbURL = "jdbc:mysql://" + SERVER + ":" + PORT + "/" + DB_NAME 
                         + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
            
            conn = DriverManager.getConnection(dbURL, USER, PASS);
            // System.out.println("Kết nối CSDL thành công!"); 
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.err.println("Kết nối CSDL thất bại: " + e.getMessage());
        }
        return conn;
    }
    
    // Main method để Test nhanh xem kết nối được chưa
    public static void main(String[] args) {
        if(getConnection() != null) {
            System.out.println("TEST KẾT NỐI THÀNH CÔNG!");
        } else {
            System.out.println("TEST KẾT NỐI THẤT BẠI.");
        }
    }
}