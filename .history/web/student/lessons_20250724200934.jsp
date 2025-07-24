<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Lesson" %>
<%@ page import="Model.Subject" %>
<%
    Subject subject = (Subject) request.getAttribute("subject");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Lessons of <%= subject != null ? subject.getTitle() : "Subject" %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(120deg, #f0f4ff 0%, #e6e9f0 100%);
            min-height: 100vh;
        }
        .lessons-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .lessons-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .lessons-header h2 {
            font-weight: 700;
            color: #3a3a7c;
            letter-spacing: 1px;
        }
        .lesson-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 24px rgba(60,60,120,0.08);
            padding: 1.5rem 2rem;
            margin-bottom: 1.5rem;
            transition: box-shadow 0.3s, transform 0.2s;
            border-left: 6px solid #667eea;
            position: relative;
        }
        .lesson-card:hover {
            box-shadow: 0 8px 32px rgba(60,60,120,0.16);
            transform: translateY(-2px) scale(1.01);
            border-left: 6px solid #4f5bd5;
        }
        .lesson-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #4f5bd5;
            margin-bottom: 0.5rem;
        }
        .lesson-meta {
            font-size: 0.95rem;
            color: #888;
            margin-bottom: 0.5rem;
        }
        .lesson-content {
            color: #444;
            margin-bottom: 1rem;
        }
        .lesson-actions {
            margin-top: 10px;
        }
        .btn-practice {
            background: linear-gradient(90deg, #667eea 0%, #4f5bd5 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 22px;
            font-weight: 500;
            font-size: 1rem;
            box-shadow: 0 2px 8px rgba(60,60,120,0.08);
            transition: background 0.2s, box-shadow 0.2s;
        }
        .btn-practice:hover {
            background: linear-gradient(90deg, #4f5bd5 0%, #667eea 100%);
            color: #fff;
            box-shadow: 0 4px 16px rgba(60,60,120,0.16);
        }
        .btn-all {
            background: #fff;
            color: #4f5bd5;
            border: 2px solid #4f5bd5;
            border-radius: 6px;
            padding: 8px 22px;
            font-weight: 500;
            font-size: 1rem;
            margin-top: 1.5rem;
            transition: background 0.2s, color 0.2s;
        }
        .btn-all:hover {
            background: #4f5bd5;
            color: #fff;
        }
        .lessons-list {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            justify-content: center;
            margin-bottom: 2rem;
        }
        .lesson-card {
            flex: 0 1 calc(50% - 1.5rem);
            min-width: 300px;
            max-width: 380px;
        }
        @media (max-width: 900px) {
            .lesson-card { flex: 0 1 100%; max-width: 100%; }
        }
        .filter-bar {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .filter-bar select {
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 1rem;
        }
    </style>
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
    <div class="lessons-container py-4">
        <div class="lessons-header">
            <h2>Lessons in <%= subject != null ? subject.getTitle() : "Subject" %></h2>
        </div>
        <%-- Filter bar --%>
        <div class="filter-bar">
            <select id="dimensionFilter" onchange="filterLessons()">
                <option value="">Tất cả phân loại</option>
                <%-- Lấy các dimension duy nhất --%>
                <% java.util.Set<String> dims = new java.util.HashSet<>();
                   if (lessons != null) for (Model.Lesson l : lessons) dims.add(l.getDimension());
                   for (String dim : dims) { %>
                    <option value="<%= dim %>"><%= dim %></option>
                <% } %>
            </select>
            <select id="statusFilter" onchange="filterLessons()">
                <option value="">Tất cả trạng thái</option>
                <% java.util.Set<String> stats = new java.util.HashSet<>();
                   if (lessons != null) for (Model.Lesson l : lessons) stats.add(l.getStatus());
                   for (String st : stats) { %>
                    <option value="<%= st %>"><%= st %></option>
                <% } %>
            </select>
        </div>
        <% if (lessons != null && !lessons.isEmpty()) { %>
        <div class="lessons-list" id="lessonsList">
            <% for (Lesson lesson : lessons) { %>
                <div class="lesson-card" data-dimension="<%= lesson.getDimension() %>" data-status="<%= lesson.getStatus() %>">
                    <div class="lesson-title"><%= lesson.getTitle() %></div>
                    <div class="lesson-meta">Dimension: <%= lesson.getDimension() %> | Status: <%= lesson.getStatus() %></div>
                    <div class="lesson-content"><%= lesson.getContent() != null ? lesson.getContent().substring(0, Math.min(100, lesson.getContent().length())) + (lesson.getContent().length() > 100 ? "..." : "") : "" %></div>
                    <div class="lesson-actions">
                        <form method="get" action="${pageContext.request.contextPath}/student/practice">
                            <input type="hidden" name="action" value="start" />
                            <input type="hidden" name="subjectId" value="<%= subject.getId() %>" />
                            <input type="hidden" name="lessonId" value="<%= lesson.getId() %>" />
                            <button type="submit" class="btn btn-practice">
                                <i class="fas fa-dumbbell me-1"></i>Luyện tập bài này
                            </button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
        <% } else { %>
            <div class="alert alert-info">No lessons found for this subject.</div>
        <% } %>
        <a href="${pageContext.request.contextPath}/student/practice?action=start&subjectId=<%= subject != null ? subject.getId() : 0 %>" class="btn btn-all">
            <i class="fas fa-dumbbell me-1"></i>Luyện tập toàn bộ môn học
        </a>
        <script>
            function filterLessons() {
                var dim = document.getElementById('dimensionFilter').value;
                var st = document.getElementById('statusFilter').value;
                var cards = document.querySelectorAll('.lesson-card');
                cards.forEach(function(card) {
                    var show = true;
                    if (dim && card.getAttribute('data-dimension') !== dim) show = false;
                    if (st && card.getAttribute('data-status') !== st) show = false;
                    card.style.display = show ? '' : 'none';
                });
            }
        </script>
    </div>
</body>
</html> 