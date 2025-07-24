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
        String sql = "INSERT INTO Questions (SubjectId, LessonId, Level, Content, Status, CreatedAt, UpdatedAt, ImageUrl, IsPracticeOnly) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            Timestamp now = new Timestamp(new Date().getTime());
            ps.setInt(1, q.getSubjectId());
            ps.setInt(2, q.getLessonId());
            ps.setString(3, q.getLevel());
            ps.setString(4, q.getContent());
            ps.setString(5, q.getStatus());
            ps.setTimestamp(6, now);
            ps.setTimestamp(7, now);
            ps.setBytes(8, q.getImage());
            ps.setBoolean(9, q.isPracticeOnly());
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
        String sql = "UPDATE Questions SET SubjectId=?, LessonId=?, Level=?, Content=?, Status=?, UpdatedAt=?, ImageUrl=?, IsPracticeOnly=? WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getSubjectId());
            ps.setInt(2, q.getLessonId());
            ps.setString(3, q.getLevel());
            ps.setString(4, q.getContent());
            ps.setString(5, q.getStatus());
            ps.setTimestamp(6, new Timestamp(new Date().getTime()));
            ps.setBytes(7, q.getImage());
            ps.setBoolean(8, q.isPracticeOnly());
            ps.setInt(9, q.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuestion(int id) {
        String sql = "UPDATE Questions SET Status='Inactive' WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Question> getQuestionsByLessonId(int lessonId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Questions WHERE LessonId = ? AND Status = 'Active' AND IsPracticeOnly = 1";
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
        String sql = "SELECT * FROM Questions WHERE SubjectId = ? AND Status = 'Active' AND IsPracticeOnly = 1";
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
