package com.bunnyshop.models;
import java.sql.Timestamp;

public class Transaction {
    private String transactionID;
    private String type;   // Nạp tiền, Thanh toán, Hoàn tiền
    private double amount;
    private Timestamp timestamp;
    private String status;
    private String orderInfo; // <--- Cột mới: Chứa tên các sản phẩm

    public Transaction() {}

    public Transaction(String transactionID, String type, double amount, Timestamp timestamp, String status, String orderInfo) {
        this.transactionID = transactionID;
        this.type = type;
        this.amount = amount;
        this.timestamp = timestamp;
        this.status = status;
        this.orderInfo = orderInfo;
    }

    // Getter & Setter đầy đủ
    public String getTransactionID() { return transactionID; }
    public void setTransactionID(String transactionID) { this.transactionID = transactionID; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public Timestamp getTimestamp() { return timestamp; }
    public void setTimestamp(Timestamp timestamp) { this.timestamp = timestamp; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOrderInfo() { return orderInfo; }
    public void setOrderInfo(String orderInfo) { this.orderInfo = orderInfo; }
}