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
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = lessonDAO.getAllLessons(); // hoặc getLessonsByTeacherId nếu cần
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
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = lessonDAO.getAllLessons();
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
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = lessonDAO.getAllLessons();
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
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String level = request.getParameter("level");
        int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        double passRate = Double.parseDouble(request.getParameter("passRate"));
        String type = request.getParameter("type");

        // 1. Lấy danh sách câu hỏi của lesson
        QuestionDAO questionDAO = new QuestionDAO();
        List<Question> allQuestions = questionDAO.getQuestionsByLessonId(lessonId);

        // 2. Random chọn số lượng câu hỏi
        Collections.shuffle(allQuestions);
        List<Question> selectedQuestions = allQuestions.subList(0, Math.min(numberOfQuestions, allQuestions.size()));

        // 3. Tạo quiz mới, chỉ lưu subjectId (lấy từ lessonId)
        // TODO: Lấy ownerId thực tế từ session, tạm thời để 0
        int ownerId = 0;
        boolean isPracticeable = true; // hoặc lấy từ request nếu có
        quizDAO.insertQuizWithLesson(lessonId, name, level, selectedQuestions.size(), durationMinutes, passRate, type, ownerId, isPracticeable);

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
        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String level = request.getParameter("level");
        int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        double passRate = Double.parseDouble(request.getParameter("passRate"));
        String type = request.getParameter("type");

        // Lấy subjectId từ lessonId
        int subjectId = quizDAO.getSubjectIdByLessonId(lessonId);

        int ownerId = 0; // TODO: Lấy ownerId thực tế từ session
        boolean isPracticeable = true; // hoặc lấy từ request nếu có
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
