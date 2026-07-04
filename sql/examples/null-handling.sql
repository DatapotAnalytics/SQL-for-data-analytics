/*
NULL handling patterns in SQL Server.
Created by Hoang (Datapot Analytics)
*/

DROP TABLE IF EXISTS #Players;
GO

CREATE TABLE #Players (
    PlayerID INT PRIMARY KEY,
    LastName NVARCHAR(50),
    MiddleName NVARCHAR(50),
    FirstName NVARCHAR(50),
    BirthYear INT,
    Zodiac NVARCHAR(20),
    YearlyIncome DECIMAL(18, 2)
);

INSERT INTO #Players (PlayerID, LastName, MiddleName, FirstName, BirthYear, Zodiac, YearlyIncome)
VALUES
    (1, N'Nguyen', N'Quang', N'Hai', 1997, N'Libra', 10.00),
    (2, N'Nguyen', NULL, N'Phuong', 1995, N'Pisces', 5.00),
    (3, N'Do', N'Duy', N'Manh', NULL, NULL, NULL),
    (4, N'Que', N'Ngoc', N'Hai', 1993, N'', 0.00),
    (5, N'Nguyen', N'', N'Anh', 1995, N'Scorpio', 5.00);

SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    BirthYear,
    Zodiac,
    YearlyIncome
FROM #Players;

-----------------------------------------------------
-- 1) Any arithmetic/string operation with NULL returns NULL
-----------------------------------------------------
SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    LastName + N'-' + MiddleName + N'-' + FirstName AS FullName_Basic,
    CONCAT(LastName, N'-', MiddleName, N'-', FirstName) AS FullName_Concat,
    CONCAT_WS(N'-', LastName, MiddleName, FirstName) AS FullName_ConcatWs,
    CONCAT_WS(N'-', LastName, NULLIF(MiddleName, N''), FirstName) AS FullName_ConcatWsClean
FROM #Players;

-----------------------------------------------------
-- 2) Comparisons with NULL are UNKNOWN (not TRUE)
-----------------------------------------------------
SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    BirthYear
FROM #Players
WHERE BirthYear <= 1994;

SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    BirthYear
FROM #Players
WHERE BirthYear > 1994;

SELECT
    PlayerID,
    BirthYear,
    IIF(BirthYear > 1994, 'TRUE', 'FALSE') AS IsGreaterThan1994,
    IIF(BirthYear <= 1994, 'TRUE', 'FALSE') AS IsLessOrEqual1994
FROM #Players;

SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    BirthYear
FROM #Players
WHERE BirthYear IS NULL;

-- Always FALSE, because "= NULL" is invalid for NULL checks
SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    BirthYear
FROM #Players
WHERE BirthYear = NULL;

-- NOT IN with nullable columns can remove expected rows
SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    Zodiac
FROM #Players
WHERE Zodiac NOT IN (N'Libra', N'Pisces')
   OR Zodiac IS NULL;

SELECT
    PlayerID,
    LastName,
    MiddleName,
    FirstName,
    Zodiac
FROM #Players
WHERE Zodiac IS NULL
   OR Zodiac = N'';

-----------------------------------------------------
-- 3) Aggregate functions ignore NULL values
-----------------------------------------------------
DROP TABLE IF EXISTS #RevenueCost;
CREATE TABLE #RevenueCost (
    ID INT PRIMARY KEY,
    [Date] DATE,
    Revenue DECIMAL(10, 2),
    Cost DECIMAL(10, 2)
);

INSERT INTO #RevenueCost (ID, [Date], Revenue, Cost)
VALUES
    (1, '2024-01-01', 15.00, 20.00),
    (2, '2024-01-02', 12.00, 15.00),
    (3, '2024-01-03', NULL, 10.00),
    (4, '2024-01-04', 10.00, NULL),
    (5, '2024-01-05', 90.00, 50.00),
    (6, '2024-01-06', NULL, NULL),
    (7, '2024-01-07', 20.00, 30.00),
    (8, '2024-01-08', NULL, 5.00),
    (9, '2024-01-09', 10.00, NULL),
    (10, '2024-01-10', 15.00, 10.00);

SELECT
    AVG(Revenue) AS Revenue_Avg_IgnoreNull,
    AVG(Cost) AS Cost_Avg_IgnoreNull,
    SUM(Revenue) / COUNT([Date]) AS Revenue_Avg_WithDateCount,
    SUM(Cost) / COUNT([Date]) AS Cost_Avg_WithDateCount
FROM #RevenueCost;
