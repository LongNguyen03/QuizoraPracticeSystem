package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Account;
import DAO.AccountDAO;
import Utils.PasswordUtil;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");

        if (email == null || otp == null || newPassword == null) {
            response.getWriter().write("Vui lòng nhập đầy đủ thông tin");
            return;
        }

        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("resetOTP");
        String storedEmail = (String) session.getAttribute("resetEmail");
        Long otpTime = (Long) session.getAttribute("resetOTPTime");

        // Kiểm tra OTP
        if (storedOTP == null || storedEmail == null || otpTime == null) {
            response.getWriter().write("Phiên đặt lại mật khẩu đã hết hạn");
            return;
        }

        // Kiểm tra email có khớp không
        if (!email.equals(storedEmail)) {
            response.getWriter().write("Email không khớp với phiên đặt lại mật khẩu");
            return;
        }

        // Kiểm tra OTP có hết hạn chưa (5 phút)
        if (System.currentTimeMillis() - otpTime > 5 * 60 * 1000) {
            response.getWriter().write("Mã xác thực đã hết hạn");
            return;
        }

        // Kiểm tra OTP có đúng không
        if (!otp.equals(storedOTP)) {
            response.getWriter().write("Mã xác thực không đúng");
            return;
        }

        // Kiểm tra độ mạnh của mật khẩu
        if (!PasswordUtil.isStrongPassword(newPassword)) {
            response.getWriter().write("Mật khẩu không đủ mạnh");
            return;
        }

        // Cập nhật mật khẩu mới
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmail(email);
        if (account != null) {
            account.setPasswordHash(PasswordUtil.hashPassword(newPassword));
            if (accountDAO.updateAccount(account)) {
                // Xóa các thông tin OTP trong session
                session.removeAttribute("resetOTP");
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetOTPTime");
                response.getWriter().write("success");
            } else {
                response.getWriter().write("Không thể cập nhật mật khẩu. Vui lòng thử lại sau.");
            }
        } else {
            response.getWriter().write("Không tìm thấy tài khoản");
        }
    }
} 