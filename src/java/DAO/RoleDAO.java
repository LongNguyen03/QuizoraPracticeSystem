package DAO;

import Model.Role;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBcontext {

    // Lấy Role theo ID
    public Role getRoleById(int id) {
        String sql = "SELECT id, name, description FROM Roles WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Role(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy Role theo tên
    public Role getRoleByName(String name) {
        String sql = "SELECT id, name, description FROM Roles WHERE LOWER(name) = LOWER(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            System.out.println("Searching for role with name: " + name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                System.out.println("Found role: " + role.getName() + " with ID: " + role.getId());
                return role;
            }
            System.out.println("No role found with name: " + name);
        } catch (SQLException e) {
            System.out.println("Error searching for role: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Lấy tất cả Role
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT id, name, description FROM Roles";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(new Role(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }

    // Thêm mới Role
    public boolean insertRole(Role role) {
        String sql = "INSERT INTO Roles(name, description) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật Role
    public boolean updateRole(Role role) {
        String sql = "UPDATE Roles SET name = ?, description = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            ps.setInt(3, role.getId());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa Role
    public boolean deleteRole(int id) {
        String sql = "DELETE FROM Roles WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
