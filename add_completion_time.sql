-- Thêm cột CompletionTime vào bảng QuizResults
-- Chạy script này để cập nhật cấu trúc database

-- Kiểm tra xem cột CompletionTime đã tồn tại chưa
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'QuizResults' AND COLUMN_NAME = 'CompletionTime'
)
BEGIN
    -- Thêm cột CompletionTime
    ALTER TABLE QuizResults ADD CompletionTime DATETIME NULL;
    PRINT 'Đã thêm cột CompletionTime vào bảng QuizResults';
END
ELSE
BEGIN
    PRINT 'Cột CompletionTime đã tồn tại trong bảng QuizResults';
END

-- Kiểm tra cấu trúc bảng sau khi cập nhật
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'QuizResults' 
ORDER BY ORDINAL_POSITION; 