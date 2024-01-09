/*
Các lưu ý khi làm việc với NULL
Created by Hoang at 2024-01-06
(c) Datapot Analytics
*/
-- Xoá bản tạm nếu đã tồn tại
DROP TABLE IF EXISTS #DSCauThu

GO 
-- Tạo bảng tạm
CREATE TABLE #DSCauThu (
    CauThuID INT PRIMARY KEY,
    Ho NVARCHAR(50),
    TenDem NVARCHAR(50),
    Ten NVARCHAR(50),
    NamSinh INT,
    CungHoangDao NVARCHAR(20),
    ThuNhapNam decimal(18, 10)
);

-- Insert dữ liệu vào bảng tạm
INSERT INTO #DSCauThu (CauThuID, Ho, TenDem, Ten, NamSinh, CungHoangDao, ThuNhapNam)
VALUES 
    (1, N'Nguyễn', N'Quang', N'Hải', 1997, N'Thiên Bình', 10),
    (2, N'Nguyễn', NULL, N'Phượng', 1995, N'Song Ngư', 5),
    (3, N'Đỗ', N'Duy', N'Mạnh', NULL, NULL, NULL),
    (4, N'Quế', N'Ngọc', N'Hải', 1993, N'', 0),
    (5, N'Nguyễn', '', N'Anh', 1995, N'Thần Nông', 5)


-- Show bảng dữ liệu mẫu
SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
, CungHoangDao
FROM #DSCauThu 

-----------------------------------------------------
-- Lưu ý 1: Mọi phép toán với NULL đều trả về NULL
-----------------------------------------------------
-- Yêu cầu: Tạo ra một trường thông tin HovaTen ghép từ Ho, TenDem, Ten và phân cách bởi dấu "-" ở giữa.

SELECT 
CauThuID
, Ho
, TenDem
, Ten
, Ho + '-' + TenDem + '-' + Ten as 'HovaTen'
, CONCAT(Ho , '-', TenDem, '-', Ten) as 'HovaTen_1'  
, CONCAT_WS( '-', Ho , TenDem, Ten) as 'HovaTen_2' 
, CONCAT_WS( '-', Ho , NULLIF(TenDem, ''), Ten) as 'HovaTen_3' 
FROM #DSCauThu 

/*
Kết luận: Mọi phép toán thực hiện với NULL đều sẽ trả về NULL. 
Chúng ta cần xác định cách thức xử lý phù hợp cho từng trường hợp.
*/








SELECT 
CauThuID
, Ho
, TenDem
, Ten
, Ho + '-' + TenDem + '-' + Ten as 'HovaTen'
-- , CONCAT(Ho , '-', TenDem, '-', Ten) as 'HovaTen_1'  
-- , CONCAT_WS( '-', Ho , TenDem, Ten) as 'HovaTen_2' 
-- , CONCAT_WS( '-', Ho , NULLIF(TenDem, ''), Ten) as 'HovaTen_3' 
FROM #DSCauThu 







-----------------------------------------------------
-- Lưu ý 2: Mọi phép toán so sánh với NULL đều trả về FALSE
-----------------------------------------------------

-- Show bảng dữ liệu mẫu
SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
, CungHoangDao
FROM #DSCauThu 


SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
FROM #DSCauThu 
WHERE NamSinh <= 1994


SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
FROM #DSCauThu 
WHERE NamSinh > 1994


-- Cùng nhìn kĩ hơn vào logic của mệnh đề WHERE
SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
, IIF(NamSinh > 1994, 'TRUE', 'FALSE') as "> 1994"
, IIF(NamSinh <= 1994, 'TRUE', 'FALSE') as "<= 1994"
FROM #DSCauThu 



SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
FROM #DSCauThu 
WHERE NamSinh IS NULL


SELECT 
CauThuID
, Ho
, TenDem
, Ten
, NamSinh
FROM #DSCauThu 
WHERE NamSinh = NULL




-- Vấn đề rủi ro xảy ra thường xuyên hơn khi làm việt với phép loại trừ (NOT IN)
SELECT 
CauThuID
, Ho
, TenDem
, Ten
, CungHoangDao
FROM #DSCauThu 
WHERE CungHoangDao NOT IN (N'Thiên Bình', N'Song Ngư') or CungHoangDao IS NULL


-- Xử lý NULL và chuỗi rỗng trong bộ lọc một cách cẩn trọng
SELECT 
CauThuID
, Ho
, TenDem
, Ten
, CungHoangDao
FROM #DSCauThu 
WHERE CungHoangDao IS NULL or CungHoangDao = ''




-----------------------------------------------------
-- Lưu ý 3: Các phép toán tổng hợp dữ liệu không tính đến NULL
-----------------------------------------------------

-- Xoá bản tạm nếu đã tồn tại
DROP TABLE IF EXISTS #BangDoanhThuChiPhi

-- Tạo bảng tạm mới
CREATE TABLE #BangDoanhThuChiPhi (
    ID INT PRIMARY KEY,
    Ngay DATE,
    DoanhThu DECIMAL(10, 2),
    ChiPhi DECIMAL(10, 2)
);

-- Insert dữ liệu vào bảng tạm
INSERT INTO #BangDoanhThuChiPhi (ID, Ngay, DoanhThu, ChiPhi)
VALUES 
    (1, '2024-01-01', 15.00, 20.00),
    (2, '2024-01-02', 12.00, 15.00),
    (3, '2024-01-03', NULL, 10.00),  -- Không có doanh thu
    (4, '2024-01-04', 10.00, NULL),  -- Không có chi phí
    (5, '2024-01-05', 90.00, 50.00),
    (6, '2024-01-06', NULL, NULL),     -- Không có cả doanh thu và chi phí
    (7, '2024-01-07', 20.00, 30.00),
    (8, '2024-01-08', NULL, 5.00),    -- Không có doanh thu
    (9, '2024-01-09', 10.00, NULL),  -- Không có chi phí
    (10, '2024-01-10', 15.00, 10.00);

SELECT * FROM #BangDoanhThuChiPhi

SELECT 
  AVG(DoanhThu) as DoanhThu_AVG
, AVG(ChiPhi) as ChiPhi_AVG
, SUM(DoanhThu)/COUNT(Ngay) as DoanhThu_TB
, SUM(ChiPhi)/COUNT(Ngay) as ChiPhi_TB
FROM #BangDoanhThuChiPhi