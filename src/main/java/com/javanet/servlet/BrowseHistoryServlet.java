package com.javanet.servlet;

import com.javanet.dao.CustomerBrowseLogDAO;
import com.javanet.model.CustomerBrowseLog;
import com.javanet.model.User;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/browse-history")
public class BrowseHistoryServlet extends HttpServlet {
    private CustomerBrowseLogDAO browseLogDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        browseLogDAO = new CustomerBrowseLogDAO();
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
        
        try {
            // 获取分页参数
            int page = 1;
            int limit = 20;
            
            String pageParam = request.getParameter("page");
            String limitParam = request.getParameter("limit");
            
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    page = Math.max(page, 1);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            if (limitParam != null && !limitParam.trim().isEmpty()) {
                try {
                    limit = Integer.parseInt(limitParam);
                    limit = Math.min(Math.max(limit, 5), 100); // 限制在5-100之间
                } catch (NumberFormatException e) {
                    limit = 20;
                }
            }
            
            // 计算偏移量
            int offset = (page - 1) * limit;
            
            // 获取浏览记录
            List<CustomerBrowseLog> browseLogs = browseLogDAO.getBrowseLogsByUserId(user.getId(), offset, limit);
            
            // 计算统计数据
            int totalLogs = browseLogDAO.getUserBrowseLogCount(user.getId());
            int totalPages = (int) Math.ceil((double) totalLogs / limit);
            
            request.setAttribute("browseLogs", browseLogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("limit", limit);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("totalPages", totalPages);
            
            request.getRequestDispatcher("/WEB-INF/views/browse-history.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("BrowseHistoryServlet Error: " + e.getMessage());
            e.printStackTrace(System.err);
            
            // 设置详细的错误信息用于调试
            request.setAttribute("errorMessage", "获取浏览记录失败: " + e.getMessage());
            request.setAttribute("errorDetails", e.toString());
            
            try {
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            } catch (Exception forwardException) {
                forwardException.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取浏览记录失败: " + e.getMessage());
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String action = request.getParameter("action");
        
        try {
            if ("clear".equals(action)) {
                // 清空浏览记录
                boolean success = browseLogDAO.clearUserBrowseLogs(user.getId());
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "浏览记录已清空");
                } else {
                    result.put("success", false);
                    result.put("message", "清空失败，请重试");
                }
                
            } else if ("delete".equals(action)) {
                // 删除单条浏览记录
                String logIdStr = request.getParameter("logId");
                
                if (logIdStr == null || logIdStr.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("message", "记录ID不能为空");
                } else {
                    try {
                        int logId = Integer.parseInt(logIdStr);
                        boolean success = browseLogDAO.deleteBrowseLog(logId, user.getId());
                        
                        if (success) {
                            result.put("success", true);
                            result.put("message", "记录已删除");
                        } else {
                            result.put("success", false);
                            result.put("message", "删除失败或无权限");
                        }
                    } catch (NumberFormatException e) {
                        result.put("success", false);
                        result.put("message", "无效的记录ID");
                    }
                }
                
            } else {
                result.put("success", false);
                result.put("message", "无效的操作");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "操作失败");
        }
        
        out.print(gson.toJson(result));
    }
}