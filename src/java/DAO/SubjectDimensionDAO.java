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
import Model.SubjectDimension;

public class SubjectDimensionDAO extends DBcontext {
    
    public List<SubjectDimension> getAll() {
        List<SubjectDimension> list = new ArrayList<>();
        String sql = "SELECT * FROM SubjectDimensions";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SubjectDimension sd = new SubjectDimension(
                    rs.getInt("Id"),
                    rs.getInt("SubjectId"),
                    rs.getString("Type"),
                    rs.getString("Name"),
                    rs.getString("Description")
                );
                list.add(sd);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
