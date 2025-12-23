-- 1. XÓA VÀ TẠO MỚI DATABASE
DROP DATABASE IF EXISTS BunnyShopDB;
CREATE DATABASE BunnyShopDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BunnyShopDB;

-- =============================================
-- 2. TẠO CẤU TRÚC BẢNG (TABLES)
-- =============================================

-- Bảng Danh mục
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255)
) ENGINE=InnoDB;

-- Bảng Người dùng (Chứa cả Admin, Staff, Khách)
CREATE TABLE Users (
    UserID VARCHAR(20) PRIMARY KEY,
    Password VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Hoten VARCHAR(100) NOT NULL,
    RoleID INT NOT NULL, -- 1: Quản lý, 2: Nhân viên, 3: Khách hàng
    Phone VARCHAR(20) NOT NULL,
    Address VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Bảng Nhân viên
CREATE TABLE Employee (
    EmployeeID VARCHAR(20) PRIMARY KEY,
    UserID VARCHAR(20) NOT NULL UNIQUE,
    Position VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Employee_User FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- Bảng Quản lý
CREATE TABLE Manager (
    ManagerID VARCHAR(20) PRIMARY KEY,
    UserID VARCHAR(20) NOT NULL UNIQUE,
    Department VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Manager_User FOREIGN KEY (UserID) REFERENCES Users(UserID)
) ENGINE=InnoDB;

-- Bảng Ví tiền (Tạo trước để tham chiếu)
CREATE TABLE CustomerWallet (
    WalletID VARCHAR(20) PRIMARY KEY,
    Balance DECIMAL(15,2) DEFAULT 0.00,
    CustomerID VARCHAR(20) NULL 
) ENGINE=InnoDB;

-- Bảng Khách hàng
CREATE TABLE Customer (
    CustomerID VARCHAR(20) PRIMARY KEY,
    UserID VARCHAR(20) NOT NULL UNIQUE,
    WalletID VARCHAR(20) NULL,
    CONSTRAINT FK_Customer_User FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Customer_Wallet FOREIGN KEY (WalletID) REFERENCES CustomerWallet(WalletID)
) ENGINE=InnoDB;

-- Cập nhật lại mối quan hệ 1-1 giữa Khách và Ví
ALTER TABLE CustomerWallet
ADD CONSTRAINT FK_Wallet_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID);

-- Bảng Sản phẩm
CREATE TABLE Product (
    ProductID VARCHAR(20) PRIMARY KEY,
    CategoryID INT NOT NULL,
    Name VARCHAR(225) NOT NULL,
    RentalPrice DECIMAL(10,2) NOT NULL,
    QuantityInStock INT NOT NULL,
    Status VARCHAR(50) NOT NULL, -- 'Sẵn sàng', 'Hết hàng', 'Đã ngừng kinh doanh'
    ImageURL VARCHAR(255),       -- Đường dẫn ảnh (assets/img/...)
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
) ENGINE=InnoDB;

-- Bảng Đơn hàng
CREATE TABLE RentalOrder (
    OrderID VARCHAR(20) PRIMARY KEY,
    CustomerID VARCHAR(20) NOT NULL,
    EmployeeID VARCHAR(20),      -- Người xác nhận đơn
    StartDate DATE NOT NULL,
    ExpectedReturnDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL, -- 'Chờ xác nhận', 'Đang thuê', 'Hoàn tất', 'Đã hủy'
    DepositAmount DECIMAL(10,2) NOT NULL,
    CompensationFee DECIMAL(10,2) DEFAULT 0,
    TotalAmount DECIMAL(10,2),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Order_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
) ENGINE=InnoDB;

-- Bảng Chi tiết đơn hàng
CREATE TABLE OrderDetail (
    DetailID VARCHAR(50) PRIMARY KEY, -- Tăng độ dài để tránh lỗi chuỗi dài
    OrderID VARCHAR(20) NOT NULL,
    ProductID VARCHAR(20) NOT NULL,
    Quantity INT NOT NULL,
    PriceAtTime DECIMAL(10,2) NOT NULL,
    Size VARCHAR(20) NOT NULL,
    CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (OrderID) REFERENCES RentalOrder(OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
) ENGINE=InnoDB;

-- Bảng Lịch sử giao dịch
CREATE TABLE FinancialTransaction (
    TransactionID VARCHAR(20) PRIMARY KEY,
    OrderID VARCHAR(20) NULL,
    WalletID VARCHAR(20) NOT NULL,
    Type VARCHAR(100) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Trans_Order FOREIGN KEY (OrderID) REFERENCES RentalOrder(OrderID),
    CONSTRAINT FK_Trans_Wallet FOREIGN KEY (WalletID) REFERENCES CustomerWallet(WalletID)
) ENGINE=InnoDB;

-- =============================================
-- 3. INSERT DỮ LIỆU MẪU (DATA)
-- =============================================

-- 3.1. Danh mục
INSERT INTO Category (Name, Description) VALUES 
('Cosplay Anime', 'Trang phục nhân vật Anime/Manga'),
('Dạ Hội / Prom', 'Váy dạ hội, Vest sang trọng'),
('Đồng Phục / School', 'Đồng phục học sinh Nhật Bản, Hàn Quốc'),
('Set Couple / Nhóm', 'Combo trang phục đôi hoặc nhóm');

-- 3.2. Sản phẩm (Sử dụng link assets/img/...)
INSERT INTO Product (ProductID, CategoryID, Name, RentalPrice, QuantityInStock, Status, ImageURL) VALUES 
('AYA01', 3, 'Aya Oosawa - Đồng phục học sinh', 230000, 5, 'Sẵn sàng', 'assets/img/aya_school.jpg'),
('AYA02', 2, 'Aya Oosawa - Prom Đỏ Rượu', 460000, 3, 'Sẵn sàng', 'assets/img/aya_prom.jpg'),
('UMR01', 1, 'Umaru - Home (Áo choàng cam)', 200000, 10, 'Sẵn sàng', 'assets/img/umaru_home.jpg'),
('UMR02', 1, 'Umaru - UMR (Hoodie Đỏ)', 200000, 8, 'Sẵn sàng', 'assets/img/umaru_red.jpg'),
('KOGA01', 1, 'Mitsuki Koga - Nirvana', 230000, 4, 'Sẵn sàng', 'assets/img/koga_nirvana.jpg'),
('KOGA02', 2, 'Mitsuki Koga - Prom Vest', 320000, 4, 'Sẵn sàng', 'assets/img/koga_prom.jpg'),
('KOGA03', 1, 'Mitsuki Koga - Staff', 230000, 6, 'Sẵn sàng', 'assets/img/koga_staff.jpg'),
('CP01', 4, 'Couple Koga x Aya - Prom', 760000, 2, 'Sẵn sàng', 'assets/img/couple_prom.jpg'),
('CP02', 4, 'Couple Koga x Aya - Nir x Cardigan', 450000, 3, 'Sẵn sàng', 'assets/img/couple_casual.jpg'),
('CP03', 4, 'Couple Koga x Aya - Staff x School', 400000, 3, 'Sẵn sàng', 'assets/img/couple_staff.jpg'),
('JUDY01', 2, 'Judy Hopps - Váy Dạ Hội Vàng', 450000, 4, 'Sẵn sàng', 'assets/img/judy_prom.jpg'),
('NICK01', 2, 'Nick Wilde - Vest Đuôi Cáo', 400000, 5, 'Sẵn sàng', 'assets/img/nick_prom.jpg'),
('CP04', 4, 'Couple Nick & Judy - Prom Night', 800000, 2, 'Sẵn sàng', 'assets/img/couple_zootopia.jpg');

-- 3.3. Người dùng (User) - Mật khẩu mặc định: 123
-- QUẢN LÝ
INSERT INTO Users VALUES ('U_MGR', '123', 'admin@bunny.com', 'Trần Quốc Khánh (Admin)', 1, '0909000111', 'Hà Nội');
INSERT INTO Manager VALUES ('MGR01', 'U_MGR', 'Board of Directors');

-- NHÂN VIÊN
INSERT INTO Users VALUES ('U_EMP', '123', 'staff@bunny.com', 'Lê Thị Lan Anh (Staff)', 2, '0909000222', 'Hà Nội');
INSERT INTO Employee VALUES ('EMP01', 'U_EMP', 'Sales');

-- KHÁCH HÀNG
INSERT INTO Users VALUES ('U_CUS', '123', 'khach@bunny.com', 'Nguyễn Thảo Nguyên', 3, '0909000333', 'TP.HCM');
INSERT INTO Customer (CustomerID, UserID, WalletID) VALUES ('CUS01', 'U_CUS', NULL);

-- Tạo ví cho khách (Tặng 5.000.000 để test)
INSERT INTO CustomerWallet (WalletID, Balance, CustomerID) VALUES ('W_CUS01', 5000000, 'CUS01');
UPDATE Customer SET WalletID = 'W_CUS01' WHERE CustomerID = 'CUS01';

-- =============================================
-- KIỂM TRA DỮ LIỆU
-- =============================================
SELECT * FROM Users;
SELECT * FROM Product;