package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }
    
    private void performLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session hiện tại
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Log thông tin logout
            String email = (String) session.getAttribute("email");
            String role = (String) session.getAttribute("role");
            System.out.println("User logout: " + email + " (Role: " + role + ")");
            
            // Xóa tất cả các thuộc tính trong session
            session.invalidate();
        }
        
        // Xóa cookie rememberMe nếu có
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberMe".equals(c.getName())) {
                    c.setMaxAge(0);
                    c.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(c);
                }
            }
        }
        
        // Chuyển hướng về trang login với thông báo
        response.sendRedirect(request.getContextPath() + "/login?message=You have been logged out successfully.");
    }
} 