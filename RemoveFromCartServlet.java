package com.bunnyshop.controllers;

import com.bunnyshop.models.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý xoá sản phẩm khỏi giỏ hàng
 * URL: /remove-from-cart?productId=XXX&size=YYY
 */
@WebServlet(name = "RemoveFromCartServlet", urlPatterns = {"/remove-from-cart"})
public class RemoveFromCartServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy các tham số từ URL query string
        String productId = request.getParameter("productId");
        String size = request.getParameter("size");
        
        // Lấy giỏ hàng từ session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart != null && productId != null && size != null) {
            // Tìm và xoá sản phẩm khớp với productId và size
            for (CartItem item : cart) {
                if (item.getProduct().getProductID().equals(productId) 
                    && item.getSize().equals(size)) {
                    cart.remove(item);
                    break; // Xoá item đầu tiên tìm được thôi
                }
            }
            
            // Cập nhật lại số lượng item trong giỏ
            session.setAttribute("cartSize", cart.size());
            
            // Cập nhật lại giỏ hàng (không thay đổi, nhưng để đảm bảo)
            session.setAttribute("cart", cart);
        }
        
        // Chuyển hướng lại trang giỏ hàng
        response.sendRedirect("cart");
    }
}