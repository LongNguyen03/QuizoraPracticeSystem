package Controller;

import DAO.QuizDAO;
import DAO.SubjectDAO;
import DAO.QuizResultDAO;
import Model.Quiz;
import Model.Subject;
import Model.QuizResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherDashboardServlet", urlPatterns = {"/teacher/dashboard"})
public class TeacherDashboardServlet extends HttpServlet {
    
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
            // Lấy thống kê cho teacher
            QuizDAO quizDAO = new QuizDAO();
            SubjectDAO subjectDAO = new SubjectDAO();
            QuizResultDAO resultDAO = new QuizResultDAO();
            
            // Thống kê quiz của teacher này
            List<Quiz> teacherQuizzes = quizDAO.getAllAvailableQuizzes(); // Tạm thời lấy tất cả
            long totalQuizzes = teacherQuizzes.size();
            
            // Thống kê môn học
            List<Subject> subjects = subjectDAO.getAllSubjects();
            long totalSubjects = subjects.size();
            
            // Thống kê kết quả (tạm thời)
            long totalResults = 0;
            long passedResults = 0;
            
            // Đưa dữ liệu vào request
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("totalResults", totalResults);
            request.setAttribute("passedResults", passedResults);
            request.setAttribute("recentQuizzes", teacherQuizzes.subList(0, Math.min(5, teacherQuizzes.size())));
            request.setAttribute("recentSubjects", subjects.subList(0, Math.min(5, subjects.size())));
            
            request.getRequestDispatcher("/teacher/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/teacher/home.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 