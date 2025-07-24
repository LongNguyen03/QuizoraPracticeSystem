package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import DAO.AccountDAO;
import Utils.EmailTemplateUtil;

@WebServlet(name = "SendOTPServlet", urlPatterns = {"/send-otp"})
public class SendOTPServlet extends HttpServlet {
    
    private final AccountDAO accountDAO = new AccountDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response type to plain text
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("Email không được để trống");
            return;
        }
        
        // Kiểm tra định dạng email
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            response.getWriter().write("Email không đúng định dạng");
            return;
        }
        
        // Kiểm tra email đã tồn tại chưa
        if (accountDAO.isEmailExists(email)) {
            response.getWriter().write("Email đã được sử dụng. Vui lòng chọn email khác");
            return;
        }
        if (accountDAO.isEmailDeleted(email)) {
            response.getWriter().write("Tài khoản này đã bị xóa và không thể đăng ký lại bằng email này");
            return;
        }
        
        try {
            // Tạo mã OTP ngẫu nhiên 6 số
            String otp = generateOTP();
            
            // Lưu OTP vào session
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("otpEmail", email);
            session.setAttribute("otpTime", System.currentTimeMillis());
            
            // Gửi email chứa OTP
            if (sendOTPEmail(email, otp)) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("Không thể gửi OTP. Vui lòng thử lại sau");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private boolean sendOTPEmail(String toEmail, String otp) {
        // Cấu hình email
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        // Thông tin đăng nhập email
        final String username = "dangdang0xx@gmail.com";
        final String password = "iefy mrzr lfoa hyhq";
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Xác thực đăng ký tài khoản Quizora");
            message.setContent(EmailTemplateUtil.getRegistrationOTPTemplate(otp), "text/html; charset=UTF-8");
            
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
} 