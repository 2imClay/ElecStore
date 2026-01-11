package com.elecstore.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "nnthanh1209@gmail.com";  // Gmail app của bạn
    private static final String EMAIL_PASSWORD = "iyje crza gmhn gsua";   // App Password Gmail

    public static boolean sendOtpEmail(String toEmail, String otpCode, String userName) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("ElecStore - Mã xác thực khôi phục mật khẩu");

            String content = "Xin chào " + userName + ",\n\n"
                    + "Mã xác thực khôi phục mật khẩu ElecStore:\n\n"
                    +  otpCode
                    + "Mã có hiệu lực trong 10 phút.\n"
                    + "Không chia sẻ mã này với bất kỳ ai.\n\n"
                    + "Trân trọng,\nElecStore Team";

            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email gửi thành công đến: " + toEmail);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi gửi email: " + e.getMessage());
            return false;
        }
    }
}
