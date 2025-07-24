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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f7f7f7; padding: 40px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .lesson-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 1.5rem; margin-bottom: 18px; transition: box-shadow 0.2s, transform 0.1s; display: flex; align-items: flex-start; }
        .lesson-card:hover { box-shadow: 0 6px 18px rgba(0,0,0,0.13); transform: translateY(-2px); }
        .lesson-info { flex-grow: 1; }
        .lesson-info div { margin-bottom: 4px; line-height: 1.4; }
        .lesson-actions { margin-left: 20px; display: flex; flex-direction: column; gap: 8px; }
        .lesson-actions a { padding: 6px 14px; border-radius: 6px; font-size: 1rem; text-decoration: none; transition: background 0.2s; }
        .lesson-actions a.edit { background: #e3e8ff; color: #3b3b7a; }
        .lesson-actions a.edit:hover { background: #b2bfff; }
        .lesson-actions a.delete { background: #ffe3e3; color: #a33b3b; }
        .lesson-actions a.delete:hover { background: #ffb2b2; }
        .badge { font-size: 0.95rem; }
        .add-btn { padding: 10px 22px; background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); color: #fff; border-radius: 8px; font-weight: 500; border: none; text-decoration: none; transition: background 0.2s; }
        .add-btn:hover { background: linear-gradient(90deg, #764ba2 0%, #667eea 100%); color: #fff; }

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
    <jsp:include page="../views/components/header.jsp" />
<%
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
%>
<%! 
    public String getSubjectName(int id, java.util.List<Model.Subject> subjects) {
        for (Model.Subject s : subjects) {
            if (s.getId() == id) return s.getTitle();
        }
        return "";
    }
%>
    <div class="header">
        <h2 class="fw-bold text-primary"><i class="fas fa-book me-2"></i>Danh sách bài học</h2>
        <a href="${pageContext.request.contextPath}/lesson?action=detail" class="add-btn"><i class="fas fa-plus me-1"></i> Thêm bài học mới</a>
    </div>
    <div class="container-fluid px-0">
        <% if (lessons != null && !lessons.isEmpty()) { %>
            <% for (Lesson lesson : lessons) { %>
            <div class="lesson-card" data-id="<%= lesson.getId() %>">
                <div class="lesson-info">
                    <div class="fw-semibold mb-1"><i class="fas fa-chalkboard text-primary me-1"></i> <%= lesson.getTitle() %></div>
                    <div class="mb-1">
                        <span class="badge bg-secondary me-1"><i class="fas fa-book me-1"></i> <%= getSubjectName(lesson.getSubjectId(), subjects) %></span>
                        <span class="badge bg-info text-dark me-1"><i class="fas fa-layer-group me-1"></i> <%= lesson.getDimension() %></span>
                        <span class="badge bg-light text-dark"><i class="fas fa-toggle-on me-1"></i> <%= lesson.getStatus() %></span>
                    </div>
                    <div class="text-muted small">
                        <i class="fas fa-calendar-plus me-1"></i> <strong>Ngày tạo:</strong> <%= lesson.getCreatedAt() %>
                        &nbsp;|&nbsp;
                        <i class="fas fa-calendar-check me-1"></i> <strong>Ngày cập nhật:</strong> <%= lesson.getUpdatedAt() != null ? lesson.getUpdatedAt() : "Chưa cập nhật" %>
                    </div>
                </div>
                <div class="lesson-actions ms-auto">
                    <a href="lesson?action=detail&id=<%= lesson.getId() %>" class="edit" onclick="event.stopPropagation();"><i class="fas fa-pen"></i> Edit</a>
                    <a href="lesson?action=delete&id=<%= lesson.getId() %>&subjectId=<%= lesson.getSubjectId() %>" class="delete" onclick="event.stopPropagation(); return confirm('Bạn chắc chắn muốn xoá chứ?');"><i class="fas fa-trash"></i> Delete</a>
                </div>
            </div>
            <% } %>
        <% } else { %>
            <div class="alert alert-info text-center">Không có bài học nào được tìm thấy...</div>
        <% } %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

