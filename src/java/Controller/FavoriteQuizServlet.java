package Controller;

import DAO.FavoriteQuizDAO;
import Model.Account;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Đã xóa annotation @WebServlet để tránh xung đột mapping
public class FavoriteQuizServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // "add" hoặc "remove"
        String quizIdStr = request.getParameter("quizId");
        HttpSession session = request.getSession(false);
        String referer = request.getHeader("referer");

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int accountId = ((Account) session.getAttribute("account")).getId();
        int quizId;
        try {
            quizId = Integer.parseInt(quizIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(referer != null ? referer : "home.jsp");
            return;
        }

        FavoriteQuizDAO favoriteQuizDAO = new FavoriteQuizDAO();
        if ("add".equalsIgnoreCase(action)) {
            favoriteQuizDAO.addToFavorites(accountId, quizId);
        } else if ("remove".equalsIgnoreCase(action)) {
            favoriteQuizDAO.removeFromFavorites(accountId, quizId);
        }
        // Quay lại trang trước đó
        response.sendRedirect(referer != null ? referer : "home.jsp");
    }
} 