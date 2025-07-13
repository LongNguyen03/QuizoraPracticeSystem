package Controller;

import DAO.QuizResultDAO;
import DAO.QuizDAO;
import DAO.SubjectDAO;
import DAO.AccountDAO;
import Model.QuizResult;
import Model.Quiz;
import Model.Subject;
import Model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminReportsServlet", urlPatterns = {"/admin/reports"})
public class AdminReportsServlet extends HttpServlet {
    
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
            QuizDAO quizDAO = new QuizDAO();
            SubjectDAO subjectDAO = new SubjectDAO();
            AccountDAO accountDAO = new AccountDAO();
            
            // Lấy dữ liệu cho báo cáo
            List<Quiz> quizzes = quizDAO.getAllAvailableQuizzes();
            List<Subject> subjects = subjectDAO.getAllSubjects();
            List<Account> users = accountDAO.getAllUsers();
            
            // Thống kê tổng quan
            long totalQuizzes = quizzes.size();
            long totalSubjects = subjects.size();
            long totalUsers = users.size();
            long activeUsers = users.stream().filter(u -> "active".equals(u.getStatus())).count();
            
            // Thống kê theo role - chỉ focus vào teacher
            long teacherCount = users.stream().filter(u -> "Teacher".equalsIgnoreCase(u.getRoleName())).count();
            long activeTeachers = users.stream().filter(u -> "Teacher".equalsIgnoreCase(u.getRoleName()) && "active".equals(u.getStatus())).count();
            
            // Đưa dữ liệu vào request
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("teacherCount", teacherCount);
            request.setAttribute("activeTeachers", activeTeachers);
            request.setAttribute("recentQuizzes", quizzes.subList(0, Math.min(5, quizzes.size())));
            request.setAttribute("recentSubjects", subjects.subList(0, Math.min(5, subjects.size())));
            request.setAttribute("teachers", users.stream().filter(u -> "Teacher".equalsIgnoreCase(u.getRoleName())).toList());
            
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 