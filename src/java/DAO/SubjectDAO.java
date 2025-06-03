package DAO;

import Model.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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

}
