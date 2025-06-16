package Controller;

import DAO.QuestionDAO;
import DAO.SubjectDAO;
import DAO.LessonDAO;
import Model.Question;
import Model.Subject;
import Model.Lesson;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

@WebServlet("/QuestionController")
@MultipartConfig(maxFileSize = 16177215)
public class QuestionController extends HttpServlet {
    private QuestionDAO questionDAO;
    private SubjectDAO subjectDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        questionDAO = new QuestionDAO();
        subjectDAO  = new SubjectDAO();
        lessonDAO   = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            default:
                listQuestions(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                insertQuestion(request, response);
                break;
            case "update":
                updateQuestion(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            default:
                response.sendRedirect("QuestionController?action=list");
                break;
        }
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lọc tham số
        String subjectId  = request.getParameter("subjectId");
        String lessonId   = request.getParameter("lessonId");
        String dimension  = request.getParameter("dimension");
        String level      = request.getParameter("level");
        String search     = request.getParameter("search");

        List<Question> questions = questionDAO.getFilteredQuestions(
                subjectId, lessonId, dimension, level, search);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lesson> lessons   = lessonDAO.getAllLessons();

        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.getRequestDispatcher("questionList.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lesson> lessons   = lessonDAO.getAllLessons();

        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.getRequestDispatcher("questionDetail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Question q = questionDAO.getQuestionById(id);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lesson> lessons   = lessonDAO.getAllLessons();

        request.setAttribute("question", q);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.getRequestDispatcher("questionDetail.jsp").forward(request, response);
    }

    private void insertQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        int lessonId  = Integer.parseInt(request.getParameter("lessonId"));
        String level  = request.getParameter("level");
        String content = request.getParameter("content");

        // Xử lý upload ảnh
        byte[] imageData = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            imageData = filePart.getInputStream().readAllBytes();
        }

        Question q = new Question();
        q.setSubjectId(subjectId);
        q.setLessonId(lessonId);
        q.setLevel(level);
        q.setContent(content);
        q.setStatus("Active");
        q.setCreatedAt(new Timestamp(new Date().getTime()));
        q.setUpdatedAt(new Timestamp(new Date().getTime()));
        q.setImage(imageData);

        questionDAO.createQuestion(q);
        response.sendRedirect("QuestionController?action=list");
    }

    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id        = Integer.parseInt(request.getParameter("id"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        int lessonId  = Integer.parseInt(request.getParameter("lessonId"));
        String level  = request.getParameter("level");
        String content= request.getParameter("content");

        byte[] imageData = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            imageData = filePart.getInputStream().readAllBytes();
        }

        Question q = new Question();
        q.setId(id);
        q.setSubjectId(subjectId);
        q.setLessonId(lessonId);
        q.setLevel(level);
        q.setContent(content);
        q.setUpdatedAt(new Timestamp(new Date().getTime()));
        if (imageData != null) q.setImage(imageData);

        questionDAO.updateQuestion(q);
        response.sendRedirect("QuestionController?action=list");
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        questionDAO.deleteQuestion(id);
        response.sendRedirect("QuestionController?action=list");
    }
}
