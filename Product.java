package com.bunnyshop.models;

public class Product {
    
    // 1. Khai báo thuộc tính (Fields)
    private String productID;
    private int categoryID;
    private String name;
    private double rentalPrice;
    private int quantityInStock;
    private String status;
    private String imageURL;

    // 2. Constructor rỗng (Bắt buộc phải có để JSP/Servlet khởi tạo)
    public Product() {
    }

    // 3. Constructor đầy đủ tham số (Dùng trong DAO để hứng dữ liệu từ DB)
    public Product(String productID, int categoryID, String name, double rentalPrice, int quantityInStock, String status, String imageURL) {
        this.productID = productID;
        this.categoryID = categoryID;
        this.name = name;
        this.rentalPrice = rentalPrice;
        this.quantityInStock = quantityInStock;
        this.status = status;
        this.imageURL = imageURL;
    }

    // 4. Getter & Setter (Viết thủ công chuẩn convention)
    
    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getRentalPrice() {
        return rentalPrice;
    }

    public void setRentalPrice(double rentalPrice) {
        this.rentalPrice = rentalPrice;
    }

    public int getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(int quantityInStock) {
        this.quantityInStock = quantityInStock;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    // 5. Override toString để in log kiểm tra lỗi cho tiện
    @Override
    public String toString() {
        return "Product{" + "productID=" + productID + ", name=" + name + ", rentalPrice=" + rentalPrice + '}';
    }
}