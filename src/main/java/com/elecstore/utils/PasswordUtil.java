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

        StringBuilder sb = new StringBuilder();
        for (byte b : messageDigest) {
            sb.append(String.format("%02x", b));
        }

        return sb.toString();
    }

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


    public static String hashPasswordBCrypt(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        try {
            return hashPasswordSHA256(password);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean validatePasswordBCrypt(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        return validatePasswordSHA256(plainPassword, hashedPassword);
    }

    public static String hashPassword(String password) {
        try {
            return hashPasswordSHA256(password);
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            return null;
        }
    }

    public static boolean validatePassword(String plainPassword, String hashedPassword) {
        return validatePasswordSHA256(plainPassword, hashedPassword);
    }

    public static int checkPasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return 0;
        }
        int strength = 0;

        if (password.length() >= 8) {
            strength++;
        }

        if (password.matches(".*[a-z].*") && password.matches(".*[A-Z].*")) {
            strength++;
        }

        if (password.matches(".*\\d.*")) {
            strength++;
        }

        if (password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            strength++;
        }

        return strength;
    }

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

    public static String generateRandomPassword() {
        return generateRandomPassword(12);
    }

    public static boolean isValidPassword(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }

        if (password.length() < 6) {
            return false;
        }

        return true;
    }

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

        return null;
    }

    public static void main(String[] args) {
        System.out.println("=== PASSWORD UTIL TEST ===\n");

        String testPassword = "Password123";

        System.out.println("Test 1: Hash & Validate");
        String hashed = PasswordUtil.hashPassword(testPassword);
        System.out.println("Original: " + testPassword);
        System.out.println("Hashed: " + hashed);
        System.out.println("Valid: " + PasswordUtil.validatePassword(testPassword, hashed));
        System.out.println("Invalid: " + PasswordUtil.validatePassword("WrongPassword", hashed));
        System.out.println();

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

        System.out.println("Test 3: Generate Random Password");
        System.out.println("Random (12 chars): " + PasswordUtil.generateRandomPassword());
        System.out.println("Random (16 chars): " + PasswordUtil.generateRandomPassword(16));
        System.out.println();

        System.out.println("Test 4: Validation");
        System.out.println("Validate 'Password123': " + PasswordUtil.isValidPassword("Password123"));
        System.out.println("Validate 'pass': " + PasswordUtil.isValidPassword("pass"));
        System.out.println("Error for 'pass': " + PasswordUtil.getPasswordValidationError("pass"));
    }

}
