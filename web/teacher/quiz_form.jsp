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
<%@ page import="Model.Subject" %>
<% List<Subject> subjects = (List<Subject>) request.getAttribute("subjects"); %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    boolean isEdit = (quiz != null);
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    Integer selectedLessonId = (Integer) request.getAttribute("lessonId");
    // Lấy danh sách subject từ lessons
    java.util.Set<Integer> subjectIds = new java.util.HashSet<>();
    java.util.Map<Integer, String> subjectTitles = new java.util.HashMap<>();
    for (Lesson l : lessons) {
        subjectIds.add(l.getSubjectId());
        subjectTitles.put(l.getSubjectId(), l.getTitle()); // sẽ bị ghi đè, nhưng chỉ cần lấy tên bất kỳ
    }
    // Lấy danh sách subject (id, title)
    // List<Model.Subject> subjects = (List<Model.Subject>) request.getAttribute("subjects"); // This line is now redundant
%>
<% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
  <div class="alert alert-danger text-center"><%= error %></div>
<% } %>
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
            <form method="post" action="${pageContext.request.contextPath}/quizzes">
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
                        <label class="form-label">Môn học</label>
                        <select name="subjectId" id="subjectSelect" class="form-select" required onchange="renderLessonDropdown()">
                            <option value="">-- Chọn môn học --</option>
                            <% if (subjects != null) for (Subject s : subjects) { %>
                                <option value="<%= s.getId() %>"
                                    <%= (isEdit && selectedLessonId != null && lessons.stream().anyMatch(l -> l.getId() == selectedLessonId && l.getSubjectId() == s.getId())) ? "selected" : "" %>>
                                    <%= s.getTitle() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Bài học</label>
                        <div class="input-group mb-2">
                            <select id="lessonDropdown" class="form-select">
                                <option value="">-- Chọn bài học --</option>
                                <% for (Lesson lesson : lessons) { %>
                                    <option value="<%= lesson.getId() %>" data-subject="<%= lesson.getSubjectId() %>">
                                        <%= lesson.getTitle() %>
                                    </option>
                                <% } %>
                            </select>
                            <button type="button" class="btn btn-outline-primary" id="addLessonBtn" title="Thêm bài học">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <div id="selectedLessons" class="mb-2"></div>
                        <input type="hidden" name="lessonIds" id="lessonIdsInput" />
                        <small class="text-muted">Chọn từng bài học, bấm dấu cộng để thêm. Không thể chọn trùng.</small>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Level</label>
                        <select name="level" class="form-select" required>
                            <option value="Easy" <%= isEdit && "Easy".equalsIgnoreCase(quiz.getLevel()) ? "selected" : "" %>>Dễ</option>
                            <option value="Medium" <%= isEdit && "Medium".equalsIgnoreCase(quiz.getLevel()) ? "selected" : "" %>>Trung bình</option>
                            <option value="Hard" <%= isEdit && "Hard".equalsIgnoreCase(quiz.getLevel()) ? "selected" : "" %>>Khó</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Loại</label>
                        <select name="type" class="form-select" required>
                            <option value="Trắc nghiệm" <%= isEdit && "Trắc nghiệm".equalsIgnoreCase(quiz.getType()) ? "selected" : "" %>>Trắc nghiệm</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Số câu hỏi</label>
                        <input type="number" name="numberOfQuestions" id="numberOfQuestions" class="form-control" required min="1"
                               placeholder="VD: 10" value="<%= isEdit ? quiz.getNumberOfQuestions() : "" %>"/>
                        <div class="form-text" id="maxQuestionsInfo"></div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thời gian (phút)</label>
                        <input type="number" name="durationMinutes" class="form-control" required min="1" max="120" placeholder="VD: 30"
                               value="<%= isEdit ? quiz.getDurationMinutes() : "" %>"/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Pass Rate (%)</label>
                        <input type="number" step="0.1" name="passRate" class="form-control" required min="0" max="100" placeholder="VD: 70"
                               value="<%= isEdit ? quiz.getPassRate() : "" %>"/>
                    </div>
                    <div class="col-md-4 d-flex align-items-center">
                        <div class="form-check mt-4">
                            <input class="form-check-input" type="checkbox" name="isPracticeable" id="isPracticeable"
                                <%= (!isEdit || quiz.isPracticeable()) ? "checked" : "" %> />
                            <label class="form-check-label" for="isPracticeable">
                                Cho phép luyện tập (Practiceable)
                            </label>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                        <button type="submit" class="btn btn-success px-4">
                            <i class="fas fa-save"></i> <%= isEdit ? "Cập nhật" : "Tạo mới" %>
                        </button>
                        <a href="${pageContext.request.contextPath}/quizzes" class="btn btn-secondary px-4">Hủy</a>
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
<script>
    var lessons = [
        <% for (int i = 0; i < lessons.size(); i++) { Lesson l = lessons.get(i); %>
        { id: <%= l.getId() %>, subjectId: <%= l.getSubjectId() %>, title: "<%= l.getTitle().replace("\"", "\\\"") %>" }<%= (i < lessons.size() - 1) ? "," : "" %>
        <% } %>
    ];
    <% if (request.getAttribute("lessonIds") != null && request.getAttribute("lessonIds") instanceof java.util.List) { %>
    var selectedLessons = [<%java.util.List<?> lids = (java.util.List<?>) request.getAttribute("lessonIds");for (int i = 0; i < lids.size(); i++) { %><%= Integer.parseInt(lids.get(i).toString()) %><% if (i < lids.size() - 1) { %>,<% } %><% } %>];
    <% } else { %>
    var selectedLessons = [];
    <% } %>
    var subjectSelect = document.getElementById('subjectSelect');
    var lessonDropdown = document.getElementById('lessonDropdown');
    var addLessonBtn = document.getElementById('addLessonBtn');
    var selectedLessonsDiv = document.getElementById('selectedLessons');
    var lessonIdsInput = document.getElementById('lessonIdsInput');

    function renderLessonDropdown() {
        var subjectId = subjectSelect.value;
        for (var i = 0; i < lessonDropdown.options.length; i++) {
            var opt = lessonDropdown.options[i];
            if (!opt.value) continue;
            var subj = opt.getAttribute('data-subject');
            var lessonId = parseInt(opt.value);
            opt.style.display = (subj === subjectId && !selectedLessons.includes(lessonId)) ? '' : 'none';
        }
        lessonDropdown.value = '';
    }

    function renderSelectedLessons() {
        selectedLessonsDiv.innerHTML = '';
        selectedLessons.forEach(function(lessonId) {
            var lesson = lessons.find(function(l) { return l.id === lessonId; });
            if (lesson) {
                var tag = document.createElement('span');
                tag.className = 'badge bg-primary me-2 mb-1';
                tag.innerHTML = lesson.title +
                    ' <button type="button" class="btn btn-sm btn-light ms-1" onclick="removeLesson(' + lesson.id + ')"><i class="fas fa-times"></i></button>';
                selectedLessonsDiv.appendChild(tag);
            }
        });
        lessonIdsInput.value = selectedLessons.join(',');
    }

    addLessonBtn.onclick = function() {
        var lessonId = parseInt(lessonDropdown.value);
        if (!lessonId || selectedLessons.includes(lessonId)) return;
        selectedLessons.push(lessonId);
        renderLessonDropdown();
        renderSelectedLessons();
    };

    window.removeLesson = function(lessonId) {
        selectedLessons = selectedLessons.filter(function(id) { return id !== lessonId; });
        renderLessonDropdown();
        renderSelectedLessons();
    };

    subjectSelect.onchange = function() {
        renderLessonDropdown();
    };

    window.addEventListener('DOMContentLoaded', function() {
        renderLessonDropdown();
        renderSelectedLessons();
    });
</script>
</body>
</html>
