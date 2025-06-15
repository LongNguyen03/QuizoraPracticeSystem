package Utils;

import java.security.SecureRandom;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

public class OTPUtil {
    private static final SecureRandom secureRandom = new SecureRandom();
    private static final int OTP_LENGTH = 6;
    private static final long OTP_VALIDITY_DURATION = 5 * 60 * 1000; // 5 minutes in milliseconds
    private static final int MAX_ATTEMPTS = 3;
    private static final long DELAY_BETWEEN_ATTEMPTS = 2000; // 2 seconds delay
    private static final ConcurrentHashMap<String, OTPData> otpStore = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, Long> lastAttemptTime = new ConcurrentHashMap<>();
    
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
            return System.currentTimeMillis() - timestamp < OTP_VALIDITY_DURATION;
        }
        
        public boolean isMaxAttemptsReached() {
            return attempts >= MAX_ATTEMPTS;
        }
        
        public void incrementAttempts() {
            attempts++;
        }
        
        public int getRemainingAttempts() {
            return MAX_ATTEMPTS - attempts;
        }
    }
    
    public static String generateOTP() {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(secureRandom.nextInt(10));
        }
        return otp.toString();
    }
    
    public static void storeOTP(String email, String otp) {
        otpStore.put(email, new OTPData(otp));
        lastAttemptTime.put(email, 0L); // Reset last attempt time
    }
    
    public static boolean validateOTP(String email, String otp) {
        OTPData otpData = otpStore.get(email);
        if (otpData == null) {
            return false;
        }
        
        // Check if we need to wait before next attempt
        long currentTime = System.currentTimeMillis();
        long lastAttempt = lastAttemptTime.getOrDefault(email, 0L);
        if (currentTime - lastAttempt < DELAY_BETWEEN_ATTEMPTS) {
            try {
                TimeUnit.MILLISECONDS.sleep(DELAY_BETWEEN_ATTEMPTS - (currentTime - lastAttempt));
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        lastAttemptTime.put(email, currentTime);
        
        if (!otpData.isValid()) {
            otpStore.remove(email);
            lastAttemptTime.remove(email);
            return false;
        }
        
        if (otpData.isMaxAttemptsReached()) {
            otpStore.remove(email);
            lastAttemptTime.remove(email);
            return false;
        }
        
        otpData.incrementAttempts();
        if (otpData.otp.equals(otp)) {
            otpStore.remove(email);
            lastAttemptTime.remove(email);
            return true;
        }
        
        return false;
    }
    
    public static void removeOTP(String email) {
        otpStore.remove(email);
        lastAttemptTime.remove(email);
    }
    
    public static boolean isOTPExpired(String email) {
        OTPData otpData = otpStore.get(email);
        return otpData == null || !otpData.isValid();
    }
    
    public static int getRemainingAttempts(String email) {
        OTPData otpData = otpStore.get(email);
        return otpData != null ? otpData.getRemainingAttempts() : 0;
    }
    
    public static boolean isMaxAttemptsReached(String email) {
        OTPData otpData = otpStore.get(email);
        return otpData != null && otpData.isMaxAttemptsReached();
    }
} 