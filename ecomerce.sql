-- Drop the database if it exists and create a new one
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
GO

USE ecommerce;
GO

-- Create Roles table
CREATE TABLE Roles (
    roleID INT IDENTITY(1,1) PRIMARY KEY,
    roleName VARCHAR(100)
);
GO

-- Create Users table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    userName VARCHAR(100),
    roleID INT,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    phone int UNIQUE CHECK (LEN(phone) = 9 OR LEN(phone) = 10),
    status BIT,
    FOREIGN KEY (roleID) REFERENCES Roles(roleID)
);
GO

-- Create Employees table
CREATE TABLE Employees (
    EmpID INT IDENTITY(1,1) PRIMARY KEY,
    position VARCHAR(100),
    FOREIGN KEY (EmpID) REFERENCES Users(UserID)
);
GO

-- Create Customers table
CREATE TABLE Customers (
    CustID INT IDENTITY(1,1) PRIMARY KEY,
    points INT,
    birthday DATE,
    province_city VARCHAR(100),
    district VARCHAR(100),
    ward VARCHAR(100),
    detailAddress VARCHAR(255),
    FOREIGN KEY (CustID) REFERENCES Users(UserID)
);
GO

-- Create Brands table
CREATE TABLE Brands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    BrandName VARCHAR(100),
    status BIT
);
GO

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    productName VARCHAR(100),
    description TEXT,
    NumberOfPurchasing INT,
    status BIT,
    BrandID INT,
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);
GO

-- Create ProductDetails table
CREATE TABLE ProductDetails (
    ProductID INT PRIMARY KEY,
    color VARCHAR(50),
    size VARCHAR(50),
    stockQuantity INT,
    price DECIMAL(10, 2),
    importDate DATE,
    image VARCHAR(MAX),
	status BIT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create OverseeProducts table
CREATE TABLE OverseeProducts (
    EmpID INT,
    ProductID INT,
    PRIMARY KEY (EmpID, ProductID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create SuperviseEmployees table
CREATE TABLE SuperviseEmployees (
    EmpID INT,
    SupervisorID INT,
    PRIMARY KEY (EmpID, SupervisorID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (SupervisorID) REFERENCES Employees(EmpID)
);
GO

-- Create SuperviseCustomers table
CREATE TABLE SuperviseCustomers (
    EmpID INT,
    CustID INT,
    PRIMARY KEY (EmpID, CustID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create Supports table
CREATE TABLE Supports (
    SupportID INT IDENTITY(1,1) PRIMARY KEY,
    status BIT,
    requestDate DATE,
    requestMessage TEXT,
    CustID INT,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create ProcessSupports table
CREATE TABLE ProcessSupports (
    EmpID INT,
    SupportID INT,
    responseMessage TEXT,
    responseDate DATE,
    PRIMARY KEY (EmpID, SupportID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (SupportID) REFERENCES Supports(SupportID)
);
GO

-- Create Wishlists table
CREATE TABLE Wishlists (
    WishlistID INT IDENTITY(1,1) PRIMARY KEY,
    CustID INT UNIQUE,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create WishlistDetails table
CREATE TABLE WishlistDetails (
    WishlistID INT,
    ProductID INT,
    PRIMARY KEY (WishlistID, ProductID),
    FOREIGN KEY (WishlistID) REFERENCES Wishlists(WishlistID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create Carts table
CREATE TABLE Carts (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    totalPrice DECIMAL(10, 2),
    quantity INT,
    CustID INT UNIQUE,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create CartDetails table
CREATE TABLE CartDetails (
    CartID INT,
    ProductID INT,
    PRIMARY KEY (CartID, ProductID),
    FOREIGN KEY (CartID) REFERENCES Carts(CartID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create Promotions table
CREATE TABLE Promotions (
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    promotionName VARCHAR(100),
    startDate DATE,
    endDate DATE,
    discountPer DECIMAL(5, 2),
    condition TEXT
);
GO

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    status VARCHAR(100),
    total DECIMAL(10, 2),
    orderDate DATE,
    CustID INT,
    promotionID INT,
    CartID INT,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID),
    FOREIGN KEY (promotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (CartID) REFERENCES Carts(CartID)
);
GO

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    quantity INT,
    unitPrice DECIMAL(10, 2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create ManageOrders table
CREATE TABLE ManageOrders (
    OrderID INT,
    EmpID INT,
    PRIMARY KEY (OrderID, EmpID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create ManagePromotions table
CREATE TABLE ManagePromotions (
    PromotionID INT,
    EmpID INT,
    PRIMARY KEY (PromotionID, EmpID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create ManageBrands table
CREATE TABLE ManageBrands (
    BrandID INT,
    EmpID INT,
    PRIMARY KEY (BrandID, EmpID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriesName VARCHAR(100),
    Description TEXT,
    status BIT
);
GO

-- Create ChildrenCategories table
CREATE TABLE ChildrenCategories (
    CDCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriesName VARCHAR(100),
    ParentID INT,
    status BIT,
    FOREIGN KEY (ParentID) REFERENCES Categories(CategoryID)
);
GO

-- Create ManageCategories table
CREATE TABLE ManageCategories (
    Categories INT,
    EmpID INT,
    PRIMARY KEY (Categories, EmpID),
    FOREIGN KEY (Categories) REFERENCES Categories(CategoryID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create ProductBelongtoCategories table
CREATE TABLE ProductBelongtoCategories (
    ProductID INT,
    Categories INT,
    PRIMARY KEY (ProductID, Categories),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (Categories) REFERENCES Categories(CategoryID)
);
GO

-- Create ProductBelongtoCDCategories table
CREATE TABLE ProductBelongtoCDCategories (
    ProductID INT,
    CDCategoryID INT,
    PRIMARY KEY (ProductID, CDCategoryID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CDCategoryID) REFERENCES ChildrenCategories(CDCategoryID)
);
GO

SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Employees;
SELECT * FROM Customers c JOIN Users u ON c.CustID = u.UserID;
SELECT * FROM Brands;

INSERT INTO Roles (roleName) VALUES ('Admin');
INSERT INTO Roles (roleName) VALUES ('Employee');
INSERT INTO Roles (roleName) VALUES ('Customer');

INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('admin', 1, 'admin@gmail.com', '123', 123456789, 1);
INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('employee', 2, 'emp@gmail.com', '123', 987654321, 1);
INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('customer', 3, 'customer@gmail.com', '123', 1234567890, 1);

INSERT INTO Employees (position) VALUES ('Manager');
INSERT INTO Employees (position) VALUES ('Staff');

INSERT INTO Customers (points, birthday, province_city, district, ward, detailAddress) VALUES (0, '2000-01-01', 'HCM', '1', 'Da Kao', '123 Nguyen Dinh Chieu');
INSERT INTO Customers (points, birthday, province_city, district, ward, detailAddress) VALUES (0, '2000-01-01', 'HCM', '1', 'Da Kao', '123 Nguyen Dinh Chieu');