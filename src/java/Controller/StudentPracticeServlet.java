package Controller;

import DAO.*;
import Model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import DAO.QuestionAnswerDAO;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "StudentPracticeServlet", urlPatterns = {"/student/practice", "/student/practice-history"})
public class StudentPracticeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String uri = request.getRequestURI();
        if (uri.endsWith("/practice-history")) {
            // Hiển thị lịch sử luyện tập
            PracticeSessionDAO sessionDao = new PracticeSessionDAO();
            List<PracticeSession> sessions = sessionDao.getPracticeSessionsByAccountId(accountId);
            request.setAttribute("practiceSessions", sessions);
            request.getRequestDispatcher("/student/practice-history.jsp").forward(request, response);
            return;
        }
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "start":
                    startPractice(request, response);
                    break;
                case "question":
                    showQuestion(request, response);
                    break;
                case "result":
                    showResult(request, response);
                    break;
                case "history":
                    showHistory(request, response);
                    break;
                default:
                    showPracticeList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/student/practice.jsp").forward(request, response);
        }
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
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "submit_answer":
                    submitAnswer(request, response);
                    break;
                case "finish":
                    finishPractice(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/student/practice");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/student/practice.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách practice options
     */
    private void showPracticeList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        // Lấy danh sách session
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        List<PracticeSession> sessions = sessionDao.getPracticeSessionsByAccountId(accountId);
        request.setAttribute("practiceSessions", sessions);
        int sessionCount = sessions.size();
        double avgScore = 0;
        if (sessionCount > 0) {
            double total = 0;
            for (PracticeSession ps : sessions) {
                if (ps.getTotalScore() != null) total += ps.getTotalScore();
            }
            avgScore = total / sessionCount;
        }
        request.setAttribute("practiceSessionCount", sessionCount);
        request.setAttribute("practiceAvgScore", avgScore);
        
        SubjectDAO subjectDao = new SubjectDAO();
        List<Subject> subjects = subjectDao.getAllSubjects();
        LessonDAO lessonDao = new LessonDAO();
        java.util.Map<Integer, java.util.List<Lesson>> subjectLessonsMap = new java.util.HashMap<>();
        for (Subject subject : subjects) {
            // Lấy các bài học active cho từng subject
            List<Lesson> lessons = lessonDao.getLessonsBySubjectAndStatus(subject.getId(), "Active");
            subjectLessonsMap.put(subject.getId(), lessons);
        }
        
        request.setAttribute("subjects", subjects);
        request.setAttribute("subjectLessonsMap", subjectLessonsMap);
        request.getRequestDispatcher("/student/practice.jsp").forward(request, response);
    }
    
    /**
     * Bắt đầu practice session
     */
    private void startPractice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String lessonIdStr = request.getParameter("lessonId");
        Integer lessonId = null;
        if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
            lessonId = Integer.parseInt(lessonIdStr);
        }
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        // Tạo practice session
        PracticeSession practiceSession = new PracticeSession();
        practiceSession.setAccountId(accountId);
        practiceSession.setSubjectId(subjectId);
        practiceSession.setLessonId(lessonId);
        practiceSession.setStartTime(new Timestamp(new Date().getTime()));
        practiceSession.setCompleted(false);
        
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        int sessionId = sessionDao.createPracticeSession(practiceSession);
        
        if (sessionId > 0) {
            // Lưu session ID vào session để sử dụng trong quá trình practice
            session.setAttribute("currentPracticeSessionId", sessionId);
            session.setAttribute("currentPracticeSubjectId", subjectId);
            session.setAttribute("currentPracticeLessonId", lessonId);
            
            // Chuyển đến câu hỏi đầu tiên
            response.sendRedirect(request.getContextPath() + "/student/practice?action=question&sessionId=" + sessionId);
        } else {
            request.setAttribute("error", "Không thể tạo practice session.");
            request.getRequestDispatcher("/student/practice.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị câu hỏi practice
     */
    private void showQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String sessionIdStr = request.getParameter("sessionId");
        int sessionId = Integer.parseInt(sessionIdStr);
        
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        PracticeSession session = sessionDao.getPracticeSessionById(sessionId);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/student/practice");
            return;
        }
        
        // Lấy câu hỏi cho practice
        QuestionDAO questionDao = new QuestionDAO();
        List<Question> questions;
        if (session.getLessonId() != null) {
            // Practice theo lesson cụ thể
            questions = questionDao.getPracticeQuestionsByLessonId(session.getLessonId());
        } else {
            // Practice theo subject
            questions = questionDao.getPracticeQuestionsBySubjectId(session.getSubjectId());
        }
        if (questions == null || questions.isEmpty()) {
            request.setAttribute("noPracticeQuestions", true);
            request.getRequestDispatcher("/student/practice.jsp").forward(request, response);
            return;
        }
        // Random thứ tự câu hỏi
        java.util.Collections.shuffle(questions);
        // Không lưu thứ tự câu hỏi vào DB nữa vì bảng PracticeSessionQuestions không tồn tại
        System.out.println("Randomized " + questions.size() + " questions for session " + sessionId);
        
        // Lấy đáp án cho mỗi câu hỏi và random đáp án
        QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
        for (Question question : questions) {
            List<QuestionAnswer> answers = answerDao.getAnswersByQuestionId(question.getId());
            java.util.Collections.shuffle(answers);
            question.setAnswers(answers);
        }
        
        request.setAttribute("practiceSession", session);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/student/take-practice.jsp").forward(request, response);
    }
    
    /**
     * Xử lý submit câu trả lời
     */
    private void submitAnswer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        int questionId = Integer.parseInt(request.getParameter("questionId"));
        String answerIdStr = request.getParameter("answerId");
        
        Integer answerId = null;
        if (answerIdStr != null && !answerIdStr.isEmpty()) {
            answerId = Integer.parseInt(answerIdStr);
        }
        
        // Kiểm tra đáp án đúng
        QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
        boolean isCorrect = false;
        
        if (answerId != null) {
            QuestionAnswer selectedAnswer = answerDao.getAnswerById(answerId);
            isCorrect = selectedAnswer != null && selectedAnswer.isCorrect();
        }
        
        // Lưu practice answer
        PracticeAnswer practiceAnswer = new PracticeAnswer();
        practiceAnswer.setPracticeSessionId(sessionId);
        practiceAnswer.setQuestionId(questionId);
        practiceAnswer.setAnswerId(answerId);
        practiceAnswer.setCorrect(isCorrect);
        
        PracticeAnswerDAO practiceAnswerDao = new PracticeAnswerDAO();
        practiceAnswerDao.savePracticeAnswer(practiceAnswer);
        
        // Trả về kết quả dạng JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String jsonResponse = String.format(
            "{\"correct\": %s, \"message\": \"%s\"}",
            isCorrect ? "true" : "false",
            isCorrect ? "Chính xác!" : "Sai rồi!"
        );
        
        response.getWriter().write(jsonResponse);
    }
    
    /**
     * Kết thúc practice session
     */
    private void finishPractice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== FINISH PRACTICE DEBUG ===");
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        System.out.println("Session ID: " + sessionId);
        
        String userAnswersStr = request.getParameter("userAnswers");
        System.out.println("User Answers String: " + userAnswersStr);
        
        if (userAnswersStr != null && !userAnswersStr.isEmpty()) {
            String[] pairs = userAnswersStr.split(",");
            System.out.println("Number of answer pairs: " + pairs.length);
            
            PracticeAnswerDAO practiceAnswerDao = new PracticeAnswerDAO();
            QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
            
            for (String pair : pairs) {
                System.out.println("Processing pair: " + pair);
                String[] qa = pair.split(":");
                if (qa.length == 2) {
                    try {
                        int questionId = Integer.parseInt(qa[0].trim());
                        int answerId = Integer.parseInt(qa[1].trim());
                        System.out.println("Question ID: " + questionId + ", Answer ID: " + answerId);
                        
                        boolean isCorrect = false;
                        QuestionAnswer selectedAnswer = answerDao.getAnswerById(answerId);
                        if (selectedAnswer != null && selectedAnswer.isCorrect()) {
                            isCorrect = true;
                        }
                        System.out.println("Is correct: " + isCorrect);
                        
                        PracticeAnswer practiceAnswer = new PracticeAnswer();
                        practiceAnswer.setPracticeSessionId(sessionId);
                        practiceAnswer.setQuestionId(questionId);
                        practiceAnswer.setAnswerId(answerId);
                        practiceAnswer.setCorrect(isCorrect);
                        practiceAnswerDao.savePracticeAnswer(practiceAnswer);
                        System.out.println("Saved practice answer for question " + questionId);
                    } catch (NumberFormatException e) {
                        System.out.println("Error parsing pair: " + pair + " - " + e.getMessage());
                        System.out.println("qa[0] = '" + qa[0] + "', qa[1] = '" + qa[1] + "'");
                    }
                } else {
                    System.out.println("Invalid pair format: " + pair);
                }
            }
        } else {
            System.out.println("No user answers provided or empty string");
        }
        
        // Cập nhật practice session
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        PracticeSession session = sessionDao.getPracticeSessionById(sessionId);
        System.out.println("Found session: " + (session != null ? "yes" : "no"));
        
        if (session != null) {
            session.setEndTime(new Timestamp(new Date().getTime()));
            session.setCompleted(true);
            
            // Tính điểm
            PracticeAnswerDAO answerDao = new PracticeAnswerDAO();
            PracticeAnswerDAO.PracticeAnswerStats stats = answerDao.getPracticeAnswerStats(sessionId);
            System.out.println("Stats: " + (stats != null ? "total=" + stats.getTotalQuestions() + ", correct=" + stats.getCorrectAnswers() : "null"));
            
            if (stats != null) {
                session.setTotalScore(stats.getScorePercentage());
                System.out.println("Score percentage: " + stats.getScorePercentage());
            }
            
            boolean updated = sessionDao.updatePracticeSession(session);
            System.out.println("Session updated: " + updated);
            
            // Xóa session data
            HttpSession httpSession = request.getSession();
            httpSession.removeAttribute("currentPracticeSessionId");
            httpSession.removeAttribute("currentPracticeSubjectId");
            httpSession.removeAttribute("currentPracticeLessonId");
            
            // Chuyển đến trang kết quả
            System.out.println("Redirecting to result page with sessionId: " + sessionId);
            response.sendRedirect(request.getContextPath() + "/student/practice?action=result&sessionId=" + sessionId);
        } else {
            System.out.println("Session not found, redirecting to practice list");
            response.sendRedirect(request.getContextPath() + "/student/practice");
        }
    }
    
    /**
     * Hiển thị kết quả practice
     */
    private void showResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== SHOW RESULT DEBUG ===");
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        System.out.println("Session ID: " + sessionId);
        
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        PracticeAnswerDAO answerDao = new PracticeAnswerDAO();
        QuestionAnswerDAO questionAnswerDAO = new QuestionAnswerDAO();
        
        PracticeSession session = sessionDao.getPracticeSessionById(sessionId);
        System.out.println("Found session: " + (session != null ? "yes" : "no"));
        
        List<PracticeAnswer> answers = answerDao.getPracticeAnswersBySessionId(sessionId);
        System.out.println("Found " + answers.size() + " practice answers");
        
        PracticeAnswerDAO.PracticeAnswerStats stats = answerDao.getPracticeAnswerStats(sessionId);
        System.out.println("Stats: " + (stats != null ? "total=" + stats.getTotalQuestions() + ", correct=" + stats.getCorrectAnswers() : "null"));

        // Lấy danh sách câu hỏi từ practice answers để hiển thị
        List<Question> questions = new java.util.ArrayList<>();
        QuestionDAO questionDao = new QuestionDAO();
        
        // Lấy danh sách questionId từ practice answers
        java.util.Set<Integer> questionIds = new java.util.HashSet<>();
        for (PracticeAnswer answer : answers) {
            questionIds.add(answer.getQuestionId());
        }
        
        // Lấy thông tin câu hỏi
        for (Integer questionId : questionIds) {
            Question q = questionDao.getQuestionById(questionId);
            if (q != null) {
                // Lấy đáp án và random như trong practice
                List<QuestionAnswer> qAnswers = questionAnswerDAO.getAnswersByQuestionId(q.getId());
                java.util.Collections.shuffle(qAnswers);
                q.setAnswers(qAnswers);
                questions.add(q);
            }
        }
        System.out.println("Loaded " + questions.size() + " questions from practice answers");

        // Format scorePercentage ở phía Java
        String scorePercentageFormatted = "0.0";
        if (stats != null) {
            java.text.DecimalFormat df = new java.text.DecimalFormat("#,##0.0");
            scorePercentageFormatted = df.format(stats.getScorePercentage());
        }
        System.out.println("Score percentage formatted: " + scorePercentageFormatted);
        
        request.setAttribute("practiceSession", session);
        request.setAttribute("practiceAnswers", answers);
        request.setAttribute("stats", stats);
        request.setAttribute("scorePercentageFormatted", scorePercentageFormatted);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/student/practice-result.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị lịch sử practice
     */
    private void showHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        List<PracticeSession> sessions = sessionDao.getPracticeSessionsByAccountId(accountId);
        
        request.setAttribute("practiceSessions", sessions);
        request.getRequestDispatcher("/student/practice-history.jsp").forward(request, response);
    }
} 