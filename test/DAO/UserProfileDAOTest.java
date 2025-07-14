package DAO;

import Model.UserProfile;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class UserProfileDAOTest {

    static Connection connection;
    static UserProfileDAO dao;

    @BeforeAll
    static void setup() throws Exception {
        connection = DriverManager.getConnection("jdbc:h2:mem:testdb_profiles;DB_CLOSE_DELAY=-1");
        dao = new UserProfileDAO();
        dao.connection = connection;

        try (Statement st = connection.createStatement()) {
            st.execute("""
                CREATE TABLE Roles (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(50),
                    description VARCHAR(255)
                );
                CREATE TABLE Accounts (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    email VARCHAR(255),
                    status VARCHAR(50),
                    roleId INT,
                    FOREIGN KEY (roleId) REFERENCES Roles(id)
                );
                CREATE TABLE UserProfiles (
                    accountId INT PRIMARY KEY,
                    firstName VARCHAR(50),
                    middleName VARCHAR(50),
                    lastName VARCHAR(50),
                    gender VARCHAR(10),
                    mobile VARCHAR(20),
                    dateOfBirth DATE,
                    avatarUrl VARCHAR(255)
                );
            """);

            st.execute("INSERT INTO Roles(name, description) VALUES ('User', 'Standard User')");
            st.execute("INSERT INTO Accounts(email, status, roleId) VALUES ('test@example.com', 'Active', 1)");
        }
    }

    @AfterAll
    static void teardown() throws Exception {
        connection.close();
    }

    @Test
    void testInsertAndGetProfile() {
        UserProfile p = new UserProfile();
        p.setAccountId(1);
        p.setFirstName("John");
        p.setMiddleName("M");
        p.setLastName("Doe");
        p.setGender("Male");
        p.setMobile("123456789");
        p.setDateOfBirth(new Date());
        p.setAvatarUrl("avatar.png");

        boolean inserted = dao.insertUserProfile(p);
        assertTrue(inserted);

        UserProfile fetched = dao.getProfileByAccountId(1);
        assertNotNull(fetched);
        assertEquals("John", fetched.getFirstName());
        assertEquals("Doe", fetched.getLastName());
    }

    @Test
    void testUpdateUserProfile() {
        UserProfile profile = dao.getProfileByAccountId(1);
        assertNotNull(profile);

        profile.setLastName("Smith");
        profile.setGender("Other");

        boolean updated = dao.updateUserProfile(profile);
        assertTrue(updated);

        UserProfile updatedProfile = dao.getProfileByAccountId(1);
        assertEquals("Smith", updatedProfile.getLastName());
        assertEquals("Other", updatedProfile.getGender());
    }

    @Test
    void testUpdateAvatar() {
        boolean updated = dao.updateAvatar(1, "new-avatar.png");
        assertTrue(updated);

        UserProfile fetched = dao.getProfileByAccountId(1);
        assertEquals("new-avatar.png", fetched.getAvatarUrl());
    }

    @Test
    void testGetProfileWithAccount() {
        UserProfile profile = dao.getProfileWithAccount(1);
        assertNotNull(profile);
        assertEquals("test@example.com", profile.getEmail());
        assertEquals("Active", profile.getStatus());
        assertEquals("User", profile.getRoleName());
    }

    @Test
    void testSearchProfiles() {
        List<UserProfile> results = dao.searchProfiles("John");
        assertFalse(results.isEmpty());
        assertEquals("test@example.com", results.get(0).getEmail());
    }

    @Test
    void testDeleteUserProfile() {
        boolean deleted = dao.deleteUserProfile(2);
        assertTrue(deleted);

        UserProfile fetched = dao.getProfileByAccountId(2);
        assertNull(fetched);
    }

    @Test
    void testGetAllProfiles() {
        List<UserProfile> profiles = dao.getAllProfiles();
        assertFalse(profiles.isEmpty());
        assertEquals("User", profiles.get(0).getRoleName());
    }

}
