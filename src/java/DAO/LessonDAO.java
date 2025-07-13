/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Lesson;
import Model.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class LessonDAO extends DBcontext {

    public List<Lesson> getAllLessons() {
        List<Lesson> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Lessons";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractLesson(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Lesson> getAllLessons(int subjectId, String keyword, String dimension) {
        List<Lesson> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Lessons WHERE 1=1");

        if (subjectId > 0) {
            sql.append(" AND SubjectId = ?");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND Title LIKE ?");
        }
        if (dimension != null && !dimension.trim().isEmpty()) {
            sql.append(" AND Dimension = ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (subjectId > 0) {
                ps.setInt(index++, subjectId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword.trim() + "%");
            }
            if (dimension != null && !dimension.trim().isEmpty()) {
                ps.setString(index++, dimension);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractLesson(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Lesson getLessonById(int id) {
        String sql = "SELECT * FROM Lessons WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractLesson(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void addLesson(Lesson lesson) {
        String sql = "INSERT INTO Lessons (SubjectId, Title, Content, Dimension, Status, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lesson.getSubjectId());
            ps.setString(2, lesson.getTitle());
            ps.setString(3, lesson.getContent());
            ps.setString(4, lesson.getDimension());
            ps.setString(5, lesson.getStatus());
            ps.setTimestamp(6, new Timestamp(new Date().getTime()));
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateLesson(Lesson lesson) {
        String sql = "UPDATE Lessons SET Title = ?, Content = ?, Dimension = ?, Status = ?, UpdatedAt = ? WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());
            ps.setString(3, lesson.getDimension());
            ps.setString(4, lesson.getStatus());
            ps.setTimestamp(5, new Timestamp(new Date().getTime()));
            ps.setInt(6, lesson.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteLesson(int id) {
        String sql = "DELETE FROM Lessons WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Lesson extractLesson(ResultSet rs) throws SQLException {
        Lesson lesson = new Lesson();
        lesson.setId(rs.getInt("Id"));
        lesson.setSubjectId(rs.getInt("SubjectId"));
        lesson.setTitle(rs.getString("Title"));
        lesson.setContent(rs.getString("Content"));
        lesson.setDimension(rs.getString("Dimension"));
        lesson.setStatus(rs.getString("Status"));
        lesson.setCreatedAt(rs.getTimestamp("CreatedAt"));
        lesson.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return lesson;
    }

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM Subjects"; // Đảm bảo tên bảng đúng

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Subject subject = new Subject();
                subject.setId(rs.getInt("Id"));                        
                subject.setTitle(rs.getString("Title"));              
                subject.setTagline(rs.getString("Tagline"));          
                subject.setOwnerId(rs.getInt("OwnerId"));             
                subject.setStatus(rs.getString("Status"));           
                subject.setDescription(rs.getString("Description"));   
                subject.setCreatedAt(rs.getTimestamp("CreatedAt"));    
                subject.setUpdatedAt(rs.getTimestamp("UpdatedAt"));    
                subject.setThumbnailUrl(rs.getString("ThumbnailUrl")); 
                list.add(subject);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Lesson> getLessonsBySubjectAndStatus(int subjectId, String status) {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM Lessons WHERE SubjectId = ? AND Status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractLesson(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

//    public List<Lesson> findBySubject(int subjectId) throws SQLException {
//        Connection conn = DB.getConnection();
//        PreparedStatement ps = conn.prepareStatement(
//            "SELECT id, title FROM Lessons WHERE subjectId=? AND status='Active'");
//        ps.setInt(1, subjectId);
//        ResultSet rs = ps.executeQuery();
//        List<Lesson> list = new ArrayList<>();
//        while (rs.next()) {
//            list.add(new Lesson(rs.getInt("id"), rs.getString("title")));
//        }
//        rs.close(); ps.close(); conn.close();
//        return list;
//    }
    
}
