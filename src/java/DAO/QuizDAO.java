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
    
    /**
     * Lấy tất cả quiz có sẵn
     */
    public List<Quiz> getAllAvailableQuizzes() {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT Id, Name, SubjectId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, CreatedAt, UpdatedAt FROM Quizzes ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
    
    /**
     * Lấy tất cả levels có sẵn
     */
    public List<String> getAllQuizLevels() {
        List<String> levels = new ArrayList<>();
        String sql = "SELECT DISTINCT Level FROM Quizzes ORDER BY Level";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                levels.add(rs.getString("Level"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return levels;
    }
    
    /**
     * Lấy quiz theo ID
     */
    public Quiz getQuizById(int quizId) {
        String sql = "SELECT Id, Name, SubjectId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, CreatedAt, UpdatedAt FROM Quizzes WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Quiz(
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
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
//     public int insert(Quiz q) throws SQLException {
//        Connection conn = DB.getConnection();
//        PreparedStatement ps = conn.prepareStatement(
//          "INSERT INTO Quizzes(name, subjectId, level, numberOfQuestions, durationMinutes, passRate, type, createdAt) VALUES (?,?,?,?,?,?,?,?)",
//          Statement.RETURN_GENERATED_KEYS);
//        ps.setString(1, q.getName());
//        ps.setInt(2, q.getSubjectId());
//        ps.setString(3, q.getLevel());
//        ps.setInt(4, q.getNumberOfQuestions());
//        ps.setInt(5, q.getDurationMinutes());
//        ps.setDouble(6, q.getPassRate());
//        ps.setString(7, q.getType());
//        ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
//        ps.executeUpdate();
//        ResultSet keys = ps.getGeneratedKeys();
//        keys.next();
//        int newId = keys.getInt(1);
//        keys.close(); ps.close(); conn.close();
//        return newId;
//    }
}
