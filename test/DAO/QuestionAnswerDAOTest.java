package DAO;

import Model.QuestionAnswer;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class QuestionAnswerDAOTest {

    static QuestionAnswerDAO dao;
    static int testQuestionId = 1; // Đảm bảo tồn tại Question Id = 1
    static int createdAnswerId;

    @BeforeAll
    static void setup() {
        dao = new QuestionAnswerDAO();
    }

    @Test
    @Order(1)
    void testCreateAnswer() {
        QuestionAnswer answer = new QuestionAnswer();
        answer.setQuestionId(testQuestionId);
        answer.setContent("Answer Content A");
        answer.setCorrect(true);
        answer.setAnswerOrder(1);

        dao.createAnswer(answer);
        createdAnswerId = answer.getId();

        assertTrue(createdAnswerId > 0, "Id được tạo phải > 0");
    }

    @Test
    @Order(2)
    void testGetAnswersByQuestionId() {
        List<QuestionAnswer> answers = dao.getAnswersByQuestionId(testQuestionId);
        assertFalse(answers.isEmpty(), "Không tìm thấy đáp án nào");
        boolean found = answers.stream().anyMatch(a -> a.getId() == createdAnswerId);
        assertTrue(found, "Không tìm thấy đáp án vừa tạo");
    }

    @Test
    @Order(3)
    void testGetAnswerById() {
        QuestionAnswer answer = dao.getAnswerById(createdAnswerId);
        assertNotNull(answer, "Không tìm thấy đáp án theo ID");
        assertEquals(testQuestionId, answer.getQuestionId());
    }

    @Test
    @Order(4)
    void testGetCorrectAnswerByQuestionId() {
        QuestionAnswer answer = dao.getCorrectAnswerByQuestionId(testQuestionId);
        assertNotNull(answer, "Không tìm thấy đáp án đúng");
        assertTrue(answer.isCorrect());
    }

    @Test
    @Order(5)
    void testIsAnswerCorrect() {
        boolean isCorrect = dao.isAnswerCorrect(testQuestionId, createdAnswerId);
        assertTrue(isCorrect, "Đáp án đúng nhưng trả về false");
    }

    @Test
    @Order(6)
    void testUpdateAnswer() {
        QuestionAnswer answer = dao.getAnswerById(createdAnswerId);
        assertNotNull(answer);

        answer.setContent("Updated Answer Content");
        answer.setCorrect(false);
        answer.setAnswerOrder(2);

        dao.updateAnswer(answer);

        QuestionAnswer updated = dao.getAnswerById(createdAnswerId);
        assertEquals("Updated Answer Content", updated.getContent());
        assertFalse(updated.isCorrect());
        assertEquals(2, updated.getAnswerOrder());
    }

    @Test
    @Order(7)
    void testDeleteAnswer() {
        dao.deleteAnswer(createdAnswerId);
        QuestionAnswer answer = dao.getAnswerById(createdAnswerId);
        assertNull(answer, "Đáp án vẫn tồn tại sau khi xoá");
    }

    @Test
    @Order(8)
    void testDeleteAnswersByQuestionId() {
        // Tạo thêm 2 đáp án mới cho câu hỏi này
        QuestionAnswer a1 = new QuestionAnswer();
        a1.setQuestionId(testQuestionId);
        a1.setContent("A1");
        a1.setCorrect(false);
        a1.setAnswerOrder(1);
        dao.createAnswer(a1);

        QuestionAnswer a2 = new QuestionAnswer();
        a2.setQuestionId(testQuestionId);
        a2.setContent("A2");
        a2.setCorrect(false);
        a2.setAnswerOrder(2);
        dao.createAnswer(a2);

        List<QuestionAnswer> before = dao.getAnswersByQuestionId(testQuestionId);
        assertTrue(before.size() >= 2, "Không có đủ đáp án để test xoá");

        dao.deleteAnswersByQuestionId(testQuestionId);

        List<QuestionAnswer> after = dao.getAnswersByQuestionId(testQuestionId);
        assertTrue(after.isEmpty(), "Đáp án vẫn còn sau khi xoá theo question");
    }

}
