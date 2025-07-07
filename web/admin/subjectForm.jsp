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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .subject-form-container {
            max-width: 500px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            padding: 30px 40px;
        }
        .subject-form-title {
            color: #2d3a4b;
            text-align: center;
            margin-bottom: 30px;
        }
        .subject-form-label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-weight: 500;
        }
        .subject-form-input, .subject-form-textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 18px;
            border: 1px solid #d1d5db;
            border-radius: 5px;
            font-size: 15px;
            background: #f9fafb;
            transition: border 0.2s;
        }
        .subject-form-input:focus, .subject-form-textarea:focus {
            border: 1.5px solid #007bff;
            outline: none;
        }
        .subject-form-textarea {
            min-height: 80px;
            resize: vertical;
        }
        .subject-form-submit {
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
        .subject-form-submit:hover {
            background: #0056b3;
        }
        .subject-form-back {
            color: #007bff;
            text-decoration: none;
            margin-left: 15px;
        }
        .subject-form-back:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    <div class="subject-form-container">
        <h2 class="subject-form-title"><%= isEdit ? "Chỉnh sửa" : "Tạo mới" %> môn học</h2>
        <form method="post" action="<%= isEdit ? ("/admin/subject/edit?id=" + subject.getId()) : "/admin/subject/create" %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= subject.getId() %>" />
            <% } %>
            <label class="subject-form-label">Tên môn học:</label><br>
            <input type="text" name="title" value="<%= isEdit ? subject.getTitle() : "" %>" required class="subject-form-input"/><br>
            <label class="subject-form-label">Tagline:</label><br>
            <input type="text" name="tagline" value="<%= isEdit ? subject.getTagline() : "" %>" class="subject-form-input"/><br>
            <%-- <label>Chủ sở hữu (ID):</label><br>
            <input type="number" name="ownerId" value="<%= isEdit ? subject.getOwnerId() : "" %>" required/><br> --%>
            <label class="subject-form-label">Trạng thái:</label><br>
            <input type="text" name="status" value="<%= isEdit ? subject.getStatus() : "Active" %>" required class="subject-form-input"/><br>
            <label class="subject-form-label">Mô tả:</label><br>
            <textarea name="description" class="subject-form-textarea"><%= isEdit ? subject.getDescription() : "" %></textarea><br>
            <label class="subject-form-label">Thumbnail URL:</label><br>
            <input type="text" name="thumbnailUrl" value="<%= isEdit ? subject.getThumbnailUrl() : "" %>" class="subject-form-input"/><br>
            <button type="submit" class="subject-form-submit"><%= isEdit ? "Cập nhật" : "Tạo mới" %></button>
            <a href="/admin/subjects" class="subject-form-back">Quay lại</a>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 