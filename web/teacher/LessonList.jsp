<%-- 
    Document   : LessonList
    Created on : Jun 14, 2025, 8:07:40 PM
    Author     : kan3v
--%>
<%@page import="java.util.List"%>
<%@page import="Model.Lesson, Model.Subject"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lesson List</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; padding: 40px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { margin: 0; }
        .add-btn { padding: 8px 12px; background: #007BFF; color: #fff; text-decoration: none; border-radius: 4px; }
        .lesson-card { display: flex; align-items: center; background: #fff; border: 1px solid #ccc; box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 10px; padding: 10px; cursor: pointer; }
        .lesson-info { flex-grow: 1; }
        .lesson-info div { margin-bottom: 4px; }
        .lesson-actions { margin-left: 15px; }
        .lesson-actions a { display: block; margin-bottom: 5px; color: #007BFF; text-decoration: none; }
        .lesson-actions a:hover { text-decoration: underline; }
    </style>
    <script>
        window.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.lesson-card').forEach(function(card) {
                card.addEventListener('click', function(e) {
                    if (e.target.tagName.toLowerCase() === 'a') return;
                    var id = this.getAttribute('data-id');
                    window.location.href = '${pageContext.request.contextPath}/QuestionController?action=list&lessonId=' + id;
                });
            });
        });
    </script>
</head>
<body>
    <div class="header">
        <h2>📚 Danh sách bài học</h2>
        <a href="${pageContext.request.contextPath}/lesson?action=detail" class="add-btn">➕ Thêm bài học mới</a>
    </div>

    <%-- Helper để lấy tên Subject theo id --%>
    <%! public String getSubjectName(int id, List<Subject> subjects) {
        for (Subject s : subjects) {
            if (s.getId() == id) return s.getTitle();
        }
        return "";
    } %>

    <%
        List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
        List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
        if (subjects == null) subjects = new java.util.ArrayList<>();
    %>

    <%
        if (lessons != null && !lessons.isEmpty()) {
            for (Lesson lesson : lessons) {
    %>
    <div class="lesson-card" data-id="<%= lesson.getId() %>">
        <div class="lesson-info">
            <div><strong>ID:</strong> <%= lesson.getId() %> — <strong>Subject:</strong> <%= getSubjectName(lesson.getSubjectId(), subjects) %></div>
            <div><strong>Tiêu đề:</strong> <%= lesson.getTitle() %></div>
            <div><strong>Dimension:</strong> <%= lesson.getDimension() %></div>
            <div><strong>Trạng thái:</strong> <%= lesson.getStatus() %></div>
            <div><strong>Ngày tạo:</strong> <%= lesson.getCreatedAt() %> | <strong>Ngày cập nhật:</strong> <%= lesson.getUpdatedAt()!=null?lesson.getUpdatedAt():"Chưa cập nhật" %></div>
        </div>
        <div class="lesson-actions">
            <a href="${pageContext.request.contextPath}/lesson?action=detail&id=<%= lesson.getId() %>" onclick="event.stopPropagation();">✏️ Sửa</a>
            <a href="${pageContext.request.contextPath}/lesson?action=delete&id=<%= lesson.getId() %>&subjectId=<%= lesson.getSubjectId() %>" onclick="event.stopPropagation(); return confirm('Bạn chắc chắn muốn xoá chứ?');">🗑️ Xoá</a>
        </div>
    </div>
    <%
            }
        } else {
    %>
    <p>Không có bài học nào được tìm thấy...</p>
    <%
        }
    %>
</body>
</html>
