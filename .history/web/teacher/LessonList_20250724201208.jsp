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
        /* ----- BODY ----- */
        body {
            font-family: Arial, sans-serif;
            background: #f7f7f7;
            padding: 40px;
            margin: 0;
        }

        /* ----- HEADER ----- */
        .header {
           
        }

        .header h2 {
            margin: 0;
        }

        .add-btn {
            padding: 8px 12px;
            background: #007BFF;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            transition: background 0.3s;
        }

        .add-btn:hover {
            background: #0056b3;
        }

        /* ----- LESSON CARD ----- */
        .lesson-card {
            display: flex;
            align-items: flex-start;
            background: #fff;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 10px;
            padding: 15px;
            cursor: pointer;
            transition: box-shadow 0.3s, transform 0.1s;
        }

        .lesson-card:hover {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .lesson-info {
            flex-grow: 1;
        }

        .lesson-info div {
            margin-bottom: 4px;
            line-height: 1.4;
        }

        .lesson-actions {
            margin-left: 20px;
        }

        .lesson-actions a {
            display: inline-block;
            margin-bottom: 5px;
            color: #007BFF;
            text-decoration: none;
            font-size: 1.2rem;
        }

        .lesson-actions a:hover {
            text-decoration: underline;
        }

        /* ----- HEADER NAVBAR basic fix ----- */
        .navbar-brand:hover {
            transform: scale(1.05);
            transition: transform 0.2s ease;
        }

        .nav-link {
            position: relative;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            transform: translateY(-1px);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 50%;
            background-color: #fff;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after {
            width: 100%;
        }

        .dropdown-menu {
            animation: fadeInDown 0.3s ease;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-item {
            transition: all 0.2s ease;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }

        .alert {
            animation: slideInDown 0.5s ease;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .navbar-brand span {
                font-size: 1.1rem !important;
            }
            .dropdown-menu {
                margin-top: 0.5rem;
            }
        }
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

    <div class="header">
        <h2>📚 Danh sách bài học</h2>
        <a href="${pageContext.request.contextPath}/lesson?action=detail" class="add-btn">➕ Thêm bài học mới</a>
    </div>

    <%-- Helper --%>
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
            <div><strong>Ngày tạo:</strong> <%= lesson.getCreatedAt() %> | <strong>Ngày cập nhật:</strong> <%= lesson.getUpdatedAt() != null ? lesson.getUpdatedAt() : "Chưa cập nhật" %></div>
        </div>
        <div class="lesson-actions">
            <a href="lesson?action=detail&id=<%= lesson.getId() %>" onclick="event.stopPropagation();">✏️</a>
            <a href="lesson?action=delete&id=<%= lesson.getId() %>&subjectId=<%= lesson.getSubjectId() %>" onclick="event.stopPropagation(); return confirm('Bạn chắc chắn muốn xoá chứ?');">🗑️</a>
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

