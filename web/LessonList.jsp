<%-- 
    Document   : LessonList
    Created on : Jun 14, 2025, 8:07:40 PM
    Author     : kan3v
--%>
<%@page import="java.util.List"%>
<%@page import="Model.Lesson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lesson List</title>
    <style>
        table {
            width: 95%;
            margin: auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #999;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f3f3f3;
        }
        h2 {
            text-align: center;
        }
        .action-links a {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <h2>📚 Danh sách bài học (Lesson List)</h2>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Subject ID</th>
                <th>Tiêu đề</th>
                <th>Nội dung</th>
                <th>Phân loại</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Ngày cập nhật</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
                if (lessons != null && !lessons.isEmpty()) {
                    for (Lesson lesson : lessons) {
            %>
            <tr>
                <td><%= lesson.getId() %></td>
                <td><%= lesson.getSubjectId() %></td>
                <td><%= lesson.getTitle() %></td>
                <td><%= lesson.getContent() %></td>
                <td><%= lesson.getDimension() %></td>
                <td><%= lesson.getStatus() %></td>
                <td><%= lesson.getCreatedAt() %></td>
                <td><%= lesson.getUpdatedAt() != null ? lesson.getUpdatedAt() : "Chưa cập nhật" %></td>
                <td class="action-links">
                    <a href="lesson?action=detail&id=<%= lesson.getId() %>">✏️ Sửa</a>
                    <a href="lesson?action=delete&id=<%= lesson.getId() %>&subjectId=<%= lesson.getSubjectId() %>"
                       onclick="return confirm('Bạn chắc chắn muốn xoá chứ? 😥');">🗑️ Xoá</a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="9" style="text-align: center;">Không có bài học nào được tìm thấy... Có lẽ giáo viên chưa đăng bài?</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <div style="text-align: center; margin-top: 20px;">
        <a href="lesson?action=detail">➕ Thêm bài học mới</a>
    </div>
</body>
</html>
