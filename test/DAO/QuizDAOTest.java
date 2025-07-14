package DAO;

import Model.Quiz;
import org.junit.jupiter.api.*;

import java.sql.Timestamp;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class QuizDAOTest {

    static QuizDAO dao;
    static int createdQuizId;
    static final int TEST_SUBJECT_ID = 1; // Subject mẫu có ID = 1

    @BeforeAll
    static void setup() {
        dao = new QuizDAO();
    }

    @Test
    @Order(1)
    void testInsertQuiz() {
        Quiz quiz = new Quiz();
        quiz.setName("Unit Test Quiz");
        quiz.setSubjectId(TEST_SUBJECT_ID);
        quiz.setLevel("Easy");
        quiz.setNumberOfQuestions(5);
        quiz.setDurationMinutes(30);
        quiz.setPassRate(70.0);
        quiz.setType("Practice");

        dao.insertQuiz(quiz);

        // ⚠️ Nếu `insertQuiz` không set lại ID, cần truy vấn lại
        List<Quiz> quizzes = dao.getQuizzesBySubjectId(TEST_SUBJECT_ID);
        assertFalse(quizzes.isEmpty());

        Quiz found = quizzes.stream()
                .filter(q -> q.getName().equals("Unit Test Quiz"))
                .findFirst()
                .orElse(null);

        assertNotNull(found);
        createdQuizId = found.getId();
        assertTrue(createdQuizId > 0, "Phải lấy được ID quiz vừa tạo");
    }

    @Test
    @Order(2)
    void testGetQuizById() {
        Quiz quiz = dao.getQuizById(createdQuizId);
        assertNotNull(quiz);
        assertEquals("Unit Test Quiz", quiz.getName());
        assertEquals("Easy", quiz.getLevel());
    }

    @Test
    @Order(3)
    void testUpdateQuiz() {
        Quiz quiz = dao.getQuizById(createdQuizId);
        quiz.setName("Updated Quiz");
        quiz.setLevel("Medium");
        quiz.setNumberOfQuestions(10);
        quiz.setPassRate(80.0);

        dao.updateQuiz(quiz);

        Quiz updated = dao.getQuizById(createdQuizId);
        assertEquals("Updated Quiz", updated.getName());
        assertEquals("Medium", updated.getLevel());
        assertEquals(10, updated.getNumberOfQuestions());
        assertEquals(80.0, updated.getPassRate());
    }

    @Test
    @Order(4)
    void testGetQuizzesBySubjectId() {
        List<Quiz> quizzes = dao.getQuizzesBySubjectId(TEST_SUBJECT_ID);
        assertFalse(quizzes.isEmpty());
        boolean found = quizzes.stream().anyMatch(q -> q.getId() == createdQuizId);
        assertTrue(found, "Không tìm thấy quiz theo subjectId");
    }

    @Test
    @Order(5)
    void testGetAllAvailableQuizzes() {
        List<Quiz> quizzes = dao.getAllAvailableQuizzes();
        assertFalse(quizzes.isEmpty());
        boolean found = quizzes.stream().anyMatch(q -> q.getId() == createdQuizId);
        assertTrue(found, "Không tìm thấy quiz vừa tạo trong all available");
    }

    @Test
    @Order(6)
    void testGetAllQuizLevels() {
        List<String> levels = dao.getAllQuizLevels();
        assertTrue(levels.contains("Medium"), "Không tìm thấy level Medium trong danh sách levels");
    }

    @Test
    @Order(7)
    void testDeleteQuiz() {
        dao.deleteQuiz(createdQuizId);
        Quiz quiz = dao.getQuizById(createdQuizId);
        assertNull(quiz, "Quiz không bị xóa");
    }

}
