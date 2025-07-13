package DAO;

import Model.PracticeAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PracticeAnswerDAO extends DBcontext {
    
    /**
     * Lưu practice answer
     */
    public void savePracticeAnswer(PracticeAnswer answer) {
        String sql = "INSERT INTO PracticeAnswers (PracticeSessionId, QuestionId, AnswerId, IsCorrect) " +
                     "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, answer.getPracticeSessionId());
            ps.setInt(2, answer.getQuestionId());
            
            // Xử lý AnswerId - có thể là null
            if (answer.getAnswerId() != null) {
                ps.setInt(3, answer.getAnswerId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            ps.setBoolean(4, answer.isCorrect());
            ps.executeUpdate();
            System.out.println("PracticeAnswerDAO: Saved practice answer - SessionId: " + answer.getPracticeSessionId() + 
                             ", QuestionId: " + answer.getQuestionId() + ", AnswerId: " + answer.getAnswerId() + 
                             ", IsCorrect: " + answer.isCorrect());
        } catch (SQLException e) {
            System.out.println("PracticeAnswerDAO: Error saving practice answer: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Lấy practice answers theo session ID với thứ tự hiển thị đúng
     */
    public List<PracticeAnswer> getPracticeAnswersBySessionId(int sessionId) {
        List<PracticeAnswer> answers = new ArrayList<>();
        String sql = "SELECT pa.*, q.Content AS QuestionContent, qa.Content AS AnswerContent " +
                     "FROM PracticeAnswers pa " +
                     "JOIN Questions q ON pa.QuestionId = q.Id " +
                     "LEFT JOIN QuestionAnswers qa ON pa.AnswerId = qa.Id " +
                     "WHERE pa.PracticeSessionId = ? " +
                     "ORDER BY pa.Id";
        
        System.out.println("PracticeAnswerDAO: Getting practice answers for sessionId: " + sessionId);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                int displayOrder = 1;
                while (rs.next()) {
                    PracticeAnswer answer = mapRowToPracticeAnswer(rs);
                    answer.setDisplayOrder(displayOrder++);
                    answers.add(answer);
                }
            }
        } catch (SQLException e) {
            System.out.println("PracticeAnswerDAO: Error getting practice answers: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("PracticeAnswerDAO: Found " + answers.size() + " practice answers");
        return answers;
    }
    
    /**
     * Lấy practice answer theo ID
     */
    public PracticeAnswer getPracticeAnswerById(int answerId) {
        String sql = "SELECT pa.*, q.Content AS QuestionContent, qa.Content AS AnswerContent " +
                     "FROM PracticeAnswers pa " +
                     "JOIN Questions q ON pa.QuestionId = q.Id " +
                     "LEFT JOIN QuestionAnswers qa ON pa.AnswerId = qa.Id " +
                     "WHERE pa.Id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, answerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPracticeAnswer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật practice answer
     */
    public boolean updatePracticeAnswer(PracticeAnswer answer) {
        String sql = "UPDATE PracticeAnswers SET AnswerId = ?, IsCorrect = ? WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setObject(1, answer.getAnswerId());
            ps.setBoolean(2, answer.isCorrect());
            ps.setInt(3, answer.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa practice answer
     */
    public boolean deletePracticeAnswer(int answerId) {
        String sql = "DELETE FROM PracticeAnswers WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, answerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa tất cả practice answers của một session
     */
    public boolean deletePracticeAnswersBySessionId(int sessionId) {
        String sql = "DELETE FROM PracticeAnswers WHERE PracticeSessionId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy thống kê practice answers của một session
     */
    public PracticeAnswerStats getPracticeAnswerStats(int sessionId) {
        String sql = "SELECT " +
                     "COUNT(*) AS totalQuestions, " +
                     "SUM(CASE WHEN IsCorrect = 1 THEN 1 ELSE 0 END) AS correctAnswers, " +
                     "SUM(CASE WHEN AnswerId IS NOT NULL THEN 1 ELSE 0 END) AS answeredQuestions " +
                     "FROM PracticeAnswers WHERE PracticeSessionId = ?";
        
        System.out.println("PracticeAnswerDAO: Getting stats for sessionId: " + sessionId);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PracticeAnswerStats stats = new PracticeAnswerStats();
                    stats.setTotalQuestions(rs.getInt("totalQuestions"));
                    stats.setCorrectAnswers(rs.getInt("correctAnswers"));
                    stats.setAnsweredQuestions(rs.getInt("answeredQuestions"));
                    System.out.println("PracticeAnswerDAO: Stats - total: " + stats.getTotalQuestions() + 
                                     ", correct: " + stats.getCorrectAnswers() + 
                                     ", answered: " + stats.getAnsweredQuestions());
                    return stats;
                }
            }
        } catch (SQLException e) {
            System.out.println("PracticeAnswerDAO: Error getting stats: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("PracticeAnswerDAO: No stats found");
        return null;
    }
    
    /**
     * Map ResultSet row to PracticeAnswer object
     */
    private PracticeAnswer mapRowToPracticeAnswer(ResultSet rs) throws SQLException {
        PracticeAnswer answer = new PracticeAnswer();
        answer.setId(rs.getInt("Id"));
        answer.setPracticeSessionId(rs.getInt("PracticeSessionId"));
        answer.setQuestionId(rs.getInt("QuestionId"));
        answer.setAnswerId(rs.getObject("AnswerId", Integer.class));
        answer.setCorrect(rs.getBoolean("IsCorrect"));
        
        String questionContent = rs.getString("QuestionContent");
        String answerContent = rs.getString("AnswerContent");
        
        answer.setQuestionContent(questionContent);
        answer.setAnswerContent(answerContent);
        
        System.out.println("PracticeAnswerDAO: Mapped answer - QuestionId: " + answer.getQuestionId() + 
                         ", AnswerId: " + answer.getAnswerId() + 
                         ", QuestionContent: " + (questionContent != null ? questionContent.substring(0, Math.min(50, questionContent.length())) + "..." : "null") +
                         ", AnswerContent: " + (answerContent != null ? answerContent.substring(0, Math.min(50, answerContent.length())) + "..." : "null"));
        
        return answer;
    }
    
    /**
     * Inner class để lưu thống kê practice answers
     */
    public static class PracticeAnswerStats {
        private int totalQuestions;
        private int correctAnswers;
        private int answeredQuestions;
        
        public int getTotalQuestions() { return totalQuestions; }
        public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }
        
        public int getCorrectAnswers() { return correctAnswers; }
        public void setCorrectAnswers(int correctAnswers) { this.correctAnswers = correctAnswers; }
        
        public int getAnsweredQuestions() { return answeredQuestions; }
        public void setAnsweredQuestions(int answeredQuestions) { this.answeredQuestions = answeredQuestions; }
        
        public double getScorePercentage() {
            if (totalQuestions == 0) return 0.0;
            return (double) correctAnswers / totalQuestions * 100;
        }
        
        public int getUnansweredQuestions() {
            return totalQuestions - answeredQuestions;
        }
    }
} 