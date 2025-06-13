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
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        HttpSession session = request.getSession();

        // Validate input
        if (email == null || otp == null || newPassword == null || confirmPassword == null) {
            session.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            response.sendRedirect("views/login.jsp");
            return;
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "Mật khẩu xác nhận không khớp");
            response.sendRedirect("views/login.jsp");
            return;
        }

        // Validate password strength
        if (!PasswordUtil.isStrongPassword(newPassword)) {
            session.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            response.sendRedirect("views/login.jsp");
            return;
        }

        // Check if OTP is valid
        if (!OTPUtil.validateOTP(email, otp)) {
            int remainingAttempts = OTPUtil.getRemainingAttempts(email);
            if (remainingAttempts > 0) {
                session.setAttribute("error", "Mã xác thực không đúng. Bạn còn " + remainingAttempts + " lần thử.");
            } else {
                session.setAttribute("error", "Bạn đã nhập sai mã xác thực quá nhiều lần. Vui lòng yêu cầu mã mới.");
            }
            response.sendRedirect("views/login.jsp");
            return;
        }

        // Update password
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmail(email);
        if (account != null) {
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            account.setPasswordHash(hashedPassword);
            if (accountDAO.updateAccount(account)) {
                session.setAttribute("success", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.");
                response.sendRedirect("views/login.jsp");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi đặt lại mật khẩu");
                response.sendRedirect("views/login.jsp");
            }
        } else {
            session.setAttribute("error", "Không tìm thấy tài khoản");
            response.sendRedirect("views/login.jsp");
        }
    }
} 