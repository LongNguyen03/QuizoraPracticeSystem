package Controller;

import DAO.QuizDAO;
import Model.Quiz;
import DAO.LessonDAO;
import Model.Lesson;
import DAO.QuestionDAO;
import DAO.QuizQuestionDAO;
import Model.Question;
import DAO.QuestionAnswerDAO;
import Model.QuestionAnswer;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import DAO.SubjectDAO;
import Model.Subject;
import java.util.ArrayList;

@WebServlet(name = "QuizController", urlPatterns = { "/quiz" })
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
        HttpSession session = request.getSession(false);
        int teacherId = -1;
        if (session != null && session.getAttribute("accountId") != null) {
            teacherId = (int) session.getAttribute("accountId");
        }
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = teacherId > 0 ? lessonDAO.getLessonsByOwnerId(teacherId) : lessonDAO.getAllLessons();
        request.setAttribute("lessons", lessons);
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
        HttpSession session = request.getSession(false);
        int teacherId = -1;
        if (session != null && session.getAttribute("accountId") != null) {
            teacherId = (int) session.getAttribute("accountId");
        }
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = teacherId > 0 ? lessonDAO.getLessonsByOwnerId(teacherId) : lessonDAO.getAllLessons();
        request.setAttribute("lessons", lessons);
        SubjectDAO subjectDAO = new SubjectDAO();
        List<Subject> subjects = subjectDAO.getAllSubjects();
        request.setAttribute("subjects", subjects);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/quiz_form.jsp");
        dispatcher.forward(request, response);
    }

    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountId") == null ||
            session.getAttribute("role") == null ||
            !"Teacher".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int teacherId = (int) session.getAttribute("accountId");
        request.setAttribute("quizList", quizDAO.getQuizzesByOwnerId(teacherId));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/quiz_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Quiz existingQuiz = quizDAO.getQuizById(id);

        // Lấy lessonId từ 1 câu hỏi bất kỳ của quiz
        QuestionDAO questionDAO = new QuestionDAO();
        List<Question> quizQuestions = questionDAO.getQuestionsByQuizId(id);
        int lessonId = -1;
        if (!quizQuestions.isEmpty()) {
            lessonId = quizQuestions.get(0).getLessonId();
        }
        request.setAttribute("quiz", existingQuiz);
        request.setAttribute("lessonId", lessonId);

        // Truyền danh sách lessons như khi tạo mới
        HttpSession session = request.getSession(false);
        int teacherId = -1;
        if (session != null && session.getAttribute("accountId") != null) {
            teacherId = (int) session.getAttribute("accountId");
        }
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = teacherId > 0 ? lessonDAO.getLessonsByOwnerId(teacherId) : lessonDAO.getAllLessons();
        request.setAttribute("lessons", lessons);

        // Lấy danh sách câu hỏi của quiz (đã có).
        // Lấy danh sách đáp án cho từng câu hỏi.
        Map<Integer, List<QuestionAnswer>> answersMap = new HashMap<>();
        QuestionAnswerDAO qaDAO = new QuestionAnswerDAO();
        for (Question q : quizQuestions) {
            List<QuestionAnswer> answers = qaDAO.getAnswersByQuestionId(q.getId());
            answersMap.put(q.getId(), answers);
        }
        request.setAttribute("quizQuestions", quizQuestions);
        request.setAttribute("answersMap", answersMap);

        // Lấy lessonIds cho quiz để truyền sang form (phục vụ update)
        QuizQuestionDAO quizQuestionDAO = new QuizQuestionDAO();
        List<Integer> lessonIds = quizQuestionDAO.getLessonIdsByQuizId(id);
        request.setAttribute("lessonIds", lessonIds);

        SubjectDAO subjectDAO = new SubjectDAO();
        List<Subject> subjects = subjectDAO.getAllSubjects();
        request.setAttribute("subjects", subjects);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/quiz_form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        if (quizDAO.isQuizNameExists(name)) {
            request.setAttribute("error", "Tên quiz đã tồn tại, vui lòng chọn tên khác!");
            showCreateForm(request, response);
            return;
        }
        String[] lessonIdsArr = request.getParameterValues("lessonIds");
        List<String> lessonIdList = new ArrayList<>();
        if (lessonIdsArr != null && lessonIdsArr.length > 0) {
            // Nếu chỉ có 1 phần tử và có dấu phẩy, tách ra
            if (lessonIdsArr.length == 1 && lessonIdsArr[0].contains(",")) {
                String[] split = lessonIdsArr[0].split(",");
                for (String s : split) {
                    if (!s.trim().isEmpty()) lessonIdList.add(s.trim());
                }
            } else {
                for (String s : lessonIdsArr) {
                    if (!s.trim().isEmpty()) lessonIdList.add(s.trim());
                }
            }
        }
        if (lessonIdList.isEmpty()) {
            request.setAttribute("error", "Bạn phải chọn ít nhất 1 bài học!");
            showCreateForm(request, response);
            return;
        }
        LessonDAO lessonDAO = new LessonDAO();
        int firstLessonId = Integer.parseInt(lessonIdList.get(0));
        int subjectId = lessonDAO.getLessonById(firstLessonId).getSubjectId();
        // Kiểm tra tất cả lesson phải cùng subject
        for (String lessonIdStr : lessonIdList) {
            int lessonId = Integer.parseInt(lessonIdStr);
            if (lessonDAO.getLessonById(lessonId).getSubjectId() != subjectId) {
                request.setAttribute("error", "Tất cả bài học phải thuộc cùng một môn học!");
                showCreateForm(request, response);
                return;
            }
        }
        String level = request.getParameter("level");
        int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        double passRate = Double.parseDouble(request.getParameter("passRate"));
        String type = request.getParameter("type");
        boolean isPracticeable = request.getParameter("isPracticeable") != null;

        // 1. Lấy danh sách câu hỏi của lesson
        QuestionDAO questionDAO = new QuestionDAO();
        List<Question> allQuestions = new ArrayList<>();
        for (String lessonIdStr : lessonIdList) {
            int lessonId = Integer.parseInt(lessonIdStr);
            allQuestions.addAll(questionDAO.getQuestionsByLessonId(lessonId));
        }
        if (allQuestions.size() < numberOfQuestions) {
            request.setAttribute("error", "Tổng số câu hỏi của các bài học không đủ để tạo quiz này!");
            showCreateForm(request, response);
            return;
        }
        // 2. Random chọn số lượng câu hỏi
        Collections.shuffle(allQuestions);
        List<Question> selectedQuestions = allQuestions.subList(0, numberOfQuestions);

        // 3. Tạo quiz mới
        HttpSession session = request.getSession(false);
        int ownerId = (session != null && session.getAttribute("accountId") != null)
            ? (int) session.getAttribute("accountId") : 0;
        Quiz quiz = new Quiz(0, name, subjectId, ownerId, level, numberOfQuestions, durationMinutes, passRate, type, isPracticeable, null, new java.util.Date());
        quizDAO.insertQuiz(quiz);

        // 4. Lấy id quiz vừa tạo
        int quizId = quizDAO.getLatestQuizId();
        QuizQuestionDAO quizQuestionDAO = new QuizQuestionDAO();
        int order = 1;
        for (Question q : selectedQuestions) {
            quizQuestionDAO.addQuestionToQuiz(quizId, q.getId(), order++);
        }

        response.sendRedirect("quiz");
    }

    private void updateQuiz(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        if (quizDAO.isQuizNameExists(name) && !name.equals(quizDAO.getQuizById(id).getName())) {
            request.setAttribute("error", "Tên quiz đã tồn tại, vui lòng chọn tên khác!");
            showEditForm(request, response);
            return;
        }
        // Parse lessonIds like in insertQuiz
        String[] lessonIdsArr = request.getParameterValues("lessonIds");
        List<String> lessonIdList = new ArrayList<>();
        if (lessonIdsArr != null && lessonIdsArr.length > 0) {
            if (lessonIdsArr.length == 1 && lessonIdsArr[0].contains(",")) {
                String[] split = lessonIdsArr[0].split(",");
                for (String s : split) {
                    if (!s.trim().isEmpty()) lessonIdList.add(s.trim());
                }
            } else {
                for (String s : lessonIdsArr) {
                    if (!s.trim().isEmpty()) lessonIdList.add(s.trim());
                }
            }
        }
        if (lessonIdList.isEmpty()) {
            request.setAttribute("error", "Bạn phải chọn ít nhất 1 bài học!");
            showEditForm(request, response);
            return;
        }
        LessonDAO lessonDAO = new LessonDAO();
        int firstLessonId = Integer.parseInt(lessonIdList.get(0));
        int subjectId = lessonDAO.getLessonById(firstLessonId).getSubjectId();
        String level = request.getParameter("level");
        int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        double passRate = Double.parseDouble(request.getParameter("passRate"));
        String type = request.getParameter("type");
        boolean isPracticeable = request.getParameter("isPracticeable") != null;

        HttpSession session = request.getSession(false);
        int ownerId = (session != null && session.getAttribute("accountId") != null)
            ? (int) session.getAttribute("accountId") : 0;
        Quiz quiz = new Quiz(id, name, subjectId, ownerId, level, numberOfQuestions, durationMinutes, passRate, type, isPracticeable, null, new java.util.Date());
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
