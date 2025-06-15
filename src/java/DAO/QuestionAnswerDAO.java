///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package DAO;
//
//import Model.QuestionAnswer;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//
///**
// *
// * @author kan3v
// */
//public class QuestionAnswerDAO extends DBcontext{
//
//    public List<QuestionAnswer> getAnswersByQuestionId(int questionId) {
//        List<QuestionAnswer> list = new ArrayList<>();
//        String sql = "SELECT * FROM QuestionAnswers WHERE QuestionId = ? ORDER BY AnswerOrder ASC";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, questionId);
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    QuestionAnswer ans = new QuestionAnswer();
//                    ans.setId(rs.getInt("Id"));
//                    ans.setQuestionId(rs.getInt("QuestionId"));
//                    ans.setContent(rs.getString("Content"));
//                    ans.setCorrect(rs.getBoolean("IsCorrect"));
//                    ans.setAnswerOrder(rs.getInt("AnswerOrder"));
//                    list.add(ans);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//// Lưu (thêm hoặc cập nhật) câu trả lời cho question
//    public void saveQuestionAnswers(int questionId, List<QuestionAnswer> answers) {
//        // Xóa toàn bộ câu trả lời cũ trước
//        String deleteSql = "DELETE FROM QuestionAnswers WHERE QuestionId = ?";
//        try (PreparedStatement ps = connection.prepareStatement(deleteSql)) {
//            ps.setInt(1, questionId);
//            ps.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        // Thêm mới
//        String insertSql = "INSERT INTO QuestionAnswers (QuestionId, Content, IsCorrect, AnswerOrder) VALUES (?, ?, ?, ?)";
//        try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
//            for (int i = 0; i < answers.size(); i++) {
//                QuestionAnswer ans = answers.get(i);
//                ps.setInt(1, questionId);
//                ps.setString(2, ans.getContent());
//                ps.setBoolean(3, ans.isCorrect());
//                ps.setInt(4, i + 1); // order bắt đầu từ 1
//                ps.addBatch();
//            }
//            ps.executeBatch();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//}
