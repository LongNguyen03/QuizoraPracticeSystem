/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.QuestionAnswerDAO;
import DAO.QuestionDAO;
import DAO.SubjectDAO;
import DAO.LessonDAO;
import DAO.SubjectDimensionDAO;
import Model.Question;
import Model.QuestionAnswer;
import Model.Subject;
import Model.Lesson;
import Model.SubjectDimension;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;


@WebServlet(name = "QuestionController", urlPatterns = {"/QuestionController"})
public class QuestionController extends HttpServlet {

    private QuestionDAO questionDAO = new QuestionDAO();
    private QuestionAnswerDAO answerDAO = new QuestionAnswerDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();
    private LessonDAO lessonDAO = new LessonDAO();
    private SubjectDimensionDAO dimensionDAO = new SubjectDimensionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listQuestions(request, response);
        }

        switch (action) {
            case "create":
                prepareFormData(request);
                request.getRequestDispatcher("questionDetail.jsp").forward(request, response);
                break;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Question q = questionDAO.getQuestionById(editId);
                List<QuestionAnswer> answers = answerDAO.getAnswersByQuestionId(editId);
                q.setAnswerOptions(answers);

                prepareFormData(request);
                request.setAttribute("question", q);
                request.getRequestDispatcher("questionDetail.jsp").forward(request, response);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                questionDAO.deleteQuestion(deleteId);
                response.sendRedirect("QuestionController");
                break;

            default: // list
                List<Question> list = questionDAO.getActiveQuestions();
                request.setAttribute("questions", list);
                request.getRequestDispatcher("questionList.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        boolean isEdit = (idStr != null && !idStr.isEmpty());
        int id = isEdit ? Integer.parseInt(idStr) : 0;

        Question q = new Question();
        q.setId(id);
        q.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
        q.setLessonId(Integer.parseInt(request.getParameter("lessonId")));
        q.setDimensionId(Integer.parseInt(request.getParameter("dimensionId")));
        q.setLevel(request.getParameter("level"));
        q.setContent(request.getParameter("content"));
        q.setImageUrl(request.getParameter("imageUrl"));
        q.setStatus(request.getParameter("status"));
        Timestamp now = new Timestamp(System.currentTimeMillis());

        if (isEdit) {
            q.setUpdatedAt(now);
            questionDAO.updateQuestion(q);
        } else {
            q.setCreatedAt(now);
            q.setUpdatedAt(now);
            questionDAO.createQuestion(q);
        }

        // Xử lý answer options
        String[] contents = request.getParameterValues("answerContent");
        String[] corrects = request.getParameterValues("answerIsCorrect");

        List<QuestionAnswer> answers = new ArrayList<>();
        if (contents != null) {
            for (int i = 0; i < contents.length; i++) {
                QuestionAnswer ans = new QuestionAnswer();
                ans.setQuestionId(q.getId());
                ans.setContent(contents[i]);
                ans.setCorrect(corrects != null && i < corrects.length && "on".equalsIgnoreCase(corrects[i]));
                ans.setAnswerOrder(i + 1);
                answers.add(ans);
            }
        }
        answerDAO.saveQuestionAnswers(q.getId(), answers);

        response.sendRedirect("QuestionController");
    }

    private void prepareFormData(HttpServletRequest request) {
        List<Subject> subjects = subjectDAO.getAll();
        List<Lesson> lessons = lessonDAO.getAll();
        List<SubjectDimension> dimensions = dimensionDAO.getAll();

        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.setAttribute("dimensions", dimensions);
    }
    
    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filters from request (if any)
        String subjectIdStr = request.getParameter("subjectId");
        String lessonIdStr = request.getParameter("lessonId");
        String dimensionIdStr = request.getParameter("dimensionId");
        String level = request.getParameter("level");
        String status = request.getParameter("status");
        String search = request.getParameter("search");

        // Get data
        QuestionDAO questionDAO = new QuestionDAO();
        SubjectDAO subjectDAO = new SubjectDAO();
        LessonDAO lessonDAO = new LessonDAO();
        SubjectDimensionDAO dimensionDAO = new SubjectDimensionDAO();

        List<Question> questions = questionDAO.getFilteredQuestions(subjectIdStr, lessonIdStr, dimensionIdStr, level, status, search);

        List<Subject> subjects = subjectDAO.getAll();
        List<Lesson> lessons = lessonDAO.getAll();
        List<SubjectDimension> dimensions = dimensionDAO.getAll();

        // Set attributes
        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.setAttribute("dimensions", dimensions);

        request.getRequestDispatcher("questionList.jsp").forward(request, response);
    }
    
}

