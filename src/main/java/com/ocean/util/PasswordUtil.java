package com.ocean.util;

import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    private static final SecureRandom RAND = new SecureRandom();
    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256; // bits
    private static final int SALT_LEN = 16;

    public static String hash(String plain) {
        try {
            byte[] salt = new byte[SALT_LEN];
            RAND.nextBytes(salt);

            byte[] hash = pbkdf2(plain.toCharArray(), salt, ITERATIONS, KEY_LENGTH);

            return ITERATIONS + ":" +
                    Base64.getEncoder().encodeToString(salt) + ":" +
                    Base64.getEncoder().encodeToString(hash);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean verify(String plain, String stored) {
        try {
            if (stored == null) return false;

            // If old plaintext stored -> compare directly
            if (!stored.contains(":")) {
                return plain.equals(stored);
            }

            String[] parts = stored.split(":");
            int it = Integer.parseInt(parts[0]);
            byte[] salt = Base64.getDecoder().decode(parts[1]);
            byte[] hash = Base64.getDecoder().decode(parts[2]);

            byte[] test = pbkdf2(plain.toCharArray(), salt, it, hash.length * 8);

            int diff = 0;
            for (int i = 0; i < hash.length; i++) diff |= (hash[i] ^ test[i]);
            return diff == 0;

        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLength) throws Exception {
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, keyLength);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        return skf.generateSecret(spec).getEncoded();
    }
}