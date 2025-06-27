package Controller;

import DAO.AccountDAO;
import Model.Account;
import Utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {
    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        String email = (String) session.getAttribute("email");
        if (accountId == null || email == null) {
            response.sendRedirect("login");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra nhập đủ thông tin
        if (oldPassword == null || newPassword == null || confirmPassword == null ||
            oldPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("error", "Please fill in all password fields.");
            response.sendRedirect("profile");
            return;
        }

        // Lấy account hiện tại
        Account account = accountDAO.getAccountById(accountId);
        if (account == null) {
            session.setAttribute("error", "Account not found.");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra mật khẩu cũ
        if (!PasswordUtil.hashPassword(oldPassword).equals(account.getPasswordHash())) {
            session.setAttribute("error", "Old password is incorrect.");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra mật khẩu mới đủ mạnh
        if (!PasswordUtil.isStrongPassword(newPassword)) {
            session.setAttribute("error", "New password is not strong enough. It must be at least 8 characters, include uppercase, lowercase, number, and special character.");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "New password and confirm password do not match.");
            response.sendRedirect("profile");
            return;
        }

        // Không cho phép trùng mật khẩu cũ
        if (PasswordUtil.hashPassword(newPassword).equals(account.getPasswordHash())) {
            session.setAttribute("error", "New password must be different from old password.");
            response.sendRedirect("profile");
            return;
        }

        // Cập nhật mật khẩu
        account.setPasswordHash(PasswordUtil.hashPassword(newPassword));
        boolean updated = accountDAO.updateAccount(account);
        if (updated) {
            session.setAttribute("message", "Password changed successfully!");
        } else {
            session.setAttribute("error", "Failed to change password. Please try again.");
        }
        response.sendRedirect("profile");
    }
} 