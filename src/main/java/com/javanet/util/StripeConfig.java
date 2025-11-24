package com.javanet.util;

<<<<<<< HEAD
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class StripeConfig {
    private static final Properties properties = new Properties();
    
    static {
        loadProperties();
    }
    
    private static void loadProperties() {
        // 首先尝试从环境变量读取
        String publishableKey = System.getenv("STRIPE_PUBLISHABLE_KEY");
        String secretKey = System.getenv("STRIPE_SECRET_KEY");
        
        if (publishableKey != null && !publishableKey.trim().isEmpty()) {
            properties.setProperty("STRIPE_PUBLISHABLE_KEY", publishableKey);
        }
        if (secretKey != null && !secretKey.trim().isEmpty()) {
            properties.setProperty("STRIPE_SECRET_KEY", secretKey);
        }
        
        // 如果环境变量没有设置，尝试从.env文件读取
        if (!properties.containsKey("STRIPE_PUBLISHABLE_KEY") || !properties.containsKey("STRIPE_SECRET_KEY")) {
            try {
                String projectPath = System.getProperty("user.dir");
                String envFilePath = projectPath + "/.env";
                FileInputStream fis = new FileInputStream(envFilePath);
                properties.load(fis);
                fis.close();
            } catch (IOException e) {
                // .env文件不存在或无法读取，使用默认值
                System.err.println("Warning: Could not read .env file: " + e.getMessage());
            }
        }
    }
    
    // 获取可用的发布密钥
    public static String getPublishableKey() {
        String key = properties.getProperty("STRIPE_PUBLISHABLE_KEY");
        if (key == null || key.trim().isEmpty()) {
            throw new IllegalStateException("Stripe publishable key not configured. Please set STRIPE_PUBLISHABLE_KEY environment variable or add it to .env file.");
        }
        return key.trim();
=======
public class StripeConfig {
    // 从环境变量获取Stripe配置
    private static final String PUBLISHABLE_KEY = System.getenv("STRIPE_PUBLISHABLE_KEY");
    private static final String SECRET_KEY = System.getenv("STRIPE_SECRET_KEY");
    
    // 获取可用的发布密钥
    public static String getPublishableKey() {
        if (PUBLISHABLE_KEY == null || PUBLISHABLE_KEY.trim().isEmpty()) {
            throw new IllegalStateException("Stripe publishable key not configured. Please set STRIPE_PUBLISHABLE_KEY environment variable.");
        }
        return PUBLISHABLE_KEY;
>>>>>>> 9db7c0c1c388e60b7ba3f1b5e1d863539e636a0e
    }
    
    // 获取可用的秘密密钥
    public static String getSecretKey() {
<<<<<<< HEAD
        String key = properties.getProperty("STRIPE_SECRET_KEY");
        if (key == null || key.trim().isEmpty()) {
            throw new IllegalStateException("Stripe secret key not configured. Please set STRIPE_SECRET_KEY environment variable or add it to .env file.");
        }
        return key.trim();
=======
        if (SECRET_KEY == null || SECRET_KEY.trim().isEmpty()) {
            throw new IllegalStateException("Stripe secret key not configured. Please set STRIPE_SECRET_KEY environment variable.");
        }
        return SECRET_KEY;
>>>>>>> 9db7c0c1c388e60b7ba3f1b5e1d863539e636a0e
    }
}