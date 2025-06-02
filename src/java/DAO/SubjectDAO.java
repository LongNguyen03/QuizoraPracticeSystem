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

public class SubjectDAO extends DBcontext{

    public List<Subject> getAll() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM Subjects";

        try (PreparedStatement ps = connection.prepareStatement(sql);
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

