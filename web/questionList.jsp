<%-- 
    Document   : question_list
    Created on : May 30, 2025, 8:39:56 AM
    Author     : kan3v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question, Model.Subject, Model.Lesson, Model.SubjectDimension" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<SubjectDimension> dimensions = (List<SubjectDimension>) request.getAttribute("dimensions");

    String subjectId = request.getParameter("subjectId");
    String lessonId = request.getParameter("lessonId");
    String dimensionId = request.getParameter("dimensionId");
    String level = request.getParameter("level");
    String status = request.getParameter("status");
    String search = request.getParameter("search");
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

    public String getDimensionName(int id, List<SubjectDimension> dimensions) {
        for (SubjectDimension d : dimensions) {
            if (d.getId() == id) return d.getName();
        }
        return "";
    }
%>

<html>
    <head>
        <title>Question List</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f7f7f7;
                padding: 40px;
            }
            h2 {
                color: #333;
            }
            a {
                text-decoration: none;
                color: #007BFF;
            }
            a:hover {
                text-decoration: underline;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                background-color: white;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                margin-top: 20px;
            }
            th, td {
                padding: 10px 15px;
                border: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: #007BFF;
                color: white;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .filter-form {
                background: white;
                padding: 15px;
                box-shadow: 0 0 5px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .filter-form label {
                margin-right: 10px;
            }
            .filter-form select, .filter-form input[type="text"] {
                margin-right: 20px;
                padding: 5px;
            }
            .action-links a {
                margin-right: 10px;
            }
            .pagination {
                margin-top: 20px;
            }
            .pagination a {
                margin-right: 5px;
                padding: 5px 10px;
                background: #eee;
                border: 1px solid #ccc;
                text-decoration: none;
            }
            .pagination a.active {
                background: #007BFF;
                color: white;
            }
        </style>
    </head>
    <body>

        <div class="top-bar">
            <h2>Question List</h2>
            <div>
                <a href="QuestionController?action=create">➕ Create New Question</a> |
                <a href="QuestionController?action=import">📥 Import Questions</a>
            </div>
        </div>

        <form method="get" action="QuestionController" class="filter-form">
            <input type="hidden" name="action" value="list"/>

            <label>Subject:</label>
            <select name="subjectId">
                <option value="" <%= (subjectId == null || subjectId.isEmpty()) ? "selected" : "" %>>All</option>
                <% for (Subject s : subjects) { %>
                <option value="<%= s.getId() %>" <%= (subjectId != null && subjectId.equals(String.valueOf(s.getId()))) ? "selected" : "" %>>
                    <%= s.getTitle() %>
                </option>
                <% } %>
            </select>

            <label>Lesson:</label>
            <select name="lessonId">
                <option value="" <%= (lessonId == null || lessonId.isEmpty()) ? "selected" : "" %>>All</option>
                <% for (Lesson l : lessons) { %>
                <option value="<%= l.getId() %>" <%= (lessonId != null && lessonId.equals(String.valueOf(l.getId()))) ? "selected" : "" %>>
                    <%= l.getTitle() %>
                </option>
                <% } %>
            </select>

            <label>Dimension:</label>
            <select name="dimensionId">
                <option value="" <%= (dimensionId == null || dimensionId.isEmpty()) ? "selected" : "" %>>All</option>
                <% for (SubjectDimension d : dimensions) { %>
                <option value="<%= d.getId() %>" <%= (dimensionId != null && dimensionId.equals(String.valueOf(d.getId()))) ? "selected" : "" %>>
                    <%= d.getName() %>
                </option>
                <% } %>
            </select>

            <label>Level:</label>
            <select name="level">
                <option value="" <%= (level == null || level.isEmpty()) ? "selected" : "" %>>All</option>
                <option value="Easy" <%= "Easy".equals(level) ? "selected" : "" %>>Easy</option>
                <option value="Medium" <%= "Medium".equals(level) ? "selected" : "" %>>Medium</option>
                <option value="Hard" <%= "Hard".equals(level) ? "selected" : "" %>>Hard</option>
            </select>

            <label>Status:</label>
            <select name="status">
                <option value="" <%= (status == null || status.isEmpty()) ? "selected" : "" %>>All</option>
                <option value="active" <%= "active".equalsIgnoreCase(status) ? "selected" : "" %>>Active</option>
                <option value="inactive" <%= "inactive".equalsIgnoreCase(status) ? "selected" : "" %>>Inactive</option>
            </select>

            <label>Search:</label>
            <input type="text" name="search" placeholder="Search by content..." value="<%= (search != null) ? search : "" %>"/>

            <input type="submit" value="Filter"/>
        </form>

        <table>
            <tr>
                <th>ID</th>
                <th>Content</th>
                <th>Subject</th>
                <th>Lesson</th>
                <th>Dimension</th>
                <th>Level</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <% for (Question q : questions) { %>
            <tr>
                <td><%= q.getId() %></td>
                <td><%= q.getContent() %></td>
                <td><%= getSubjectName(q.getSubjectId(), subjects) %></td>
                <td><%= getLessonName(q.getLessonId(), lessons) %></td>
                <td><%= getDimensionName(q.getDimensionId(), dimensions) %></td>
                <td><%= q.getLevel() %></td>
                <td style="color: <%= "active".equalsIgnoreCase(q.getStatus()) ? "green" : "red" %>;">
                    <%= "active".equalsIgnoreCase(q.getStatus()) ? "Active" : "Inactive" %>
                </td>
                <td>
                    <a href="QuestionController?action=edit&id=<%= q.getId() %>">✏️ Edit</a>
                    <a href="QuestionController?action=delete&id=<%= q.getId() %>" 
                       onclick="return confirm('Are you sure you want to delete this question?');">🗑️ Delete</a>
                </td>
            </tr>
            <% } %>
        </table>

        <%-- Optional Pagination Placeholder --%>
        <div class="pagination">
            <a href="?page=1" class="active">1</a>
            <a href="?page=2">2</a>
            <a href="?page=3">3</a>
        </div>

    </body>
</html>
