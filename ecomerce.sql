-- Drop the database if it exists and create a new one
DROP DATABASE IF EXISTS github;
CREATE DATABASE github;
GO

USE github;
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
    phone int UNIQUE,
    status INT,
    FOREIGN KEY (roleID) REFERENCES Roles(roleID)
);
GO

-- Create Employees table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FOREIGN KEY (EmpID) REFERENCES Users(UserID)
);
GO

-- Create Customers table
CREATE TABLE Customers (
    CustID INT PRIMARY KEY,
    points INT,
    birthday DATE,
    province_city VARCHAR(100),
    district VARCHAR(100),
    ward VARCHAR(100),
    detailAddress VARCHAR(255),
    FOREIGN KEY (CustID) REFERENCES Users(UserID)
);
GO

CREATE TABLE ForgetPassword (
    ResetID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    token VARCHAR(100),
    expiredDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    tokenStatus INT
);
GO  

-- Create Brands table
CREATE TABLE Brands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    BrandName VARCHAR(100),
	image VARCHAR(MAX),
    status INT
);
GO

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    productName VARCHAR(100),
    description VARCHAR(100),
    NumberOfPurchasing INT,
    status INT,
    BrandID INT,
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);
GO

-- Create ProductDetails table
CREATE TABLE ProductDetails (
    ProductDetailsID INT PRIMARY KEY,
	ProductID INT,
    color VARCHAR(50),
    size VARCHAR(50),
    stockQuantity INT,
    price INT,
    importDate DATE,
    image VARCHAR(MAX),
	status INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create OverseeProducts table
CREATE TABLE OverseeProducts (
    EmpID INT,
    ProductID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
    PRIMARY KEY (EmpID, ProductID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create SuperviseEmployees table
CREATE TABLE SuperviseEmployees (
    EmpID INT,
    SupervisorID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
    PRIMARY KEY (EmpID, SupervisorID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (SupervisorID) REFERENCES Employees(EmpID)
);
GO

-- Create SuperviseCustomers table
CREATE TABLE SuperviseCustomers (
    EmpID INT,
    CustID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
    PRIMARY KEY (EmpID, CustID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create Supports table
CREATE TABLE Supports (
    SupportID INT IDENTITY(1,1) PRIMARY KEY,
    status INT,
	title varchar(100),
    requestDate DATE,
    requestMessage VARCHAR(100),
    CustID INT,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create ProcessSupports table
CREATE TABLE ProcessSupports (
    EmpID INT,
    SupportID INT,
    responseMessage VARCHAR(100),
	title varchar(100),
    responseDate DATE,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
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
    totalPrice DECIMAL(10, 2), --CHange totalPrice from int to Decimal
    CustID INT UNIQUE,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);
GO

-- Create CartDetails table
CREATE TABLE CartDetails (
    CartID INT,
    ProductID INT,
	ProductDetailsID INT,
	quantity INT,
	price INT,
    PRIMARY KEY (CartID, ProductID, ProductDetailsID),
    FOREIGN KEY (CartID) REFERENCES Carts(CartID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
	FOREIGN KEY (ProductDetailsID) REFERENCES ProductDetails(ProductDetailsID)
);
GO

-- Create Promotions table
CREATE TABLE Promotions (
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    promotionName VARCHAR(100),
    startDate DATE,
    endDate DATE,
    discountPer DECIMAL(5, 2),
	description varchar(100),
	image VARCHAR(MAX),
    condition INT,
	status INT
);
GO

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    status INT,
    total DECIMAL(10, 2), --CHange to decimal from int to store price
    orderDate DATE,
    CustID INT,
    promotionID INT,
    CartID INT,
    userName VARCHAR(100),
    city VARCHAR(100), 
    district VARCHAR(100),
    ward VARCHAR(100),
    address VARCHAR(100),
    phone INT,
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
    unitPrice INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Create ManageOrders table
CREATE TABLE ManageOrders (
    OrderID INT,
    EmpID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
    PRIMARY KEY (OrderID, EmpID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create ManagePromotions table
CREATE TABLE ManagePromotions (
    PromotionID INT,
    EmpID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
    PRIMARY KEY (PromotionID, EmpID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create ManageBrands table
CREATE TABLE ManageBrands (
    BrandID INT,
    EmpID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
    PRIMARY KEY (BrandID, EmpID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriesName VARCHAR(100),
    Description VARCHAR(100),
	image VARCHAR(MAX),
    status INT
);
GO

-- Create ChildrenCategories table
CREATE TABLE ChildrenCategories (
    CDCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriesName VARCHAR(100),
    ParentID INT,
    status INT,
    FOREIGN KEY (ParentID) REFERENCES Categories(CategoryID)
);
GO

-- Create ManageCategories table
CREATE TABLE ManageCategories (
    Categories INT,
    EmpID INT,
	FieldOld VARCHAR(20),
	[Action] VARCHAR(20),
	FieldNew VARCHAR(20),
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

DELETE From Users where UserID = 5;

SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Employees;
SELECT * FROM Customers c JOIN Users u ON c.CustID = u.UserID;
SELECT * FROM Brands;
SELECT * FROM Products;
SELECT * FROM Supports WHERE CustID like '%%' OR status like '%%' OR SupportID like '%%' OR requestDate like '%%' OR requestMessage like '%%';
SELECT *  FROM Supports s 
INNER JOIN Customers c ON s.CustID = c.CustID
INNER JOIN Users u ON c.CustID = u.UserID
WHERE u.userName like '%%'

SELECT * FROM Supports s 
INNER JOIN Customers c ON s.CustID = c.CustID
INNER JOIN Users u ON c.CustID = u.UserID
WHERE s.SupportID = 1;
SELECT * FROM Promotions;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Categories;
SELECT * FROM ChildrenCategories;
SELECT * FROM ProductBelongtoCategories;
SELECT * FROM ProductBelongtoCDCategories;
SELECT * FROM ManageCategories;
SELECT * FROM ManageBrands;
SELECT * FROM ManagePromotions;
SELECT * FROM ManageOrders;
SELECT * FROM WishlistDetails;
SELECT * FROM Wishlists;
SELECT * FROM CartDetails;
SELECT * FROM Carts;
SELECT * FROM ProductDetails;
SELECT * FROM OverseeProducts;
SELECT * FROM SuperviseEmployees;
SELECT * FROM SuperviseCustomers;
SELECT * FROM ProcessSupports;
SELECT * FROM ForgetPassword;
SELECT * FROM ForgetPassword WHERE token = '26c77a61-0541-4d57-b6cc-afbb56b9d50f' AND expiredDate > GETDATE() AND tokenStatus = 1


INSERT INTO Roles (roleName) VALUES ('System Manager');
INSERT INTO Roles (roleName) VALUES ('Shop Manager');
INSERT INTO Roles (roleName) VALUES ('Shop Staff');
INSERT INTO Roles (roleName) VALUES ('Customer');


INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('admin', 1, 'admin@gmail.com', '123', 123456789, 1);
INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('manager', 2, 'manager@gmail.com', '123', 987654321, 1);
INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('employee', 3, 'employee@gmail.com', '123', 1234567890, 1);
INSERT INTO Users (userName, roleID, email, password, phone, status) VALUES ('customer', 4, 'customer@gmail.com', '123', 1234467890, 1);


INSERT INTO Employees (EmpID) VALUES (1);
INSERT INTO Employees (EmpID) VALUES (2);
INSERT INTO Employees (EmpID) VALUES (3);

INSERT INTO Customers (CustID, points, birthday, province_city, district, ward, detailAddress) VALUES (4,0, '2000-01-01', 'HCM', '1', 'Da Kao', '123 Nguyen Dinh Chieu');

INSERT INTO Promotions(promotionName, startDate, endDate, discountPer, description, condition) VALUES('SALE50', '2024-01-01', '2024-02-01', 50.00,'Happy Sale', 100);
INSERT INTO Promotions(promotionName, startDate, endDate, discountPer, description, condition) VALUES('SALE35', '2024-01-01', '2024-02-01', 35.00,'Happy Sale', 50);
INSERT INTO Promotions(promotionName, startDate, endDate, discountPer, description, condition) VALUES('NOSALE', '2024-01-01', '2024-02-01', 0,'Sad No Sale' 0);

INSERT INTO Brands (BrandName, status) VALUES ('Adidas', 1);
INSERT INTO Brands (BrandName, status) VALUES ('Nike', 1);
INSERT INTO Brands (BrandName, status) VALUES ('Puma', 1);

INSERT INTO [Supports] (status, title, requestDate, requestMessage, CustID) VALUES (1,'HELP', '2021-01-01', 'Help me', 4);

INSERT INTO  ProcessSupports (EmpID, SupportID, title, responseMessage, responseDate) VALUES (3, 2,'SHOP REPLY YOUR SUPPORT', 'I will help you', GETDATE());
DELETE FROM ProcessSupports WHERE EmpID = 3 AND SupportID = 1;

INSERT INTO Carts (totalPrice, quantity, CustID) VALUES (0,0,4);

INSERT INTO [dbo].[Carts] ([totalPrice], [quantity],[CustID]) VALUES (0,0,4)

INSERT INTO Orders (status, total, orderDate, CustID, promotionID, CartID) VALUES (1, 100, '2021-01-01', 4, 3 , 1);

INSERT INTO Products (productName, description, NumberOfPurchasing, status, BrandID) VALUES ('Shoes', 'Good', 0, 1, 1);
INSERT INTO OrderDetails (orderID, productID, quantity, unitPrice) VALUES (2, 2, 1, 100) 

UPDATE Orders SET status = 0 WHERE OrderID = 1

-- ALTER TABLE Products
-- ALTER COLUMN status int;
-- ALTER TABLE Products
-- ALTER COLUMN description nvarchar(255);
SELECT * FROM ForgetPassword WHERE token = '3c9894b9-6266-4f3d-9dbf-272a70c2ac12' AND expiredDate > GETDATE() AND tokenStatus = 1
SELECT TOP 1 * FROM ForgetPassword WHERE userID = 8 AND tokenStatus = 1 ORDER BY ResetID DESC 
SELECT * FROM Users

SELECT* FROM ForgetPassword

SELECT SUM(c.quantity * pd.price) FROM Carts c 
INNER JOIN CartDetails cd ON cd.CartID = c.CartID
INNER JOIN Products p ON p.ProductID = cd.ProductID
INNER JOIN ProductDetails pd ON pd.ProductID = p.ProductID
WHERE c.CartID = 
SELECT * FROM ProcessSupports WHERE supportID = 1

INSERT INTO Carts()
SELECT * FROM Users
INSERT INTO Supports (status, requestDate, requestMessage, CustID) VALUES (0, '2021-01-01', 'Help me', 4);
SELECT *  FROM Supports s 
INNER JOIN Customers c ON s.CustID = c.CustID
INNER JOIN Users u ON c.CustID = u.UserID
WHERE u.userName like '%%'