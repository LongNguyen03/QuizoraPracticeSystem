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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background:#f7f7f7; padding:40px; }
        .card-form { max-width:600px; margin:auto; background:#fff; padding:32px 28px; border-radius:16px; box-shadow:0 2px 16px rgba(0,0,0,0.09); }
        .form-label { font-weight:600; }
        .form-control, .form-select { border-radius:8px; }
        .actions { text-align:center; margin-top:28px; }
        .actions button, .actions a { padding:10px 28px; border-radius:8px; font-weight:500; }
        .actions .btn-primary { background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); border:none; }
        .actions .btn-primary:hover { background: linear-gradient(90deg, #764ba2 0%, #667eea 100%); }
        .actions .btn-secondary { background:#e9ecef; color:#333; border:none; }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
<%
    String formAction = (String) request.getAttribute("formAction");
    Model.Lesson lesson = (Model.Lesson) request.getAttribute("lesson");
    if (lesson == null) lesson = new Model.Lesson();
    java.util.List<Model.Subject> subjects = (java.util.List<Model.Subject>) request.getAttribute("subjects");
%>
    <div class="container py-4">
        <div class="card-form">
            <h2 class="text-center mb-4 fw-bold text-primary"><i class="fas fa-chalkboard me-2"></i><%= "edit".equals(formAction) ? "Chỉnh sửa bài học" : "Thêm bài học mới" %></h2>
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="alert alert-danger text-center"><%= error %></div>
            <% } %>
            <form action="${pageContext.request.contextPath}/lesson" method="post">
                <input type="hidden" name="action" value="<%= formAction %>"/>
                <input type="hidden" name="id" value="<%= lesson.getId() %>"/>
                <div class="mb-3">
                    <label for="subjectId" class="form-label">Môn học:</label>
                    <select name="subjectId" id="subjectId" class="form-select" required>
                        <% if (subjects != null) {
                            for (Subject sub : subjects) {
                                boolean selected = (sub.getId() == lesson.getSubjectId()); %>
                                <option value="<%= sub.getId() %>" <%= selected ? "selected" : "" %>><%= sub.getTitle() %></option>
                        <%  }
                        } %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="title" class="form-label">Tiêu đề:</label>
                    <input type="text" name="title" id="title" class="form-control" value="<%= lesson.getTitle() != null ? lesson.getTitle() : "" %>" required/>
                </div>
                <div class="mb-3">
                    <label for="dimension" class="form-label">Phân loại (Dimension):</label>
                    <input type="text" name="dimension" id="dimension" class="form-control" list="dimensionList"
                           value="<%= lesson.getDimension() != null ? lesson.getDimension() : "" %>" required/>
                    <datalist id="dimensionList">
                        <% 
                            java.util.List<String> dimensionList = (java.util.List<String>) request.getAttribute("dimensionList");
                            if (dimensionList != null) for (String dim : dimensionList) { 
                        %>
                            <option value="<%= dim %>"/>
                        <% } %>
                    </datalist>
                </div>
                <% if (!"edit".equals(formAction)) { %>
                    <input type="hidden" name="status" value="active"/>
                <% } %>
                <div class="mb-3">
                    <label for="content" class="form-label">Nội dung:</label>
                    <textarea name="content" id="content" class="form-control" rows="6"><%= lesson.getContent() != null ? lesson.getContent() : "" %></textarea>
                </div>
                <div class="actions">
                    <button type="submit" class="btn btn-primary me-2"><i class="fas fa-save me-1"></i><%= "edit".equals(formAction) ? "Cập nhật" : "Thêm mới" %></button>
                    <a href="${pageContext.request.contextPath}/lesson?action=list&subjectId=<%= lesson.getSubjectId() %>" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Hủy</a>
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
