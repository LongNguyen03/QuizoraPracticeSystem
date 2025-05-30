<%-- 
    Document   : question_list
    Created on : May 30, 2025, 8:39:56 AM
    Author     : kan3v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Question List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f7f7f7;
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
        }
        th, td {
            padding: 12px 15px;
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
        .action-links a {
            margin-right: 10px;
        }
        .top-bar {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="top-bar">
        <h2>Question List</h2>
        <a href="QuestionController?action=create">➕ Create New Question</a>
    </div>

    <table>
        <tr>
            <th>ID</th>
            <th>Content</th>
            <th>Level</th>
            <th>Media</th>
            <th>Action</th>
        </tr>
        <%
            List<Question> questions = (List<Question>) request.getAttribute("questions");
            for (Question q : questions) {
        %>
        <tr>
            <td><%= q.getId() %></td>
            <td><%= q.getContent() %></td>
            <td><%= q.getLevel() %></td>
            <td><%= q.getMedia() %></td>
            <td class="action-links">
                <a href="QuestionController?action=edit&id=<%= q.getId() %>">✏️ Edit</a>
                <a href="QuestionController?action=delete&id=<%= q.getId() %>" onclick="return confirm('Confirm delete?')">🗑️ Delete</a>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>
