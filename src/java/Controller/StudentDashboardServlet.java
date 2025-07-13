package Controller;

import DAO.QuizDAO;
import DAO.QuizResultDAO;
import DAO.SubjectDAO;
import DAO.FavoriteQuizDAO;
import Model.Quiz;
import Model.QuizResult;
import Model.Subject;
import Model.FavoriteQuiz;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {
    
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
            // Lấy thống kê cho student
            QuizDAO quizDAO = new QuizDAO();
            QuizResultDAO resultDAO = new QuizResultDAO();
            SubjectDAO subjectDAO = new SubjectDAO();
            FavoriteQuizDAO favoriteDAO = new FavoriteQuizDAO();
            
            // Thống kê quiz đã làm
            List<QuizResult> studentResults = resultDAO.getQuizResultsByAccountId(accountId);
            long completedQuizzes = studentResults.size();
            long passedQuizzes = studentResults.stream().filter(r -> r.isPassed()).count();
            
            // Điểm trung bình
            double averageScore = resultDAO.getAverageScoreByAccountId(accountId);
            
            // Quiz yêu thích
            List<FavoriteQuiz> favoriteQuizzes = favoriteDAO.getFavoriteQuizzesByAccountId(accountId);
            long totalFavorites = favoriteQuizzes.size();
            
            // Môn học
            List<Subject> subjects = subjectDAO.getAllSubjects();
            long totalSubjects = subjects.size();
            
            // Đưa dữ liệu vào request
            request.setAttribute("completedQuizzes", completedQuizzes);
            request.setAttribute("passedQuizzes", passedQuizzes);
            request.setAttribute("averageScore", averageScore);
            request.setAttribute("totalFavorites", totalFavorites);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("recentResults", studentResults.subList(0, Math.min(5, studentResults.size())));
            request.setAttribute("favoriteQuizzes", favoriteQuizzes.subList(0, Math.min(5, favoriteQuizzes.size())));
            
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 