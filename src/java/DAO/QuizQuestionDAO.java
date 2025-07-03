package DAO;

import Model.QuizQuestion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class QuizQuestionDAO extends DBcontext {
    public void insert(QuizQuestion qq) throws SQLException {
        String sql = "INSERT INTO QuizQuestions (QuizId, QuestionId, QuestionOrder) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, qq.getQuizId());
            ps.setInt(2, qq.getQuestionId());
            ps.setInt(3, qq.getQuestionOrder());
            ps.executeUpdate();
        }
    }
} 