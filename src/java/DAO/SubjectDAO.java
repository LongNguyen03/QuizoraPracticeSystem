/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author kan3v
 */

import Model.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO extends DBcontext {

    /**
     * Lấy tất cả Subject
     */
    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM Subjects";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subject s = new Subject();
                s.setId(rs.getInt("Id"));
                s.setTitle(rs.getString("Title"));
                s.setTagline(rs.getString("Tagline"));
                s.setOwnerId(rs.getInt("OwnerId"));
                s.setStatus(rs.getString("Status"));
                s.setDescription(rs.getString("Description"));
                s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                s.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                s.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy Subject theo ID
     */
    public Subject getSubjectById(int id) {
        String sql = "SELECT * FROM Subjects WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject s = new Subject();
                    s.setId(rs.getInt("Id"));
                    s.setTitle(rs.getString("Title"));
                    s.setTagline(rs.getString("Tagline"));
                    s.setOwnerId(rs.getInt("OwnerId"));
                    s.setStatus(rs.getString("Status"));
                    s.setDescription(rs.getString("Description"));
                    s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    s.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    s.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Thêm môn học mới
     */
    public boolean insertSubject(Subject s) {
        String sql = "INSERT INTO Subjects (Title, Tagline, OwnerId, Status, Description, CreatedAt, UpdatedAt, ThumbnailUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getTitle());
            ps.setString(2, s.getTagline());
            ps.setInt(3, s.getOwnerId());
            ps.setString(4, s.getStatus());
            ps.setString(5, s.getDescription());
            ps.setTimestamp(6, new java.sql.Timestamp(s.getCreatedAt().getTime()));
            ps.setTimestamp(7, new java.sql.Timestamp(s.getUpdatedAt().getTime()));
            ps.setString(8, s.getThumbnailUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật môn học
     */
    public boolean updateSubject(Subject s) {
        String sql = "UPDATE Subjects SET Title = ?, Tagline = ?, OwnerId = ?, Status = ?, Description = ?, UpdatedAt = ?, ThumbnailUrl = ? WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getTitle());
            ps.setString(2, s.getTagline());
            ps.setInt(3, s.getOwnerId());
            ps.setString(4, s.getStatus());
            ps.setString(5, s.getDescription());
            ps.setTimestamp(6, new java.sql.Timestamp(s.getUpdatedAt().getTime()));
            ps.setString(7, s.getThumbnailUrl());
            ps.setInt(8, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa môn học theo ID
     */
    public boolean deleteSubject(int id) {
        String sql = "DELETE FROM Subjects WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra tên môn học đã tồn tại (không phân biệt hoa thường)
     */
    public boolean isSubjectTitleExists(String title) {
        String sql = "SELECT COUNT(*) FROM Subjects WHERE LOWER(Title) = LOWER(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, title);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

//    public List<Subject> findAll() throws SQLException {
//        Connection conn = DB.getConnection();
//        PreparedStatement ps = conn.prepareStatement("SELECT id, title FROM Subjects WHERE status='Active'");
//        ResultSet rs = ps.executeQuery();
//        List<Subject> list = new ArrayList<>();
//        while (rs.next()) {
//            list.add(new Subject(rs.getInt("id"), rs.getString("title")));
//        }
//        rs.close(); ps.close(); conn.close();
//        return list;
//    }
}
