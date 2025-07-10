package Controller;

import DAO.FavoriteQuizDAO;
import DAO.QuizDAO;
import DAO.SubjectDAO;
import Model.FavoriteQuiz;
import Model.Quiz;
import Model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "StudentFavoriteQuizzesServlet", urlPatterns = {"/student/favorite-quizzes"})
public class StudentFavoriteQuizzesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            FavoriteQuizDAO favoriteDao = new FavoriteQuizDAO();
            QuizDAO quizDao = new QuizDAO();
            SubjectDAO subjectDao = new SubjectDAO();
            List<FavoriteQuiz> favoriteQuizzes = favoriteDao.getFavoriteQuizzesByAccountId(accountId);
            List<Quiz> quizzes = new ArrayList<>();
            for (FavoriteQuiz fav : favoriteQuizzes) {
                Quiz quiz = quizDao.getQuizById(fav.getQuizId());
                if (quiz != null) {
                    quiz.setFavorite(true);
                    Subject subject = subjectDao.getSubjectById(quiz.getSubjectId());
                    quiz.setSubjectTitle(subject != null ? subject.getTitle() : "Unknown Subject");
                    quizzes.add(quiz);
                }
            }
            request.setAttribute("quizzes", quizzes);
            request.getRequestDispatcher("/student/favorite_quizzes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading favorite quizzes.");
            request.getRequestDispatcher("/student/favorite_quizzes.jsp").forward(request, response);
        }
    }
} 