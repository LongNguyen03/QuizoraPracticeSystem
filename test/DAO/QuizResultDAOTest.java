package DAO;

import Model.QuizResult;
import org.junit.jupiter.api.*;
import java.sql.*;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class QuizResultDAOTest {

    private static Connection connection;
    private static QuizResultDAO quizResultDAO;

    @BeforeAll
    static void setup() throws SQLException {
        // 💡 Dùng H2 in-memory cho test
        connection = DriverManager.getConnection("jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1");
        quizResultDAO = new QuizResultDAO();
        quizResultDAO.connection = connection;

        try (Statement stmt = connection.createStatement()) {
            // Tạo bảng QuizResults tối thiểu
            stmt.execute("CREATE TABLE QuizResults (" +
                    "Id INT AUTO_INCREMENT PRIMARY KEY," +
                    "QuizId INT," +
                    "AccountId INT," +
                    "Score DOUBLE," +
                    "Passed BOOLEAN," +
                    "AttemptDate TIMESTAMP," +
                    "CompletionTime TIMESTAMP" +
                    ")");
        }
    }

    @AfterAll
    static void tearDown() throws SQLException {
        connection.close();
    }

    @Test
    void testSaveAndGetQuizResult() {
        // 📝 Tạo mới
        QuizResult result = new QuizResult();
        result.setQuizId(1);
        result.setAccountId(100);
        result.setScore(85.0);
        result.setPassed(true);
        result.setAttemptDate(new Date());
        result.setCompletionTime(new Date());

        int newId = quizResultDAO.saveQuizResult(result);
        assertTrue(newId > 0);

        // 🔍 Truy vấn lại
        QuizResult loaded = quizResultDAO.getQuizResultById(newId);
        assertNotNull(loaded);
        assertEquals(85.0, loaded.getScore());
        assertEquals(1, loaded.getQuizId());
        assertTrue(loaded.isPassed());
    }

    @Test
    void testGetQuizResultsByAccountId() {
        // 📝 Thêm nhiều kết quả
        for (int i = 0; i < 3; i++) {
            QuizResult result = new QuizResult();
            result.setQuizId(2);
            result.setAccountId(200);
            result.setScore(60 + i * 10);
            result.setPassed(true);
            result.setAttemptDate(new Date());
            result.setCompletionTime(new Date());
            quizResultDAO.saveQuizResult(result);
        }

        List<QuizResult> results = quizResultDAO.getQuizResultsByAccountId(200);
        assertEquals(3, results.size());
    }

    @Test
    void testGetAverageScoreByAccountId() {
        // 📝 Thêm kết quả mới để test average
        QuizResult r1 = new QuizResult();
        r1.setQuizId(3);
        r1.setAccountId(300);
        r1.setScore(70);
        r1.setPassed(true);
        r1.setAttemptDate(new Date());
        quizResultDAO.saveQuizResult(r1);

        QuizResult r2 = new QuizResult();
        r2.setQuizId(3);
        r2.setAccountId(300);
        r2.setScore(90);
        r2.setPassed(true);
        r2.setAttemptDate(new Date());
        quizResultDAO.saveQuizResult(r2);

        double avg = quizResultDAO.getAverageScoreByAccountId(300);
        assertTrue(avg >= 70 && avg <= 90);
        assertEquals(80.0, avg, 0.01);
    }

    @Test
    void testGetCompletedQuizCountByAccountId() {
        // 📝 Thêm kết quả mới
        QuizResult r1 = new QuizResult();
        r1.setQuizId(4);
        r1.setAccountId(400);
        r1.setScore(100);
        r1.setPassed(true);
        r1.setAttemptDate(new Date());
        quizResultDAO.saveQuizResult(r1);

        int count = quizResultDAO.getCompletedQuizCountByAccountId(400);
        assertEquals(1, count);
    }
}
