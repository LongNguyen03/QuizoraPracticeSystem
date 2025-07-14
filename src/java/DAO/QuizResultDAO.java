package DAO;

import Model.QuizResult;
import Model.QuizUserAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizResultDAO extends DBcontext {

    /**
     * Lưu quiz result và trả về ID
     */
    public int saveQuizResult(QuizResult result) {
        String sql = "INSERT INTO QuizResults (QuizId, AccountId, Score, Passed, AttemptDate, CompletionTime) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, result.getQuizId());
            ps.setInt(2, result.getAccountId());
            ps.setDouble(3, result.getScore());
            ps.setBoolean(4, result.isPassed());
            ps.setTimestamp(5, new Timestamp(result.getAttemptDate().getTime()));
            ps.setTimestamp(6, result.getCompletionTime() != null
                    ? new Timestamp(result.getCompletionTime().getTime()) : null);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Lấy quiz result theo ID
     */
    public QuizResult getQuizResultById(int resultId) {
        String sql = "SELECT * FROM QuizResults WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, resultId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuizResult(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy quiz results của một account
     */
    public List<QuizResult> getQuizResultsByAccountId(int accountId) {
        List<QuizResult> results = new ArrayList<>();
        String sql = "SELECT qr.*, q.Name as QuizName, s.Title as SubjectTitle "
                + "FROM QuizResults qr "
                + "JOIN Quizzes q ON qr.QuizId = q.Id "
                + "JOIN Subjects s ON q.SubjectId = s.Id "
                + "WHERE qr.AccountId = ? "
                + "ORDER BY qr.AttemptDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizResult result = mapRowToQuizResult(rs);
                    result.setQuizName(rs.getString("QuizName"));
                    result.setSubjectTitle(rs.getString("SubjectTitle"));
                    results.add(result);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    /**
     * Lấy quiz results của một quiz
     */
    public List<QuizResult> getQuizResultsByQuizId(int quizId) {
        List<QuizResult> results = new ArrayList<>();
        String sql = "SELECT * FROM QuizResults WHERE QuizId = ? ORDER BY AttemptDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(mapRowToQuizResult(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    /**
     * Tính điểm trung bình của một account
     */
    public double getAverageScoreByAccountId(int accountId) {
        String sql = "SELECT AVG(Score) as AverageScore FROM QuizResults WHERE AccountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("AverageScore");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Đếm số quiz đã hoàn thành của một account
     */
    public int getCompletedQuizCountByAccountId(int accountId) {
        String sql = "SELECT COUNT(*) as Count FROM QuizResults WHERE AccountId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private QuizResult mapRowToQuizResult(ResultSet rs) throws SQLException {
        QuizResult result = new QuizResult();
        result.setId(rs.getInt("Id"));
        result.setQuizId(rs.getInt("QuizId"));
        result.setAccountId(rs.getInt("AccountId"));
        result.setScore(rs.getDouble("Score"));
        result.setPassed(rs.getBoolean("Passed"));
        result.setAttemptDate(rs.getTimestamp("AttemptDate"));

        // Đọc CompletionTime nếu có
        Timestamp completionTime = rs.getTimestamp("CompletionTime");
        if (completionTime != null) {
            result.setCompletionTime(completionTime);
        }

        return result;
    }

    public void calculateAndUpdateResult(int resultId) {
        // 1️⃣ Lấy toàn bộ user answers của kết quả này
        List<QuizUserAnswer> answers = new QuizUserAnswerDAO().getUserAnswersByResultId(resultId);

        int totalQuestions = answers.size();
        int correctAnswers = 0;

        for (QuizUserAnswer ans : answers) {
            if (ans.isCorrect()) {
                correctAnswers++;
            }
        }

        // 2️⃣ Tính điểm %
        double score = 0;
        if (totalQuestions > 0) {
            score = ((double) correctAnswers / totalQuestions) * 100;
        }

        // 3️⃣ Xác định pass/fail (ví dụ pass nếu >= 50)
        boolean passed = score >= 50; // Hoặc lấy passRate từ Quiz cũng được

        // 4️⃣ Update lại DB
        String sql = "UPDATE QuizResults SET Score = ?, Passed = ? WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDouble(1, score);
            ps.setBoolean(2, passed);
            ps.setInt(3, resultId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
