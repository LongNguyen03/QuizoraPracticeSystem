package Controller;

import DAO.QuizDAO;
import DAO.QuestionDAO;
import DAO.QuestionAnswerDAO;
import DAO.QuizResultDAO;
import DAO.QuizUserAnswerDAO;
import Model.Quiz;
import Model.Question;
import Model.QuestionAnswer;
import Model.QuizResult;
import Model.QuizUserAnswer;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Date;

public class StudentTakeQuizServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String quizIdStr = request.getParameter("quizId");
            if (quizIdStr == null || quizIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/student/quizzes");
                return;
            }
            
            int quizId = Integer.parseInt(quizIdStr);
            QuizDAO quizDao = new QuizDAO();
            QuestionDAO questionDao = new QuestionDAO();
            QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
            
            // Get quiz details
            Quiz quiz = quizDao.getQuizById(quizId);
            if (quiz == null) {
                request.setAttribute("error", "Quiz not found.");
                request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
                return;
            }
            
            // Get questions for this quiz
            List<Question> questions = questionDao.getQuestionsByQuizId(quizId);
            if (questions.isEmpty()) {
                request.setAttribute("error", "No questions found for this quiz.");
                request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
                return;
            }
            
            // Get answers for each question
            for (Question question : questions) {
                List<QuestionAnswer> answers = answerDao.getAnswersByQuestionId(question.getId());
                question.setAnswers(answers);
            }
            
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.getRequestDispatcher("/student/take-quiz.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the quiz.");
            request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
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
        
        try {
            String quizIdStr = request.getParameter("quizId");
            if (quizIdStr == null || quizIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/student/quizzes");
                return;
            }
            
            int quizId = Integer.parseInt(quizIdStr);
            QuizDAO quizDao = new QuizDAO();
            QuizResultDAO resultDao = new QuizResultDAO();
            QuizUserAnswerDAO userAnswerDao = new QuizUserAnswerDAO();
            QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
            
            // Get quiz details
            Quiz quiz = quizDao.getQuizById(quizId);
            if (quiz == null) {
                request.setAttribute("error", "Quiz not found.");
                request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
                return;
            }
            
            // Calculate score
            int totalQuestions = quiz.getNumberOfQuestions();
            int correctAnswers = 0;
            
            // Create quiz result
            QuizResult result = new QuizResult();
            result.setQuizId(quizId);
            result.setAccountId(accountId);
            result.setAttemptDate(new Date());
            
            // Process each question
            for (int i = 1; i <= totalQuestions; i++) {
                String answerIdStr = request.getParameter("answer_" + i);
                String questionIdStr = request.getParameter("question_" + i);
                
                if (answerIdStr != null && questionIdStr != null) {
                    int questionId = Integer.parseInt(questionIdStr);
                    int answerId = Integer.parseInt(answerIdStr);
                    
                    // Check if answer is correct
                    QuestionAnswer selectedAnswer = answerDao.getAnswerById(answerId);
                    boolean isCorrect = selectedAnswer != null && selectedAnswer.isCorrect();
                    
                    if (isCorrect) {
                        correctAnswers++;
                    }
                    
                    // Save user answer
                    QuizUserAnswer userAnswer = new QuizUserAnswer();
                    userAnswer.setQuestionId(questionId);
                    userAnswer.setAnswerId(answerId);
                    userAnswer.setCorrect(isCorrect);
                    userAnswer.setQuizResultId(result.getId()); // Will be set after result is saved
                    
                    // Save to database
                    userAnswerDao.saveUserAnswer(userAnswer);
                }
            }
            
            // Calculate final score
            double score = (double) correctAnswers / totalQuestions * 100;
            boolean passed = score >= quiz.getPassRate();
            
            result.setScore(score);
            result.setPassed(passed);
            
            // Save quiz result
            int resultId = resultDao.saveQuizResult(result);
            
            // Update user answers with result ID
            userAnswerDao.updateQuizResultId(resultId, accountId, quizId);
            
            // Redirect to result page
            response.sendRedirect(request.getContextPath() + "/student/quiz-result?resultId=" + resultId);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/quizzes");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while submitting the quiz.");
            request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
        }
    }
} 