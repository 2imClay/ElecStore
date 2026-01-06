package com.elecstore.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class PasswordUtil {

    public static String hashPasswordSHA256(String password) throws NoSuchAlgorithmException {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] messageDigest = md.digest(password.getBytes());

        // Convert bytes to hexadecimal string
        StringBuilder sb = new StringBuilder();
        for (byte b : messageDigest) {
            sb.append(String.format("%02x", b));
        }

        return sb.toString();
    }

    /**
     * Validate password using SHA-256
     * @param plainPassword Plain text password to validate
     * @param hashedPassword Hashed password from database
     * @return true if passwords match, false otherwise
     */
    public static boolean validatePasswordSHA256(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        try {
            String hash = hashPasswordSHA256(plainPassword);
            return hash.equals(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error validating password: " + e.getMessage());
            return false;
        }
    }

    // ===== BCRYPT HASHING (RECOMMENDED - More Secure) =====
    // Ghi chú: Cần add dependency: org.mindrot:jbcrypt:0.4

    /**
     * Hash password using BCrypt
     * BCrypt tự động tạo salt và là slow hashing (bảo mật tốt hơn)
     * @param password Plain text password
     * @return Hashed password
     */
    public static String hashPasswordBCrypt(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        // Uncomment khi add jbcrypt dependency
        // int rounds = 12; // Cost factor (10-12 recommended)
        // return BCrypt.hashpw(password, BCrypt.gensalt(rounds));

        // Fallback to SHA-256 if BCrypt not available
        try {
            return hashPasswordSHA256(password);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Validate password using BCrypt
     * @param plainPassword Plain text password
     * @param hashedPassword Hashed password from database
     * @return true if passwords match, false otherwise
     */
    public static boolean validatePasswordBCrypt(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        // Uncomment khi add jbcrypt dependency
        // return BCrypt.checkpw(plainPassword, hashedPassword);

        // Fallback to SHA-256
        return validatePasswordSHA256(plainPassword, hashedPassword);
    }

    // ===== RECOMMENDED METHOD (Use this in RegisterServlet) =====

    /**
     * Hash password - Phương thức khuyến nghị sử dụng
     * Hiện tại dùng SHA-256, có thể nâng cấp lên BCrypt sau
     * @param password Plain text password
     * @return Hashed password
     */
    public static String hashPassword(String password) {
        try {
            return hashPasswordSHA256(password);
            // Nâng cấp: return hashPasswordBCrypt(password);
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            return null;
        }
    }

    /**
     * Validate password - Phương thức khuyến nghị sử dụng
     * @param plainPassword Plain text password
     * @param hashedPassword Hashed password
     * @return true if match, false otherwise
     */
    public static boolean validatePassword(String plainPassword, String hashedPassword) {
        return validatePasswordSHA256(plainPassword, hashedPassword);
        // Nâng cấp: return validatePasswordBCrypt(plainPassword, hashedPassword);
    }

    // ===== PASSWORD STRENGTH CHECKING =====

    /**
     * Check password strength level (0-4)
     * 0: Very Weak
     * 1: Weak
     * 2: Medium
     * 3: Strong
     * 4: Very Strong
     */
    public static int checkPasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return 0;
        }

        int strength = 0;

        // Kiểm tra độ dài
        if (password.length() >= 8) {
            strength++;
        }

        // Kiểm tra chữ cái hoa & thường
        if (password.matches(".*[a-z].*") && password.matches(".*[A-Z].*")) {
            strength++;
        }

        // Kiểm tra số
        if (password.matches(".*\\d.*")) {
            strength++;
        }

        // Kiểm tra ký tự đặc biệt
        if (password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            strength++;
        }

        return strength;
    }

    /**
     * Get password strength label
     */
    public static String getPasswordStrengthLabel(String password) {
        int strength = checkPasswordStrength(password);
        switch (strength) {
            case 0:
                return "Very Weak";
            case 1:
                return "Weak";
            case 2:
                return "Medium";
            case 3:
                return "Strong";
            case 4:
                return "Very Strong";
            default:
                return "Unknown";
        }
    }

    /**
     * Get password strength in Vietnamese
     */
    public static String getPasswordStrengthLabelVI(String password) {
        int strength = checkPasswordStrength(password);
        switch (strength) {
            case 0:
                return "Rất Yếu";
            case 1:
                return "Yếu";
            case 2:
                return "Trung Bình";
            case 3:
                return "Mạnh";
            case 4:
                return "Rất Mạnh";
            default:
                return "Không Xác Định";
        }
    }

    // ===== GENERATE RANDOM PASSWORD =====

    /**
     * Generate random password with specified length
     * @param length Length of password
     * @return Random password
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) {
            length = 8; // Minimum length
        }

        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder password = new StringBuilder();
        SecureRandom random = new SecureRandom();

        for (int i = 0; i < length; i++) {
            password.append(characters.charAt(random.nextInt(characters.length())));
        }

        return password.toString();
    }

    /**
     * Generate default random password (12 characters)
     */
    public static String generateRandomPassword() {
        return generateRandomPassword(12);
    }

    // ===== VALIDATION HELPERS =====

    /**
     * Validate password format
     * - Min 6 characters
     * - Min 1 uppercase letter
     * - Min 1 lowercase letter
     * - Min 1 digit
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }

        // Min length 6
        if (password.length() < 6) {
            return false;
        }

        // Optional: Require specific character types
        // Uncomment below for stricter validation
        /*
        boolean hasUpperCase = password.matches(".*[A-Z].*");
        boolean hasLowerCase = password.matches(".*[a-z].*");
        boolean hasDigit = password.matches(".*\\d.*");

        return hasUpperCase && hasLowerCase && hasDigit;
        */

        return true;
    }

    /**
     * Get password validation error message
     */
    public static String getPasswordValidationError(String password) {
        if (password == null || password.isEmpty()) {
            return "Mật khẩu không được để trống";
        }

        if (password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự";
        }

        // Optional stricter validation
        /*
        if (!password.matches(".*[A-Z].*")) {
            return "Mật khẩu phải có ít nhất 1 chữ cái hoa";
        }

        if (!password.matches(".*[a-z].*")) {
            return "Mật khẩu phải có ít nhất 1 chữ cái thường";
        }

        if (!password.matches(".*\\d.*")) {
            return "Mật khẩu phải có ít nhất 1 số";
        }
        */

        return null; // Valid password
    }

    // ===== TESTING =====

    /**
     * Main method for testing
     */
    public static void main(String[] args) {
        System.out.println("=== PASSWORD UTIL TEST ===\n");

        String testPassword = "Password123";

        // Test 1: Hash & Validate
        System.out.println("Test 1: Hash & Validate");
        String hashed = PasswordUtil.hashPassword(testPassword);
        System.out.println("Original: " + testPassword);
        System.out.println("Hashed: " + hashed);
        System.out.println("Valid: " + PasswordUtil.validatePassword(testPassword, hashed));
        System.out.println("Invalid: " + PasswordUtil.validatePassword("WrongPassword", hashed));
        System.out.println();

        // Test 2: Password Strength
        System.out.println("Test 2: Password Strength");
        String[] testPasswords = {
                "123",
                "password",
                "Password",
                "Password1",
                "Password1!@#"
        };
        for (String pwd : testPasswords) {
            System.out.println(pwd + " -> " + PasswordUtil.getPasswordStrengthLabelVI(pwd));
        }
        System.out.println();

        // Test 3: Generate Random Password
        System.out.println("Test 3: Generate Random Password");
        System.out.println("Random (12 chars): " + PasswordUtil.generateRandomPassword());
        System.out.println("Random (16 chars): " + PasswordUtil.generateRandomPassword(16));
        System.out.println();

        // Test 4: Validation
        System.out.println("Test 4: Validation");
        System.out.println("Validate 'Password123': " + PasswordUtil.isValidPassword("Password123"));
        System.out.println("Validate 'pass': " + PasswordUtil.isValidPassword("pass"));
        System.out.println("Error for 'pass': " + PasswordUtil.getPasswordValidationError("pass"));
    }

}
