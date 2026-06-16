package tool;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class SignaturePanel extends JPanel {

    private static final long serialVersionUID = 1L;
    
    private JTextField txtOrderFilePath;
    private JTextField txtVerifyOrderFilePath;

    private JButton btnChooseOrderFile;
    private JButton btnChooseVerifyOrderFile;

    private JTextField txtPrivateKeyPath;
    private JTextField txtPublicKeyPath;
    private JTextField txtSignaturePath;

    private JTextArea txtHash;
    private JTextArea txtSignature;
    private JTextArea txtResult;

    private JButton btnChoosePrivateKey;
    private JButton btnHashAndSign;
    private JButton btnSaveSignature;

    private JButton btnChoosePublicKey;
    private JButton btnChooseSignature;
    private JButton btnVerify;

    public SignaturePanel() {
        initUI();
        addListeners();
    }

    private void initUI() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JTabbedPane tabs = new JTabbedPane();

        tabs.addTab("Ký đơn hàng", createSignPanel());
        tabs.addTab("Xác minh chữ ký", createVerifyPanel());

        txtResult = new JTextArea(8, 70);
        txtResult.setEditable(false);
        txtResult.setFont(new Font("Consolas", Font.PLAIN, 14));
        txtResult.setLineWrap(true);
        txtResult.setWrapStyleWord(true);

        JPanel resultPanel = new JPanel(new BorderLayout());
        resultPanel.setBorder(BorderFactory.createTitledBorder("Kết quả"));
        resultPanel.add(new JScrollPane(txtResult), BorderLayout.CENTER);

        add(tabs, BorderLayout.CENTER);
        add(resultPanel, BorderLayout.SOUTH);
    }

    private JPanel createSignPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));

        JPanel inputPanel = new JPanel(new GridLayout(2, 1, 5, 10));

        JPanel p1 = new JPanel(new FlowLayout(FlowLayout.LEFT));
        p1.add(new JLabel("File đơn hàng .txt:"));
        txtOrderFilePath = new JTextField(45);
        txtOrderFilePath.setEditable(false);
        btnChooseOrderFile = new JButton("Chọn đơn hàng");
        p1.add(txtOrderFilePath);
        p1.add(btnChooseOrderFile);

        JPanel p2 = new JPanel(new FlowLayout(FlowLayout.LEFT));
        p2.add(new JLabel("Private Key:"));
        txtPrivateKeyPath = new JTextField(45);
        txtPrivateKeyPath.setEditable(false);
        btnChoosePrivateKey = new JButton("Chọn private key");
        p2.add(txtPrivateKeyPath);
        p2.add(btnChoosePrivateKey);

        inputPanel.add(p1);
        inputPanel.add(p2);

        txtHash = createTextArea();
        JScrollPane hashScroll = new JScrollPane(txtHash);
        hashScroll.setBorder(BorderFactory.createTitledBorder("Mã hash của đơn hàng"));

        txtSignature = createTextArea();
        JScrollPane sigScroll = new JScrollPane(txtSignature);
        sigScroll.setBorder(BorderFactory.createTitledBorder("Chữ ký số"));

        JPanel centerPanel = new JPanel(new GridLayout(2, 1, 10, 10));
        centerPanel.add(hashScroll);
        centerPanel.add(sigScroll);

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 10));
        btnHashAndSign = new JButton("Hash & Ký đơn hàng");
        btnSaveSignature = new JButton("Lưu chữ ký .sig");
        buttonPanel.add(btnHashAndSign);
        buttonPanel.add(btnSaveSignature);

        panel.add(inputPanel, BorderLayout.NORTH);
        panel.add(centerPanel, BorderLayout.CENTER);
        panel.add(buttonPanel, BorderLayout.SOUTH);

        return panel;
    }

    private JPanel createVerifyPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));

        JPanel inputPanel = new JPanel(new GridLayout(3, 1, 5, 10));

        JPanel p1 = new JPanel(new FlowLayout(FlowLayout.LEFT));
        p1.add(new JLabel("File đơn hàng .txt:"));

        txtVerifyOrderFilePath = new JTextField(45);
        txtVerifyOrderFilePath.setEditable(false);

        btnChooseVerifyOrderFile = new JButton("Chọn đơn hàng");

        p1.add(txtVerifyOrderFilePath);
        p1.add(btnChooseVerifyOrderFile);

        JPanel p2 = new JPanel(new FlowLayout(FlowLayout.LEFT));
        p2.add(new JLabel("Public Key:"));
        txtPublicKeyPath = new JTextField(45);
        txtPublicKeyPath.setEditable(false);
        btnChoosePublicKey = new JButton("Chọn public key");
        p2.add(txtPublicKeyPath);
        p2.add(btnChoosePublicKey);

        JPanel p3 = new JPanel(new FlowLayout(FlowLayout.LEFT));
        p3.add(new JLabel("File chữ ký .sig:"));
        txtSignaturePath = new JTextField(45);
        txtSignaturePath.setEditable(false);
        btnChooseSignature = new JButton("Chọn chữ ký");
        p3.add(txtSignaturePath);
        p3.add(btnChooseSignature);

        inputPanel.add(p1);
        inputPanel.add(p2);
        inputPanel.add(p3);

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        btnVerify = new JButton("Xác minh chữ ký");
        buttonPanel.add(btnVerify);

        panel.add(inputPanel, BorderLayout.NORTH);
        panel.add(buttonPanel, BorderLayout.CENTER);

        return panel;
    }

    private void addListeners() {
        btnChooseOrderFile.addActionListener(e -> chooseFile(txtOrderFilePath));
        btnChooseVerifyOrderFile.addActionListener(e -> chooseFile(txtVerifyOrderFilePath));

        btnChoosePrivateKey.addActionListener(e -> chooseFile(txtPrivateKeyPath));
        btnHashAndSign.addActionListener(e -> hashAndSignOrder());
        btnSaveSignature.addActionListener(e -> saveSignatureToFile());

        btnChoosePublicKey.addActionListener(e -> chooseFile(txtPublicKeyPath));
        btnChooseSignature.addActionListener(e -> chooseFile(txtSignaturePath));
        btnVerify.addActionListener(e -> verifySignature());
    }

    private void hashAndSignOrder() {
        String orderFilePath = txtOrderFilePath.getText().trim();
        String privateKeyPath = txtPrivateKeyPath.getText().trim();

        if (orderFilePath.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn file đơn hàng .txt");
            return;
        }

        if (privateKeyPath.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn file private key");
            return;
        }

        try {
            byte[] orderBytes = Files.readAllBytes(new File(orderFilePath).toPath());

            String orderHash = sha256Hex(orderBytes);
            txtHash.setText(orderHash);

            PrivateKey privateKey = readPrivateKey(privateKeyPath);

            String signAlgorithm = getSignAlgorithm(privateKey);

            Signature signature = Signature.getInstance(signAlgorithm);
            signature.initSign(privateKey);
            signature.update(orderHash.getBytes(StandardCharsets.UTF_8));

            byte[] signatureBytes = signature.sign();
            String signatureBase64 = Base64.getEncoder().encodeToString(signatureBytes);

            txtSignature.setText(signatureBase64);

            txtResult.setText(
                    "Ký đơn hàng thành công\n\n" +
                    "File đơn hàng: " + orderFilePath + "\n" +
                    "Private key: " + privateKeyPath
            );

        } catch (Exception ex) {
            txtResult.setText("Lỗi ký đơn hàng: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    private void verifySignature() {
    	String orderFilePath = txtVerifyOrderFilePath.getText().trim();
        String publicKeyPath = txtPublicKeyPath.getText().trim();
        String signaturePath = txtSignaturePath.getText().trim();

        if (orderFilePath.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn file đơn hàng .txt");
            return;
        }

        if (publicKeyPath.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn file public key");
            return;
        }

        if (signaturePath.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn file chữ ký .sig");
            return;
        }

        try {
            byte[] orderBytes = Files.readAllBytes(new File(orderFilePath).toPath());
            String orderHash = sha256Hex(orderBytes);

            PublicKey publicKey = readPublicKey(publicKeyPath);

            String signAlgorithm = getSignAlgorithm(publicKey);

            String signatureText = new String(
                    Files.readAllBytes(new File(signaturePath).toPath()),
                    StandardCharsets.UTF_8
            ).trim();

            byte[] signatureBytes = Base64.getDecoder().decode(cleanBase64(signatureText));

            Signature signature = Signature.getInstance(signAlgorithm);
            signature.initVerify(publicKey);

            signature.update(orderHash.getBytes(StandardCharsets.UTF_8));

            boolean valid = signature.verify(signatureBytes);

            txtHash.setText(orderHash);

            if (valid) {
                txtResult.setText(
                        "Chữ ký HỢP LỆ.\n\n" +
                        "File đơn hàng: " + orderFilePath + "\n" +
                        "Public key: " + publicKeyPath + "\n" +
                        "Signature file: " + signaturePath
                );
            } else {
                txtResult.setText(
                        "Chữ ký KHÔNG HỢP LỆ"
                );
            }

        } catch (Exception ex) {
            txtResult.setText("Lỗi xác minh chữ ký: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    private String sha256Hex(byte[] data) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(data);

        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }

        return sb.toString();
    }

    private PrivateKey readPrivateKey(String path) throws Exception {
        byte[] keyBytes = readKeyBytes(path);

        Exception lastException = null;

        try {
            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
            return KeyFactory.getInstance("RSA").generatePrivate(spec);
        } catch (Exception e) {
            lastException = e;
        }

        try {
            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
            return KeyFactory.getInstance("DSA").generatePrivate(spec);
        } catch (Exception e) {
            lastException = e;
        }

        throw new Exception("Không đọc được private key");
    }

    private PublicKey readPublicKey(String path) throws Exception {
        byte[] keyBytes = readKeyBytes(path);

        Exception lastException = null;

        try {
            X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
            return KeyFactory.getInstance("RSA").generatePublic(spec);
        } catch (Exception e) {
            lastException = e;
        }

        try {
            X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
            return KeyFactory.getInstance("DSA").generatePublic(spec);
        } catch (Exception e) {
            lastException = e;
        }

        throw new Exception("Không đọc được public key. Key phải là RSA hoặc DSA. Chi tiết: " + lastException.getMessage());
    }

    private byte[] readKeyBytes(String path) throws Exception {
        byte[] fileBytes = Files.readAllBytes(new File(path).toPath());

        /*
         * Trường hợp 1:
         * Key được lưu dạng binary từ key.getEncoded()
         */
        try {
            String text = new String(fileBytes, StandardCharsets.UTF_8);
            String cleaned = cleanBase64(text);

            /*
             * Nếu file là Base64 hoặc PEM thì decode Base64.
             */
            if (cleaned.matches("[A-Za-z0-9+/=]+") && cleaned.length() > 100) {
                return Base64.getDecoder().decode(cleaned);
            }
        } catch (Exception ignored) {
        }

        return fileBytes;
    }

    private String cleanBase64(String text) {
        return text
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s+", "");
    }

    private String getSignAlgorithm(Key key) throws Exception {
        String algorithm = key.getAlgorithm();

        if ("RSA".equalsIgnoreCase(algorithm)) {
            return "SHA256withRSA";
        }

        if ("DSA".equalsIgnoreCase(algorithm)) {

            return "SHA1withDSA";
        }

        throw new Exception("Không hỗ trợ loại key: " + algorithm);
    }

    private void saveSignatureToFile() {
        String signatureText = txtSignature.getText().trim();

        if (signatureText.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Chưa có chữ ký để lưu. Hãy ký đơn hàng trước.");
            return;
        }

        JFileChooser chooser = new JFileChooser();
        chooser.setDialogTitle("Lưu chữ ký số");
        chooser.setSelectedFile(new File("order_signature.sig"));

        if (chooser.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
            try {
                Files.write(
                        chooser.getSelectedFile().toPath(),
                        signatureText.getBytes(StandardCharsets.UTF_8)
                );

                txtResult.setText(
                        "Lưu chữ ký số thành công:\n" +
                        chooser.getSelectedFile().getAbsolutePath()
                );

            } catch (Exception ex) {
                txtResult.setText("Lỗi lưu chữ ký: " + ex.getMessage());
                ex.printStackTrace();
            }
        }
    }

    private void chooseFile(JTextField target) {
        JFileChooser chooser = new JFileChooser();
        chooser.setCurrentDirectory(new File(System.getProperty("user.home")));

        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            target.setText(chooser.getSelectedFile().getAbsolutePath());
        }
    }

    private JTextArea createTextArea() {
        JTextArea area = new JTextArea(7, 70);
        area.setEditable(false);
        area.setFont(new Font("Consolas", Font.PLAIN, 14));
        area.setLineWrap(true);
        area.setWrapStyleWord(true);
        return area;
    }
}