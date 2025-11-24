package com.javanet.util;

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
    }
    
    // 获取可用的秘密密钥
    public static String getSecretKey() {
        if (SECRET_KEY == null || SECRET_KEY.trim().isEmpty()) {
            throw new IllegalStateException("Stripe secret key not configured. Please set STRIPE_SECRET_KEY environment variable.");
        }
        return SECRET_KEY;
    }
}