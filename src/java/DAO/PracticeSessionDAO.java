package DAO;

import Model.PracticeSession;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PracticeSessionDAO extends DBcontext {
    
    /**
     * Tạo practice session mới
     */
    public int createPracticeSession(PracticeSession session) {
        String sql = "INSERT INTO PracticeSessions (AccountId, SubjectId, LessonId, StartTime, EndTime, TotalScore, Completed) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, session.getAccountId());
            ps.setInt(2, session.getSubjectId());
            ps.setObject(3, session.getLessonId()); // nullable
            ps.setTimestamp(4, session.getStartTime());
            ps.setTimestamp(5, session.getEndTime());
            ps.setObject(6, session.getTotalScore()); // nullable
            ps.setBoolean(7, session.isCompleted());
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int sessionId = rs.getInt(1);
                    System.out.println("PracticeSessionDAO: Created session with ID: " + sessionId);
                    return sessionId;
                }
            }
        } catch (SQLException e) {
            System.out.println("PracticeSessionDAO: Error creating session: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("PracticeSessionDAO: Failed to create session");
        return -1;
    }
    
    /**
     * Cập nhật practice session
     */
    public boolean updatePracticeSession(PracticeSession session) {
        String sql = "UPDATE PracticeSessions SET EndTime = ?, TotalScore = ?, Completed = ? WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, session.getEndTime());
            ps.setObject(2, session.getTotalScore());
            ps.setBoolean(3, session.isCompleted());
            ps.setInt(4, session.getId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("PracticeSessionDAO: Updated session " + session.getId() + " - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("PracticeSessionDAO: Error updating session: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy practice session theo ID
     */
    public PracticeSession getPracticeSessionById(int sessionId) {
        String sql = "SELECT * FROM PracticeSessions WHERE Id = ?";
        System.out.println("PracticeSessionDAO: Getting session by ID: " + sessionId);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PracticeSession session = mapRowToPracticeSession(rs);
                    System.out.println("PracticeSessionDAO: Found session - ID: " + session.getId() + 
                                     ", AccountId: " + session.getAccountId() + 
                                     ", SubjectId: " + session.getSubjectId() + 
                                     ", Completed: " + session.isCompleted());
                    return session;
                }
            }
        } catch (SQLException e) {
            System.out.println("PracticeSessionDAO: Error getting session: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("PracticeSessionDAO: Session not found");
        return null;
    }
    
    /**
     * Lấy practice sessions của một account
     */
    public List<PracticeSession> getPracticeSessionsByAccountId(int accountId) {
        List<PracticeSession> sessions = new ArrayList<>();
        String sql = "SELECT ps.*, s.Title AS SubjectTitle, l.Title AS LessonTitle " +
                     "FROM PracticeSessions ps " +
                     "LEFT JOIN Subjects s ON ps.SubjectId = s.Id " +
                     "LEFT JOIN Lessons l ON ps.LessonId = l.Id " +
                     "WHERE ps.AccountId = ? " +
                     "ORDER BY ps.StartTime DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapRowToPracticeSessionWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }
    
    /**
     * Lấy practice sessions theo subject
     */
    public List<PracticeSession> getPracticeSessionsBySubject(int accountId, int subjectId) {
        List<PracticeSession> sessions = new ArrayList<>();
        String sql = "SELECT ps.*, s.Title AS SubjectTitle, l.Title AS LessonTitle " +
                     "FROM PracticeSessions ps " +
                     "LEFT JOIN Subjects s ON ps.SubjectId = s.Id " +
                     "LEFT JOIN Lessons l ON ps.LessonId = l.Id " +
                     "WHERE ps.AccountId = ? AND ps.SubjectId = ? " +
                     "ORDER BY ps.StartTime DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapRowToPracticeSessionWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sessions;
    }
    
    /**
     * Xóa practice session
     */
    public boolean deletePracticeSession(int sessionId) {
        String sql = "DELETE FROM PracticeSessions WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Map ResultSet row to PracticeSession object
     */
    private PracticeSession mapRowToPracticeSession(ResultSet rs) throws SQLException {
        PracticeSession session = new PracticeSession();
        session.setId(rs.getInt("Id"));
        session.setAccountId(rs.getInt("AccountId"));
        session.setSubjectId(rs.getInt("SubjectId"));
        session.setLessonId(rs.getObject("LessonId", Integer.class));
        session.setStartTime(rs.getTimestamp("StartTime"));
        session.setEndTime(rs.getTimestamp("EndTime"));
        session.setTotalScore(rs.getObject("TotalScore", Double.class));
        session.setCompleted(rs.getBoolean("Completed"));
        return session;
    }
    
    /**
     * Map ResultSet row to PracticeSession object with additional details
     */
    private PracticeSession mapRowToPracticeSessionWithDetails(ResultSet rs) throws SQLException {
        PracticeSession session = mapRowToPracticeSession(rs);
        session.setSubjectTitle(rs.getString("SubjectTitle"));
        session.setLessonTitle(rs.getString("LessonTitle"));
        return session;
    }
} 