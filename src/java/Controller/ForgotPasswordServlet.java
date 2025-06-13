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
import Utils.EmailUtil;
import Utils.OTPUtil;
import Utils.EmailTemplateUtil;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ForgotPasswordServlet: Received request");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        System.out.println("ForgotPasswordServlet: Email received: " + email);
        
        if (email == null || email.trim().isEmpty()) {
            System.out.println("ForgotPasswordServlet: Email is empty");
            response.getWriter().write("Vui lòng nhập email");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmail(email);
        System.out.println("ForgotPasswordServlet: Account found: " + (account != null));

        if (account == null) {
            System.out.println("ForgotPasswordServlet: Email not found in system");
            response.getWriter().write("Email không tồn tại trong hệ thống");
            return;
        }

        // Tạo và lưu OTP
        String otp = OTPUtil.generateOTP();
        System.out.println("ForgotPasswordServlet: Generated OTP: " + otp);
        HttpSession session = request.getSession();
        session.setAttribute("resetOTP", otp);
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetOTPTime", System.currentTimeMillis());

        // Gửi OTP qua email
        String subject = "Mã xác thực đặt lại mật khẩu";
        String message = EmailTemplateUtil.getResetPasswordOTPTemplate(otp);
        
        try {
            System.out.println("ForgotPasswordServlet: Sending email to: " + email);
            EmailUtil.sendEmail(email, subject, message);
            System.out.println("ForgotPasswordServlet: Email sent successfully");
            response.getWriter().write("success");
        } catch (Exception e) {
            System.out.println("ForgotPasswordServlet: Error sending email: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("Không thể gửi email. Vui lòng thử lại sau.");
        }
    }
} 