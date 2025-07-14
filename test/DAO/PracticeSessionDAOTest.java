package DAO;

import Model.PracticeSession;
import org.junit.jupiter.api.*;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class PracticeSessionDAOTest {

    static PracticeSessionDAO dao;
    static int insertedSessionId;

    static int testAccountId = 1; // Đảm bảo account này tồn tại
    static int testSubjectId = 1; // Đảm bảo subject này tồn tại
    static Integer testLessonId = null; // Cho phép null để test nullable

    @BeforeAll
    static void setup() {
        dao = new PracticeSessionDAO();
    }

    @Test
    void testCreatePracticeSession() {
        PracticeSession session = new PracticeSession();
        session.setAccountId(testAccountId);
        session.setSubjectId(testSubjectId);
        session.setLessonId(testLessonId);
        session.setStartTime(Timestamp.from(Instant.now()));
        session.setEndTime(null);
        session.setTotalScore(null);
        session.setCompleted(false);

        insertedSessionId = dao.createPracticeSession(session);
        assertTrue(insertedSessionId > 0, "Session ID phải > 0");
    }

    @Test
    void testGetPracticeSessionById() {
        PracticeSession session = dao.getPracticeSessionById(insertedSessionId);
        assertNotNull(session, "Session không tồn tại!");
        assertEquals(insertedSessionId, session.getId());
        assertEquals(testAccountId, session.getAccountId());
        assertFalse(session.isCompleted());
    }

    @Test
    void testUpdatePracticeSession() {
        PracticeSession session = dao.getPracticeSessionById(insertedSessionId);
        assertNotNull(session);

        session.setEndTime(Timestamp.from(Instant.now()));
        session.setTotalScore(85.5);
        session.setCompleted(true);

        boolean updated = dao.updatePracticeSession(session);
        assertTrue(updated, "Update thất bại!");

        PracticeSession updatedSession = dao.getPracticeSessionById(insertedSessionId);
        assertNotNull(updatedSession.getEndTime());
        assertEquals(85.5, updatedSession.getTotalScore());
        assertTrue(updatedSession.isCompleted());
    }

    @Test
    void testGetPracticeSessionsByAccountId() {
        List<PracticeSession> sessions = dao.getPracticeSessionsByAccountId(testAccountId);
        assertFalse(sessions.isEmpty());
        boolean found = sessions.stream().anyMatch(s -> s.getId() == insertedSessionId);
        assertTrue(found, "Không tìm thấy session vừa thêm!");
    }

    @Test
    void testGetPracticeSessionsBySubject() {
        List<PracticeSession> sessions = dao.getPracticeSessionsBySubject(testAccountId, testSubjectId);
        assertFalse(sessions.isEmpty());
        boolean found = sessions.stream().anyMatch(s -> s.getId() == insertedSessionId);
        assertTrue(found, "Không tìm thấy session theo subject!");
    }

    @Test
    void testDeletePracticeSession() {
        boolean deleted = dao.deletePracticeSession(insertedSessionId);
        assertTrue(deleted, "Xoá session thất bại!");

        PracticeSession session = dao.getPracticeSessionById(insertedSessionId);
        assertNull(session, "Session vẫn tồn tại sau khi xoá!");
    }
}
