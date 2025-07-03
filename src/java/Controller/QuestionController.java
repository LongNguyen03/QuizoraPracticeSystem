package Controller;

import DAO.QuestionDAO;
import DAO.QuestionAnswerDAO;
import DAO.SubjectDAO;
import DAO.LessonDAO;
import Model.Question;
import Model.QuestionAnswer;
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
    private QuestionAnswerDAO answerDAO;
    private SubjectDAO subjectDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        questionDAO = new QuestionDAO();
        answerDAO   = new QuestionAnswerDAO();
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
                Question q = questionDAO.getQuestionById(editId);
                List<QuestionAnswer> answers = answerDAO.getByQuestion(editId);
                request.setAttribute("answers", answers);
                showForm(request, response, q);
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
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        List<Question> questions = questionDAO.getQuestionsByLessonId(lessonId);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lesson> lessons   = lessonDAO.getAllLessons();
        Lesson lesson = lessonDAO.getLessonById(lessonId);

        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.setAttribute("lessonId", lessonId);
        request.setAttribute("lessonTitle", lesson.getTitle());
        request.getRequestDispatcher("teacher/questionList.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Question q)
            throws ServletException, IOException {
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lesson> lessons   = lessonDAO.getAllLessons();

        request.setAttribute("question", q);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lessons", lessons);
        request.getRequestDispatcher("teacher/questionDetail.jsp").forward(request, response);
    }

    private void insertQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Question q = buildQuestionFromRequest(request, true);
        questionDAO.createQuestion(q);
        processAnswers(request, q.getId());
        response.sendRedirect("QuestionController?action=list&lessonId=" + q.getLessonId());
    }

    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Question q = buildQuestionFromRequest(request, false);
        questionDAO.updateQuestion(q);
        processAnswers(request, q.getId());
        response.sendRedirect("QuestionController?action=list&lessonId=" + q.getLessonId());
    }

    private Question buildQuestionFromRequest(HttpServletRequest request, boolean isNew) throws IOException, ServletException {
        Question q = new Question();
        if (!isNew) {
            q.setId(Integer.parseInt(request.getParameter("id")));
        }
        q.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
        q.setLessonId(Integer.parseInt(request.getParameter("lessonId")));
        q.setLevel(request.getParameter("level"));
        q.setContent(request.getParameter("content"));
        q.setStatus("Active");
        Timestamp now = new Timestamp(new Date().getTime());
        q.setUpdatedAt(now);
        if (isNew) q.setCreatedAt(now);
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            q.setImage(filePart.getInputStream().readAllBytes());
        }
        return q;
    }

    private void processAnswers(HttpServletRequest request, int questionId) {
        answerDAO.deleteByQuestion(questionId);
        String[] contents = request.getParameterValues("answerContent[]");
        String[] corrects = request.getParameterValues("answerIsCorrect[]");
        String[] orders   = request.getParameterValues("answerOrder[]");
        if (contents == null) return;
        for (int i = 0; i < contents.length; i++) {
            QuestionAnswer a = new QuestionAnswer();
            a.setQuestionId(questionId);
            a.setContent(contents[i]);
            a.setCorrect(corrects != null && i < corrects.length);
            a.setAnswerOrder(Integer.parseInt(orders[i]));
            answerDAO.insertAnswer(a);
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String lessonId = request.getParameter("lessonId");
        questionDAO.deleteQuestion(id);
        answerDAO.deleteByQuestion(id);
        response.sendRedirect("QuestionController?action=list&lessonId=" + lessonId);
    }
}
