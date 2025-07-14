/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

/**
 *
 * @author kan3v
 */
package Controller;

import DAO.QuestionAnswerDAO;
import DAO.QuizQuestionDAO;
import DAO.QuizResultDAO;
import DAO.QuizUserAnswerDAO;
import Model.QuestionAnswer;
import Model.QuizQuestion;
import Model.QuizResult;
import Model.QuizUserAnswer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/quiz-handle")
public class QuizHandleController extends HttpServlet {

    private QuizQuestionDAO quizQuestionDAO = new QuizQuestionDAO();
    private QuestionAnswerDAO questionAnswerDAO = new QuestionAnswerDAO();
    private QuizUserAnswerDAO quizUserAnswerDAO = new QuizUserAnswerDAO();
    private QuizResultDAO quizResultDAO = new QuizResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bước 1: Nhận quizId từ URL
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        
        // Lấy câu hỏi
        List<QuizQuestion> quizQuestions = quizQuestionDAO.getQuestionsByQuizId(quizId);
        request.setAttribute("quizQuestions", quizQuestions);

        // Lấy đáp án cho từng câu hỏi
        for (QuizQuestion qq : quizQuestions) {
            List<QuestionAnswer> answers = questionAnswerDAO.getAnswersByQuestionId(qq.getQuestionId());
            request.setAttribute("answers_" + qq.getQuestionId(), answers);
        }

        // Truyền quizId cho JSP
        request.setAttribute("quizId", quizId);

        request.getRequestDispatcher("quiz_handle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bước 2: Nhận quizId + accountId 
        int quizId = Integer.parseInt(request.getParameter("quizId"));
        int accountId = (int) request.getSession().getAttribute("accountId");

        // Lấy câu hỏi
        List<QuizQuestion> quizQuestions = quizQuestionDAO.getQuestionsByQuizId(quizId);

        // Xử lý từng câu hỏi
        for (QuizQuestion qq : quizQuestions) {
            String param = "answer_" + qq.getQuestionId();
            String selected = request.getParameter(param);

            QuizUserAnswer answer = new QuizUserAnswer();
            answer.setQuizResultId(0); // chưa có kết quả, set tạm
            answer.setQuestionId(qq.getQuestionId());

            if (selected != null) {
                int selectedAnswerId = Integer.parseInt(selected);
                answer.setAnswerId(selectedAnswerId);
                boolean isCorrect = questionAnswerDAO.isAnswerCorrect(qq.getQuestionId(), selectedAnswerId);
                answer.setCorrect(isCorrect);
            } else {
                answer.setAnswerId(null);
                answer.setCorrect(false);
            }

            // Lưu user answer
            quizUserAnswerDAO.saveUserAnswer(answer);
        }

        // Bước 3: Tạo quiz result
        QuizResult result = new QuizResult();
        result.setQuizId(quizId);
        result.setAccountId(accountId);
        result.setScore(0); // tạm thời 0, lát update
        result.setPassed(false);
        result.setAttemptDate(new Date());
        result.setCompletionTime(null);

        int resultId = quizResultDAO.saveQuizResult(result);

        // Cập nhật quiz_result_id cho user answer
        quizUserAnswerDAO.updateQuizResultId(resultId, accountId, quizId);

        // Tính điểm
        quizResultDAO.calculateAndUpdateResult(resultId);

        // Chuyển sang trang kết quả
        response.sendRedirect("quiz_result.jsp?resultId=" + resultId);
    }
}
