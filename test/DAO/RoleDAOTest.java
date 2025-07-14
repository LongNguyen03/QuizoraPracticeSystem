package DAO;

import Model.Role;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class RoleDAOTest {

    private static Connection connection;
    private static RoleDAO dao;

    @BeforeAll
    static void setup() throws Exception {
        // Tạo kết nối H2
        connection = DriverManager.getConnection("jdbc:h2:mem:testdb_roles;DB_CLOSE_DELAY=-1");
        dao = new RoleDAO();
        dao.connection = connection;

        // Tạo bảng Roles
        try (Statement st = connection.createStatement()) {
            st.execute("CREATE TABLE Roles (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(255), " +
                    "description VARCHAR(255))");
        }
    }

    @AfterAll
    static void tearDown() throws Exception {
        connection.close();
    }

    @Test
    void testInsertAndGetById() {
        Role role = new Role();
        role.setName("Admin");
        role.setDescription("Administrator role");

        boolean inserted = dao.insertRole(role);
        assertTrue(inserted);

        List<Role> all = dao.getAllRoles();
        assertEquals(1, all.size());

        Role fetched = dao.getRoleById(all.get(0).getId());
        assertNotNull(fetched);
        assertEquals("Admin", fetched.getName());
        assertEquals("Administrator role", fetched.getDescription());
    }

    @Test
    void testGetByName() {
        Role role = new Role();
        role.setName("Editor");
        role.setDescription("Editor role");

        dao.insertRole(role);

        Role fetched = dao.getRoleByName("editor");
        assertNotNull(fetched);
        assertEquals("Editor", fetched.getName());
    }

    @Test
    void testUpdateRole() {
        Role role = new Role();
        role.setName("Tester");
        role.setDescription("Tester role");
        dao.insertRole(role);

        List<Role> all = dao.getAllRoles();
        Role toUpdate = all.stream().filter(r -> r.getName().equals("Tester")).findFirst().orElse(null);
        assertNotNull(toUpdate);

        toUpdate.setName("QA");
        toUpdate.setDescription("QA Engineer");
        boolean updated = dao.updateRole(toUpdate);
        assertTrue(updated);

        Role fetched = dao.getRoleById(toUpdate.getId());
        assertEquals("QA", fetched.getName());
        assertEquals("QA Engineer", fetched.getDescription());
    }

    @Test
    void testDeleteRole() {
        Role role = new Role();
        role.setName("Temp");
        role.setDescription("Temporary");
        dao.insertRole(role);

        List<Role> all = dao.getAllRoles();
        Role toDelete = all.stream().filter(r -> r.getName().equals("Temp")).findFirst().orElse(null);
        assertNotNull(toDelete);

        boolean deleted = dao.deleteRole(toDelete.getId());
        assertTrue(deleted);

        Role fetched = dao.getRoleById(toDelete.getId());
        assertNull(fetched);
    }

    @Test
    void testGetAllRoles() {
        // Insert vài role khác
        dao.insertRole(new Role(0, "Role1", "Desc1"));
        dao.insertRole(new Role(0, "Role2", "Desc2"));

        List<Role> roles = dao.getAllRoles();
        assertTrue(roles.size() >= 2);
    }
}
