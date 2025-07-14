package DAO;

import Model.Question;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class QuestionDAOTest {

    static QuestionDAO dao;
    static int createdQuestionId;
    static final int TEST_SUBJECT_ID = 1; // đảm bảo tồn tại
    static final int TEST_LESSON_ID = 1;  // đảm bảo tồn tại

    @BeforeAll
    static void setup() {
        dao = new QuestionDAO();
    }

    @Test
    @Order(1)
    void testCreateQuestion() {
        Question q = new Question();
        q.setSubjectId(TEST_SUBJECT_ID);
        q.setLessonId(TEST_LESSON_ID);
        q.setLevel("Easy");
        q.setContent("Unit test content");
        q.setStatus("Active");
        q.setImage(null);
        q.setPracticeOnly(true);

        dao.createQuestion(q);
        createdQuestionId = q.getId();

        assertTrue(createdQuestionId > 0, "Phải có ID được tạo");
    }

    @Test
    @Order(2)
    void testGetQuestionById() {
        Question q = dao.getQuestionById(createdQuestionId);
        assertNotNull(q, "Không tìm thấy question");
        assertEquals("Unit test content", q.getContent());
    }

    @Test
    @Order(3)
    void testGetActiveQuestions() {
        List<Question> list = dao.getActiveQuestions();
        assertFalse(list.isEmpty());
        boolean found = list.stream().anyMatch(q -> q.getId() == createdQuestionId);
        assertTrue(found, "Không tìm thấy question vừa tạo trong list active");
    }

    @Test
    @Order(4)
    void testUpdateQuestion() {
        Question q = dao.getQuestionById(createdQuestionId);
        q.setContent("Updated content");
        q.setLevel("Medium");
        q.setPracticeOnly(false);

        dao.updateQuestion(q);

        Question updated = dao.getQuestionById(createdQuestionId);
        assertEquals("Updated content", updated.getContent());
        assertEquals("Medium", updated.getLevel());
        assertFalse(updated.isPracticeOnly());
    }

    @Test
    @Order(5)
    void testGetQuestionsByLessonId() {
        List<Question> list = dao.getQuestionsByLessonId(TEST_LESSON_ID);
        assertFalse(list.isEmpty());
        boolean found = list.stream().anyMatch(q -> q.getId() == createdQuestionId);
        assertTrue(found, "Không tìm thấy question theo lesson id");
    }

    @Test
    @Order(6)
    void testGetQuestionsBySubjectId() {
        List<Question> list = dao.getQuestionsBySubjectId(TEST_SUBJECT_ID);
        assertFalse(list.isEmpty());
        boolean found = list.stream().anyMatch(q -> q.getId() == createdQuestionId);
        assertTrue(found, "Không tìm thấy question theo subject id");
    }

    @Test
    @Order(7)
    void testGetFilteredQuestions() {
        List<Question> list = dao.getFilteredQuestions(
                String.valueOf(TEST_SUBJECT_ID),
                String.valueOf(TEST_LESSON_ID),
                null,
                "Medium",
                "Updated"
        );
        assertFalse(list.isEmpty());
        boolean found = list.stream().anyMatch(q -> q.getId() == createdQuestionId);
        assertTrue(found, "Không tìm thấy question filter");
    }

    @Test
    @Order(8)
    void testDeleteQuestion() {
        dao.deleteQuestion(createdQuestionId);
        Question q = dao.getQuestionById(createdQuestionId);
        assertEquals("Inactive", q.getStatus(), "Status không chuyển thành Inactive");
    }

    @Test
    @Order(9)
    void testGetQuestionsByQuizId() {
        // ⚠️ Đảm bảo QuizQuestions đã có liên kết QuizId -> QuestionId
        // Ví dụ insert: INSERT INTO QuizQuestions (QuizId, QuestionId, QuestionOrder) VALUES (1, createdQuestionId, 1);
        int testQuizId = 1;
        List<Question> list = dao.getQuestionsByQuizId(testQuizId);
        assertNotNull(list);
        // Không assertEmpty vì có thể quiz chưa gán
    }
}
