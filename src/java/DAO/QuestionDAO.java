//package DAO;
//
//import Model.Question;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//
//public class QuestionDAO extends DBcontext {
//
//    public List<Question> getActiveQuestions() {
//        List<Question> list = new ArrayList<>();
//        String sql = "SELECT * FROM Questions WHERE Status = 'active'";
//        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//            while (rs.next()) {
//                Question q = new Question();
//                q.setId(rs.getInt("Id"));
//                q.setSubjectId(rs.getInt("SubjectId"));
//                q.setLessonId(rs.getInt("LessonId"));
//                q.setDimensionId(rs.getInt("DimensionId"));
//                q.setLevel(rs.getString("Level"));
//                q.setContent(rs.getString("Content"));
//                q.setStatus(rs.getString("Status"));
//                q.setImageUrl(rs.getBytes("ImageUrl"));  // sửa lấy dữ liệu dạng byte[]
//                q.setCreatedAt(rs.getTimestamp("CreatedAt"));
//                q.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
//                list.add(q);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    public Question getQuestionById(int id) {
//        String sql = "SELECT * FROM Questions WHERE Id = ?";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    Question q = new Question();
//                    q.setId(rs.getInt("Id"));
//                    q.setSubjectId(rs.getInt("SubjectId"));
//                    q.setLessonId(rs.getInt("LessonId"));
//                    q.setDimensionId(rs.getInt("DimensionId"));
//                    q.setLevel(rs.getString("Level"));
//                    q.setContent(rs.getString("Content"));
//                    q.setStatus(rs.getString("Status"));
//                    q.setImageUrl(rs.getBytes("ImageUrl"));  // sửa lấy dữ liệu dạng byte[]
//                    q.setCreatedAt(rs.getTimestamp("CreatedAt"));
//                    q.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
//                    return q;
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    public void createQuestion(Question q) {
//        String sql = "INSERT INTO Questions (SubjectId, LessonId, DimensionId, Level, Content, ImageUrl, Status, CreatedAt, UpdatedAt) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//
//            Timestamp now = new Timestamp(new Date().getTime());
//
//            ps.setInt(1, q.getSubjectId());
//            ps.setInt(2, q.getLessonId());
//            ps.setInt(3, q.getDimensionId());
//            ps.setString(4, q.getLevel());
//            ps.setString(5, q.getContent());
//            ps.setBytes(6, q.getImageUrl());  // nếu đây là ảnh byte[]
//            ps.setString(7, "Active");        // set status là "Active"
//            ps.setTimestamp(8, now);
//            ps.setTimestamp(9, now);
//
//            ps.executeUpdate();
//
//            try (ResultSet rs = ps.getGeneratedKeys()) {
//                if (rs.next()) {
//                    q.setId(rs.getInt(1)); // Gán lại id vào object Question
//                }
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public void updateQuestion(Question q) {
//        String sql = "UPDATE Questions SET SubjectId=?, LessonId=?, DimensionId=?, Level=?, Content=?, ImageUrl=?, UpdatedAt=? WHERE Id=?";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, q.getSubjectId());
//            ps.setInt(2, q.getLessonId());
//            ps.setInt(3, q.getDimensionId());
//            ps.setString(4, q.getLevel());
//            ps.setString(5, q.getContent());
//            ps.setBytes(6, q.getImageUrl());  // sửa set dữ liệu byte[]
//            ps.setTimestamp(7, new Timestamp(new Date().getTime()));
//            ps.setInt(8, q.getId());
//
//            ps.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public void deleteQuestion(int id) {
//        String sql = "UPDATE Questions SET Status='inactive' WHERE Id=?";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            ps.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public List<Question> getFilteredQuestions(
//            String subjectIdStr, String lessonIdStr, String dimensionIdStr,
//            String level, String status, String search) {
//
//        List<Question> list = new ArrayList<>();
//        String sql = "SELECT * FROM Questions WHERE 1=1";
//
//        List<Object> params = new ArrayList<>();
//
//        if (subjectIdStr != null && !subjectIdStr.isEmpty()) {
//            sql += " AND SubjectId = ?";
//            params.add(Integer.parseInt(subjectIdStr));
//        }
//
//        if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
//            sql += " AND LessonId = ?";
//            params.add(Integer.parseInt(lessonIdStr));
//        }
//
//        if (dimensionIdStr != null && !dimensionIdStr.isEmpty()) {
//            sql += " AND DimensionId = ?";
//            params.add(Integer.parseInt(dimensionIdStr));
//        }
//
//        if (level != null && !level.isEmpty()) {
//            sql += " AND Level = ?";
//            params.add(level);
//        }
//
//        if (status != null && !status.isEmpty()) {
//            sql += " AND Status = ?";
//            params.add(status);
//        }
//
//        if (search != null && !search.isEmpty()) {
//            sql += " AND Content LIKE ?";
//            params.add("%" + search + "%");
//        }
//
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//
//            for (int i = 0; i < params.size(); i++) {
//                ps.setObject(i + 1, params.get(i));
//            }
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Question q = new Question();
//                q.setId(rs.getInt("Id"));
//                q.setContent(rs.getString("Content"));
//                q.setSubjectId(rs.getInt("SubjectId"));
//                q.setLessonId(rs.getInt("LessonId"));
//                q.setDimensionId(rs.getInt("DimensionId"));
//                q.setLevel(rs.getString("Level"));
//                q.setStatus(rs.getString("Status"));
//                q.setImageUrl(rs.getBytes("ImageUrl"));  // sửa lấy dữ liệu byte[]
//                q.setCreatedAt(rs.getTimestamp("CreatedAt"));
//                q.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
//                list.add(q);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//}
