package DAO;

import Model.QuizUserAnswer;
import org.junit.jupiter.api.*;

import java.sql.*;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class QuizUserAnswerDAOTest {

    private static Connection connection;
    private static QuizUserAnswerDAO dao;

    @BeforeAll
    static void setup() throws SQLException {
        // 🗄️ Setup H2 in-memory
        connection = DriverManager.getConnection("jdbc:h2:mem:testdb2;DB_CLOSE_DELAY=-1");
        dao = new QuizUserAnswerDAO();
        dao.connection = connection;

        try (Statement stmt = connection.createStatement()) {
            // Tạo bảng tối thiểu
            stmt.execute("CREATE TABLE QuizUserAnswers (" +
                    "Id INT AUTO_INCREMENT PRIMARY KEY," +
                    "QuizResultId INT," +
                    "QuestionId INT," +
                    "AnswerId INT," +
                    "IsCorrect BOOLEAN)");

            stmt.execute("CREATE TABLE Questions (Id INT PRIMARY KEY, Content VARCHAR(255))");
            stmt.execute("CREATE TABLE QuestionAnswers (Id INT PRIMARY KEY, Content VARCHAR(255))");

            // Tạo dữ liệu mock cho JOIN
            stmt.execute("INSERT INTO Questions VALUES (1, 'Question 1 Content')");
            stmt.execute("INSERT INTO QuestionAnswers VALUES (10, 'Answer 1 Content')");
        }
    }

    @AfterAll
    static void tearDown() throws SQLException {
        connection.close();
    }

    @Test
    void testSaveUserAnswer() {
        QuizUserAnswer a = new QuizUserAnswer();
        a.setQuizResultId(1);
        a.setQuestionId(1);
        a.setAnswerId(10);
        a.setCorrect(true);

        dao.saveUserAnswer(a);

        List<QuizUserAnswer> answers = dao.getUserAnswersByResultId(1);
        assertEquals(1, answers.size());
        assertEquals(10, answers.get(0).getAnswerId());
        assertTrue(answers.get(0).isCorrect());
    }

    @Test
    void testSaveOrUpdateUserAnswer_insertAndUpdate() {
        QuizUserAnswer a = new QuizUserAnswer();
        a.setQuizResultId(2);
        a.setQuestionId(1);
        a.setAnswerId(10);
        a.setCorrect(false);

        dao.saveOrUpdateUserAnswer(a);

        List<QuizUserAnswer> answers = dao.getUserAnswersByResultId(2);
        assertEquals(1, answers.size());
        assertFalse(answers.get(0).isCorrect());

        // Gọi lại với cùng QuizResultId + QuestionId → sẽ UPDATE
        a.setCorrect(true);
        dao.saveOrUpdateUserAnswer(a);

        List<QuizUserAnswer> updated = dao.getUserAnswersByResultId(2);
        assertTrue(updated.get(0).isCorrect());
    }

    @Test
    void testGetUserAnswersWithDetails() {
        // Insert mới để join được
        QuizUserAnswer a = new QuizUserAnswer();
        a.setQuizResultId(3);
        a.setQuestionId(1);
        a.setAnswerId(10);
        a.setCorrect(true);
        dao.saveUserAnswer(a);

        List<QuizUserAnswer> details = dao.getUserAnswersWithDetails(3);
        assertEquals(1, details.size());

        QuizUserAnswer detail = details.get(0);
        assertEquals("Question 1 Content", detail.getQuestionContent());
        assertEquals("Answer 1 Content", detail.getAnswerContent());
    }

    @Test
    void testDeleteUserAnswersByResultId() {
        QuizUserAnswer a = new QuizUserAnswer();
        a.setQuizResultId(4);
        a.setQuestionId(1);
        a.setAnswerId(10);
        a.setCorrect(false);
        dao.saveUserAnswer(a);

        assertEquals(1, dao.getUserAnswersByResultId(4).size());

        dao.deleteUserAnswersByResultId(4);
        assertEquals(0, dao.getUserAnswersByResultId(4).size());
    }
}
