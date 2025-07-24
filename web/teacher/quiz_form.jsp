<%-- 
    Document   : quiz_form
    Created on : Jul 3, 2025, 10:27:55 PM
    Author     : kan3v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Quiz" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Lesson" %>
<%@ page import="Model.Question" %>
<%@ page import="Model.QuestionAnswer" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Tên Quiz</label>
                        <input type="text" name="name" class="form-control" required placeholder="Nhập tên quiz"
                               value="<%= isEdit ? quiz.getName() : "" %>"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Lesson</label>
                        <select name="lessonId" class="form-select" required>
                            <% 
                                List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
                                Integer selectedLessonId = (Integer) request.getAttribute("lessonId");
                                if (lessons != null) {
                                    for (Lesson lesson : lessons) {
                            %>
                                <option value="<%= lesson.getId() %>" <%= (selectedLessonId != null && lesson.getId() == selectedLessonId) ? "selected" : "" %>>
                                    <%= lesson.getTitle() %>
                                </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Level</label>
                        <input type="text" name="level" class="form-control" required placeholder="VD: Easy, Medium, Hard"
                               value="<%= isEdit ? quiz.getLevel() : "" %>"/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Số câu hỏi</label>
                        <input type="number" name="numberOfQuestions" class="form-control" required min="1" placeholder="VD: 10"
                               value="<%= isEdit ? quiz.getNumberOfQuestions() : "" %>"/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thời gian (phút)</label>
                        <input type="number" name="durationMinutes" class="form-control" required min="1" placeholder="VD: 30"
                               value="<%= isEdit ? quiz.getDurationMinutes() : "" %>"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Pass Rate (%)</label>
                        <input type="number" step="0.1" name="passRate" class="form-control" required min="0" max="100" placeholder="VD: 70"
                               value="<%= isEdit ? quiz.getPassRate() : "" %>"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Loại</label>
                        <input type="text" name="type" class="form-control" required placeholder="VD: Practice, Exam"
                               value="<%= isEdit ? quiz.getType() : "" %>"/>
                    </div>
                    <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                        <button type="submit" class="btn btn-success px-4">
                            <i class="fas fa-save"></i> <%= isEdit ? "Cập nhật" : "Tạo mới" %>
                        </button>
                        <a href="${pageContext.request.contextPath}/quiz" class="btn btn-secondary px-4">Hủy</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<% if (isEdit) { %>
<div class="container mt-5">
    <div class="card mt-4">
        <div class="card-body">
            <h4 class="mb-3">Danh sách câu hỏi trong Quiz</h4>
            <div class="row g-4">
                <%
                    List<Question> quizQuestions = (List<Question>) request.getAttribute("quizQuestions");
                    Map<Integer, List<QuestionAnswer>> answersMap = (Map<Integer, List<QuestionAnswer>>) request.getAttribute("answersMap");
                    if (quizQuestions != null) {
                        for (Question q : quizQuestions) {
                %>
                <div class="col-md-6">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <h6 class="card-title mb-2"><i class="bi bi-question-circle"></i> <%= q.getContent() %></h6>
                            <ul class="list-group list-group-flush">
                            <%
                                List<QuestionAnswer> answers = answersMap.get(q.getId());
                                if (answers != null) {
                                    for (QuestionAnswer ans : answers) {
                            %>
                                <li class="list-group-item d-flex align-items-center">
                                    <input type="checkbox" class="form-check-input me-2" disabled <%= ans.isCorrect() ? "checked" : "" %> />
                                    <span class="<%= ans.isCorrect() ? "badge bg-success me-2" : "badge bg-light text-dark me-2" %>">
                                        <%= ans.isCorrect() ? "Đúng" : "Sai" %>
                                    </span>
                                    <span><%= ans.getContent() %></span>
                                </li>
                            <%
                                    }
                                }
                            %>
                            </ul>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
