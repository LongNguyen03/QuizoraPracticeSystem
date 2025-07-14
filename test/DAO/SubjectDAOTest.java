package DAO;

import Model.Subject;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class SubjectDAOTest {

    static Connection connection;
    static SubjectDAO dao;

    @BeforeAll
    static void setup() throws Exception {
        connection = DriverManager.getConnection("jdbc:h2:mem:testdb_subjects;DB_CLOSE_DELAY=-1");
        dao = new SubjectDAO();
        dao.connection = connection;

        try (Statement st = connection.createStatement()) {
            st.execute("""
                CREATE TABLE Subjects (
                    Id INT AUTO_INCREMENT PRIMARY KEY,
                    Title VARCHAR(255),
                    Tagline VARCHAR(255),
                    OwnerId INT,
                    Status VARCHAR(50),
                    Description VARCHAR(500),
                    CreatedAt TIMESTAMP,
                    UpdatedAt TIMESTAMP,
                    ThumbnailUrl VARCHAR(255)
                )
            """);
        }
    }

    @AfterAll
    static void teardown() throws Exception {
        connection.close();
    }

    @Test
    void testInsertAndGetSubject() {
        Subject s = new Subject();
        s.setTitle("Math");
        s.setTagline("Numbers & Logic");
        s.setOwnerId(1);
        s.setStatus("Active");
        s.setDescription("Basic Math Course");
        s.setCreatedAt(new Date());
        s.setUpdatedAt(new Date());
        s.setThumbnailUrl("http://example.com/thumb.jpg");

        boolean inserted = dao.insertSubject(s);
        assertTrue(inserted);

        List<Subject> all = dao.getAllSubjects();
        assertEquals(1, all.size());

        Subject fetched = dao.getSubjectById(all.get(0).getId());
        assertNotNull(fetched);
        assertEquals("Math", fetched.getTitle());
        assertEquals("Numbers & Logic", fetched.getTagline());
    }

    @Test
    void testUpdateSubject() {
        Subject s = new Subject();
        s.setTitle("Physics");
        s.setTagline("Laws of Nature");
        s.setOwnerId(2);
        s.setStatus("Active");
        s.setDescription("Physics basics");
        s.setCreatedAt(new Date());
        s.setUpdatedAt(new Date());
        s.setThumbnailUrl("http://example.com/phy.jpg");

        dao.insertSubject(s);

        List<Subject> all = dao.getAllSubjects();
        Subject toUpdate = all.stream().filter(sub -> sub.getTitle().equals("Physics")).findFirst().orElse(null);
        assertNotNull(toUpdate);

        toUpdate.setTitle("Advanced Physics");
        toUpdate.setUpdatedAt(new Date());
        boolean updated = dao.updateSubject(toUpdate);
        assertTrue(updated);

        Subject fetched = dao.getSubjectById(toUpdate.getId());
        assertEquals("Advanced Physics", fetched.getTitle());
    }

    @Test
    void testDeleteSubject() {
        Subject s = new Subject();
        s.setTitle("Chemistry");
        s.setTagline("Reactions & Bonds");
        s.setOwnerId(3);
        s.setStatus("Active");
        s.setDescription("Chem 101");
        s.setCreatedAt(new Date());
        s.setUpdatedAt(new Date());
        s.setThumbnailUrl("http://example.com/chem.jpg");

        dao.insertSubject(s);

        List<Subject> all = dao.getAllSubjects();
        Subject toDelete = all.stream().filter(sub -> sub.getTitle().equals("Chemistry")).findFirst().orElse(null);
        assertNotNull(toDelete);

        boolean deleted = dao.deleteSubject(toDelete.getId());
        assertTrue(deleted);

        Subject fetched = dao.getSubjectById(toDelete.getId());
        assertNull(fetched);
    }

    @Test
    void testGetAllSubjects() {
        dao.insertSubject(createSampleSubject("Bio"));
        dao.insertSubject(createSampleSubject("IT"));

        List<Subject> all = dao.getAllSubjects();
        assertTrue(all.size() >= 2);
    }

    private Subject createSampleSubject(String title) {
        Subject s = new Subject();
        s.setTitle(title);
        s.setTagline("Sample");
        s.setOwnerId(5);
        s.setStatus("Active");
        s.setDescription("Sample Desc");
        s.setCreatedAt(new Date());
        s.setUpdatedAt(new Date());
        s.setThumbnailUrl("http://example.com/sample.jpg");
        return s;
    }

}
