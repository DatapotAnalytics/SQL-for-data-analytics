/*
Self-Join trong SQL và những tình huống thường gặp
Created by BinhPH at 2024-12-20
(c) Datapot Analytics
*/

-- Tạo bảng Employee
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    ManagerID INT
);
INSERT INTO Employee (EmployeeID, EmployeeName, ManagerID) VALUES (1, 'John Smith', 3);
INSERT INTO Employee (EmployeeID, EmployeeName, ManagerID) VALUES (2, 'Jane Anderson', 3);
INSERT INTO Employee (EmployeeID, EmployeeName, ManagerID) VALUES (3, 'Tom Lanon', 4);
INSERT INTO Employee (EmployeeID, EmployeeName, ManagerID) VALUES (4, 'Anne Connor', NULL);
INSERT INTO Employee (EmployeeID, EmployeeName, ManagerID) VALUES (5, 'Jeremy York', 1);

-- Tạo bảng Customer
CREATE TABLE Customer (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(255),
    ReferralID VARCHAR(10) REFERENCES Customer(CustomerID)
);
INSERT INTO Customer (CustomerID, CustomerName, ReferralID)
VALUES
    ('ABC123DEF4', 'John Doe', NULL),
    ('XYZ987ABC0', 'Jane Smith', 'ABC123DEF4'),
    ('LMN456OPQ7', 'Bob Johnson', 'ABC123DEF4'),
    ('DEF123GHI5', 'Alice Brown', NULL),
    ('JKL789MNO1', 'Charlie Davis', 'XYZ987ABC0');

-- Tạo bảng Branch
CREATE TABLE Branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(50),
    parent_branch VARCHAR(10) 
);
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('1', 'Hanoi', NULL);
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('2', 'Haiphong', NULL);
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('3', 'Hochiminh', NULL);
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN1', 'Ba Dinh', '1');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN2', 'Dong Da', '1');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN3', 'Ha Noi', '1');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN4', 'Dong Hai Phong', '2');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN5', 'Hai Phong', '2');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN6', 'Q1', '3');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('CN7', 'Thu Duc', '3');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD1', 'PGD Bich Cau', 'CN1');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD10', 'PGD To Hieu', 'CN4');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD11', 'PGD Hong Bang', 'CN4');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD12', 'PGD Le Chan', 'CN5');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD13', 'PGD Dien Bien Phu', 'CN5');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD14', 'PGD Thu Duc', 'CN6');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD15', 'PGD Thu Thiem', 'CN6');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD16', 'PGD Cu Chi', 'CN6');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD17', 'PGD Q1', 'CN6');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD18', 'PGD Cho Lon', 'CN7');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD19', 'PGD Sai Gon', 'CN7');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD2', 'PGD Cau Giay', 'CN1');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD20', 'PGD Thao Dien', 'CN7');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD3', 'PGD Le Van Luong', 'CN1');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD4', 'PGD La Thanh', 'CN2');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD5', 'PGD Chua Lang', 'CN2');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD6', 'PGD Nguyen Chi Thanh', 'CN2');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD7', 'PGD Tay Ho', 'CN3');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD8', 'PGD Le Van Huu', 'CN3');
INSERT INTO Branch (branch_id, branch_name, parent_branch) VALUES ('PGD9', 'PGD Kien An', 'CN4');

-- Tạo bảng EPLFootballTeam2324
CREATE TABLE EPLFootballTeam2324 (
    TeamName VARCHAR(255) PRIMARY KEY,
    Abbreviation VARCHAR(3),
    HomeStadium VARCHAR(255)
);
INSERT INTO EPLFootballTeam2324 (TeamName, Abbreviation, HomeStadium)
VALUES
    ('Arsenal', 'ARS', 'Emirates Stadium'),
    ('Aston Villa', 'AVL', 'Villa Park'),
    ('Bournemouth', 'BOU', 'Vitality Stadium'),
    ('Brentford', 'BRE', 'Brentford Community Stadium'),
    ('Brighton & Hove Albion', 'BHA', 'American Express Community Stadium'),
    ('Burnley', 'BUR', 'Turf Moor'),
    ('Chelsea', 'CHE', 'Stamford Bridge'),
    ('Crystal Palace', 'CRY', 'Selhurst Park'),
    ('Everton', 'EVE', 'Goodison Park'),
    ('Fulham', 'FUL', 'Craven Cottage'),
    ('Liverpool', 'LIV', 'Anfield'),
    ('Luton Town', 'LUT', 'Kenilworth Road'),
    ('Manchester City', 'MCI', 'Etihad Stadium'),
    ('Manchester United', 'MUN', 'Old Trafford'),
    ('Newcastle United', 'NEW', 'St James'' Park'),
    ('Nottingham Forest', 'NOT', 'City Ground'),
    ('Sheffield United', 'SHU', 'Bramall Lane'),
    ('Tottenham Hotspur', 'TOT', 'Tottenham Hotspur Stadium'),
    ('West Ham United', 'WHU', 'London Stadium'),
    ('Wolverhampton Wanderers', 'WOL', 'Molineux Stadium');

-- Từ bảng Employee, hãy lấy ra tên nhân viên và tên quản lý của họ


-- Từ bảng Customer, hãy lấy ra tên khách hàng và người giới thiệu của họ


-- Từ bảng Branch, hãy lấy ra các chi nhánh (lv2), chi nhánh con (lv3) và chi nhánh mẹ (lv1) của chi nhánh đó


-- Từ bảng EPLFootballTeam2324, hãy tạo danh sách các trận đấu trong một mùa giải, bao gồm tên đội chủ nhà, tên đội khách, và sân thi đấu (là sân nhà của đội chủ nhà)