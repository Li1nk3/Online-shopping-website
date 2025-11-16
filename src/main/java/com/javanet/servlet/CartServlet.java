package com.javanet.servlet;

import com.javanet.dao.CartDAO;
import com.javanet.model.Cart;
import com.javanet.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
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
        
        List<Cart> cartItems = cartDAO.getCartItems(user.getId());
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action) {
                case "add":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity") != null ? 
                                  request.getParameter("quantity") : "1");
                    
                    if (cartDAO.addToCart(user.getId(), productId, quantity)) {
                        out.print("{\"success\": true, \"message\": \"商品已加入购物车\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"添加失败\"}");
                    }
                    break;
                    
                case "update":
                    productId = Integer.parseInt(request.getParameter("productId"));
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                    
                    if (cartDAO.updateQuantity(user.getId(), productId, quantity)) {
                        out.print("{\"success\": true, \"message\": \"数量已更新\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"更新失败\"}");
                    }
                    break;
                    
                case "remove":
                    productId = Integer.parseInt(request.getParameter("productId"));
                    
                    if (cartDAO.removeFromCart(user.getId(), productId)) {
                        out.print("{\"success\": true, \"message\": \"商品已移除\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"移除失败\"}");
                    }
                    break;
                    
                case "clear":
                    if (cartDAO.clearCart(user.getId())) {
                        out.print("{\"success\": true, \"message\": \"购物车已清空\"}");
                    } else {
                        out.print("{\"success\": false, \"message\": \"清空失败\"}");
                    }
                    break;
                    
                default:
                    out.print("{\"success\": false, \"message\": \"无效操作\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"操作失败\"}");
        }
    }
}