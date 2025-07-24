<%-- 
    Document   : quiz_list
    Created on : Jul 3, 2025, 10:29:10 PM
    Author     : kan3v
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Quiz" %>
<%
    List<Quiz> quizList = (List<Quiz>) request.getAttribute("quizList");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Quiz</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
        <style>
            body { background: #f7f7f7; padding: 40px; }
            .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
            .quiz-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 1.5rem; margin-bottom: 18px; transition: box-shadow 0.2s, transform 0.1s; display: flex; align-items: center; }
            .quiz-card:hover { box-shadow: 0 6px 18px rgba(0,0,0,0.13); transform: translateY(-2px); }
            .quiz-info { flex-grow: 1; }
            .quiz-info .title { font-size: 1.2rem; font-weight: 600; color: #764ba2; margin-bottom: 6px; }
            .quiz-info .meta { font-size: 0.97rem; color: #888; margin-bottom: 4px; }
            .quiz-info .badge { font-size: 0.97rem; }
            .quiz-actions { display: flex; gap: 10px; }
            .quiz-actions a { padding: 7px 16px; border-radius: 6px; font-size: 1rem; text-decoration: none; transition: background 0.2s; }
            .quiz-actions a.edit { background: #e3e8ff; color: #3b3b7a; }
            .quiz-actions a.edit:hover { background: #b2bfff; }
            .quiz-actions a.delete { background: #ffe3e3; color: #a33b3b; }
            .quiz-actions a.delete:hover { background: #ffb2b2; }
            .quiz-actions a.try { background: #e6fff2; color: #1a7f5a; }
            .quiz-actions a.try:hover { background: #b2ffe0; }
            .create-btn { padding: 10px 22px; background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); color: #fff; border-radius: 8px; font-weight: 500; border: none; text-decoration: none; transition: background 0.2s; }
            .create-btn:hover { background: linear-gradient(90deg, #764ba2 0%, #667eea 100%); color: #fff; }
        </style>
    </head>
    <body>

        <jsp:include page="../views/components/header.jsp"/>

        <div class="top-bar">
            <h2 class="fw-bold text-primary"><i class="fas fa-list me-2"></i>Danh sách Quiz</h2>
            <a class="create-btn" href="${pageContext.request.contextPath}/quiz?action=new">
                <i class="fas fa-plus me-1"></i> Tạo Quiz mới
            </a>
        </div>
        <div class="container-fluid px-0">
            <% if (quizList != null && !quizList.isEmpty()) { %>
                <% for (Quiz quiz : quizList) { %>
                <div class="quiz-card">
                    <div class="quiz-info">
                        <div class="title"><i class="fas fa-clipboard-list me-2 text-primary"></i><%= quiz.getName() %></div>
                        <div class="meta mb-1">
                            <span class="badge bg-secondary me-1"><i class="fas fa-book me-1"></i> Môn: <%= quiz.getSubjectId() %></span>
                            <span class="badge bg-info text-dark me-1"><i class="fas fa-layer-group me-1"></i> <%= quiz.getLevel() %></span>
                            <span class="badge bg-light text-dark"><i class="fas fa-clock me-1"></i> <%= quiz.getDurationMinutes() %> phút</span>
                        </div>
                        <div class="meta">
                            <span class="badge bg-success me-1"><i class="fas fa-question me-1"></i> <%= quiz.getNumberOfQuestions() %> câu</span>
                            <span class="badge bg-warning text-dark me-1"><i class="fas fa-percent me-1"></i> Pass: <%= quiz.getPassRate() %>%</span>
                            <span class="badge bg-primary"><i class="fas fa-tag me-1"></i> <%= quiz.getType() %></span>
                        </div>
                    </div>
                    <div class="quiz-actions ms-auto">
                        <a href="${pageContext.request.contextPath}/quiz?action=edit&id=<%= quiz.getId() %>" class="edit"><i class="fas fa-pen"></i> Sửa</a>
                        <a href="${pageContext.request.contextPath}/quiz?action=delete&id=<%= quiz.getId() %>" class="delete" onclick="return confirm('Xác nhận xoá quiz này?');"><i class="fas fa-trash"></i> Xoá</a>
                        <!-- <a href="${pageContext.request.contextPath}/quiz-handle?quizId=<%= quiz.getId() %>" class="try"><i class="fas fa-play-circle"></i> Làm thử</a> -->
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <div class="alert alert-info text-center">Không có quiz nào.</div>
            <% } %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
