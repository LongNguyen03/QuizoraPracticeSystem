package DAO;

import Model.QuestionAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionAnswerDAO extends DBcontext {

    /**
     * Lấy đáp án theo question ID
     */
    public List<QuestionAnswer> getAnswersByQuestionId(int questionId) {
        List<QuestionAnswer> answers = new ArrayList<>();
        String sql = "SELECT * FROM QuestionAnswers WHERE QuestionId = ? ORDER BY AnswerOrder";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    answers.add(mapRowToQuestionAnswer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return answers;
    }
    
    /**
     * Lấy đáp án theo ID
     */
    public QuestionAnswer getAnswerById(int answerId) {
        String sql = "SELECT * FROM QuestionAnswers WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, answerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuestionAnswer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy đáp án đúng của một câu hỏi
     */
    public QuestionAnswer getCorrectAnswerByQuestionId(int questionId) {
        String sql = "SELECT * FROM QuestionAnswers WHERE QuestionId = ? AND IsCorrect = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuestionAnswer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Tạo đáp án mới
     */
    public void createAnswer(QuestionAnswer answer) {
        String sql = "INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, AnswerOrder) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getContent());
            ps.setBoolean(3, answer.isCorrect());
            ps.setInt(4, answer.getAnswerOrder());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    answer.setId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Cập nhật đáp án
     */
    public void updateAnswer(QuestionAnswer answer) {
        String sql = "UPDATE QuestionAnswers SET Content = ?, IsCorrect = ?, AnswerOrder = ? WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, answer.getContent());
            ps.setBoolean(2, answer.isCorrect());
            ps.setInt(3, answer.getAnswerOrder());
            ps.setInt(4, answer.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Xóa đáp án
     */
    public void deleteAnswer(int answerId) {
        String sql = "DELETE FROM QuestionAnswers WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, answerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Xóa tất cả đáp án của một câu hỏi
     */
    public void deleteAnswersByQuestionId(int questionId) {
        String sql = "DELETE FROM QuestionAnswers WHERE QuestionId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private QuestionAnswer mapRowToQuestionAnswer(ResultSet rs) throws SQLException {
        QuestionAnswer answer = new QuestionAnswer();
        answer.setId(rs.getInt("Id"));
        answer.setQuestionId(rs.getInt("QuestionId"));
        answer.setContent(rs.getString("Content"));
        answer.setCorrect(rs.getBoolean("IsCorrect"));
        answer.setAnswerOrder(rs.getInt("AnswerOrder"));
        return answer;
    }
}
