-- Create PracticeSessions table
CREATE TABLE PracticeSessions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    AccountId INT NOT NULL,
    SubjectId INT NOT NULL,
    LessonId INT NULL, -- nullable for practice by subject
    StartTime DATETIME2 NOT NULL,
    EndTime DATETIME2 NULL,
    TotalScore DECIMAL(5,2) NULL,
    Completed BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (AccountId) REFERENCES Accounts(Id),
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (LessonId) REFERENCES Lessons(Id)
);

-- Create PracticeSessionQuestions table to store randomized question order
CREATE TABLE PracticeSessionQuestions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PracticeSessionId INT NOT NULL,
    QuestionId INT NOT NULL,
    FOREIGN KEY (PracticeSessionId) REFERENCES PracticeSessions(Id),
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id)
);

-- Create PracticeAnswers table
CREATE TABLE PracticeAnswers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PracticeSessionId INT NOT NULL,
    QuestionId INT NOT NULL,
    AnswerId INT NULL, -- nullable for unanswered questions
    IsCorrect BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (PracticeSessionId) REFERENCES PracticeSessions(Id),
    FOREIGN KEY (QuestionId) REFERENCES Questions(Id),
    FOREIGN KEY (AnswerId) REFERENCES QuestionAnswers(Id)
);

-- Create indexes for better performance
CREATE INDEX IX_PracticeSessions_AccountId ON PracticeSessions(AccountId);
CREATE INDEX IX_PracticeSessions_SubjectId ON PracticeSessions(SubjectId);
CREATE INDEX IX_PracticeSessions_StartTime ON PracticeSessions(StartTime);
CREATE INDEX IX_PracticeSessionQuestions_SessionId ON PracticeSessionQuestions(PracticeSessionId);
CREATE INDEX IX_PracticeSessionQuestions_QuestionId ON PracticeSessionQuestions(QuestionId);
CREATE INDEX IX_PracticeAnswers_SessionId ON PracticeAnswers(PracticeSessionId);
CREATE INDEX IX_PracticeAnswers_QuestionId ON PracticeAnswers(QuestionId);

-- Insert sample data for testing (optional)
-- INSERT INTO PracticeSessions (AccountId, SubjectId, LessonId, StartTime, EndTime, TotalScore, Completed)
-- VALUES 
--     (1, 1, 1, GETDATE(), DATEADD(MINUTE, 30, GETDATE()), 85.5, 1),
--     (1, 1, 2, DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, -1, DATEADD(MINUTE, 45, GETDATE())), 72.0, 1);

-- Add IsPracticeOnly column to Questions table if not exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Questions' AND COLUMN_NAME = 'IsPracticeOnly')
BEGIN
    ALTER TABLE Questions ADD IsPracticeOnly BIT NOT NULL DEFAULT 0;
END

-- Update existing questions to be available for practice
UPDATE Questions SET IsPracticeOnly = 0 WHERE IsPracticeOnly IS NULL; 