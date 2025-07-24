package DAO;

import Model.Quiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import DAO.QuestionDAO;
import DAO.QuizQuestionDAO;
import Model.Question;
import java.util.Collections;

public class QuizDAO extends DBcontext {

    public List<Quiz> getQuizzesBySubjectId(int subjectId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT Id, Name, SubjectId, OwnerId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, IsPracticeable, CreatedAt, UpdatedAt FROM Quizzes WHERE SubjectId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                quizzes.add(new Quiz(
                        rs.getInt("Id"),
                        rs.getString("Name"),
                        rs.getInt("SubjectId"),
                        rs.getInt("OwnerId"),
                        rs.getString("Level"),
                        rs.getInt("NumberOfQuestions"),
                        rs.getInt("DurationMinutes"),
                        rs.getDouble("PassRate"),
                        rs.getString("Type"),
                        rs.getBoolean("IsPracticeable"),
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
        String sql = "SELECT Id, Name, SubjectId, OwnerId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, IsPracticeable, CreatedAt, UpdatedAt FROM Quizzes ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                quizzes.add(new Quiz(
                        rs.getInt("Id"),
                        rs.getString("Name"),
                        rs.getInt("SubjectId"),
                        rs.getInt("OwnerId"),
                        rs.getString("Level"),
                        rs.getInt("NumberOfQuestions"),
                        rs.getInt("DurationMinutes"),
                        rs.getDouble("PassRate"),
                        rs.getString("Type"),
                        rs.getBoolean("IsPracticeable"),
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
        String sql = "SELECT Id, Name, SubjectId, OwnerId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, IsPracticeable, CreatedAt, UpdatedAt FROM Quizzes WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Quiz(
                        rs.getInt("Id"),
                        rs.getString("Name"),
                        rs.getInt("SubjectId"),
                        rs.getInt("OwnerId"),
                        rs.getString("Level"),
                        rs.getInt("NumberOfQuestions"),
                        rs.getInt("DurationMinutes"),
                        rs.getDouble("PassRate"),
                        rs.getString("Type"),
                        rs.getBoolean("IsPracticeable"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getTimestamp("UpdatedAt")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertQuiz(Quiz quiz) {
        String sql = "INSERT INTO Quizzes (Name, SubjectId, OwnerId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, IsPracticeable, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, quiz.getName());
            ps.setInt(2, quiz.getSubjectId());
            ps.setInt(3, quiz.getOwnerId());
            ps.setString(4, quiz.getLevel());
            ps.setInt(5, quiz.getNumberOfQuestions());
            ps.setInt(6, quiz.getDurationMinutes());
            ps.setDouble(7, quiz.getPassRate());
            ps.setString(8, quiz.getType());
            ps.setBoolean(9, quiz.isPracticeable());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateQuiz(Quiz quiz) {
        String sql = "UPDATE Quizzes SET Name=?, SubjectId=?, OwnerId=?, Level=?, NumberOfQuestions=?, DurationMinutes=?, PassRate=?, Type=?, IsPracticeable=?, UpdatedAt=GETDATE() WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, quiz.getName());
            ps.setInt(2, quiz.getSubjectId());
            ps.setInt(3, quiz.getOwnerId());
            ps.setString(4, quiz.getLevel());
            ps.setInt(5, quiz.getNumberOfQuestions());
            ps.setInt(6, quiz.getDurationMinutes());
            ps.setDouble(7, quiz.getPassRate());
            ps.setString(8, quiz.getType());
            ps.setBoolean(9, quiz.isPracticeable());
            ps.setInt(10, quiz.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuiz(int quizId) {
        String sql = "DELETE FROM Quizzes WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getLatestQuizId() {
        String sql = "SELECT TOP 1 Id FROM Quizzes ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Lấy subjectId từ lessonId
     */
    public int getSubjectIdByLessonId(int lessonId) {
        String sql = "SELECT SubjectId FROM Lessons WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("SubjectId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Chèn quiz mới, nhận lessonId, tự động lấy subjectId từ lessonId
     */
    public void insertQuizWithLesson(int lessonId, String name, String level, int numberOfQuestions, int durationMinutes, double passRate, String type, int ownerId, boolean isPracticeable) {
        int subjectId = getSubjectIdByLessonId(lessonId);
        String sql = "INSERT INTO Quizzes (Name, SubjectId, OwnerId, Level, NumberOfQuestions, DurationMinutes, PassRate, Type, IsPracticeable, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, subjectId);
            ps.setInt(3, ownerId);
            ps.setString(4, level);
            ps.setInt(5, numberOfQuestions);
            ps.setInt(6, durationMinutes);
            ps.setDouble(7, passRate);
            ps.setString(8, type);
            ps.setBoolean(9, isPracticeable);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean isQuizNameExists(String name) {
        String sql = "SELECT COUNT(*) FROM Quizzes WHERE Name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Quiz> getQuizzesByOwnerId(int ownerId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM Quizzes WHERE OwnerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                quizzes.add(new Quiz(
                    rs.getInt("Id"),
                    rs.getString("Name"),
                    rs.getInt("SubjectId"),
                    rs.getInt("OwnerId"),
                    rs.getString("Level"),
                    rs.getInt("NumberOfQuestions"),
                    rs.getInt("DurationMinutes"),
                    rs.getDouble("PassRate"),
                    rs.getString("Type"),
                    rs.getBoolean("IsPracticeable"),
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
