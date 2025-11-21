package com.javanet.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.Date;

/**
 * 邮件发送工具类
 */
public class EmailUtil {
    private static final String SMTP_HOST = "smtp.outlook.com";
    private static final String SMTP_PORT = "465";
    private static final String FROM_EMAIL = "javaonlineshopnet@outlook.com"; // 需要配置实际邮箱
    private static final String FROM_PASSWORD = "Du2YVdNMrbcRqFF"; // 需要配置授权码
    private static final String FROM_NAME = "JavaNet在线商城";
    
    /**
     * 发送订单确认邮件
     */
    public static boolean sendOrderConfirmation(String toEmail, String orderNumber, 
                                               String totalAmount, String shippingAddress) {
        String subject = "订单确认 - " + orderNumber;
        String content = buildOrderConfirmationEmail(orderNumber, totalAmount, shippingAddress);
        return sendEmail(toEmail, subject, content);
    }
    
    /**
     * 发送付款成功邮件
     */
    public static boolean sendPaymentConfirmation(String toEmail, String orderNumber, 
                                                  String totalAmount, String paymentMethod) {
        String subject = "付款成功通知 - " + orderNumber;
        String content = buildPaymentConfirmationEmail(orderNumber, totalAmount, paymentMethod);
        return sendEmail(toEmail, subject, content);
    }
    
    /**
     * 发送发货通知邮件
     */
    public static boolean sendShippingNotification(String toEmail, String orderNumber, 
                                                   String trackingNumber) {
        String subject = "订单已发货 - " + orderNumber;
        String content = buildShippingNotificationEmail(orderNumber, trackingNumber);
        return sendEmail(toEmail, subject, content);
    }
    
    /**
     * 发送收货确认邮件
     */
    public static boolean sendDeliveryConfirmation(String toEmail, String orderNumber) {
        String subject = "确认收货 - " + orderNumber;
        String content = buildDeliveryConfirmationEmail(orderNumber);
        return sendEmail(toEmail, subject, content);
    }
    
    /**
     * 通用邮件发送方法
     */
    private static boolean sendEmail(String toEmail, String subject, String content) {
        try {
            // 配置邮件服务器属性
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // 创建会话
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            });
            
            // 创建邮件消息
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html;charset=UTF-8");
            message.setSentDate(new Date());
            
            // 发送邮件
            Transport.send(message);
            System.out.println("邮件发送成功: " + toEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("邮件发送失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 构建订单确认邮件内容
     */
    private static String buildOrderConfirmationEmail(String orderNumber, 
                                                     String totalAmount, String shippingAddress) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='UTF-8'></head>" +
               "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
               "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
               "<h2 style='color: #0F7B0F; border-bottom: 2px solid #0F7B0F; padding-bottom: 10px;'>订单确认</h2>" +
               "<p>尊敬的客户，您好！</p>" +
               "<p>感谢您在JavaNet在线商城购物，您的订单已成功提交。</p>" +
               "<div style='background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;'>" +
               "<p><strong>订单号：</strong>" + orderNumber + "</p>" +
               "<p><strong>订单金额：</strong>¥" + totalAmount + "</p>" +
               "<p><strong>收货地址：</strong>" + shippingAddress + "</p>" +
               "</div>" +
               "<p>我们将尽快为您处理订单，请耐心等待。</p>" +
               "<p>如有任何问题，请随时联系我们的客服。</p>" +
               "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
               "<p style='color: #666; font-size: 12px;'>此邮件由系统自动发送，请勿直接回复。</p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * 构建付款确认邮件内容
     */
    private static String buildPaymentConfirmationEmail(String orderNumber, 
                                                       String totalAmount, String paymentMethod) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='UTF-8'></head>" +
               "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
               "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
               "<h2 style='color: #28a745; border-bottom: 2px solid #28a745; padding-bottom: 10px;'>付款成功</h2>" +
               "<p>尊敬的客户，您好！</p>" +
               "<p>您的订单付款已成功完成。</p>" +
               "<div style='background: #d1e7dd; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #28a745;'>" +
               "<p><strong>订单号：</strong>" + orderNumber + "</p>" +
               "<p><strong>付款金额：</strong>¥" + totalAmount + "</p>" +
               "<p><strong>付款方式：</strong>" + getPaymentMethodName(paymentMethod) + "</p>" +
               "</div>" +
               "<p>我们将尽快为您安排发货，请留意物流信息。</p>" +
               "<p>感谢您的信任与支持！</p>" +
               "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
               "<p style='color: #666; font-size: 12px;'>此邮件由系统自动发送，请勿直接回复。</p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * 构建发货通知邮件内容
     */
    private static String buildShippingNotificationEmail(String orderNumber, String trackingNumber) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='UTF-8'></head>" +
               "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
               "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
               "<h2 style='color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 10px;'>订单已发货</h2>" +
               "<p>尊敬的客户，您好！</p>" +
               "<p>您的订单已发货，请注意查收。</p>" +
               "<div style='background: #cfe2ff; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #007bff;'>" +
               "<p><strong>订单号：</strong>" + orderNumber + "</p>" +
               "<p><strong>物流单号：</strong>" + trackingNumber + "</p>" +
               "</div>" +
               "<p>您可以通过物流单号查询包裹的实时位置。</p>" +
               "<p>预计3-5个工作日送达，请保持电话畅通。</p>" +
               "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
               "<p style='color: #666; font-size: 12px;'>此邮件由系统自动发送，请勿直接回复。</p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * 构建收货确认邮件内容
     */
    private static String buildDeliveryConfirmationEmail(String orderNumber) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='UTF-8'></head>" +
               "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
               "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
               "<h2 style='color: #28a745; border-bottom: 2px solid #28a745; padding-bottom: 10px;'>确认收货</h2>" +
               "<p>尊敬的客户，您好！</p>" +
               "<p>您已确认收货，感谢您的购买！</p>" +
               "<div style='background: #d1e7dd; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #28a745;'>" +
               "<p><strong>订单号：</strong>" + orderNumber + "</p>" +
               "<p><strong>订单状态：</strong>已完成</p>" +
               "</div>" +
               "<p>如果您对商品满意，欢迎给我们好评！</p>" +
               "<p>如有任何问题，请随时联系我们的客服。</p>" +
               "<p>期待您的再次光临！</p>" +
               "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
               "<p style='color: #666; font-size: 12px;'>此邮件由系统自动发送，请勿直接回复。</p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * 获取付款方式名称
     */
    private static String getPaymentMethodName(String paymentMethod) {
        switch (paymentMethod) {
            case "online":
                return "在线支付";
            case "cod":
                return "货到付款";
            case "alipay":
                return "支付宝";
            case "wechat":
                return "微信支付";
            case "bank":
                return "银行卡";
            default:
                return paymentMethod;
        }
    }
}