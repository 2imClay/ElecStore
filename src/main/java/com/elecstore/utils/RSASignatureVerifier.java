package com.elecstore.utils;

import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class RSASignatureVerifier {

    public static boolean verify(String publicKeyBase64, String documentHash, String signatureRaw) {
        try {
            if (publicKeyBase64 == null || documentHash == null || signatureRaw == null) {
                return false;
            }

            PublicKey publicKey = decodePublicKey(publicKeyBase64);
            byte[] signatureBytes = decodeSignature(signatureRaw);

            Signature verifier = Signature.getInstance("SHA256withRSA");
            verifier.initVerify(publicKey);
            verifier.update(documentHash.getBytes(StandardCharsets.UTF_8));

            return verifier.verify(signatureBytes);

        } catch (Exception e) {
            return false;
        }
    }

    private static PublicKey decodePublicKey(String publicKeyBase64) throws Exception {
        String cleaned = stripPemHeaders(publicKeyBase64);
        byte[] keyBytes = Base64.getDecoder().decode(cleaned);

        X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePublic(spec);
    }

    private static String stripPemHeaders(String pem) {
        StringBuilder b64 = new StringBuilder();
        for (String line : pem.split("\n")) {
            String trimmed = line.trim();
            if (trimmed.isEmpty() || trimmed.contains("-----")) {
                continue;
            }
            b64.append(trimmed);
        }
        return b64.length() > 0 ? b64.toString() : pem.trim();
    }

    private static byte[] decodeSignature(String signatureRaw) {
        String sig = signatureRaw.trim().replaceAll("\\s", "");

        if (sig.matches("^[0-9a-fA-F]+$") && sig.length() % 2 == 0) {
            int len = sig.length();
            byte[] bytes = new byte[len / 2];
            for (int i = 0; i < len; i += 2) {
                bytes[i / 2] = (byte) Integer.parseInt(sig.substring(i, i + 2), 16);
            }
            return bytes;
        }
        return Base64.getDecoder().decode(sig);
    }
}
