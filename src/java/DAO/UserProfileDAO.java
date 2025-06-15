package DAO;

import Model.UserProfile;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserProfileDAO extends DBcontext {

    // Tạo mới profile (thường là cùng lúc khi register)
    public boolean insertUserProfile(UserProfile profile) {
        String sql = "INSERT INTO UserProfiles(accountId, firstName, middleName, lastName, gender, mobile, dateOfBirth, avatarUrl) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, profile.getAccountId());
            ps.setString(2, profile.getFirstName());
            ps.setString(3, profile.getMiddleName());
            ps.setString(4, profile.getLastName());
            ps.setString(5, profile.getGender());
            ps.setString(6, profile.getMobile());
            if (profile.getDateOfBirth() != null) {
                ps.setDate(7, new java.sql.Date(profile.getDateOfBirth().getTime()));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }
            ps.setString(8, profile.getAvatarUrl());
            System.out.println("Inserting user profile for accountId: " + profile.getAccountId());
            int affected = ps.executeUpdate();
            System.out.println("User profile insertion affected rows: " + affected);
            return affected > 0;
        } catch (SQLException e) {
            System.out.println("Error inserting user profile: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Lấy profile theo accountId
    public UserProfile getProfileByAccountId(int accountId) {
        String sql = "SELECT accountId, firstName, middleName, lastName, gender, mobile, dateOfBirth, avatarUrl " +
                     "FROM UserProfiles WHERE accountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserProfile(
                    rs.getInt("accountId"),
                    rs.getString("firstName"),
                    rs.getString("middleName"),
                    rs.getString("lastName"),
                    rs.getString("gender"),
                    rs.getString("mobile"),
                    rs.getDate("dateOfBirth"),
                    rs.getString("avatarUrl")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy profile kèm thông tin account
    public UserProfile getProfileWithAccount(int accountId) {
        String sql = "SELECT up.*, a.email, a.status, r.name as roleName " +
                     "FROM UserProfiles up " +
                     "JOIN Accounts a ON up.accountId = a.id " +
                     "JOIN Roles r ON a.roleId = r.id " +
                     "WHERE up.accountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserProfile(
                    rs.getInt("accountId"),
                    rs.getString("firstName"),
                    rs.getString("middleName"),
                    rs.getString("lastName"),
                    rs.getString("gender"),
                    rs.getString("mobile"),
                    rs.getDate("dateOfBirth"),
                    rs.getString("avatarUrl")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật thông tin profile
    public boolean updateUserProfile(UserProfile profile) {
        String sql = "UPDATE UserProfiles SET firstName = ?, middleName = ?, lastName = ?, gender = ?, mobile = ?, dateOfBirth = ?, avatarUrl = ? " +
                     "WHERE accountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, profile.getFirstName());
            ps.setString(2, profile.getMiddleName());
            ps.setString(3, profile.getLastName());
            ps.setString(4, profile.getGender());
            ps.setString(5, profile.getMobile());
            if (profile.getDateOfBirth() != null) {
                ps.setDate(6, new java.sql.Date(profile.getDateOfBirth().getTime()));
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }
            ps.setString(7, profile.getAvatarUrl());
            ps.setInt(8, profile.getAccountId());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật avatar
    public boolean updateAvatar(int accountId, String avatarUrl) {
        String sql = "UPDATE UserProfiles SET avatarUrl = ? WHERE accountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm kiếm profile theo tên hoặc email
    public List<UserProfile> searchProfiles(String keyword) {
        List<UserProfile> list = new ArrayList<>();
        String sql = "SELECT up.* FROM UserProfiles up " +
                     "JOIN Accounts a ON up.accountId = a.id " +
                     "WHERE up.firstName LIKE ? OR up.middleName LIKE ? OR up.lastName LIKE ? OR a.email LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new UserProfile(
                    rs.getInt("accountId"),
                    rs.getString("firstName"),
                    rs.getString("middleName"),
                    rs.getString("lastName"),
                    rs.getString("gender"),
                    rs.getString("mobile"),
                    rs.getDate("dateOfBirth"),
                    rs.getString("avatarUrl")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Xóa profile (thường ít dùng, vì xóa tài khoản thì xóa cascade profile)
    public boolean deleteUserProfile(int accountId) {
        String sql = "DELETE FROM UserProfiles WHERE accountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách tất cả profile (nếu cần)
    public List<UserProfile> getAllProfiles() {
        List<UserProfile> list = new ArrayList<>();
        String sql = "SELECT accountId, firstName, middleName, lastName, gender, mobile, dateOfBirth, avatarUrl FROM UserProfiles";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new UserProfile(
                    rs.getInt("accountId"),
                    rs.getString("firstName"),
                    rs.getString("middleName"),
                    rs.getString("lastName"),
                    rs.getString("gender"),
                    rs.getString("mobile"),
                    rs.getDate("dateOfBirth"),
                    rs.getString("avatarUrl")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
