package Utils;

public class EmailTemplateUtil {
    
    public static String getRegistrationOTPTemplate(String otp) {
        return "<div style='font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #222;'>"
            + "<p>Xin chào,</p>"
            + "<p><b>Mã OTP của bạn là: <span style='color:#4F46E5;font-size:20px;'>" + otp + "</span></b></p>"
            + "<p>Mã này có hiệu lực trong 5 phút.<br>Vui lòng không chia sẻ mã này với bất kỳ ai.</p>"
            + "<br>"
            + "<p>Trân trọng,<br>Team Quizora</p>"
            + "</div>";
    }
    
    public static String getResetPasswordOTPTemplate(String otp) {
        return "Xin chào,\n\n"
                + "Mã OTP của bạn là: " + otp + "\n\n"
                + "Mã này có hiệu lực trong 5 phút.\n"
                + "Vui lòng không chia sẻ mã này với bất kỳ ai.\n\n"
                + "Trân trọng,\n"
                + "Team Quizora";
    }
    
    public static String getWelcomeTemplate(String username) {
        return "Xin chào " + username + ",\n\n"
                + "Chào mừng bạn đến với Quizora!\n\n"
                + "Chúng tôi rất vui mừng khi bạn đã tham gia cùng chúng tôi.\n"
                + "Bạn có thể bắt đầu sử dụng tất cả các tính năng của Quizora ngay bây giờ.\n\n"
                + "Nếu bạn có bất kỳ câu hỏi nào, đừng ngần ngại liên hệ với chúng tôi.\n\n"
                + "Trân trọng,\n"
                + "Team Quizora";
    }
    
    public static String getPasswordChangedTemplate() {
        return "Xin chào,\n\n"
                + "Mật khẩu của bạn đã được thay đổi thành công.\n\n"
                + "Nếu bạn không thực hiện thay đổi này, vui lòng liên hệ với chúng tôi ngay lập tức.\n\n"
                + "Trân trọng,\n"
                + "Team Quizora";
    }
} 