package com.bunnyshop.models;

public class User {
    private String userID;
    private String password;
    private String email;
    private String hoten;
    private int roleID; // Giữ nguyên roleID như code gốc của bạn
    private String phone;
    private String address;
    
    // --- THÊM 2 BIẾN MỚI NÀY ---
    private double balance; // Số dư ví
    private String avatar;  // Ảnh đại diện

    public User() {
    }

    // Giữ nguyên Constructor cũ để không lỗi code đăng nhập
    public User(String userID, String password, String email, String hoten, int roleID, String phone, String address) {
        this.userID = userID;
        this.password = password;
        this.email = email;
        this.hoten = hoten;
        this.roleID = roleID;
        this.phone = phone;
        this.address = address;
        this.balance = 0; // Mặc định số dư là 0
    }

    // --- GETTER & SETTER CŨ ---
    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getHoten() { return hoten; }
    public void setHoten(String hoten) { this.hoten = hoten; }
    
    public int getRoleID() { return roleID; }
    public void setRoleID(int roleID) { this.roleID = roleID; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    // --- THÊM GETTER & SETTER MỚI (QUAN TRỌNG) ---
    
    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}