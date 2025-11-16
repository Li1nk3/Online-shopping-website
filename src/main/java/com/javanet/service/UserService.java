package com.javanet.service;

import com.javanet.dao.UserDAO;
import com.javanet.model.User;

public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    public boolean registerUser(User user) {
        // 检查用户名是否已存在
        if (userDAO.getUserByUsername(user.getUsername()) != null) {
            return false;
        }
        return userDAO.addUser(user);
    }
    
    public User loginUser(String username, String password) {
        if (userDAO.validateUser(username, password)) {
            return userDAO.getUserByUsername(username);
        }
        return null;
    }
}