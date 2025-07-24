<%-- 
    Document   : question_list
    Created on : May 30, 2025, 8:39:56 AM
    Author     : kan3v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question, Model.Subject, Model.Lesson" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<Subject> subjects  = (List<Subject>)  request.getAttribute("subjects");
    List<Lesson> lessons    = (List<Lesson>)   request.getAttribute("lessons");

    String subjectId = request.getParameter("subjectId");
    String lessonId  = request.getParameter("lessonId");
    String dimension = request.getParameter("dimension");
    String level     = request.getParameter("level");
    String search    = request.getParameter("search");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MM-yyyy");
%>

<%! 
    public String getSubjectName(int id, List<Subject> subjects) {
        for (Subject s : subjects) {
            if (s.getId() == id) return s.getTitle();
        }
        return "";
    }

    public String getLessonName(int id, List<Lesson> lessons) {
        for (Lesson l : lessons) {
            if (l.getId() == id) return l.getTitle();
        }
        return "";
    }
    
    public String getDimension(int lessonId, List<Lesson> lessons) {
        for (Lesson l : lessons) {
            if (l.getId() == lessonId) return l.getDimension();
        }
        return "";
    }
%>

<html>
<head>
    <title>Question List</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f7f7f7; padding: 40px; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .question-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 1.5rem; margin-bottom: 18px; transition: box-shadow 0.2s, transform 0.1s; }
        .question-card:hover { box-shadow: 0 6px 18px rgba(0,0,0,0.13); transform: translateY(-2px); }
        .question-card .index { font-size: 1.3rem; color: #764ba2; font-weight: bold; margin-right: 18px; }
        .question-card .img, .question-card .no-img { width: 90px; height: 90px; border-radius: 8px; object-fit: cover; background: #eee; display: flex; align-items: center; justify-content: center; margin-right: 18px; }
        .question-card .info { flex-grow: 1; }
        .question-card .actions { display: flex; flex-direction: column; gap: 8px; margin-left: 18px; }
        .question-card .actions a { padding: 6px 14px; border-radius: 6px; font-size: 1rem; text-decoration: none; transition: background 0.2s; }
        .question-card .actions a.edit { background: #e3e8ff; color: #3b3b7a; }
        .question-card .actions a.edit:hover { background: #b2bfff; }
        .question-card .actions a.delete { background: #ffe3e3; color: #a33b3b; }
        .question-card .actions a.delete:hover { background: #ffb2b2; }
        .question-card .meta { font-size: 0.95rem; color: #888; margin-bottom: 4px; }
        .question-card .badge { font-size: 0.95rem; }
        .create-btn { padding: 10px 22px; background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); color: #fff; border-radius: 8px; font-weight: 500; border: none; text-decoration: none; transition: background 0.2s; }
        .create-btn:hover { background: linear-gradient(90deg, #764ba2 0%, #667eea 100%); color: #fff; }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    <div class="top-bar">
        <h2 class="fw-bold text-primary"><i class="fas fa-list me-2"></i>Question List</h2>
        <a href="${pageContext.request.contextPath}/QuestionController?action=create&lessonId=${lessonId}" class="create-btn">
            <i class="fas fa-plus me-1"></i> Create New Question
        </a>
    </div>
    <div class="container-fluid px-0">
        <% if (questions != null && !questions.isEmpty()) { int idx=1; %>
            <% for(Question q: questions){ %>
            <div class="question-card d-flex align-items-center">
                <div class="index"><%= idx++ %>.</div>
                <% if(q.getImage()!=null){ %>
                    <img class="img" src="${pageContext.request.contextPath}/questionImage?id=<%=q.getId()%>" alt="img"/>
                <% } else { %>
                    <div class="no-img"><i class="fas fa-image fa-2x text-muted"></i></div>
                <% } %>
                <div class="info">
                    <div class="fw-semibold mb-1"><i class="fas fa-question-circle text-primary me-1"></i> <%= q.getContent() %></div>
                    <div class="meta mb-1">
                        <span class="badge bg-secondary me-1"><i class="fas fa-book me-1"></i> <%= getSubjectName(q.getSubjectId(), subjects) %></span>
                        <span class="badge bg-info text-dark me-1"><i class="fas fa-chalkboard me-1"></i> <%= getLessonName(q.getLessonId(), lessons) %></span>
                        <span class="badge bg-light text-dark"><i class="fas fa-layer-group me-1"></i> <%= q.getLevel() %></span>
                    </div>
                    <div class="meta">
                        <i class="fas fa-calendar-plus me-1"></i> <strong>Created:</strong> <%= sdf.format(q.getCreatedAt()) %>
                        &nbsp;|&nbsp;
                        <i class="fas fa-calendar-check me-1"></i> <strong>Updated:</strong> <%= q.getUpdatedAt()!=null?sdf.format(q.getUpdatedAt()):"N/A" %>
                    </div>
                </div>
                <div class="actions ms-auto">
                    <a href="${pageContext.request.contextPath}/QuestionController?action=edit&id=<%=q.getId()%>" class="edit"><i class="fas fa-pen"></i> Edit</a>
                    <a href="${pageContext.request.contextPath}/QuestionController?action=delete&id=<%=q.getId()%>&lessonId=<%=q.getLessonId()%>" class="delete" onclick="return confirm('Delete this question?');"><i class="fas fa-trash"></i> Delete</a>
                </div>
            </div>
            <% } %>
        <% } else { %>
            <div class="alert alert-info text-center">No questions found for this lesson.</div>
        <% } %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
