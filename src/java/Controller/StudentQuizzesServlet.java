package Controller;

import DAO.QuizDAO;
import DAO.SubjectDAO;
import DAO.FavoriteQuizDAO;
import Model.Quiz;
import Model.Subject;
import Model.FavoriteQuiz;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class StudentQuizzesServlet extends HttpServlet {
    
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
            QuizDAO quizDao = new QuizDAO();
            SubjectDAO subjectDao = new SubjectDAO();
            FavoriteQuizDAO favoriteDao = new FavoriteQuizDAO();
            
            // Get filter parameters
            String subjectFilter = request.getParameter("subject");
            String levelFilter = request.getParameter("level");
            String searchQuery = request.getParameter("search");
            
            // Get all subjects for filter dropdown
            List<Subject> allSubjects = subjectDao.getAllSubjects();
            request.setAttribute("subjects", allSubjects);
            
            // Get quizzes based on filters
            List<Quiz> quizzes = new ArrayList<>();
            
            if (subjectFilter != null && !subjectFilter.isEmpty()) {
                // Filter by specific subject
                quizzes = quizDao.getQuizzesBySubjectId(Integer.parseInt(subjectFilter));
            } else {
                // Get all available quizzes
                quizzes = quizDao.getAllAvailableQuizzes();
            }
            
            // Apply level filter if specified
            if (levelFilter != null && !levelFilter.isEmpty()) {
                quizzes = quizzes.stream()
                    .filter(quiz -> levelFilter.equals(quiz.getLevel()))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Apply search filter if specified
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String query = searchQuery.toLowerCase().trim();
                quizzes = quizzes.stream()
                    .filter(quiz -> quiz.getName().toLowerCase().contains(query))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Get favorite quizzes for current user
            List<FavoriteQuiz> favoriteQuizzes = favoriteDao.getFavoriteQuizzesByAccountId(accountId);
            
            // Mark quizzes as favorite
            for (Quiz quiz : quizzes) {
                boolean isFavorite = favoriteQuizzes.stream()
                    .anyMatch(fav -> fav.getQuizId() == quiz.getId());
                quiz.setFavorite(isFavorite);
            }
            
            // Get subject information for each quiz
            for (Quiz quiz : quizzes) {
                Subject subject = subjectDao.getSubjectById(quiz.getSubjectId());
                quiz.setSubjectTitle(subject != null ? subject.getTitle() : "Unknown Subject");
            }
            
            request.setAttribute("quizzes", quizzes);
            request.setAttribute("selectedSubject", subjectFilter);
            request.setAttribute("selectedLevel", levelFilter);
            request.setAttribute("searchQuery", searchQuery);
            
            // Get unique levels for filter dropdown
            List<String> levels = quizDao.getAllQuizLevels();
            request.setAttribute("levels", levels);
            
            request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading quizzes.");
            request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 