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
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; padding: 40px; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; }
        .filter-form { background: #fff; padding: 15px; box-shadow: 0 0 5px rgba(0,0,0,0.1); margin:20px 0; }
        .filter-form label, .filter-form select, .filter-form input { margin-right:15px; }
        .question-card { display:flex; align-items:center; background:#fff; border:1px solid #ccc;
                         margin-bottom:10px; padding:10px; box-shadow:0 2px 5px rgba(0,0,0,0.05); }
        .question-card .index { width:40px; font-weight:bold; color:#007BFF; }
        .question-card .img { width:100px; height:100px; object-fit:cover; margin:0 15px; }
        .question-card .no-img { width:100px; height:100px; background:#eee; display:flex;
                                 align-items:center; justify-content:center; margin:0 15px; }
        .question-card .info { flex-grow:1; }
        .question-card .actions { margin-left:15px; }
        .question-card a { display:block; margin-bottom:5px; color:#007BFF; text-decoration:none; }
        .question-card a:hover { text-decoration:underline; }
    </style>
</head>
<body>

    <div class="top-bar">
        <h2>Question List</h2>
        <a href="QuestionController?action=create" style="padding:8px 12px; background:#007BFF; color:#fff; text-decoration:none; border-radius:4px;">
            ➕ Create New Question
        </a>
    </div>

    <form method="get" action="QuestionController" class="filter-form">
        <input type="hidden" name="action" value="list"/>
        <label>Subject:</label>
        <select name="subjectId">
            <option value="" <%= (subjectId==null||subjectId.isEmpty())?"selected":"" %>>All</option>
            <% for(Subject s: subjects){ %>
                <option value="<%=s.getId()%>" <%= String.valueOf(s.getId()).equals(subjectId)?"selected":"" %>><%=s.getTitle()%></option>
            <% } %>
        </select>

        <label>Lesson:</label>
        <select name="lessonId">
            <option value="" <%= (lessonId==null||lessonId.isEmpty())?"selected":"" %>>All</option>
            <% for(Lesson l: lessons){ %>
                <option value="<%=l.getId()%>" <%= String.valueOf(l.getId()).equals(lessonId)?"selected":"" %>><%=l.getTitle()%></option>
            <% } %>
        </select>

        <label>Dimension:</label>
        <select name="dimension">
            <option value="" <%= (dimension==null||dimension.isEmpty())?"selected":"" %>>All</option>
            <% for(Lesson l: lessons){ %>
                <option value="<%=l.getDimension()%>" <%= l.getDimension().equals(dimension)?"selected":"" %>><%=l.getDimension()%></option>
            <% } %>
        </select>

        <label>Level:</label>
        <select name="level">
            <option value="" <%= (level==null||level.isEmpty())?"selected":"" %>>All</option>
            <option value="Easy"   <%= "Easy".equals(level)?"selected":"" %>>Easy</option>
            <option value="Medium" <%= "Medium".equals(level)?"selected":"" %>>Medium</option>
            <option value="Hard"   <%= "Hard".equals(level)?"selected":"" %>>Hard</option>
        </select>

        <label>Search:</label>
        <input type="text" name="search" placeholder="Search content..." value="<%= search!=null?search:"" %>"/>

        <input type="submit" value="Filter" style="padding:6px 10px"/>
    </form>

    <%
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        int idx=1;
        for(Question q: questions){
    %>
    <div class="question-card">
        <div class="index"><%= idx++ %>.</div>
        <% if(q.getImage()!=null){ %>
            <img class="img" src="questionImage?id=<%=q.getId()%>" alt="img"/>
        <% } else { %>
            <div class="no-img">No Image</div>
        <% } %>
        <div class="info">
            <div><strong>Content:</strong> <%= q.getContent() %></div>
            <div>
                <strong>Subject:</strong> <%= getSubjectName(q.getSubjectId(), subjects) %> |
                <strong>Lesson:</strong> <%= getLessonName(q.getLessonId(), lessons) %>
            </div>
            <div>
                <strong>Dimension:</strong> <%= getDimension(q.getLessonId(), lessons) %> |
                <strong>Level:</strong> <%= q.getLevel() %>
            </div>
            <div>
                <strong>Created:</strong> <%= sdf.format(q.getCreatedAt()) %> |
                <strong>Updated:</strong> <%= q.getUpdatedAt()!=null?sdf.format(q.getUpdatedAt()):"N/A" %>
            </div>
        </div>
        <div class="actions">
            <a href="QuestionController?action=edit&id=<%=q.getId()%>">✏️ Edit</a>
            <a href="QuestionController?action=delete&id=<%=q.getId()%>" onclick="return confirm('Delete this question?');">🗑️ Delete</a>
        </div>
    </div>
    <% } %>

</body>
</html>
