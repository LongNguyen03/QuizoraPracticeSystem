<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Subject" %>
<%
    String action = (String) request.getAttribute("action");
    Subject subject = (Subject) request.getAttribute("subject");
    boolean isEdit = "edit".equals(action);
%>
<html>
<head>
    <title><%= isEdit ? "Chỉnh sửa" : "Tạo mới" %> môn học</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f6f8fa;
            margin: 0;
            padding: 0;
        }
        .form-container {
            max-width: 500px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px 40px;
        }
        h2 {
            color: #2d3a4b;
            text-align: center;
            margin-bottom: 30px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-weight: 500;
        }
        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 18px;
            border: 1px solid #d1d5db;
            border-radius: 5px;
            font-size: 15px;
            background: #f9fafb;
            transition: border 0.2s;
        }
        input[type="text"]:focus, textarea:focus {
            border: 1.5px solid #007bff;
            outline: none;
        }
        textarea {
            min-height: 80px;
            resize: vertical;
        }
        button[type="submit"] {
            background: #007bff;
            color: #fff;
            border: none;
            padding: 10px 24px;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }
        button[type="submit"]:hover {
            background: #0056b3;
        }
        a {
            color: #007bff;
            text-decoration: none;
            margin-left: 15px;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="form-container">
<h2><%= isEdit ? "Chỉnh sửa" : "Tạo mới" %> môn học</h2>
<form method="post" action="<%= isEdit ? ("/admin/subject/edit?id=" + subject.getId()) : "/admin/subject/create" %>">
    <% if (isEdit) { %>
        <input type="hidden" name="id" value="<%= subject.getId() %>" />
    <% } %>
    <label>Tên môn học:</label><br>
    <input type="text" name="title" value="<%= isEdit ? subject.getTitle() : "" %>" required/><br>
    <label>Tagline:</label><br>
    <input type="text" name="tagline" value="<%= isEdit ? subject.getTagline() : "" %>"/><br>
    <%-- <label>Chủ sở hữu (ID):</label><br>
    <input type="number" name="ownerId" value="<%= isEdit ? subject.getOwnerId() : "" %>" required/><br> --%>
    <label>Trạng thái:</label><br>
    <input type="text" name="status" value="<%= isEdit ? subject.getStatus() : "Active" %>" required/><br>
    <label>Mô tả:</label><br>
    <textarea name="description"><%= isEdit ? subject.getDescription() : "" %></textarea><br>
    <label>Thumbnail URL:</label><br>
    <input type="text" name="thumbnailUrl" value="<%= isEdit ? subject.getThumbnailUrl() : "" %>"/><br>
    <button type="submit"><%= isEdit ? "Cập nhật" : "Tạo mới" %></button>
    <a href="/admin/subjects">Quay lại</a>
</form>
</div>
</body>
</html> 