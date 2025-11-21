package com.javanet.servlet;

import com.google.gson.Gson;
import com.javanet.dao.UserDAO;
import com.javanet.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户信息管理Servlet
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        // 重新从数据库获取最新的用户信息
        User latestUser = userDAO.getUserById(user.getId());
        if (latestUser != null) {
            session.setAttribute("user", latestUser);
            request.setAttribute("user", latestUser);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            out.print(gson.toJson(result));
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateInfo".equals(action)) {
            // 更新用户信息
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // 验证输入
            if (email == null || email.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "邮箱不能为空");
                out.print(gson.toJson(result));
                return;
            }
            
            // 验证邮箱格式
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                result.put("success", false);
                result.put("message", "邮箱格式不正确");
                out.print(gson.toJson(result));
                return;
            }
            
            // 更新用户对象
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            
            // 保存到数据库
            boolean success = userDAO.updateUser(user);
            
            if (success) {
                // 更新session中的用户信息
                session.setAttribute("user", user);
                result.put("success", true);
                result.put("message", "信息更新成功");
            } else {
                result.put("success", false);
                result.put("message", "信息更新失败，请重试");
            }
            
        } else if ("updatePassword".equals(action)) {
            // 更新密码
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // 验证输入
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "所有密码字段都不能为空");
                out.print(gson.toJson(result));
                return;
            }
            
            // 验证当前密码
            if (!user.getPassword().equals(currentPassword)) {
                result.put("success", false);
                result.put("message", "当前密码不正确");
                out.print(gson.toJson(result));
                return;
            }
            
            // 验证新密码
            if (newPassword.length() < 6) {
                result.put("success", false);
                result.put("message", "新密码长度至少6位");
                out.print(gson.toJson(result));
                return;
            }
            
            // 验证两次密码是否一致
            if (!newPassword.equals(confirmPassword)) {
                result.put("success", false);
                result.put("message", "两次输入的新密码不一致");
                out.print(gson.toJson(result));
                return;
            }
            
            // 更新密码
            boolean success = userDAO.updatePassword(user.getId(), newPassword);
            
            if (success) {
                // 更新session中的用户密码
                user.setPassword(newPassword);
                session.setAttribute("user", user);
                result.put("success", true);
                result.put("message", "密码修改成功");
            } else {
                result.put("success", false);
                result.put("message", "密码修改失败，请重试");
            }
            
        } else {
            result.put("success", false);
            result.put("message", "无效的操作");
        }
        
        out.print(gson.toJson(result));
    }
}