package Utils;

import java.security.SecureRandom;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

public class OTPUtil {
    private static final SecureRandom secureRandom = new SecureRandom();
    private static final ConcurrentHashMap<String, OTPData> otpStore = new ConcurrentHashMap<>();
    private static final long OTP_VALIDITY_DURATION = TimeUnit.MINUTES.toMillis(5);
    
    public static class OTPData {
        private final String otp;
        private final long timestamp;
        private int attempts;
        
        public OTPData(String otp) {
            this.otp = otp;
            this.timestamp = System.currentTimeMillis();
            this.attempts = 0;
        }
        
        public boolean isValid() {
            return System.currentTimeMillis() - timestamp <= OTP_VALIDITY_DURATION;
        }
        
        public boolean isMaxAttemptsReached() {
            return attempts >= 3;
        }
        
        public void incrementAttempts() {
            attempts++;
        }
    }
    
    public static String generateOTP() {
        int otp = 100000 + secureRandom.nextInt(900000);
        return String.valueOf(otp);
    }
    
    public static void storeOTP(String email, String otp) {
        otpStore.put(email, new OTPData(otp));
    }
    
    public static boolean validateOTP(String email, String otp) {
        OTPData otpData = otpStore.get(email);
        if (otpData == null) {
            return false;
        }
        
        otpData.incrementAttempts();
        
        if (!otpData.isValid() || otpData.isMaxAttemptsReached()) {
            otpStore.remove(email);
            return false;
        }
        
        boolean isValid = otpData.otp.equals(otp);
        if (isValid) {
            otpStore.remove(email);
        }
        
        return isValid;
    }
    
    public static void removeOTP(String email) {
        otpStore.remove(email);
    }
    
    public static boolean isOTPExpired(String email) {
        OTPData otpData = otpStore.get(email);
        return otpData == null || !otpData.isValid();
    }
} 