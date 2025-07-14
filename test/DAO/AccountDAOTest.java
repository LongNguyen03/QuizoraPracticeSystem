package DAO;

import Model.Account;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class AccountDAOTest {

    static AccountDAO dao;

    @BeforeAll
    static void setup() {
        dao = new AccountDAO();
    }

    @Test
    void testRegisterAndLogin() {
        // Tạo user test
        String email = "testuser@example.com";
        String plainPassword = "secret123";

        // Nếu email tồn tại thì xóa
        if (dao.isEmailExists(email)) {
            Account acc = dao.getAccountByEmail(email);
            dao.deleteAccount(acc.getId());
        }

        // Đăng ký
        Account acc = new Account();
        acc.setEmail(email);
        acc.setPasswordHash(plainPassword);
        acc.setRoleId(2); // Ví dụ 2 = user
        acc.setStatus("active");

        boolean registered = dao.register(acc);
        assertTrue(registered, "Đăng ký thất bại!");

        assertTrue(acc.getId() > 0, "ID phải được set sau khi insert!");

        // Test login đúng
        Account loginAcc = dao.login(email, plainPassword);
        assertNotNull(loginAcc, "Login thất bại!");
        assertEquals(email, loginAcc.getEmail());

        // Test login sai
        Account loginFail = dao.login(email, "wrongpassword");
        assertNull(loginFail, "Login sai password phải trả về null!");

        // Test login bằng hash
        String hash = dao.getAccountByEmail(email).getPasswordHash();
        Account loginHash = dao.loginWithHash(email, hash);
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

        assertTrue(dao.isEmailDeleted(email), "Email phải ở trạng thái deleted!");
    }

    @Test
    void testGetAllUsers() {
        List<Account> users = AccountDAO.getAllUsers();
        assertNotNull(users, "Danh sách không null");
        System.out.println("Tổng user: " + users.size());
    }

    @Test
    void testUpdateUserStatus() {
        // Lấy 1 user thật
        List<Account> users = AccountDAO.getAllUsers();
        if (!users.isEmpty()) {
            Account acc = users.get(0);
            boolean ok = AccountDAO.updateUserStatus(acc.getId(), "inactive");
            assertTrue(ok, "Cập nhật status thất bại!");
        }
    }

}
