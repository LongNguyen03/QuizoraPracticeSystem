package Controller;

import DAO.FavoriteQuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class FavoriteQuizServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Not logged in");
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String quizIdStr = request.getParameter("quizId");
            String action = request.getParameter("action");
            
            if (quizIdStr == null || action == null) {
                out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }
            
            int quizId = Integer.parseInt(quizIdStr);
            FavoriteQuizDAO favoriteDao = new FavoriteQuizDAO();
            boolean success = false;
            
            if ("add".equals(action)) {
                success = favoriteDao.addToFavorites(accountId, quizId);
            } else if ("remove".equals(action)) {
                success = favoriteDao.removeFromFavorites(accountId, quizId);
            }
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Favorite updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update favorite\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid quiz ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Server error\"}");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
} 