package DAO;

import Model.QuizQuestion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class QuizQuestionDAO extends DBcontext {

    public List<QuizQuestion> getQuestionsByQuizId(int quizId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM QuizQuestions WHERE QuizId = ? ORDER BY QuestionOrder";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizQuestion q = new QuizQuestion();
                    q.setId(rs.getInt("Id"));
                    q.setQuizId(rs.getInt("QuizId"));
                    q.setQuestionId(rs.getInt("QuestionId"));
                    q.setQuestionOrder(rs.getInt("QuestionOrder"));
                    questions.add(q);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }
}
