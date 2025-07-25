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

    public void addQuestionToQuiz(int quizId, int questionId, int order) {
        String sql = "INSERT INTO QuizQuestions (QuizId, QuestionId, QuestionOrder) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.setInt(2, questionId);
            ps.setInt(3, order);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getLessonIdsByQuizId(int quizId) {
        List<Integer> lessonIds = new ArrayList<>();
        String sql = "SELECT DISTINCT q.LessonId FROM QuizQuestions qq JOIN Questions q ON qq.QuestionId = q.Id WHERE qq.QuizId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lessonIds.add(rs.getInt("LessonId"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lessonIds;
    }
}
