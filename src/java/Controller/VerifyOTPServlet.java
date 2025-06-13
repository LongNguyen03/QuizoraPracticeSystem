package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verify-otp"})
public class VerifyOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response type to plain text
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        
        if (email == null || email.trim().isEmpty() || otp == null || otp.trim().isEmpty()) {
            response.getWriter().write("Vui lòng nhập đầy đủ thông tin");
            return;
        }
        
        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("otp");
        String storedEmail = (String) session.getAttribute("otpEmail");
        Long otpTime = (Long) session.getAttribute("otpTime");
        
        if (storedOTP == null || storedEmail == null || otpTime == null) {
            response.getWriter().write("Mã OTP không tồn tại hoặc đã hết hạn");
            return;
        }
        
        // Kiểm tra OTP hết hạn (5 phút)
        if (System.currentTimeMillis() - otpTime > 5 * 60 * 1000) {
            response.getWriter().write("Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới");
            return;
        }
        
        // Kiểm tra email và OTP
        if (!email.equals(storedEmail) || !otp.equals(storedOTP)) {
            response.getWriter().write("Mã OTP không đúng hoặc email không khớp");
            return;
        }
        
        // Đánh dấu email đã được xác thực
        session.setAttribute("emailVerified", true);
        response.getWriter().write("success");
    }
} 