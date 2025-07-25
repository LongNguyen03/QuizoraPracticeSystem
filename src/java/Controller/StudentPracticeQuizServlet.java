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
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/student/practice-quiz")
public class StudentPracticeQuizServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String quizIdStr = request.getParameter("quizId");
        if (quizIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }
        int quizId = Integer.parseInt(quizIdStr);
        QuizDAO quizDao = new QuizDAO();
        QuestionDAO questionDao = new QuestionDAO();
        QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
        Quiz quiz = quizDao.getQuizById(quizId);
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
        String quizIdStr = request.getParameter("quizId");
        if (quizIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
            return;
        }
        int quizId = Integer.parseInt(quizIdStr);
        QuizDAO quizDao = new QuizDAO();
        QuestionDAO questionDao = new QuestionDAO();
        QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
        Quiz quiz = quizDao.getQuizById(quizId);
        List<Question> questions = questionDao.getQuestionsByQuizId(quizId);
        int score = 0;
        for (Question q : questions) {
            String answerIdStr = request.getParameter("answer_" + q.getId());
            if (answerIdStr != null) {
                int answerId = Integer.parseInt(answerIdStr);
                QuestionAnswer ans = answerDao.getAnswerById(answerId);
                if (ans != null && ans.isCorrect()) {
                    score++;
                }
            }
            List<QuestionAnswer> answers = answerDao.getAnswersByQuestionId(q.getId());
            q.setAnswers(answers);
        }
        request.setAttribute("quiz", quiz);
        request.setAttribute("questions", questions);
        request.setAttribute("score", score);
        request.getRequestDispatcher("/student/practice-quiz.jsp").forward(request, response);
    }
} 