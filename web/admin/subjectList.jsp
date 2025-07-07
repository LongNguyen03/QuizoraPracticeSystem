<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Subject" %>
<html>
<head>
    <title>Quản lý môn học</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .subject-container {
            max-width: 1000px;
            margin: 30px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px 40px;
        }
        .subject-table th, .subject-table td {
            padding: 12px 10px;
            text-align: left;
        }
        .subject-table th {
            background: #2d3a4b;
            color: #fff;
        }
        .subject-table tr:nth-child(even) {
            background: #f2f4f8;
        }
        .subject-table tr:hover {
            background: #e6f7ff;
        }
        .subject-action-link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        .subject-action-link:hover {
            text-decoration: underline;
        }
        @media (max-width: 768px) {
            .subject-container {
                padding: 15px 5px;
            }
            .d-flex .text-center {
                font-size: 1.2rem !important;
            }
            .d-flex > a, .d-flex > h2 {
                font-size: 0.95rem;
                padding: 6px 8px;
            }
        }
    </style>
    <!--
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
    -->
</head>
<body>
    <jsp:include page="/views/components/header.jsp" />
    <div class="subject-container">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="/admin/dashboard" class="btn btn-secondary">&larr; Quay lại Dashboard</a>
            <h2 class="flex-grow-1 text-center m-0" style="font-size:2rem; font-weight:600; color:#2d3a4b;">Danh sách môn học</h2>
            <a href="/admin/subject/create" class="btn btn-primary">Tạo môn học mới</a>
        </div>
        <table class="subject-table" border="1" cellpadding="5" cellspacing="0">
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
                    <a href="/admin/subject/edit?id=<%= s.getId() %>" class="subject-action-link">Chỉnh sửa</a>
                </td>
            </tr>
            <%      }
                }
            %>
        </table>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 