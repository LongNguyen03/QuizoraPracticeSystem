package controller;

import DAO.QuizDAO;
import Model.Quiz;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class QuizController extends HttpServlet {

    private QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subjectIdStr = request.getParameter("subjectId");
        if (subjectIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "subjectId required");
            return;
        }

        int subjectId;
        try {
            subjectId = Integer.parseInt(subjectIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "subjectId invalid");
            return;
        }

        List<Quiz> quizzes = quizDAO.getQuizzesBySubjectId(subjectId);
        request.setAttribute("quizzes", quizzes);
        request.getRequestDispatcher("/views/quizList.jsp").forward(request, response);
    }
}
