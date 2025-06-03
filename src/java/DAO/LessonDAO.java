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
import Model.Lesson;

public class LessonDAO extends DBcontext {

    public List<Lesson> getAll() {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT * FROM Lessons";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Lesson lesson = new Lesson(
                    rs.getInt("Id"),
                    rs.getInt("PackageId"),
                    rs.getString("Title"),
                    rs.getString("Content"),
                    rs.getString("Status"),
                    rs.getTimestamp("CreatedAt"),
                    rs.getTimestamp("UpdatedAt")
                );
                list.add(lesson);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}

