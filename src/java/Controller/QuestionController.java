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
                showForm(request, response, null);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                showForm(request, response, questionDAO.getQuestionById(editId));
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
        if ("create".equals(action)) {
            insertQuestion(request, response);
        } else if ("update".equals(action)) {
            updateQuestion(request, response);
        } else if ("delete".equals(action)) {
            deleteQuestion(request, response);
        } else {
            response.sendRedirect("QuestionController?action=list");
        }
    }

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy lessonId để hiển thị danh sách câu hỏi
        String lessonIdStr = request.getParameter("lessonId");
        int lessonId = lessonIdStr != null && !lessonIdStr.isEmpty()
                ? Integer.parseInt(lessonIdStr) : 0;

        List<Question> questions = questionDAO.getQuestionsByLessonId(lessonId);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lesson> lessons   = lessonDAO.getAllLessons();

        Lesson lesson = lessonId > 0 ? lessonDAO.getLessonById(lessonId) : null;
        String lessonTitle = lesson != null ? lesson.getTitle() : "";

        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.setAttribute("lessonId", lessonId);
        request.setAttribute("lessonTitle", lessonTitle);

        request.getRequestDispatcher("questionList.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Question q)
            throws ServletException, IOException {
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

        Part filePart = request.getPart("image");
        byte[] imageData = filePart != null && filePart.getSize() > 0
                ? filePart.getInputStream().readAllBytes() : null;

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
        response.sendRedirect("QuestionController?action=list&lessonId=" + lessonId);
    }

    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id        = Integer.parseInt(request.getParameter("id"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        int lessonId  = Integer.parseInt(request.getParameter("lessonId"));
        String level  = request.getParameter("level");
        String content= request.getParameter("content");

        Part filePart = request.getPart("image");
        byte[] imageData = filePart != null && filePart.getSize() > 0
                ? filePart.getInputStream().readAllBytes() : null;

        Question q = new Question();
        q.setId(id);
        q.setSubjectId(subjectId);
        q.setLessonId(lessonId);
        q.setLevel(level);
        q.setContent(content);
        q.setUpdatedAt(new Timestamp(new Date().getTime()));
        if (imageData != null) q.setImage(imageData);

        questionDAO.updateQuestion(q);
        response.sendRedirect("QuestionController?action=list&lessonId=" + lessonId);
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        // Lấy lessonId trước khi xóa
        String lessonId = request.getParameter("lessonId");
        questionDAO.deleteQuestion(id);
        response.sendRedirect("QuestionController?action=list&lessonId=" + lessonId);
    }
}
