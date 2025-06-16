package DAO;

import Model.QuestionAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionAnswerDAO extends DBcontext {

    public void deleteByQuestion(int questionId) {
        String sql = "DELETE FROM QuestionAnswers WHERE QuestionId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void insertAnswer(QuestionAnswer a) {
        String sql = "INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, AnswerOrder) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, a.getQuestionId());
            ps.setString(2, a.getContent());
            ps.setBoolean(3, a.isCorrect());
            ps.setInt(4, a.getAnswerOrder());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<QuestionAnswer> getByQuestion(int questionId) {
        List<QuestionAnswer> list = new ArrayList<>();
        String sql = "SELECT * FROM QuestionAnswers WHERE QuestionId = ? ORDER BY AnswerOrder";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuestionAnswer a = new QuestionAnswer();
                    a.setId(rs.getInt("Id"));
                    a.setQuestionId(rs.getInt("QuestionId"));
                    a.setContent(rs.getString("Content"));
                    a.setCorrect(rs.getBoolean("IsCorrect"));
                    a.setAnswerOrder(rs.getInt("AnswerOrder"));
                    list.add(a);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
