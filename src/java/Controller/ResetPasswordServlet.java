package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.AccountDAO;
import Model.Account;
import Utils.PasswordUtil;
import Utils.OTPUtil;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response type for AJAX
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (email == null || otp == null || newPassword == null || confirmPassword == null) {
            response.getWriter().write("Vui lòng điền đầy đủ thông tin");
            return;
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.getWriter().write("Mật khẩu xác nhận không khớp");
            return;
        }

        // Validate password strength
        if (!PasswordUtil.isStrongPassword(newPassword)) {
            response.getWriter().write("Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            return;
        }

        // Check if OTP is valid
        if (!OTPUtil.validateOTP(email, otp)) {
            int remainingAttempts = OTPUtil.getRemainingAttempts(email);
            if (remainingAttempts > 0) {
                response.getWriter().write("Mã xác thực không đúng. Bạn còn " + remainingAttempts + " lần thử.");
            } else {
                response.getWriter().write("Bạn đã nhập sai mã xác thực quá nhiều lần. Vui lòng yêu cầu mã mới.");
            }
            return;
        }

        // Update password
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmail(email);
        if (account != null) {
            System.out.println("ResetPasswordServlet: Found account for email: " + email);
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            System.out.println("ResetPasswordServlet: New password hash: " + hashedPassword);
            account.setPasswordHash(hashedPassword);
            if (accountDAO.updateAccount(account)) {
                System.out.println("ResetPasswordServlet: Password updated successfully");
                response.getWriter().write("success");
            } else {
                System.out.println("ResetPasswordServlet: Failed to update password");
                response.getWriter().write("Có lỗi xảy ra khi đặt lại mật khẩu");
            }
        } else {
            System.out.println("ResetPasswordServlet: Account not found for email: " + email);
            response.getWriter().write("Không tìm thấy tài khoản");
        }
    }
} 