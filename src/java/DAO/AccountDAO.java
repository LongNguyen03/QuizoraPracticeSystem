package DAO;

import Model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AccountDAO extends DBcontext {

    // 1. Check login
    public Account login(String email, String passwordPlain) {
        String sql = "SELECT a.id, a.email, a.passwordHash, a.roleId, a.status, r.name AS roleName " +
                     "FROM Accounts a JOIN Roles r ON a.roleId = r.id WHERE a.email = ? AND a.status <> 'deleted'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("passwordHash");
                if (verifyPassword(passwordPlain, storedHash)) {
                    return extractAccount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Kiểm tra email đã tồn tại
    public boolean isEmailExists(String email) {
        String sql = "SELECT id FROM Accounts WHERE email = ? AND status <> 'deleted'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Đăng ký tài khoản mới
    public boolean register(Account acc) {
        String sql = "INSERT INTO Accounts(email, passwordHash, roleId, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, acc.getEmail());
            ps.setString(2, hashPassword(acc.getPasswordHash()));
            ps.setInt(3, acc.getRoleId());
            ps.setString(4, acc.getStatus());
            System.out.println("Registering account with email: " + acc.getEmail() + ", roleId: " + acc.getRoleId());
            int affected = ps.executeUpdate();
            System.out.println("Account registration affected rows: " + affected);
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        acc.setId(rs.getInt(1));
                        System.out.println("New account ID: " + acc.getId());
                    }
                }
            }
            return affected > 0;
        } catch (SQLException e) {
            System.out.println("Error registering account: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 4. Lấy Account theo email
    public Account getAccountByEmail(String email) {
        String sql = "SELECT a.id, a.email, a.passwordHash, a.roleId, a.status, r.name AS roleName " +
                     "FROM Accounts a JOIN Roles r ON a.roleId = r.id WHERE a.email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. Lấy Account theo ID
    public Account getAccountById(int id) {
        String sql = "SELECT a.id, a.email, a.passwordHash, a.roleId, a.status, r.name AS roleName " +
                     "FROM Accounts a JOIN Roles r ON a.roleId = r.id WHERE a.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 6. Cập nhật thông tin Account
    public boolean updateAccount(Account acc) {
        String sql = "UPDATE Accounts SET passwordHash = ?, roleId = ?, status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, acc.getPasswordHash()); // Không hash lại vì đã được hash từ trước
            ps.setInt(2, acc.getRoleId());
            ps.setString(3, acc.getStatus());
            ps.setInt(4, acc.getId());
            System.out.println("AccountDAO: Updating account ID " + acc.getId() + " with password hash: " + acc.getPasswordHash());
            int affected = ps.executeUpdate();
            System.out.println("AccountDAO: Update affected rows: " + affected);
            return affected > 0;
        } catch (SQLException e) {
            System.out.println("AccountDAO: Error updating account: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 7. Xóa Account (xóa mềm)
    public boolean deleteAccount(int id) {
        String sql = "UPDATE Accounts SET status = 'deleted' WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper: Extract Account from ResultSet
    private Account extractAccount(ResultSet rs) throws SQLException {
        Account acc = new Account();
        acc.setId(rs.getInt("id"));
        acc.setEmail(rs.getString("email"));
        acc.setPasswordHash(rs.getString("passwordHash"));
        acc.setRoleId(rs.getInt("roleId"));
        acc.setStatus(rs.getString("status"));
        acc.setRoleName(rs.getString("roleName"));
        return acc;
    }

    // Hash password (SHA-256 for demo purposes)
    private String hashPassword(String plain) {
        return org.apache.commons.codec.digest.DigestUtils.sha256Hex(plain);
    }

    private boolean verifyPassword(String plain, String storedHash) {
        return hashPassword(plain).equals(storedHash);
    }

    // Lấy danh sách tất cả user (trừ user đã xóa và admin)
    public static List<Account> getAllUsers() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.id, a.email, a.passwordHash, a.roleId, a.status, r.name AS roleName " +
                     "FROM Accounts a JOIN Roles r ON a.roleId = r.id " +
                     "WHERE a.status <> 'deleted' AND a.roleId <> 1";
        DBcontext db = new DBcontext();
        try (Connection conn = db.connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Account acc = new Account(
                    rs.getInt("id"),
                    rs.getString("email"),
                    rs.getString("passwordHash"),
                    rs.getInt("roleId"),
                    rs.getString("status"),
                    rs.getString("roleName")
                );
                list.add(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật status user theo id
    public static boolean updateUserStatus(int id, String status) {
        String sql = "UPDATE Accounts SET status = ? WHERE id = ?";
        DBcontext db = new DBcontext();
        try (Connection conn = db.connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra email đã bị xóa mềm
    public boolean isEmailDeleted(String email) {
        String sql = "SELECT id FROM Accounts WHERE email = ? AND status = 'deleted'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
