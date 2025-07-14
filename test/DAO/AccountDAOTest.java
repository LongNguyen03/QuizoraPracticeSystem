/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package DAO;

import Model.Account;
import java.util.List;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AccountDAOTest {
    
    public AccountDAOTest() {
    }
    
    @BeforeAll
    public static void setUpClass() {
    }
    
    @AfterAll
    public static void tearDownClass() {
    }
    
    @BeforeEach
    public void setUp() {
    }
    
    @AfterEach
    public void tearDown() {
    }

    /**
     * Test of login method, of class AccountDAO.
     */
    @Test
    public void testLogin() {
        System.out.println("login");
        String email = "";
        String passwordPlain = "";
        AccountDAO instance = new AccountDAO();
        Account expResult = null;
        Account result = instance.login(email, passwordPlain);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of loginWithHash method, of class AccountDAO.
     */
    @Test
    public void testLoginWithHash() {
        System.out.println("loginWithHash");
        String email = "";
        String passwordHash = "";
        AccountDAO instance = new AccountDAO();
        Account expResult = null;
        Account result = instance.loginWithHash(email, passwordHash);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of isEmailExists method, of class AccountDAO.
     */
    @Test
    public void testIsEmailExists() {
        System.out.println("isEmailExists");
        String email = "";
        AccountDAO instance = new AccountDAO();
        boolean expResult = false;
        boolean result = instance.isEmailExists(email);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of register method, of class AccountDAO.
     */
    @Test
    public void testRegister() {
        System.out.println("register");
        Account acc = null;
        AccountDAO instance = new AccountDAO();
        boolean expResult = false;
        boolean result = instance.register(acc);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getAccountByEmail method, of class AccountDAO.
     */
    @Test
    public void testGetAccountByEmail() {
        System.out.println("getAccountByEmail");
        String email = "";
        AccountDAO instance = new AccountDAO();
        Account expResult = null;
        Account result = instance.getAccountByEmail(email);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getAccountById method, of class AccountDAO.
     */
    @Test
    public void testGetAccountById() {
        System.out.println("getAccountById");
        int id = 0;
        AccountDAO instance = new AccountDAO();
        Account expResult = null;
        Account result = instance.getAccountById(id);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of updateAccount method, of class AccountDAO.
     */
    @Test
    public void testUpdateAccount() {
        System.out.println("updateAccount");
        Account acc = null;
        AccountDAO instance = new AccountDAO();
        boolean expResult = false;
        boolean result = instance.updateAccount(acc);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of deleteAccount method, of class AccountDAO.
     */
    @Test
    public void testDeleteAccount() {
        System.out.println("deleteAccount");
        int id = 0;
        AccountDAO instance = new AccountDAO();
        boolean expResult = false;
        boolean result = instance.deleteAccount(id);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getAllUsers method, of class AccountDAO.
     */
    @Test
    public void testGetAllUsers() {
        System.out.println("getAllUsers");
        List<Account> expResult = null;
        List<Account> result = AccountDAO.getAllUsers();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of updateUserStatus method, of class AccountDAO.
     */
    @Test
    public void testUpdateUserStatus() {
        System.out.println("updateUserStatus");
        int id = 0;
        String status = "";
        boolean expResult = false;
        boolean result = AccountDAO.updateUserStatus(id, status);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of isEmailDeleted method, of class AccountDAO.
     */
    @Test
    public void testIsEmailDeleted() {
        System.out.println("isEmailDeleted");
        String email = "";
        AccountDAO instance = new AccountDAO();
        boolean expResult = false;
        boolean result = instance.isEmailDeleted(email);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
