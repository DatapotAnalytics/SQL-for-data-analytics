/*
Self-join patterns for common analytics scenarios.
Created by BinhPH (Datapot Analytics)
*/

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS EPLFootballTeam2324;

-- Employee: manager hierarchy
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    ManagerID INT
);

INSERT INTO Employee (EmployeeID, EmployeeName, ManagerID)
VALUES
    (1, 'John Smith', 3),
    (2, 'Jane Anderson', 3),
    (3, 'Tom Lanon', 4),
    (4, 'Anne Connor', NULL),
    (5, 'Jeremy York', 1);

-- Customer: referral relationship
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

-- Branch: 3-level branch tree
CREATE TABLE Branch (
    BranchID VARCHAR(10) PRIMARY KEY,
    BranchName VARCHAR(50),
    ParentBranchID VARCHAR(10)
);

INSERT INTO Branch (BranchID, BranchName, ParentBranchID)
VALUES
    ('1', 'Hanoi', NULL),
    ('2', 'Haiphong', NULL),
    ('3', 'Ho Chi Minh', NULL),
    ('CN1', 'Ba Dinh', '1'),
    ('CN2', 'Dong Da', '1'),
    ('CN3', 'Ha Noi', '1'),
    ('CN4', 'Dong Hai Phong', '2'),
    ('CN5', 'Hai Phong', '2'),
    ('CN6', 'Q1', '3'),
    ('CN7', 'Thu Duc', '3'),
    ('PGD1', 'PGD Bich Cau', 'CN1'),
    ('PGD10', 'PGD To Hieu', 'CN4'),
    ('PGD11', 'PGD Hong Bang', 'CN4'),
    ('PGD12', 'PGD Le Chan', 'CN5'),
    ('PGD13', 'PGD Dien Bien Phu', 'CN5'),
    ('PGD14', 'PGD Thu Duc', 'CN6'),
    ('PGD15', 'PGD Thu Thiem', 'CN6'),
    ('PGD16', 'PGD Cu Chi', 'CN6'),
    ('PGD17', 'PGD Q1', 'CN6'),
    ('PGD18', 'PGD Cho Lon', 'CN7'),
    ('PGD19', 'PGD Sai Gon', 'CN7'),
    ('PGD2', 'PGD Cau Giay', 'CN1'),
    ('PGD20', 'PGD Thao Dien', 'CN7'),
    ('PGD3', 'PGD Le Van Luong', 'CN1'),
    ('PGD4', 'PGD La Thanh', 'CN2'),
    ('PGD5', 'PGD Chua Lang', 'CN2'),
    ('PGD6', 'PGD Nguyen Chi Thanh', 'CN2'),
    ('PGD7', 'PGD Tay Ho', 'CN3'),
    ('PGD8', 'PGD Le Van Huu', 'CN3'),
    ('PGD9', 'PGD Kien An', 'CN4');

-- EPL teams: generate home/away fixtures
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

-- 1) Employee and manager
SELECT
    e.EmployeeID,
    e.EmployeeName AS EmployeeName,
    m.EmployeeName AS ManagerName
FROM Employee AS e
LEFT JOIN Employee AS m
    ON e.ManagerID = m.EmployeeID
ORDER BY e.EmployeeID;

-- 2) Customer and referrer
SELECT
    c.CustomerID,
    c.CustomerName,
    r.CustomerName AS ReferrerName
FROM Customer AS c
LEFT JOIN Customer AS r
    ON c.ReferralID = r.CustomerID
ORDER BY c.CustomerID;

-- 3) Branch level-1, level-2, level-3
SELECT
    lv1.BranchID AS Level1ID,
    lv1.BranchName AS Level1Name,
    lv2.BranchID AS Level2ID,
    lv2.BranchName AS Level2Name,
    lv3.BranchID AS Level3ID,
    lv3.BranchName AS Level3Name
FROM Branch AS lv3
JOIN Branch AS lv2
    ON lv3.ParentBranchID = lv2.BranchID
JOIN Branch AS lv1
    ON lv2.ParentBranchID = lv1.BranchID
ORDER BY lv1.BranchID, lv2.BranchID, lv3.BranchID;

-- 4) Fixtures in one season (home vs away, no same-team match)
SELECT
    h.TeamName AS HomeTeam,
    a.TeamName AS AwayTeam,
    h.HomeStadium AS MatchStadium
FROM EPLFootballTeam2324 AS h
JOIN EPLFootballTeam2324 AS a
    ON h.TeamName <> a.TeamName
ORDER BY h.TeamName, a.TeamName;
