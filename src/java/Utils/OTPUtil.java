package Utils;

import java.util.Random;

public class OTPUtil {
    private static final Random random = new Random();

    public static String generateOTP() {
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
} 