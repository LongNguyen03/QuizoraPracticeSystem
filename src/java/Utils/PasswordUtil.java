package Utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Pattern;
import org.apache.commons.codec.digest.DigestUtils;

public class PasswordUtil {
    
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasUpperCase = Pattern.compile("[A-Z]").matcher(password).find();
        boolean hasLowerCase = Pattern.compile("[a-z]").matcher(password).find();
        boolean hasNumber = Pattern.compile("[0-9]").matcher(password).find();
        boolean hasSpecialChar = Pattern.compile("[!@#$%^&*(),.?\":{}|<>]").matcher(password).find();
        
        return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
    }
    
    public static String hashPassword(String password) {
        return DigestUtils.sha256Hex(password);
    }
} 