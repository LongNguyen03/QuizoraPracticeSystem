package DAO;

import Model.Feedback;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO extends DBcontext {
    public void addFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedbacks (AccountId, Content, Status, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, feedback.getAccountId());
            ps.setString(2, feedback.getContent());
            ps.setString(3, feedback.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Feedback> getFeedbacksByAccountId(int accountId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks WHERE AccountId = ? ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, a.Email as AccountEmail, " +
                 "u.FirstName, u.MiddleName, u.LastName " +
                 "FROM Feedbacks f " +
                 "JOIN Accounts a ON f.AccountId = a.Id " +
                 "LEFT JOIN UserProfiles u ON a.Id = u.AccountId " +
                 "ORDER BY f.CreatedAt DESC";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Feedback fb = mapRowToFeedback(rs);
            String firstName = rs.getString("FirstName");
            String middleName = rs.getString("MiddleName");
            String lastName = rs.getString("LastName");
            String fullName = (firstName != null ? firstName : "") +
                              (middleName != null && !middleName.isEmpty() ? " " + middleName : "") +
                              (lastName != null ? " " + lastName : "");
            fb.setAccountName(fullName.trim());
            fb.setAccountEmail(rs.getString("AccountEmail"));
            list.add(fb);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public void updateFeedbackStatus(int feedbackId, String status) {
        String sql = "UPDATE Feedbacks SET Status = ?, UpdatedAt = GETDATE() WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, feedbackId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Feedback mapRowToFeedback(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setId(rs.getInt("Id"));
        fb.setAccountId(rs.getInt("AccountId"));
        fb.setContent(rs.getString("Content"));
        fb.setStatus(rs.getString("Status"));
        fb.setCreatedAt(rs.getTimestamp("CreatedAt"));
        fb.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return fb;
    }
}
