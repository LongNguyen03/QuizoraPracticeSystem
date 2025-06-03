package DAO;

import Model.SubjectCategory;
import java.sql.*;
import java.util.*;

public class SubjectCategoryDAO extends DBcontext {
    public List<SubjectCategory> getAllCategories() {
        List<SubjectCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM SubjectCategories WHERE Status = 'Active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SubjectCategory c = new SubjectCategory();
                c.setId(rs.getInt("Id"));
                c.setName(rs.getString("Name"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
