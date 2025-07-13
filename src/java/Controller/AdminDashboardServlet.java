package Controller;

import DAO.AccountDAO;
import DAO.SubjectDAO;
import DAO.QuizDAO;
import DAO.QuizResultDAO;
import Model.Account;
import Model.Subject;
import Model.Quiz;
import Model.QuizResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    
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
            // Lấy thống kê tổng quan
            AccountDAO accountDAO = new AccountDAO();
            SubjectDAO subjectDAO = new SubjectDAO();
            QuizDAO quizDAO = new QuizDAO();
            QuizResultDAO resultDAO = new QuizResultDAO();
            
            // Thống kê người dùng
            List<Account> allUsers = accountDAO.getAllUsers();
            long totalUsers = allUsers.size();
            long activeUsers = allUsers.stream().filter(u -> "active".equals(u.getStatus())).count();
            
            // Thống kê môn học
            List<Subject> subjects = subjectDAO.getAllSubjects();
            long totalSubjects = subjects.size();
            
            // Thống kê quiz
            List<Quiz> quizzes = quizDAO.getAllAvailableQuizzes();
            long totalQuizzes = quizzes.size();
            
            // Thống kê kết quả - tạm thời để trống vì chưa có method getAllQuizResults
            long totalResults = 0;
            long passedResults = 0;
            
            // Đưa dữ liệu vào request
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("totalResults", totalResults);
            request.setAttribute("passedResults", passedResults);
            request.setAttribute("recentUsers", allUsers.subList(0, Math.min(5, allUsers.size())));
            request.setAttribute("recentSubjects", subjects.subList(0, Math.min(5, subjects.size())));
            
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 