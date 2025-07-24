package Controller;

import DAO.QuizDAO;
import DAO.QuestionDAO;
import DAO.QuestionAnswerDAO;
import Model.Quiz;
import Model.Question;
import Model.QuestionAnswer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "StudentPracticeQuizServlet", urlPatterns = {"/student/practice-quiz"})
public class StudentPracticeQuizServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String quizIdStr = request.getParameter("quizId");
        if (quizIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }
        int quizId = Integer.parseInt(quizIdStr);
        QuizDAO quizDao = new QuizDAO();
        Quiz quiz = quizDao.getQuizById(quizId);
        if (quiz == null || !quiz.isPracticeable()) {
            request.setAttribute("error", "Quiz is not available for practice.");
            request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
            return;
        }
        QuestionDAO questionDao = new QuestionDAO();
        QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
        List<Question> questions = questionDao.getQuestionsByQuizId(quizId);
        for (Question q : questions) {
            List<QuestionAnswer> answers = answerDao.getAnswersByQuestionId(q.getId());
            q.setAnswers(answers);
        }
        request.setAttribute("quiz", quiz);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/student/practice-quiz.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String quizIdStr = request.getParameter("quizId");
        if (quizIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }
        int quizId = Integer.parseInt(quizIdStr);
        QuizDAO quizDao = new QuizDAO();
        Quiz quiz = quizDao.getQuizById(quizId);
        if (quiz == null || !quiz.isPracticeable()) {
            request.setAttribute("error", "Quiz is not available for practice.");
            request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
            return;
        }
        QuestionDAO questionDao = new QuestionDAO();
        QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
        List<Question> questions = questionDao.getQuestionsByQuizId(quizId);
        int correct = 0;
        for (Question q : questions) {
            String ansIdStr = request.getParameter("answer_" + q.getId());
            if (ansIdStr != null) {
                int ansId = Integer.parseInt(ansIdStr);
                QuestionAnswer ans = answerDao.getAnswerById(ansId);
                if (ans != null && ans.isCorrect()) {
                    correct++;
                }
            }
            List<QuestionAnswer> answers = answerDao.getAnswersByQuestionId(q.getId());
            q.setAnswers(answers);
        }
        request.setAttribute("quiz", quiz);
        request.setAttribute("questions", questions);
        request.setAttribute("score", correct);
        request.getRequestDispatcher("/student/practice-quiz.jsp").forward(request, response);
    }
} 