package DAO;

import Model.QuizUserAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizUserAnswerDAO extends DBcontext {

    /**
     * Lưu user answer
     */
    public void saveUserAnswer(QuizUserAnswer userAnswer) {
        String sql = "INSERT INTO QuizUserAnswers (QuizResultId, QuestionId, AnswerId, IsCorrect) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userAnswer.getQuizResultId());
            ps.setInt(2, userAnswer.getQuestionId());
            ps.setInt(3, userAnswer.getAnswerId());
            ps.setBoolean(4, userAnswer.isCorrect());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Cập nhật QuizResultId cho user answers
     */
    public void updateQuizResultId(int resultId, int accountId, int quizId) {
        String sql = "UPDATE QuizUserAnswers SET QuizResultId = ? "
                + "WHERE QuizResultId = 0 AND QuestionId IN "
                + "(SELECT qq.QuestionId FROM QuizQuestions qq WHERE qq.QuizId = ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, resultId);
            ps.setInt(2, quizId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy user answers theo quiz result ID
     */
    public List<QuizUserAnswer> getUserAnswersByResultId(int resultId) {
        List<QuizUserAnswer> answers = new ArrayList<>();
        String sql = "SELECT * FROM QuizUserAnswers WHERE QuizResultId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, resultId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    answers.add(mapRowToQuizUserAnswer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return answers;
    }

    /**
     * Lấy user answers với thông tin chi tiết
     */
    public List<QuizUserAnswer> getUserAnswersWithDetails(int resultId) {
        List<QuizUserAnswer> answers = new ArrayList<>();
        String sql = "SELECT qua.*, q.Content as QuestionContent, qa.Content as AnswerContent "
                + "FROM QuizUserAnswers qua "
                + "JOIN Questions q ON qua.QuestionId = q.Id "
                + "LEFT JOIN QuestionAnswers qa ON qua.AnswerId = qa.Id "
                + "WHERE qua.QuizResultId = ? "
                + "ORDER BY qua.QuestionId";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, resultId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizUserAnswer answer = mapRowToQuizUserAnswer(rs);
                    String questionContent = rs.getString("QuestionContent");
                    String answerContent = rs.getString("AnswerContent");

                    // Kiểm tra null và set giá trị mặc định
                    answer.setQuestionContent(questionContent != null ? questionContent : "Nội dung câu hỏi không có");
                    answer.setAnswerContent(answerContent != null ? answerContent : "Nội dung đáp án không có");

                    System.out.println("DEBUG: Adding answer - QuestionContent: " + questionContent + ", AnswerContent: " + answerContent);
                    answers.add(answer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getUserAnswersWithDetails: " + e.getMessage());
            e.printStackTrace();
        }
        return answers;
    }

    /**
     * Xóa user answers theo quiz result ID
     */
    public void deleteUserAnswersByResultId(int resultId) {
        String sql = "DELETE FROM QuizUserAnswers WHERE QuizResultId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, resultId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private QuizUserAnswer mapRowToQuizUserAnswer(ResultSet rs) throws SQLException {
        QuizUserAnswer answer = new QuizUserAnswer();
        answer.setId(rs.getInt("Id"));
        answer.setQuizResultId(rs.getInt("QuizResultId"));
        answer.setQuestionId(rs.getInt("QuestionId"));
        answer.setAnswerId(rs.getInt("AnswerId"));
        answer.setCorrect(rs.getBoolean("IsCorrect"));
        return answer;
    }

    public void saveOrUpdateUserAnswer(QuizUserAnswer userAnswer) {
        String checkSql = "SELECT Id FROM QuizUserAnswers WHERE QuizResultId = ? AND QuestionId = ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
            checkStmt.setInt(1, userAnswer.getQuizResultId());
            checkStmt.setInt(2, userAnswer.getQuestionId());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                // Đã tồn tại → UPDATE
                int id = rs.getInt("Id");
                String updateSql = "UPDATE QuizUserAnswers SET AnswerId = ?, IsCorrect = ? WHERE Id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                    if (userAnswer.getAnswerId() != null) {
                        updateStmt.setInt(1, userAnswer.getAnswerId());
                    } else {
                        updateStmt.setNull(1, Types.INTEGER);
                    }
                    updateStmt.setBoolean(2, userAnswer.isCorrect());
                    updateStmt.setInt(3, id);
                    updateStmt.executeUpdate();
                }
            } else {
                // Chưa có → INSERT
                saveUserAnswer(userAnswer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
