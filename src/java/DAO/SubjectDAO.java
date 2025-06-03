/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author kan3v
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.Subject;


public class SubjectDAO {

    private final DBcontext db;

    public SubjectDAO() {
        db = new DBcontext();
    }

    public List<Subject> getAllSubjectsWithCategory() {
        List<Subject> list = new ArrayList<>();
        String sql = """
            SELECT s.*, sc.Name AS categoryName
            FROM Subjects s
            JOIN SubjectCategories sc ON s.CategoryId = sc.Id
            WHERE s.Status = 'Active'
        """;

        try (
                PreparedStatement ps = db.connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subject s = new Subject();
                s.setId(rs.getInt("Id"));
                s.setTitle(rs.getString("Title"));
                s.setTagline(rs.getString("Tagline"));
                s.setCategoryId(rs.getInt("CategoryId"));
                s.setOwnerId(rs.getInt("OwnerId"));
                s.setStatus(rs.getString("Status"));
                s.setDescription(rs.getString("Description"));
                s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                s.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                s.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                s.setCategoryName(rs.getString("categoryName")); // ← Tên chuyên ngành

                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Subject getSubjectDetailById(int subjectId) {
        String sql = """
        SELECT s.*, sc.Name AS categoryName
        FROM Subjects s
        JOIN SubjectCategories sc ON s.CategoryId = sc.Id
        WHERE s.Id = ? AND s.Status = 'Active'
    """;

        try (
                PreparedStatement ps = db.connection.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Subject s = new Subject();
                    s.setId(rs.getInt("Id"));
                    s.setTitle(rs.getString("Title"));
                    s.setTagline(rs.getString("Tagline"));
                    s.setCategoryId(rs.getInt("CategoryId"));
                    s.setOwnerId(rs.getInt("OwnerId"));
                    s.setStatus(rs.getString("Status"));
                    s.setDescription(rs.getString("Description"));
                    s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    s.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    s.setThumbnailUrl(rs.getString("ThumbnailUrl"));
                    s.setCategoryName(rs.getString("categoryName")); // ← Tên chuyên ngành
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null; // không tìm thấy subject
    }
     public List<Subject> getAll() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM Subjects";

        try (PreparedStatement ps = db.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Subject s = new Subject(
                    rs.getInt("Id"),
                    rs.getString("Title"),
                    rs.getString("Tagline"),
                    rs.getInt("CategoryId"),
                    rs.getInt("OwnerId"),
                    rs.getString("Status"),
                    rs.getString("Description"),
                    rs.getTimestamp("CreatedAt"),
                    rs.getTimestamp("UpdatedAt"),
                    rs.getString("ThumbnailUrl")
                );
                subjects.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return subjects;
    }

}
