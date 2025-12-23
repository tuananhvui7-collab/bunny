package com.bunnyshop.models;

public class OrderDetail {
    private String productName; // Tên SP (Lấy từ bảng Product)
    private String productImg;  // Ảnh SP (Để nhân viên dễ check)
    private int quantity;
    private String size;

    public OrderDetail() {}

    public OrderDetail(String productName, String productImg, int quantity, String size) {
        this.productName = productName;
        this.productImg = productImg;
        this.quantity = quantity;
        this.size = size;
    }

    // Getter Setter
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getProductImg() { return productImg; }
    public void setProductImg(String productImg) { this.productImg = productImg; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
}