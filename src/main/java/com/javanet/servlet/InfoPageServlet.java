package com.javanet.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/info/*")
public class InfoPageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 获取请求的页面类型
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // 去掉开头的斜杠
        String page = pathInfo.substring(1);
        
        // 根据不同的页面设置不同的标题和内容
        switch (page) {
            case "about":
                request.setAttribute("title", "关于JavaNet");
                request.setAttribute("page", "about");
                break;
            case "contact":
                request.setAttribute("title", "联系我们");
                request.setAttribute("page", "contact");
                break;
            case "careers":
                request.setAttribute("title", "招聘信息");
                request.setAttribute("page", "careers");
                break;
            case "help":
                request.setAttribute("title", "帮助中心");
                request.setAttribute("page", "help");
                break;
            case "returns":
                request.setAttribute("title", "退换货政策");
                request.setAttribute("page", "returns");
                break;
            case "shipping":
                request.setAttribute("title", "配送信息");
                request.setAttribute("page", "shipping");
                break;
            case "how-to-buy":
                request.setAttribute("title", "如何购买");
                request.setAttribute("page", "how-to-buy");
                break;
            case "payment":
                request.setAttribute("title", "支付方式");
                request.setAttribute("page", "payment");
                break;
            case "membership":
                request.setAttribute("title", "会员权益");
                request.setAttribute("page", "membership");
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/info-page.jsp").forward(request, response);
    }
}