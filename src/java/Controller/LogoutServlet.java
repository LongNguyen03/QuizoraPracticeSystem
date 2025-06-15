package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session hiện tại
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Xóa tất cả các thuộc tính trong session
            session.invalidate();
        }
        
        // Chuyển hướng về trang home
        response.sendRedirect(request.getContextPath() + "/views/home.jsp");
    }
} 