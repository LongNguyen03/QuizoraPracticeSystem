package DAO;

import Model.Account;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class AccountDAOTest {

    static AccountDAO dao;
    static final String TEST_EMAIL = "testuser@example.com";
    static int testUserId = -1;

    @BeforeAll
    public static void setup() {
        dao = new AccountDAO();
    }

    @AfterAll
    public static void cleanup() {
        // Xóa user test nếu còn tồn tại (dù ở trạng thái nào)
        Account acc = dao.getAccountByEmail(TEST_EMAIL);
        if (acc != null) {
            dao.deleteAccount(acc.getId());
        }
    }

    /**
     * Test đăng ký, đăng nhập, cập nhật, xóa mềm tài khoản
     */
    @Test
    public void testRegisterAndLogin() {
        // Nếu email tồn tại thì xóa
        if (dao.isEmailExists(TEST_EMAIL)) {
            Account acc = dao.getAccountByEmail(TEST_EMAIL);
            dao.deleteAccount(acc.getId());
        }

        // Đăng ký
        Account acc = new Account();
        acc.setEmail(TEST_EMAIL);
        acc.setPasswordHash("secret123"); // Password plain, sẽ được hash trong DAO
        acc.setRoleId(2); // Ví dụ 2 = user
        acc.setStatus("active");

        boolean registered = dao.register(acc);
        assertTrue(registered, "Đăng ký thất bại!");
        assertTrue(acc.getId() > 0, "ID phải được set sau khi insert!");
        testUserId = acc.getId();

        // Test login đúng
        Account loginAcc = dao.login(TEST_EMAIL, "secret123");
        assertNotNull(loginAcc, "Login thất bại!");
        assertEquals(TEST_EMAIL, loginAcc.getEmail());

        // Test login sai
        Account loginFail = dao.login(TEST_EMAIL, "wrongpassword");
        assertNull(loginFail, "Login sai password phải trả về null!");

        // Test login bằng hash
        String hash = dao.getAccountByEmail(TEST_EMAIL).getPasswordHash();
        Account loginHash = dao.loginWithHash(TEST_EMAIL, hash);
        assertNotNull(loginHash, "Login bằng hash thất bại!");

        // Test update
        loginAcc.setStatus("inactive");
        boolean updated = dao.updateAccount(loginAcc);
        assertTrue(updated, "Cập nhật thất bại!");

        Account updatedAcc = dao.getAccountById(loginAcc.getId());
        assertEquals("inactive", updatedAcc.getStatus(), "Trạng thái không khớp!");

        // Xóa mềm
        boolean deleted = dao.deleteAccount(loginAcc.getId());
        assertTrue(deleted, "Xóa mềm thất bại!");

        assertTrue(dao.isEmailDeleted(TEST_EMAIL), "Email phải ở trạng thái deleted!");
    }

    /**
     * Test lấy danh sách tất cả user (trừ user đã xóa và admin)
     */
    @Test
    public void testGetAllUsers() {
        List<Account> users = AccountDAO.getAllUsers();
        assertNotNull(users, "Danh sách không null");
        System.out.println("Tổng user: " + users.size());
    }

    /**
     * Test cập nhật trạng thái user bất kỳ
     */
    @Test
    public void testUpdateUserStatus() {
        List<Account> users = AccountDAO.getAllUsers();
        if (!users.isEmpty()) {
            Account acc = users.get(0);
            boolean ok = AccountDAO.updateUserStatus(acc.getId(), "inactive");
            assertTrue(ok, "Cập nhật status thất bại!");
        }
    }

}
