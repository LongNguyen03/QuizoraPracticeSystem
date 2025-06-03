package DAO;

import Model.Quiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO extends DBcontext {

    public List<Quiz> getQuizzesBySubjectId(int subjectId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT Id, Name, SubjectId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, CreatedAt, UpdatedAt FROM Quizzes WHERE SubjectId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                quizzes.add(new Quiz(
                    rs.getInt("Id"),
                    rs.getString("Name"),
                    rs.getInt("SubjectId"),
                    rs.getString("Level"),
                    rs.getInt("NumberOfQuestions"),
                    rs.getInt("DurationMinutes"),
                    rs.getDouble("PassRate"),
                    rs.getString("Type"),
                    rs.getTimestamp("CreatedAt"),
                    rs.getTimestamp("UpdatedAt")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quizzes;
    }
}
