/*
Customer ranking by yearly sales with CASE and non-equi JOIN patterns.
Target DB: AdventureWorksDW2019
*/

USE AdventureWorksDW2019;
GO

-- 1) Baseline: yearly sales by customer
WITH CustomerSalesByYear AS (
    SELECT
        CustomerKey,
        YEAR(OrderDate) AS OrderYear,
        SUM(SalesAmount) AS SalesAmountYear
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey, YEAR(OrderDate)
)
SELECT
    CustomerKey,
    OrderYear,
    SalesAmountYear
FROM CustomerSalesByYear
ORDER BY CustomerKey, OrderYear;

-- 2) Option A: CASE WHEN ranking
WITH CustomerSalesByYear AS (
    SELECT
        CustomerKey,
        YEAR(OrderDate) AS OrderYear,
        SUM(SalesAmount) AS SalesAmountYear
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey, YEAR(OrderDate)
)
SELECT
    CustomerKey,
    OrderYear,
    SalesAmountYear,
    CASE
        WHEN SalesAmountYear <= 1000 THEN 'Bronze'
        WHEN SalesAmountYear <= 2000 THEN 'Silver'
        WHEN SalesAmountYear <= 3500 THEN 'Gold'
        ELSE 'Diamond'
    END AS CustomerRanking
FROM CustomerSalesByYear
ORDER BY CustomerKey, OrderYear;

-- 3) Option B: non-equi JOIN with threshold table
-- Using NULL for open-ended max value removes the 999999999 magic number.
DROP TABLE IF EXISTS #TempCustomerRank;
CREATE TABLE #TempCustomerRank (
    CustomerGroup VARCHAR(18) NOT NULL,
    MinValue DECIMAL(18, 2) NOT NULL,
    MaxValue DECIMAL(18, 2) NULL
);

INSERT INTO #TempCustomerRank (CustomerGroup, MinValue, MaxValue)
VALUES
('Bronze', 0.00, 1000.00),
('Silver', 1000.00, 2000.00),
('Gold', 2000.00, 3500.00),
('Diamond', 3500.00, NULL);

WITH CustomerSalesByYear AS (
    SELECT
        CustomerKey,
        YEAR(OrderDate) AS OrderYear,
        SUM(SalesAmount) AS SalesAmountYear
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey, YEAR(OrderDate)
)
SELECT
    s.CustomerKey,
    s.OrderYear,
    s.SalesAmountYear,
    r.CustomerGroup
FROM CustomerSalesByYear AS s
LEFT JOIN #TempCustomerRank AS r
    ON s.SalesAmountYear >= r.MinValue
   AND (s.SalesAmountYear < r.MaxValue OR r.MaxValue IS NULL)
ORDER BY s.CustomerKey, s.OrderYear;

-- 4) Extension: yearly rules (effective-from / effective-to)
DROP TABLE IF EXISTS #TempCustomerRankByYear;
CREATE TABLE #TempCustomerRankByYear (
    CustomerGroup VARCHAR(18) NOT NULL,
    MinValue DECIMAL(18, 2) NOT NULL,
    MaxValue DECIMAL(18, 2) NULL,
    EffectiveYearFrom INT NOT NULL,
    EffectiveYearTo INT NOT NULL
);

INSERT INTO #TempCustomerRankByYear (
    CustomerGroup,
    MinValue,
    MaxValue,
    EffectiveYearFrom,
    EffectiveYearTo
)
VALUES
('Bronze', 0.00, 1000.00, 2010, 2013),
('Silver', 1000.00, 1500.00, 2010, 2013),
('Gold', 1500.00, 3000.00, 2010, 2013),
('Diamond', 3000.00, NULL, 2010, 2013),
('Bronze', 0.00, 1000.00, 2013, 9999),
('Silver', 1000.00, 2000.00, 2013, 9999),
('Gold', 2000.00, 3500.00, 2013, 9999),
('Diamond', 3500.00, NULL, 2013, 9999);

WITH CustomerSalesByYear AS (
    SELECT
        CustomerKey,
        YEAR(OrderDate) AS OrderYear,
        SUM(SalesAmount) AS SalesAmountYear
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey, YEAR(OrderDate)
)
SELECT
    s.CustomerKey,
    s.OrderYear,
    s.SalesAmountYear,
    r.CustomerGroup
FROM CustomerSalesByYear AS s
LEFT JOIN #TempCustomerRankByYear AS r
    ON s.SalesAmountYear >= r.MinValue
   AND (s.SalesAmountYear < r.MaxValue OR r.MaxValue IS NULL)
   AND s.OrderYear >= r.EffectiveYearFrom
   AND s.OrderYear < r.EffectiveYearTo
ORDER BY s.CustomerKey, s.OrderYear;
