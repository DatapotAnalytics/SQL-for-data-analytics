/*
Yêu cầu bài toán: Phân hạng khách hàng theo tổng doanh thu năm, trong đó các hạng được xác định như sau:
             Min                Max
- Bronze :      0      |         1000
- Silver :    1000     |         2000
- Gold   :    2000     |         3500
- Diamond:    3500	   |    999999999    ----> Tại sao ô này không bỏ trống mà phải để là 999999999
*/

USE AdventureWorksDW2019

SELECT CustomerKey
    , YEAR(OrderDate) as Order_Year
    , SUM(SalesAmount) AS Sales_Amount_Year
FROM dbo.FactInternetSales
GROUP BY CustomerKey, YEAR(OrderDate)




-- Phương án 1 : Case - When

SELECT CustomerKey
    , YEAR(OrderDate) as Order_Year
    , SUM(SalesAmount) AS Sales_Amount_Year
    ,  CASE
        WHEN SUM(SalesAmount) <= 1000 THEN 'Bronze'
        WHEN SUM(SalesAmount) > 1000 AND SUM(SalesAmount) <= 2000 THEN 'Silver'
        WHEN SUM(SalesAmount) > 2000 AND SUM(SalesAmount) <= 3500 THEN 'Gold'
        ELSE 'Diamonds'
       END AS CustomerRanking
FROM dbo.FactInternetSales
GROUP BY CustomerKey, YEAR(OrderDate)


-- Phương án 2: Tạo 1 bảng insert dữ liệu để quản lý phân hạng và dùng no-equi joins
DROP TABLE IF EXISTS #TempCustomerRank

-- Tạo một bảng tạm có 3 trường thông tin: Phân hạng khách hàng (Diamond, Gold, Silver, Bronze), giá trị min, giá trị max
CREATE TABLE #TempCustomerRank (
    Customer_Group VARCHAR(18),
    MinValue DECIMAL(18,2),
    MaxValue DECIMAL(18,2)
);

-- Chèn dữ liệu mẫu vào bảng
INSERT INTO #TempCustomerRank (Customer_Group, MinValue, MaxValue)
VALUES
('Diamond', 3500.00, 999999999.00),
('Gold', 2000.00, 3500.00),
('Silver', 1000.00, 2000.00),
('Bronze', 0.00, 1000.00);

-- In nội dung của bảng để kiểm tra
SELECT *
FROM #TempCustomerRank;


-- Tổng hợp doanh số mỗi khách hàng theo năm để dễ follow.
WITH CustomerSalesbyYear AS (
    SELECT CustomerKey
        , YEAR(OrderDate) as Order_Year
        , SUM(SalesAmount) AS Sales_Amount_Year
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey, YEAR(OrderDate)
)

SELECT CustomerSales.CustomerKey
, CustomerSales.Order_Year
, CustomerSales.Sales_Amount_Year
, CustomerRank.Customer_Group
FROM CustomerSalesbyYear  as CustomerSales
LEFT JOIN #TempCustomerRank as CustomerRank
    ON CustomerRank.MinValue <= CustomerSales.Sales_Amount_Year
   and CustomerRank.MaxValue >  CustomerSales.Sales_Amount_Year


-- Mở rộng: Nếu mỗi năm, các tiêu chí về hạng khách hàng lại thay đổi thì xử lý ntn?
-- Phương án: Mở rộng bảng tạm thêm 1 cột Năm + Thêm điều kiện vào phép Join.
-- Thêm 2 trường thông tin là Effective_Year_From và Effective_Year_To

DROP TABLE IF EXISTS #TempCustomerRankbyYear
CREATE TABLE #TempCustomerRankbyYear (
    Customer_Group VARCHAR(18)
    , MinValue DECIMAL(18,2)
    , MaxValue DECIMAL(18,2)
    , Effective_Year_From INT
    , Effective_Year_To INT
);

INSERT INTO #TempCustomerRankbyYear (Customer_Group, MinValue, MaxValue, Effective_Year_From, Effective_Year_To)
VALUES
('Diamond', 3500.00, 999999999.00, 2013, 9999),
('Gold', 2000.00, 3500.00, 2013, 9999),
('Silver', 1000.00, 2000.00,2013, 9999),
('Bronze', 0.00, 1000.00, 2013, 9999),
('Diamond', 3000.00, 999999999.00, 2010, 2013),
('Gold', 1500.00, 3000.00, 2010, 2013),
('Silver', 1000.00, 1500.00,2010, 2013),
('Bronze', 0.00, 1000.00, 2010, 2013);

SELECT * FROM #TempCustomerRankbyYear ORDER BY  Effective_Year_From, Customer_Group

GO
WITH CustomerSalesbyYear_1 AS (
    SELECT CustomerKey
        , YEAR(OrderDate) as Order_Year
        , SUM(SalesAmount) AS Sales_Amount_Year
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey, YEAR(OrderDate)
)

SELECT CustomerSales.CustomerKey
, CustomerSales.Order_Year
, CustomerSales.Sales_Amount_Year
, CustomerRank.Customer_Group
FROM CustomerSalesbyYear_1  as CustomerSales
LEFT JOIN #TempCustomerRankbyYear as CustomerRank
    ON CustomerRank.MinValue <= CustomerSales.Sales_Amount_Year
   and CustomerRank.MaxValue >  CustomerSales.Sales_Amount_Year
   and CustomerRank.Effective_Year_From <= CustomerSales.Order_Year
   and CustomerRank.Effective_Year_To > CustomerSales.Order_Year