package DAO;

import Model.FavoriteQuiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoriteQuizDAO extends DBcontext {
    
    /**
     * Lấy danh sách favorite quizzes của một account
     */
    public List<FavoriteQuiz> getFavoriteQuizzesByAccountId(int accountId) {
        List<FavoriteQuiz> favorites = new ArrayList<>();
        String sql = "SELECT fq.AccountId, fq.QuizId, q.Name as QuizName, s.Title as SubjectTitle " +
                     "FROM FavoriteQuizzes fq " +
                     "JOIN Quizzes q ON fq.QuizId = q.Id " +
                     "JOIN Subjects s ON q.SubjectId = s.Id " +
                     "WHERE fq.AccountId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FavoriteQuiz favorite = new FavoriteQuiz(
                    rs.getInt("AccountId"),
                    rs.getInt("QuizId"),
                    null, // accountEmail
                    rs.getString("QuizName"),
                    rs.getString("SubjectTitle")
                );
                favorites.add(favorite);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return favorites;
    }
    
    /**
     * Thêm quiz vào favorites
     */
    public boolean addToFavorites(int accountId, int quizId) {
        String sql = "INSERT INTO FavoriteQuizzes (AccountId, QuizId) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, quizId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa quiz khỏi favorites
     */
    public boolean removeFromFavorites(int accountId, int quizId) {
        String sql = "DELETE FROM FavoriteQuizzes WHERE AccountId = ? AND QuizId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, quizId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Kiểm tra xem quiz có trong favorites không
     */
    public boolean isFavorite(int accountId, int quizId) {
        String sql = "SELECT COUNT(*) FROM FavoriteQuizzes WHERE AccountId = ? AND QuizId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
} 