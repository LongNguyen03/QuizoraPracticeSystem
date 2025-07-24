package DAO;

import Model.FeedbackReply;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackReplyDAO extends DBcontext {
    public void addReply(FeedbackReply reply) {
        String sql = "INSERT INTO FeedbackReplies (FeedbackId, ResponderId, Content, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reply.getFeedbackId());
            ps.setInt(2, reply.getResponderId());
            ps.setString(3, reply.getContent());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<FeedbackReply> getRepliesByFeedbackId(int feedbackId) {
        List<FeedbackReply> list = new ArrayList<>();
        String sql = "SELECT * FROM FeedbackReplies WHERE FeedbackId = ? ORDER BY CreatedAt ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FeedbackReply reply = new FeedbackReply();
                reply.setId(rs.getInt("Id"));
                reply.setFeedbackId(rs.getInt("FeedbackId"));
                reply.setResponderId(rs.getInt("ResponderId"));
                reply.setContent(rs.getString("Content"));
                reply.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(reply);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
