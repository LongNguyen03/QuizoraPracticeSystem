<%-- 
    Document   : question_detail
    Created on : May 30, 2025, 8:40:31 AM
    Author     : kan3v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question, Model.Subject, Model.Lesson, Model.QuestionAnswer" %>
<%@ page import="java.text.SimpleDateFormat, java.util.List" %>
<%
    Question q = (Question) request.getAttribute("question");
    boolean isEdit = q != null;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Lesson> lessons   = (List<Lesson>)   request.getAttribute("lessons");
    List<QuestionAnswer> answers = (List<QuestionAnswer>) request.getAttribute("answers");
    // Lấy lesson hiện tại
    String lessonIdParam = request.getParameter("lessonId");
    int lessonId = -1;
    if (isEdit) {
        lessonId = q.getLessonId();
    } else if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
        try {
            lessonId = Integer.parseInt(lessonIdParam);
        } catch (NumberFormatException e) {
            lessonId = -1;
        }
    }
    if (lessonId == -1) {
%>
    <div style="color:red;text-align:center;">Không xác định được bài học để tạo câu hỏi!</div>
<%
} else {
%>
<%
    Lesson currentLesson = null;
    Subject currentSubject = null;
    for (Lesson l : lessons) {
        if (l.getId() == lessonId) {
            currentLesson = l;
            break;
        }
    }
    if (currentLesson != null && subjects != null) {
        for (Subject s : subjects) {
            if (s.getId() == currentLesson.getSubjectId()) {
                currentSubject = s;
                break;
            }
        }
    }
%>
<html>
<head>
  <title><%= isEdit ? "Edit" : "Create" %> Question</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body { background:#f7f7f7; padding:40px; }
    .card-form { max-width:700px; margin:auto; background:#fff; padding:32px 28px; border-radius:16px; box-shadow:0 2px 16px rgba(0,0,0,0.09); }
    .form-label { font-weight:600; }
    .form-control, .form-select { border-radius:8px; }
    .answer-table th, .answer-table td { vertical-align:middle; }
    .remove-btn { background:#dc3545; color:#fff; border:none; padding:4px 10px; border-radius:6px; cursor:pointer; font-size:1rem; }
    .remove-btn:hover { background:#a71d2a; }
    .actions { text-align:center; margin-top:28px; }
    .actions button, .actions a { padding:10px 28px; border-radius:8px; font-weight:500; }
    .actions .btn-primary { background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); border:none; }
    .actions .btn-primary:hover { background: linear-gradient(90deg, #764ba2 0%, #667eea 100%); }
    .actions .btn-secondary { background:#e9ecef; color:#333; border:none; }
    .back { text-align:center; margin-top:20px; }
    .back a { color:#007BFF; text-decoration:none; }
    .back a:hover { text-decoration:underline; }
  </style>
  <script>
    function addAnswerRow() {
      var tbody = document.getElementById('answersBody');
      var idx = tbody.rows.length + 1;
      var row = tbody.insertRow();
      row.innerHTML = `
        <td><input type="hidden" name="answerId[]" value="0"/><input type="text" name="answerContent[]" class="form-control" required/></td>
        <td class="text-center"><input type="radio" name="answerIsCorrect" value="${idx-1}" required/></td>
        <td class="text-center"><button type="button" class="remove-btn" onclick="removeRow(this)"><i class="fas fa-times"></i></button></td>`;
      updateRadioNames();
    }
    function removeRow(btn) {
      var row = btn.closest('tr');
      var tbody = document.getElementById('answersBody');
      tbody.removeChild(row);
      // update radio value
      for (var i = 0; i < tbody.rows.length; i++) {
        tbody.rows[i].querySelector('input[type="radio"]').value = i;
      }
      updateRadioNames();
    }
    function updateRadioNames() {
      // ensure only one radio group for all answers
      var radios = document.querySelectorAll('input[type="radio"][name^="answerIsCorrect"]');
      radios.forEach(function(radio, idx) {
        radio.name = 'answerIsCorrect';
        radio.value = idx;
      });
    }
    function validateForm() {
      var content = document.querySelector('textarea[name="content"]').value.trim();
      if (!content) { alert('Vui lòng nhập nội dung câu hỏi!'); return false; }
      var answerContents = document.querySelectorAll('input[name="answerContent[]"]');
      var hasEmpty = false;
      answerContents.forEach(function(input){ if (!input.value.trim()) hasEmpty = true; });
      if (hasEmpty) { alert('Không được để trống nội dung đáp án!'); return false; }
      var radios = document.getElementsByName('answerIsCorrect');
      var checked = false;
      for (var i=0;i<radios.length;i++) if (radios[i].checked) checked = true;
      if (!checked) { alert('Vui lòng chọn 1 đáp án đúng!'); return false; }
      return true;
    }
  </script>
</head>
<body>
  <div class="container py-4">
    <div class="card-form">
      <h2 class="text-center mb-4 fw-bold text-primary"><i class="fas fa-question-circle me-2"></i><%= isEdit ? "Edit" : "Create" %> Question</h2>
      <% String error = (String) request.getAttribute("error"); %>
      <% if (error != null) { %>
        <div class="alert alert-danger text-center"><%= error %></div>
      <% } %>
      <form action="${pageContext.request.contextPath}/QuestionController" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>"/>
        <% if(isEdit){ %><input type="hidden" name="id" value="<%=q.getId()%>"/><% } %>
        <input type="hidden" name="lessonId" value="<%= lessonId %>"/>
        <input type="hidden" name="subjectId" value="<%= currentLesson != null ? currentLesson.getSubjectId() : "" %>"/>
        <div class="mb-3">
          <label class="form-label">Môn học</label>
          <input type="text" class="form-control" value="<%= currentSubject != null ? currentSubject.getTitle() : "" %>" readonly/>
        </div>
        <div class="mb-3">
          <label class="form-label">Bài học</label>
          <input type="text" class="form-control" value="<%= currentLesson != null ? currentLesson.getTitle() : "" %>" readonly/>
        </div>
        <div class="mb-3">
          <label class="form-label">Level</label>
          <select name="level" class="form-select" required>
            <option value="Easy" <%= isEdit && "Easy".equalsIgnoreCase(q.getLevel()) ? "selected" : "" %>>Dễ</option>
            <option value="Medium" <%= isEdit && "Medium".equalsIgnoreCase(q.getLevel()) ? "selected" : "" %>>Trung bình</option>
            <option value="Hard" <%= isEdit && "Hard".equalsIgnoreCase(q.getLevel()) ? "selected" : "" %>>Khó</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">Nội dung câu hỏi</label>
          <textarea name="content" class="form-control" rows="3" required><%=isEdit?q.getContent():""%></textarea>
        </div>
        <div class="mb-3">
          <label class="form-label">Hình ảnh (tuỳ chọn)</label>
          <input type="file" name="image" class="form-control" accept="image/*"/>
          <% if(isEdit&&q.getImage()!=null){%>
            <div class="mt-2"><img src="${pageContext.request.contextPath}/questionImage?id=<%=q.getId()%>" style="max-width:200px;" class="rounded shadow-sm"/></div>
          <%}%>
        </div>
        <div class="mb-3 form-check">
          <input type="checkbox" class="form-check-input" id="isPracticeOnly" name="isPracticeOnly" value="true" <%= isEdit && q.isPracticeOnly() ? "checked" : "" %> />
          <label class="form-check-label" for="isPracticeOnly">Chỉ dùng cho Practice (Không xuất hiện trong Quiz)</label>
        </div>
        <div class="mb-3">
          <label class="form-label">Answer Options</label>
          <table class="table table-bordered answer-table align-middle">
            <thead class="table-light"><tr><th>Content</th><th>Correct</th><th>Action</th></tr></thead>
            <tbody id="answersBody">
              <%if(answers!=null){int idx=0;for(QuestionAnswer a:answers){%>
              <tr>
                <td><input type="hidden" name="answerId[]" value="<%=a.getId()%>"/><input type="text" name="answerContent[]" class="form-control" value="<%=a.getContent()%>" required/></td>
                <td class="text-center"><input type="radio" name="answerIsCorrect" value="<%=idx%>" <%=a.isCorrect()?"checked":""%> required/></td>
                <td class="text-center"><button type="button" class="remove-btn" onclick="removeRow(this)"><i class="fas fa-times"></i></button></td>
              </tr>
              <%idx++;}}else{%>
              <tr>
                <td><input type="hidden" name="answerId[]" value="0"/><input type="text" name="answerContent[]" class="form-control" required/></td>
                <td class="text-center"><input type="radio" name="answerIsCorrect" value="0" required/></td>
                <td class="text-center"><button type="button" class="remove-btn" onclick="removeRow(this)"><i class="fas fa-times"></i></button></td>
              </tr>
              <%}%>
            </tbody>
          </table>
          <button type="button" class="btn btn-outline-primary" onclick="addAnswerRow()"><i class="fas fa-plus"></i> Add Answer</button>
        </div>
        <div class="actions">
          <button type="submit" class="btn btn-primary me-2"><i class="fas fa-save me-1"></i>Save</button>
          <a href="${pageContext.request.contextPath}/QuestionController?action=list&lessonId=<%=lessonId%>" class="btn btn-secondary"><i class="fas fa-arrow-left me-1"></i>Back</a>
        </div>
      </form>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<% } %>