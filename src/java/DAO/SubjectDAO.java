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
        String sql = "SELECT * FROM Subjects WHERE Status = 'Active'";
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
}
