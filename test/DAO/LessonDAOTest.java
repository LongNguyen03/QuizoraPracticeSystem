package DAO;

import Model.Lesson;
import Model.Subject;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class LessonDAOTest {

    static LessonDAO dao;
    static int insertedLessonId; // sẽ lưu ID để xoá sau

    static int testSubjectId = 1; // SubjectId test, cần đảm bảo tồn tại

    @BeforeAll
    static void setup() {
        dao = new LessonDAO();
    }

    @Test
    void testAddAndGetLessonById() {
        Lesson lesson = new Lesson();
        lesson.setSubjectId(testSubjectId);
        lesson.setTitle("JUnit Test Lesson");
        lesson.setContent("This is test content.");
        lesson.setDimension("TestDimension");
        lesson.setStatus("Active");

        dao.addLesson(lesson);

        // Lấy tất cả để lấy ra ID vừa thêm
        List<Lesson> all = dao.getAllLessons();
        assertFalse(all.isEmpty(), "Danh sách Lesson không được rỗng sau khi thêm!");

        // Tìm lesson mới
        Lesson added = all.stream()
                .filter(l -> l.getTitle().equals("JUnit Test Lesson"))
                .findFirst()
                .orElse(null);

        assertNotNull(added, "Không tìm thấy lesson vừa thêm!");
        insertedLessonId = added.getId();

        Lesson byId = dao.getLessonById(insertedLessonId);
        assertNotNull(byId, "Không tìm thấy lesson theo ID!");
        assertEquals("JUnit Test Lesson", byId.getTitle());
    }

    @Test
    void testUpdateLesson() {
        Lesson lesson = dao.getLessonById(insertedLessonId);
        assertNotNull(lesson);

        lesson.setTitle("Updated Title");
        lesson.setContent("Updated content.");
        lesson.setDimension("UpdatedDim");
        lesson.setStatus("Inactive");

        dao.updateLesson(lesson);

        Lesson updated = dao.getLessonById(insertedLessonId);
        assertEquals("Updated Title", updated.getTitle());
        assertEquals("Inactive", updated.getStatus());
    }

    @Test
    void testGetAllLessonsByFilter() {
        List<Lesson> filtered = dao.getAllLessons(testSubjectId, "Updated Title", "UpdatedDim");
        assertFalse(filtered.isEmpty());
        boolean match = filtered.stream().anyMatch(l -> l.getId() == insertedLessonId);
        assertTrue(match, "Không tìm thấy lesson khớp bộ lọc!");
    }

    @Test
    void testGetAllSubjects() {
        List<Subject> subjects = dao.getAllSubjects();
        assertNotNull(subjects);
        assertTrue(subjects.size() > 0, "Phải có ít nhất 1 subject");
    }

    @Test
    void testGetLessonsBySubjectAndStatus() {
        List<Lesson> list = dao.getLessonsBySubjectAndStatus(testSubjectId, "Inactive");
        assertNotNull(list);
        boolean found = list.stream().anyMatch(l -> l.getId() == insertedLessonId);
        assertTrue(found, "Không tìm thấy lesson trong status filter!");
    }

    @AfterAll
    static void cleanUp() {
        if (insertedLessonId > 0) {
            dao.deleteLesson(insertedLessonId);
            Lesson deleted = dao.getLessonById(insertedLessonId);
            assertNull(deleted, "Xóa lesson không thành công!");
        }
    }

}
