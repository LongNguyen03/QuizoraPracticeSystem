package Controller;

import DAO.SubjectDAO;
import DAO.QuizDAO;
import DAO.QuizResultDAO;
import DAO.FavoriteQuizDAO;
import DAO.LessonDAO;
import Model.Subject;
import Model.Quiz;
import Model.QuizResult;
import Model.FavoriteQuiz;
import Model.Lesson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class StudentHomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String uri = request.getRequestURI();
        if (uri.matches(request.getContextPath() + "/student/subject/\\d+/lessons")) {
            // Lấy subjectId từ URI
            String[] parts = uri.split("/");
            int subjectId = Integer.parseInt(parts[parts.length - 2]);
            SubjectDAO subjectDao = new SubjectDAO();
            LessonDAO lessonDao = new LessonDAO();
            Subject subject = subjectDao.getSubjectById(subjectId);
            List<Lesson> lessons = lessonDao.getAllLessons(subjectId, null, null);
            request.setAttribute("subject", subject);
            request.setAttribute("lessons", lessons);
            request.getRequestDispatcher("/student/lessons.jsp").forward(request, response);
            return;
        }
        
        try {
            System.out.println("Loading student home for account ID: " + accountId);
            
            SubjectDAO subjectDao = new SubjectDAO();
            QuizDAO quizDao = new QuizDAO();
            LessonDAO lessonDao = new LessonDAO();
            QuizResultDAO resultDao = new QuizResultDAO();
            FavoriteQuizDAO favoriteDao = new FavoriteQuizDAO();
            
            // Get subjects
            List<Subject> subjects = new ArrayList<>();
            try {
                subjects = subjectDao.getAllSubjects();
                // Gán giá trị thực tế cho các trường giao diện
                for (Subject s : subjects) {
                    int quizCount = quizDao.getQuizzesBySubjectId(s.getId()).size();
                    s.setQuizCount(quizCount);
                    int lessonCount = lessonDao.getAllLessons(s.getId(), null, null).size();
                    s.setLessonCount(lessonCount);
                    // Bỏ progress vì không có logic tính
                }
                System.out.println("Loaded " + subjects.size() + " subjects");
            } catch (Exception e) {
                System.err.println("Error loading subjects: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("subjects", subjects);
            
            // Get statistics
            int totalSubjects = subjects.size();
            int totalQuizzes = 0;
            int completedQuizzes = 0;
            double averageScore = 0.0;
            
            try {
                List<Quiz> quizzes = quizDao.getAllAvailableQuizzes();
                totalQuizzes = quizzes.size();
                System.out.println("Loaded " + totalQuizzes + " quizzes");
            } catch (Exception e) {
                System.err.println("Error loading quizzes: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                completedQuizzes = resultDao.getCompletedQuizCountByAccountId(accountId);
                System.out.println("Completed quizzes: " + completedQuizzes);
            } catch (Exception e) {
                System.err.println("Error getting completed quizzes: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                averageScore = resultDao.getAverageScoreByAccountId(accountId);
                System.out.println("Average score: " + averageScore);
            } catch (Exception e) {
                System.err.println("Error getting average score: " + e.getMessage());
                e.printStackTrace();
            }
            
            request.setAttribute("totalSubjects", totalSubjects);
            request.setAttribute("totalQuizzes", totalQuizzes);
            request.setAttribute("completedQuizzes", completedQuizzes);
            request.setAttribute("averageScore", Math.round(averageScore));
            
            // Get recent quiz results
            List<QuizResult> recentResults = new ArrayList<>();
            try {
                recentResults = resultDao.getQuizResultsByAccountId(accountId);
                if (recentResults.size() > 5) {
                    recentResults = recentResults.subList(0, 5); // Limit to 5 most recent
                }
                System.out.println("Loaded " + recentResults.size() + " recent results");
            } catch (Exception e) {
                System.err.println("Error loading recent results: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("recentQuizResults", recentResults);
            
            // Get favorite quizzes
            List<FavoriteQuiz> favoriteQuizzes = new ArrayList<>();
            try {
                favoriteQuizzes = favoriteDao.getFavoriteQuizzesByAccountId(accountId);
                System.out.println("Loaded " + favoriteQuizzes.size() + " favorite quizzes");
            } catch (Exception e) {
                System.err.println("Error loading favorite quizzes: " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("favoriteQuizzes", favoriteQuizzes);
            
            request.getRequestDispatcher("/student/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Critical error in StudentHomeServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values in case of error
            request.setAttribute("subjects", new ArrayList<>());
            request.setAttribute("totalSubjects", 0);
            request.setAttribute("totalQuizzes", 0);
            request.setAttribute("completedQuizzes", 0);
            request.setAttribute("averageScore", 0);
            request.setAttribute("recentQuizResults", new ArrayList<>());
            request.setAttribute("favoriteQuizzes", new ArrayList<>());
            
            // Still forward to home page with error message
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/student/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 