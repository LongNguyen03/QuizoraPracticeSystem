package DAO;

import Model.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class QuestionDAO extends DBcontext {

    public List<Question> getActiveQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Questions WHERE Status = 'Active'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Question q = mapRowToQuestion(rs);
                list.add(q);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Question getQuestionById(int id) {
        String sql = "SELECT * FROM Questions WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuestion(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createQuestion(Question q) {
        String sql = "INSERT INTO Questions (SubjectId, OwnerId, LessonId, Level, Content, Status, CreatedAt, UpdatedAt, ImageUrl, IsPracticeOnly) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            Timestamp now = new Timestamp(new Date().getTime());
            ps.setInt(1, q.getSubjectId());
            ps.setInt(2, q.getOwnerId());
            ps.setInt(3, q.getLessonId());
            ps.setString(4, q.getLevel());
            ps.setString(5, q.getContent());
            ps.setString(6, q.getStatus());
            ps.setTimestamp(7, now);
            ps.setTimestamp(8, now);
            ps.setBytes(9, q.getImage());
            ps.setBoolean(10, q.isPracticeOnly());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    q.setId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateQuestion(Question q) {
        String sql = "UPDATE Questions SET SubjectId=?, OwnerId=?, LessonId=?, Level=?, Content=?, Status=?, UpdatedAt=?, ImageUrl=?, IsPracticeOnly=? WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getSubjectId());
            ps.setInt(2, q.getOwnerId());
            ps.setInt(3, q.getLessonId());
            ps.setString(4, q.getLevel());
            ps.setString(5, q.getContent());
            ps.setString(6, q.getStatus());
            ps.setTimestamp(7, new Timestamp(new Date().getTime()));
            ps.setBytes(8, q.getImage());
            ps.setBoolean(9, q.isPracticeOnly());
            ps.setInt(10, q.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuestion(int id) {
        // Xóa đáp án liên quan
        new QuestionAnswerDAO().deleteAnswersByQuestionId(id);
        // Xóa khỏi QuizQuestions
        try (PreparedStatement ps = connection.prepareStatement("DELETE FROM QuizQuestions WHERE QuestionId = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
        // Xóa khỏi PracticeAnswers
        try (PreparedStatement ps = connection.prepareStatement("DELETE FROM PracticeAnswers WHERE QuestionId = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
        // Xóa khỏi QuizUserAnswers
        try (PreparedStatement ps = connection.prepareStatement("DELETE FROM QuizUserAnswers WHERE QuestionId = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
        // Xóa chính Question
        String sql = "DELETE FROM Questions WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Question> getQuestionsByLessonId(int lessonId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Questions WHERE LessonId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToQuestion(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Question> getQuestionsBySubjectId(int subjectId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Questions WHERE SubjectId = ? AND Status = 'Active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToQuestion(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Question> getFilteredQuestions(
            String subjectIdStr, String lessonIdStr,
            String dimensionStr, String levelStr, String search) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.* FROM Questions q JOIN Lessons l ON q.LessonId = l.Id WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
            sql += " AND q.SubjectId = ?";
            params.add(Integer.parseInt(subjectIdStr));
        }
        if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
            sql += " AND q.LessonId = ?";
            params.add(Integer.parseInt(lessonIdStr));
        }
        if (dimensionStr != null && !dimensionStr.isEmpty()) {
            sql += " AND l.Dimension = ?";
            params.add(dimensionStr);
        }
        if (levelStr != null && !levelStr.isEmpty()) {
            sql += " AND q.Level = ?";
            params.add(levelStr);
        }
        if (search != null && !search.isEmpty()) {
            sql += " AND q.Content LIKE ?";
            params.add("%" + search + "%");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToQuestion(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy câu hỏi theo quiz ID
     */
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.* FROM Questions q " +
                     "JOIN QuizQuestions qq ON q.Id = qq.QuestionId " +
                     "WHERE qq.QuizId = ? " +
                     "ORDER BY qq.QuestionOrder";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToQuestion(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Map ResultSet row to Question object
    private Question mapRowToQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setId(rs.getInt("Id"));
        q.setSubjectId(rs.getInt("SubjectId"));
        q.setLessonId(rs.getInt("LessonId"));
        q.setLevel(rs.getString("Level"));
        q.setContent(rs.getString("Content"));
        q.setStatus(rs.getString("Status"));
        q.setCreatedAt(rs.getTimestamp("CreatedAt"));
        q.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        q.setImage(rs.getBytes("ImageUrl"));
        q.setPracticeOnly(rs.getBoolean("IsPracticeOnly"));
        return q;
    }
}
