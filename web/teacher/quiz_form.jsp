<%-- 
    Document   : quiz_form
    Created on : Jul 3, 2025, 10:27:55 PM
    Author     : kan3v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Quiz" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    boolean isEdit = (quiz != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Cập nhật Quiz" : "Tạo mới Quiz" %> - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>

<jsp:include page="../views/components/header.jsp"/>

<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0"><%= isEdit ? "Cập nhật Quiz" : "Tạo mới Quiz" %></h3>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/quiz">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>"/>
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= quiz.getId() %>"/>
                <% } %>

                <div class="mb-3">
                    <label class="form-label">Tên Quiz</label>
                    <input type="text" name="name" class="form-control" required
                           value="<%= isEdit ? quiz.getName() : "" %>"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Môn học (Subject ID)</label>
                    <input type="number" name="subjectId" class="form-control" required
                           value="<%= isEdit ? quiz.getSubjectId() : "" %>"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Level</label>
                    <input type="text" name="level" class="form-control" required
                           value="<%= isEdit ? quiz.getLevel() : "" %>"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Số câu hỏi</label>
                    <input type="number" name="numberOfQuestions" class="form-control" required
                           value="<%= isEdit ? quiz.getNumberOfQuestions() : "" %>"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Thời gian (phút)</label>
                    <input type="number" name="durationMinutes" class="form-control" required
                           value="<%= isEdit ? quiz.getDurationMinutes() : "" %>"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Pass Rate (%)</label>
                    <input type="number" step="0.1" name="passRate" class="form-control" required
                           value="<%= isEdit ? quiz.getPassRate() : "" %>"/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Loại</label>
                    <input type="text" name="type" class="form-control" required
                           value="<%= isEdit ? quiz.getType() : "" %>"/>
                </div>

                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> <%= isEdit ? "Cập nhật" : "Tạo mới" %>
                </button>
                <a href="${pageContext.request.contextPath}/quiz" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
