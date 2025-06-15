package Utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    private static final String EMAIL = "dangdang0xx@gmail.com";
    private static final String PASSWORD = "iefy mrzr lfoa hyhq";
    private static Session session;
    
    private EmailUtil() {
        // Private constructor to prevent instantiation
    }
    
    private static synchronized Session getSession() {
        if (session == null) {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.connectiontimeout", "5000");
            props.put("mail.smtp.timeout", "5000");
            props.put("mail.smtp.writetimeout", "5000");
            
            session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL, PASSWORD);
                }
            });
        }
        return session;
    }

    public static void sendEmail(String to, String subject, String message) throws MessagingException {
        try {
            Message msg = new MimeMessage(getSession());
            msg.setFrom(new InternetAddress(EMAIL));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);
            msg.setText(message);

            Transport.send(msg);
        } catch (MessagingException e) {
            throw new MessagingException("Failed to send email: " + e.getMessage(), e);
        }
    }
} 