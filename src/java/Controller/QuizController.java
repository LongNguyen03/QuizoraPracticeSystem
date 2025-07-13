package Controller;

import DAO.QuizDAO;
import Model.Quiz;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "QuizController", urlPatterns = {"/quiz"})
public class QuizController extends HttpServlet {

    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            // Không có action => load list
            listQuizzes(request, response);
        } else {
            switch (action) {
                case "new":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteQuiz(request, response);
                    break;
                default:
                    listQuizzes(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            insertQuiz(request, response);
        } else if ("update".equals(action)) {
            updateQuiz(request, response);
        } else {
            response.sendRedirect("quiz");
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/quiz_form.jsp");
        dispatcher.forward(request, response);
    }

    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("quizList", quizDAO.getAllAvailableQuizzes());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/quiz_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Quiz existingQuiz = quizDAO.getQuizById(id);
        request.setAttribute("quiz", existingQuiz);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/quiz_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertQuiz(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String level = request.getParameter("level");
        int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        double passRate = Double.parseDouble(request.getParameter("passRate"));
        String type = request.getParameter("type");

        Quiz newQuiz = new Quiz(0, name, subjectId, level, numberOfQuestions, durationMinutes, passRate, type, null, null);
        quizDAO.insertQuiz(newQuiz);

        response.sendRedirect("quiz");
    }

    private void updateQuiz(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String level = request.getParameter("level");
        int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        double passRate = Double.parseDouble(request.getParameter("passRate"));
        String type = request.getParameter("type");

        Quiz quiz = new Quiz(id, name, subjectId, level, numberOfQuestions, durationMinutes, passRate, type, null, new java.util.Date());
        quizDAO.updateQuiz(quiz);

        response.sendRedirect("quiz");
    }

    private void deleteQuiz(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        quizDAO.deleteQuiz(id);

        response.sendRedirect("quiz");
    }
}
