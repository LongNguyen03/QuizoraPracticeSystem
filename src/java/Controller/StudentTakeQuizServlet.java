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
            String pathInfo = request.getPathInfo(); // /{id}
            if (pathInfo == null || pathInfo.length() <= 1) {
                response.sendRedirect(request.getContextPath() + "/student/quizzes");
                return;
            }
            int quizId = Integer.parseInt(pathInfo.substring(1));
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
            String pathInfo = request.getPathInfo(); // /{id}
            System.out.println("StudentTakeQuizServlet POST: pathInfo = " + pathInfo);
            
            if (pathInfo == null || pathInfo.length() <= 1) {
                System.out.println("StudentTakeQuizServlet POST: Invalid pathInfo, redirecting to quizzes");
                response.sendRedirect(request.getContextPath() + "/student/quizzes");
                return;
            }
            int quizId = Integer.parseInt(pathInfo.substring(1));
            System.out.println("StudentTakeQuizServlet POST: quizId = " + quizId);
            
            QuizDAO quizDao = new QuizDAO();
            QuizResultDAO resultDao = new QuizResultDAO();
            QuizUserAnswerDAO userAnswerDao = new QuizUserAnswerDAO();
            QuestionAnswerDAO answerDao = new QuestionAnswerDAO();
            
            // Get quiz details
            Quiz quiz = quizDao.getQuizById(quizId);
            System.out.println("StudentTakeQuizServlet POST: Found quiz = " + (quiz != null ? quiz.getName() : "null"));
            
            if (quiz == null) {
                System.out.println("StudentTakeQuizServlet POST: Quiz not found");
                request.setAttribute("error", "Quiz not found.");
                request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
                return;
            }
            
            // Calculate score
            int totalQuestions = quiz.getNumberOfQuestions();
            int correctAnswers = 0;
            int answeredQuestions = 0;
            
            System.out.println("StudentTakeQuizServlet POST: Processing " + totalQuestions + " questions");
            
            // Create quiz result
            QuizResult result = new QuizResult();
            result.setQuizId(quizId);
            result.setAccountId(accountId);
            result.setAttemptDate(new Date());
            
            // Process each question and count correct answers
            for (int i = 1; i <= totalQuestions; i++) {
                String answerIdStr = request.getParameter("answer_" + i);
                String questionIdStr = request.getParameter("question_" + i);
                
                System.out.println("StudentTakeQuizServlet POST: Question " + i + " - answerId: " + answerIdStr + ", questionId: " + questionIdStr);
                
                if (answerIdStr != null && questionIdStr != null) {
                    answeredQuestions++;
                    int answerId = Integer.parseInt(answerIdStr);
                    int questionId = Integer.parseInt(questionIdStr);
                    
                    // Check if answer is correct
                    QuestionAnswer selectedAnswer = answerDao.getAnswerById(answerId);
                    boolean isCorrect = selectedAnswer != null && selectedAnswer.isCorrect();
                    
                    System.out.println("StudentTakeQuizServlet POST: Question " + i + " - selected answer: " + answerId + ", isCorrect: " + isCorrect);
                    
                    if (isCorrect) {
                        correctAnswers++;
                    }
                }
            }
            
            System.out.println("StudentTakeQuizServlet POST: Total answered: " + answeredQuestions + ", correct: " + correctAnswers);
            
            // Calculate final score
            double score = 0.0;
            if (totalQuestions > 0) {
                score = (double) correctAnswers / totalQuestions * 100;
            }
            boolean passed = score >= quiz.getPassRate();
            
            System.out.println("StudentTakeQuizServlet POST: Final score: " + score + "%, passed: " + passed + ", pass rate: " + quiz.getPassRate() + "%");
            
            result.setScore(score);
            result.setPassed(passed);
            
            // Save quiz result first
            int resultId = resultDao.saveQuizResult(result);
            System.out.println("Saved quiz result with ID: " + resultId);
            
            if (resultId == -1) {
                // Failed to save result
                request.setAttribute("error", "Failed to save quiz result.");
                request.getRequestDispatcher("/student/quizzes.jsp").forward(request, response);
                return;
            }
            
            // Now save user answers with correct result ID
            for (int i = 1; i <= totalQuestions; i++) {
                String answerIdStr = request.getParameter("answer_" + i);
                String questionIdStr = request.getParameter("question_" + i);
                
                if (answerIdStr != null && questionIdStr != null) {
                    int questionId = Integer.parseInt(questionIdStr);
                    int answerId = Integer.parseInt(answerIdStr);
                    
                    // Check if answer is correct
                    QuestionAnswer selectedAnswer = answerDao.getAnswerById(answerId);
                    boolean isCorrect = selectedAnswer != null && selectedAnswer.isCorrect();
                    
                    // Save user answer with correct result ID
                    QuizUserAnswer userAnswer = new QuizUserAnswer();
                    userAnswer.setQuestionId(questionId);
                    userAnswer.setAnswerId(answerId);
                    userAnswer.setCorrect(isCorrect);
                    userAnswer.setQuizResultId(resultId);
                    
                    // Save to database
                    userAnswerDao.saveUserAnswer(userAnswer);
                    System.out.println("Saved user answer for question " + i + ": " + answerId + " (correct: " + isCorrect + ")");
                }
            }
            
            System.out.println("Quiz submission completed. Redirecting to result page with resultId: " + resultId);
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