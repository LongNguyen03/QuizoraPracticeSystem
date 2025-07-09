package Controller;

import DAO.QuizResultDAO;
import DAO.QuizDAO;
import DAO.QuizUserAnswerDAO;
import Model.QuizResult;
import Model.Quiz;
import Model.QuizUserAnswer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class StudentQuizResultServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resultIdStr = request.getParameter("resultId");
        System.out.println("QuizResultServlet: Received resultId = " + resultIdStr);
        
        if (resultIdStr == null) {
            System.out.println("QuizResultServlet: No resultId provided, redirecting to home");
            response.sendRedirect(request.getContextPath() + "/student/home");
            return;
        }
        try {
            int resultId = Integer.parseInt(resultIdStr);
            System.out.println("QuizResultServlet: Parsed resultId = " + resultId);
            
            QuizResultDAO resultDao = new QuizResultDAO();
            QuizDAO quizDao = new QuizDAO();
            QuizUserAnswerDAO userAnswerDao = new QuizUserAnswerDAO();

            QuizResult quizResult = resultDao.getQuizResultById(resultId);
            System.out.println("QuizResultServlet: Found quizResult = " + (quizResult != null ? "yes" : "no"));
            
            if (quizResult == null) {
                System.out.println("QuizResultServlet: QuizResult not found, redirecting to home");
                response.sendRedirect(request.getContextPath() + "/student/home");
                return;
            }
            
            Quiz quiz = quizDao.getQuizById(quizResult.getQuizId());
            System.out.println("QuizResultServlet: Found quiz = " + (quiz != null ? quiz.getName() : "null"));
            
            List<QuizUserAnswer> userAnswers = userAnswerDao.getUserAnswersWithDetails(resultId);
            System.out.println("QuizResultServlet: Found " + userAnswers.size() + " user answers");

            request.setAttribute("quizResult", quizResult);
            request.setAttribute("quiz", quiz);
            request.setAttribute("userAnswers", userAnswers);
            request.getRequestDispatcher("/student/quiz-result.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("QuizResultServlet: Exception occurred: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/home");
        }
    }
} 