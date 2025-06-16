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
        tr.clickable-row {
            cursor: pointer;
        }
        td.actions a {
            margin-right: 8px;
        }
    </style>
    <script>
        window.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('tr.clickable-row').forEach(function(row) {
                row.addEventListener('click', function() {
                    var lessonId = this.getAttribute('data-lesson-id');
                    window.location.href = 'QuestionController?action=list&lessonId=' + lessonId;
                });
            });
        });
    </script>
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
            <tr class="clickable-row" data-lesson-id="<%= lesson.getId() %>">
                <td><%= lesson.getId() %></td>
                <td><%= lesson.getSubjectId() %></td>
                <td><%= lesson.getTitle() %></td>
                <td><%= lesson.getContent() %></td>
                <td><%= lesson.getDimension() %></td>
                <td><%= lesson.getStatus() %></td>
                <td><%= lesson.getCreatedAt() %></td>
                <td><%= lesson.getUpdatedAt() != null ? lesson.getUpdatedAt() : "Chưa cập nhật" %></td>
                <td class="actions">
                    <a href="lesson?action=detail&id=<%= lesson.getId() %>" onclick="event.stopPropagation();">✏️ Sửa</a>
                    <a href="lesson?action=delete&id=<%= lesson.getId() %>&subjectId=<%= lesson.getSubjectId() %>" onclick="event.stopPropagation(); return confirm('Bạn chắc chắn muốn xoá chứ? 😥');">🗑️ Xoá</a>
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
        <a href="lesson?action=detail" style="padding:8px 12px; background:#007BFF; color:#fff; text-decoration:none; border-radius:4px;">
            ➕ Thêm bài học mới
        </a>
    </div>
</body>
</html>
