package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name="AccessDeniedServlet", urlPatterns={"/access-denied"})
public class AccessDeniedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Lấy thông tin về URL mà user đang cố gắng truy cập
        String requestedUrl = request.getParameter("url");
        if (requestedUrl == null) {
            requestedUrl = request.getHeader("Referer");
        }
        
        // Lấy thông tin về role hiện tại
        String currentRole = null;
        if (session != null) {
            currentRole = (String) session.getAttribute("role");
        }
        
        // Set attributes để hiển thị trong JSP
        request.setAttribute("requestedUrl", requestedUrl);
        request.setAttribute("currentRole", currentRole);
        
        // Forward đến trang access-denied.jsp
        request.getRequestDispatcher("/error/access-denied.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 