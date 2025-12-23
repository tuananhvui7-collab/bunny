package com.bunnyshop.models;
import java.util.List;
import java.util.ArrayList;

public class RentalOrder {
    private String orderID;
    private String customerID;
    private String startDate;
    private String expectedReturnDate;
    private String status;
    private double depositAmount;
    private double compensationFee;
    private double totalAmount;
    
    // THÊM THUỘC TÍNH NÀY:
    private List<OrderDetail> details = new ArrayList<>();

    public List<OrderDetail> getDetails() {
        return details;
    }

    public void setDetails(List<OrderDetail> details) {
        this.details = details;
    }

    public RentalOrder() {
    }

    // Getter & Setter
    public String getOrderID() { return orderID; }
    public void setOrderID(String orderID) { this.orderID = orderID; }
    
    public String getCustomerID() { return customerID; }
    public void setCustomerID(String customerID) { this.customerID = customerID; }
    
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    
    public String getExpectedReturnDate() { return expectedReturnDate; }
    public void setExpectedReturnDate(String expectedReturnDate) { this.expectedReturnDate = expectedReturnDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public double getDepositAmount() { return depositAmount; }
    public void setDepositAmount(double depositAmount) { this.depositAmount = depositAmount; }
    
    public double getCompensationFee() { return compensationFee; }
    public void setCompensationFee(double compensationFee) { this.compensationFee = compensationFee; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}