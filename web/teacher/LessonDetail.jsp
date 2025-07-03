<%-- 
    Document   : LessonDetail
    Created on : Jun 14, 2025, 8:09:06 PM
    Author     : kan3v
--%>

<%@ page import="Model.Lesson" %>
<%@ page import="Model.Subject" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lesson Detail</title>
    <style>
        form {
            width: 600px;
            margin: auto;
        }
        label {
            display: block;
            margin-top: 12px;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 6px;
            box-sizing: border-box;
        }
        input[type="submit"], a.button {
            margin-top: 16px;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        a.button {
            background-color: #ccc;
            color: black;
        }
    </style>
</head>
<body>

<%
    String formAction = (String) request.getAttribute("formAction");
    Lesson lesson = (Lesson) request.getAttribute("lesson");
    if (lesson == null) lesson = new Lesson();

    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
%>

<h2 style="text-align:center;"><%= "edit".equals(formAction) ? "Chỉnh sửa bài học" : "Thêm bài học mới" %></h2>

<form action="lesson" method="post">
    <input type="hidden" name="action" value="<%= formAction %>"/>
    <input type="hidden" name="id" value="<%= lesson.getId() %>"/>

    <label for="subjectId">Môn học:</label>
    <select name="subjectId" id="subjectId" required>
        <%
            if (subjects != null) {
                for (Subject sub : subjects) {
                    boolean selected = (sub.getId() == lesson.getSubjectId());
        %>
        <option value="<%= sub.getId() %>" <%= selected ? "selected" : "" %>><%= sub.getTitle() %></option>
        <%
                }
            }
        %>
    </select>

    <label for="title">Tiêu đề:</label>
    <input type="text" name="title" id="title" value="<%= lesson.getTitle() != null ? lesson.getTitle() : "" %>" required/>

    <label for="dimension">Phân loại (Dimension):</label>
    <input type="text" name="dimension" id="dimension" value="<%= lesson.getDimension() != null ? lesson.getDimension() : "" %>" required/>

    <%-- Nếu đang tạo mới thì thêm trạng thái mặc định là "active" --%>
    <% if (!"edit".equals(formAction)) { %>
        <input type="hidden" name="status" value="active"/>
    <% } %>

    <label for="content">Nội dung:</label>
    <textarea name="content" id="content" rows="6"><%= lesson.getContent() != null ? lesson.getContent() : "" %></textarea>

    <input type="submit" value="<%= "edit".equals(formAction) ? "Cập nhật" : "Thêm mới" %>"/>
    <a href="lesson?action=list&subjectId=<%= lesson.getSubjectId() %>" class="button">Hủy</a>
</form>

</body>
</html>
