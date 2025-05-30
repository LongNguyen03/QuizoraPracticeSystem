/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author kan3v
 */
import Model.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO extends DBcontext {

    public List<Question> getActiveQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Questions WHERE Status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("Id"));
                q.setSubjectId(rs.getInt("SubjectId"));
                q.setLessonId(rs.getInt("LessonId"));
                q.setDimensionId(rs.getInt("DimensionId"));
                q.setLevel(rs.getString("Level"));
                q.setContent(rs.getString("Content"));
                q.setMedia(rs.getString("Media"));
                q.setStatus(rs.getString("Status"));
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
                    Question q = new Question();
                    q.setId(rs.getInt("Id"));
                    q.setSubjectId(rs.getInt("SubjectId"));
                    q.setLessonId(rs.getInt("LessonId"));
                    q.setDimensionId(rs.getInt("DimensionId"));
                    q.setLevel(rs.getString("Level"));
                    q.setContent(rs.getString("Content"));
                    q.setMedia(rs.getString("Media"));
                    q.setStatus(rs.getString("Status"));
                    return q;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createQuestion(Question q) {
        String sql = "INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, Media, Status) VALUES (?, ?, ?, ?, ?, ?, 'active')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getSubjectId());
            ps.setInt(2, q.getLessonId());
            ps.setInt(3, q.getDimensionId());
            ps.setString(4, q.getLevel());
            ps.setString(5, q.getContent());
            ps.setString(6, q.getMedia());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateQuestion(Question q) {
        String sql = "UPDATE Questions SET SubjectId=?, LessonId=?, DimensionId=?, Level=?, Content=?, Media=? WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, q.getSubjectId());
            ps.setInt(2, q.getLessonId());
            ps.setInt(3, q.getDimensionId());
            ps.setString(4, q.getLevel());
            ps.setString(5, q.getContent());
            ps.setString(6, q.getMedia());
            ps.setInt(7, q.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuestion(int id) {
        String sql = "UPDATE Questions SET Status='inactive' WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        QuestionDAO dao = new QuestionDAO();

        Question q = new Question(
                0, // ID (ignored in insert)
                "Test insert question", // Content
                "Easy", // Level
                "active", // Status
                "image.jpg", // Media
                1, // SubjectId
                1, // LessonId
                1 // DimensionId
        );

        dao.createQuestion(q);

        System.out.println("✅ Insert test completed. Check database manually.");
    }

}
