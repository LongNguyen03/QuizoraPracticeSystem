-- Kiểm tra cấu trúc bảng QuizResults
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'QuizResults' 
ORDER BY ORDINAL_POSITION;

-- Kiểm tra cấu trúc bảng QuizUserAnswers
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'QuizUserAnswers' 
ORDER BY ORDINAL_POSITION;

-- Kiểm tra dữ liệu mẫu trong QuizResults
SELECT TOP 10 * FROM QuizResults ORDER BY Id DESC;

-- Kiểm tra dữ liệu mẫu trong QuizUserAnswers
SELECT TOP 10 * FROM QuizUserAnswers ORDER BY Id DESC;

-- Kiểm tra xem có quiz nào không
SELECT TOP 5 * FROM Quizzes;

-- Kiểm tra xem có question nào không
SELECT TOP 5 * FROM Questions;

-- Kiểm tra xem có answer nào không
SELECT TOP 5 * FROM QuestionAnswers;

-- Tạo dữ liệu mẫu nếu cần
-- INSERT INTO QuizResults (QuizId, AccountId, Score, Passed, AttemptDate) 
-- VALUES (1, 1, 80.0, 1, GETDATE());

-- INSERT INTO QuizUserAnswers (QuizResultId, QuestionId, AnswerId, IsCorrect) 
-- VALUES (1, 1, 1, 1); 