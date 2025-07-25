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
            List<Quiz> teacherQuizzes = quizDAO.getQuizzesByOwnerId(accountId);
            long totalQuizzes = teacherQuizzes.size();
            
            // Thống kê môn học
            List<Subject> subjects = subjectDAO.getAllSubjects();
            long totalSubjects = subjects.stream().filter(s -> s.getOwnerId() == accountId).count();
            
            // Thống kê tổng số học sinh đã làm quiz của giáo viên này
            java.util.Set<Integer> studentIds = new java.util.HashSet<>();
            for (Quiz quiz : teacherQuizzes) {
                List<QuizResult> results = resultDAO.getQuizResultsByQuizId(quiz.getId());
                for (QuizResult result : results) {
                    studentIds.add(result.getAccountId());
                }
            }
            long totalStudents = studentIds.size();
            
            // Đưa dữ liệu vào request
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("recentQuizzes", teacherQuizzes.subList(0, Math.min(5, teacherQuizzes.size())));
            request.setAttribute("recentSubjects", subjects.stream().filter(s -> s.getOwnerId() == accountId).limit(5).toList());
            
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