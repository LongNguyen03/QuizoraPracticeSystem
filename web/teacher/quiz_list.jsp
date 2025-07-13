<%-- 
    Document   : quiz_list
    Created on : Jul 3, 2025, 10:29:10 PM
    Author     : kan3v
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Quiz" %>
<%
    List<Quiz> quizList = (List<Quiz>) request.getAttribute("quizList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
</head>
<body>

<jsp:include page="../views/components/header.jsp"/>

<div class="container mt-5">
    <div class="d-flex justify-content-between mb-3">
        <h2>Danh sách Quiz</h2>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/quiz?action=new">
            <i class="fas fa-plus"></i> Tạo Quiz mới
        </a>
    </div>

    <table class="table table-striped table-bordered shadow-sm">
        <thead class="table-primary">
        <tr>
            <th>ID</th>
            <th>Tên Quiz</th>
            <th>Môn học</th>
            <th>Level</th>
            <th>Số câu</th>
            <th>Thời gian</th>
            <th>Pass Rate (%)</th>
            <th>Loại</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <% if (quizList != null && !quizList.isEmpty()) {
            for (Quiz quiz : quizList) {
        %>
        <tr>
            <td><%= quiz.getId() %></td>
            <td><%= quiz.getName() %></td>
            <td><%= quiz.getSubjectId() %></td>
            <td><%= quiz.getLevel() %></td>
            <td><%= quiz.getNumberOfQuestions() %></td>
            <td><%= quiz.getDurationMinutes() %></td>
            <td><%= quiz.getPassRate() %></td>
            <td><%= quiz.getType() %></td>
            <td>
                <a href="${pageContext.request.contextPath}/quiz?action=edit&id=<%= quiz.getId() %>" class="btn btn-sm btn-warning">
                    <i class="fas fa-edit"></i> Sửa
                </a>
                <a href="${pageContext.request.contextPath}/quiz?action=delete&id=<%= quiz.getId() %>" 
                   class="btn btn-sm btn-danger"
                   onclick="return confirm('Xác nhận xoá quiz này?');">
                    <i class="fas fa-trash"></i> Xóa
                </a>
            </td>
        </tr>
        <% }
        } else { %>
        <tr><td colspan="9" class="text-center">Không có quiz nào.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
