package DAO;

import Model.PracticeAnswer;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class PracticeAnswerDAOTest {

    static PracticeAnswerDAO dao;
    static int insertedAnswerId;
    static int testSessionId = 9999; // sessionId giả để test, không đụng dữ liệu thật
    static int testQuestionId = 1;   // Cần đảm bảo tồn tại
    static int testAnswerId = 1;     // Cần đảm bảo tồn tại

    @BeforeAll
    static void setup() {
        dao = new PracticeAnswerDAO();
    }

    @Test
    void testSaveAndGetPracticeAnswer() {
        PracticeAnswer answer = new PracticeAnswer();
        answer.setPracticeSessionId(testSessionId);
        answer.setQuestionId(testQuestionId);
        answer.setAnswerId(testAnswerId);
        answer.setCorrect(true);

        dao.savePracticeAnswer(answer);

        List<PracticeAnswer> answers = dao.getPracticeAnswersBySessionId(testSessionId);
        assertFalse(answers.isEmpty(), "Danh sách answers không được rỗng!");

        PracticeAnswer saved = answers.get(0);
        insertedAnswerId = saved.getId();

        assertEquals(testSessionId, saved.getPracticeSessionId());
        assertEquals(testQuestionId, saved.getQuestionId());
        assertEquals(testAnswerId, saved.getAnswerId());
        assertTrue(saved.isCorrect());
        assertNotNull(saved.getQuestionContent());
    }

    @Test
    void testGetPracticeAnswerById() {
        PracticeAnswer answer = dao.getPracticeAnswerById(insertedAnswerId);
        assertNotNull(answer);
        assertEquals(insertedAnswerId, answer.getId());
    }

    @Test
    void testUpdatePracticeAnswer() {
        PracticeAnswer answer = dao.getPracticeAnswerById(insertedAnswerId);
        assertNotNull(answer);

        answer.setAnswerId(null);
        answer.setCorrect(false);

        boolean updated = dao.updatePracticeAnswer(answer);
        assertTrue(updated);

        PracticeAnswer updatedAnswer = dao.getPracticeAnswerById(insertedAnswerId);
        assertNull(updatedAnswer.getAnswerId());
        assertFalse(updatedAnswer.isCorrect());
    }

    @Test
    void testGetPracticeAnswerStats() {
        PracticeAnswerDAO.PracticeAnswerStats stats = dao.getPracticeAnswerStats(testSessionId);
        assertNotNull(stats);
        assertTrue(stats.getTotalQuestions() > 0);
        System.out.println("Total: " + stats.getTotalQuestions() + ", Correct: " + stats.getCorrectAnswers());
    }

    @Test
    void testDeletePracticeAnswer() {
        boolean deleted = dao.deletePracticeAnswer(insertedAnswerId);
        assertTrue(deleted);

        PracticeAnswer answer = dao.getPracticeAnswerById(insertedAnswerId);
        assertNull(answer, "Practice answer vẫn còn sau khi xoá!");
    }

    @Test
    void testDeletePracticeAnswersBySessionId() {
        // Thêm lại 2 records
        PracticeAnswer a1 = new PracticeAnswer();
        a1.setPracticeSessionId(testSessionId);
        a1.setQuestionId(testQuestionId);
        a1.setAnswerId(testAnswerId);
        a1.setCorrect(true);

        PracticeAnswer a2 = new PracticeAnswer();
        a2.setPracticeSessionId(testSessionId);
        a2.setQuestionId(testQuestionId);
        a2.setAnswerId(testAnswerId);
        a2.setCorrect(false);

        dao.savePracticeAnswer(a1);
        dao.savePracticeAnswer(a2);

        List<PracticeAnswer> answers = dao.getPracticeAnswersBySessionId(testSessionId);
        assertTrue(answers.size() >= 2);

        boolean deletedAll = dao.deletePracticeAnswersBySessionId(testSessionId);
        assertTrue(deletedAll);

        List<PracticeAnswer> check = dao.getPracticeAnswersBySessionId(testSessionId);
        assertTrue(check.isEmpty(), "Chưa xoá hết practice answers theo session!");
    }

}
