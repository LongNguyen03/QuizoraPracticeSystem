-- Debug Practice Tables
-- Kiểm tra cấu trúc bảng PracticeAnswers

-- Kiểm tra bảng có tồn tại không
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PracticeAnswers')
BEGIN
    PRINT 'Bảng PracticeAnswers tồn tại!';
    
    -- Kiểm tra cấu trúc cột
    SELECT 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'PracticeAnswers'
    ORDER BY ORDINAL_POSITION;
    
    -- Kiểm tra dữ liệu mẫu
    SELECT TOP 5 * FROM PracticeAnswers ORDER BY Id DESC;
    
    -- Kiểm tra số lượng records
    SELECT COUNT(*) as TotalRecords FROM PracticeAnswers;
    
END
ELSE
BEGIN
    PRINT 'Bảng PracticeAnswers KHÔNG tồn tại!';
    
    -- Tạo bảng nếu không tồn tại
    CREATE TABLE PracticeAnswers (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        PracticeSessionId INT NOT NULL,
        QuestionId INT NOT NULL,
        AnswerId INT NULL,
        IsCorrect BIT NOT NULL DEFAULT 0,
        FOREIGN KEY (PracticeSessionId) REFERENCES PracticeSessions(Id),
        FOREIGN KEY (QuestionId) REFERENCES Questions(Id),
        FOREIGN KEY (AnswerId) REFERENCES QuestionAnswers(Id)
    );
    
    PRINT 'Đã tạo bảng PracticeAnswers!';
END

-- Kiểm tra bảng PracticeSessions
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PracticeSessions')
BEGIN
    PRINT 'Bảng PracticeSessions tồn tại!';
    SELECT COUNT(*) as TotalSessions FROM PracticeSessions;
    SELECT TOP 3 * FROM PracticeSessions ORDER BY Id DESC;
END
ELSE
BEGIN
    PRINT 'Bảng PracticeSessions KHÔNG tồn tại!';
END

-- Kiểm tra dữ liệu Questions và QuestionAnswers
SELECT 'Questions' as TableName, COUNT(*) as RecordCount FROM Questions
UNION ALL
SELECT 'QuestionAnswers' as TableName, COUNT(*) as RecordCount FROM QuestionAnswers; 