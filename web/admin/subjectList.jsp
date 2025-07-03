<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Subject" %>
<html>
<head>
    <title>Quản lý môn học</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f6f8fa;
            margin: 0;
            padding: 0;
        }
        h2 {
            color: #2d3a4b;
            margin-top: 30px;
            text-align: center;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px 40px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 10px;
            text-align: left;
        }
        th {
            background: #2d3a4b;
            color: #fff;
        }
        tr:nth-child(even) {
            background: #f2f4f8;
        }
        tr:hover {
            background: #e6f7ff;
        }
        a.button {
            display: inline-block;
            background: #007bff;
            color: #fff;
            padding: 8px 18px;
            border-radius: 5px;
            text-decoration: none;
            margin-bottom: 15px;
            transition: background 0.2s;
        }
        a.button:hover {
            background: #0056b3;
        }
        .action-link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .action-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
<h2>Danh sách môn học</h2>
<a href="/admin/subject/create" class="button">Tạo môn học mới</a>
<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Tên môn học</th>
        <th>Tagline</th>
        <th>Chủ sở hữu</th>
        <th>Trạng thái</th>
        <th>Ngày tạo</th>
        <th>Ngày cập nhật</th>
        <th>Hành động</th>
    </tr>
    <%
        List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
        if (subjects != null) {
            for (Subject s : subjects) {
    %>
    <tr>
        <td><%= s.getId() %></td>
        <td><%= s.getTitle() %></td>
        <td><%= s.getTagline() %></td>
        <td><%= s.getOwnerId() %></td>
        <td><%= s.getStatus() %></td>
        <td><%= s.getCreatedAt() %></td>
        <td><%= s.getUpdatedAt() %></td>
        <td>
            <a href="/admin/subject/edit?id=<%= s.getId() %>" class="action-link">Chỉnh sửa</a>
        </td>
    </tr>
    <%      }
        }
    %>
</table>
</div>
</body>
</html> 