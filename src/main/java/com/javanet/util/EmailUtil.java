package com.javanet.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.Date;

/**
 * 邮件发送工具类
 */
public class EmailUtil {
    // 163邮箱配置
    private static final String SMTP_HOST = "smtp.163.com";
    private static final String SMTP_PORT = "465";
    private static final String FROM_EMAIL = "javaonlineshop@163.com"; // 请替换为您的163邮箱
    private static final String FROM_PASSWORD = "JYx5j6kNjsiKCHKd"; // 请替换为163邮箱授权码
    private static final String FROM_NAME = "JavaNet在线商城";
    
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
        // 验证邮箱格式
        if (!isValidEmail(toEmail)) {
            System.err.println("无效的邮箱地址: " + toEmail);
            return false;
        }
        
        try {
            // 配置邮件服务器属性
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.trust", "*");
            props.put("mail.smtp.connectiontimeout", "15000");
            props.put("mail.smtp.timeout", "15000");
            props.put("mail.smtp.writetimeout", "15000");
            
            // 创建会话
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            });
            
            // 调试模式（生产环境保持关闭）
            // session.setDebug(true);
            
            // 创建邮件消息
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html;charset=UTF-8");
            message.setSentDate(new Date());
            
            // 发送邮件
            Transport.send(message);
            System.out.println("邮件发送成功: " + toEmail + " - 主题: " + subject);
            return true;
            
        } catch (AuthenticationFailedException e) {
            System.err.println("邮件认证失败: 请检查邮箱账号和密码/授权码是否正确");
            e.printStackTrace();
            return false;
        } catch (SendFailedException e) {
            System.err.println("邮件发送失败: 收件人地址无效或邮箱服务器拒绝");
            e.printStackTrace();
            return false;
        } catch (MessagingException e) {
            System.err.println("邮件发送失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("邮件发送出现未知错误: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 验证邮箱格式是否正确
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
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
}