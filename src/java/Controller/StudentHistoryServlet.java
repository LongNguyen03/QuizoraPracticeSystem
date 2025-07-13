package Controller;

import DAO.QuizResultDAO;
import Model.QuizResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentHistoryServlet", urlPatterns = {"/student/history"})
public class StudentHistoryServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            QuizResultDAO resultDAO = new QuizResultDAO();
            List<QuizResult> quizResults = resultDAO.getQuizResultsByAccountId(accountId);
            
            // Tính thống kê
            long totalQuizzes = quizResults.size();
            long passedQuizzes = quizResults.stream().filter(r -> r.isPassed()).count();
            double averageScore = resultDAO.getAverageScoreByAccountId(accountId);
            
            request.setAttribute("quizResults", quizResults);
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("passedQuizzes", passedQuizzes);
            request.setAttribute("averageScore", averageScore);
            
            request.getRequestDispatcher("/student/history.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/student/history.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 