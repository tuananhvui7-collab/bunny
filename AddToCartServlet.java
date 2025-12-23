package com.bunnyshop.controllers;

import com.bunnyshop.dal.ProductDAO;
import com.bunnyshop.models.CartItem;
import com.bunnyshop.models.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/add-to-cart"})
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String size = request.getParameter("size");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        ProductDAO dao = new ProductDAO();
        Product product = dao.getProductById(productId);

        if (product != null) {
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");          
            if (cart == null) {
                cart = new ArrayList<>();
            }

            // Kiểm tra xem sản phẩm + size này đã có trong giỏ chưa
            boolean found = false;
            for (CartItem item : cart) {
                if (item.getProduct().getProductID().equals(productId) && item.getSize().equals(size)) {
                    item.setQuantity(item.getQuantity() + quantity);
                    found = true;
                    break;
                }
            }

            if (!found) {
                cart.add(new CartItem(product, quantity, size));
            }

            // Lưu lại session
            session.setAttribute("cart", cart);
            session.setAttribute("cartSize", cart.size()); // Để hiện badge số lượng trên menu
        }

        // Chuyển hướng sang trang giỏ hàng (Tránh submit lại form F5)
        response.sendRedirect("cart");
    }
}