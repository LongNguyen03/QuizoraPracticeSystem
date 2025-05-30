<%-- 
    Document   : question_detail
    Created on : May 30, 2025, 8:40:31 AM
    Author     : kan3v
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question" %>
<%
    Question q = (Question) request.getAttribute("question");
    boolean isEdit = q != null;
%>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Create" %> Question</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f9f9f9;
        }
        h2 {
            color: #333;
        }
        table {
            width: 500px;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-collapse: collapse;
        }
        td {
            padding: 10px;
        }
        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            margin-top: 20px;
            display: inline-block;
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2><%= isEdit ? "Edit" : "Create" %> Question</h2>

<form action="QuestionController" method="post">
    <input type="hidden" name="id" value="<%= isEdit ? q.getId() : "" %>"/>
    <table>
        <tr>
            <td>Content:</td>
            <td><input type="text" name="content" value="<%= isEdit ? q.getContent() : "" %>" required/></td>
        </tr>
        <tr>
            <td>Level:</td>
            <td><input type="text" name="level" value="<%= isEdit ? q.getLevel() : "" %>" required/></td>
        </tr>
        <tr>
            <td>Media:</td>
            <td><input type="text" name="media" value="<%= isEdit ? q.getMedia() : "" %>" /></td>
        </tr>
        <tr>
            <td>Subject ID:</td>
            <td><input type="number" name="subjectId" value="<%= isEdit ? q.getSubjectId() : "" %>" required/></td>
        </tr>
        <tr>
            <td>Lesson ID:</td>
            <td><input type="number" name="lessonId" value="<%= isEdit ? q.getLessonId() : "" %>" required/></td>
        </tr>
        <tr>
            <td>Dimension ID:</td>
            <td><input type="number" name="dimensionId" value="<%= isEdit ? q.getDimensionId() : "" %>" required/></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center;"><input type="submit" value="Save"/></td>
        </tr>
    </table>
</form>

<a href="QuestionController">← Back to Question List</a>
</body>
</html>

