<%-- 
    Document   : question_detail
    Created on : May 30, 2025, 8:40:31 AM
    Author     : kan3v
--%>

<%-- questionDetail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question, Model.Subject, Model.Lesson" %>
<%@ page import="java.text.SimpleDateFormat, java.util.List" %>

<%
    Question q = (Question) request.getAttribute("question");
    boolean isEdit = q != null;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Lesson> lessons   = (List<Lesson>)   request.getAttribute("lessons");
%>

<html>
<head>
  <title><%= isEdit ? "Edit" : "Create" %> Question</title>
  <style>
    body { font-family: Arial; background:#f9f9f9; padding:40px; }
    form { max-width:700px; margin:auto; background:#fff; padding:20px; box-shadow:0 0 10px rgba(0,0,0,0.1); }
    .row { margin-bottom:15px; }
    .row label { display:block; margin-bottom:5px; font-weight:bold; }
    .row input[type="text"], .row textarea, .row select { width:100%; padding:8px; border:1px solid #ccc; border-radius:4px; }
    .row input[type="file"] { padding:5px; }
    .actions { text-align:center; margin-top:20px; }
    .actions button { padding:10px 20px; background:#007BFF; color:#fff; border:none; border-radius:4px; cursor:pointer; }
    .actions button:hover { background:#0056b3; }
    .back { text-align:center; margin-top:20px; }
    .back a { color:#007BFF; text-decoration:none; }
    .back a:hover { text-decoration:underline; }
  </style>
  <script>
    // Build JS array of lessons with id and dimension
    var lessonsData = [
      <% for (Lesson l : lessons) { %>
        { id: <%=l.getId()%>, dimension: "<%=l.getDimension().replace("\"","\\\"")%>" },
      <% } %>
    ];
    function onLessonChange(el) {
      var dimInput = document.getElementById('dimField');
      var selId = parseInt(el.value);
      var found = lessonsData.find(function(item) { return item.id === selId; });
      dimInput.value = found ? found.dimension : '';
    }
  </script>
</head>
<body>
  <h2 style="text-align:center"><%= isEdit ? "Edit" : "Create" %> Question</h2>
  <form action="QuestionController" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>"/>
    <% if (isEdit) { %>
      <input type="hidden" name="id" value="<%= q.getId() %>"/>
    <% } %>

    <div class="row">
      <label>Content</label>
      <textarea name="content" rows="3" required><%= isEdit ? q.getContent() : "" %></textarea>
    </div>

    <div class="row">
      <label>Level</label>
      <input type="text" name="level" value="<%= isEdit ? q.getLevel() : "" %>" required/>
    </div>

    <div class="row">
      <label>Subject</label>
      <select name="subjectId" required>
        <option value="">-- Select Subject --</option>
        <% for (Subject s : subjects) { %>
          <option value="<%= s.getId() %>" <%= isEdit && q.getSubjectId()==s.getId()?"selected":"" %>><%= s.getTitle() %></option>
        <% } %>
      </select>
    </div>

    <div class="row">
      <label>Lesson</label>
      <select name="lessonId" onchange="onLessonChange(this)" required>
        <option value="">-- Select Lesson --</option>
        <% for (Lesson l : lessons) { %>
          <option value="<%= l.getId() %>" <%= isEdit && q.getLessonId()==l.getId()?"selected":"" %>><%= l.getTitle() %></option>
        <% } %>
      </select>
    </div>

    <div class="row">
      <label>Dimension</label>
      <input type="text" id="dimField" name="dimension" readonly
             value="<%= isEdit 
                      ? lessons.stream().filter(x->x.getId()==q.getLessonId())
                               .findFirst().map(x->x.getDimension()).orElse("") 
                      : "" %>"/>
    </div>

    <div class="row">
      <label>Image</label>
      <input type="file" name="image" accept="image/*"/>
      <% if (isEdit && q.getImage() != null) { %>
        <div style="margin-top:10px;"><img src="questionImage?id=<%= q.getId() %>" style="max-width:200px;"/></div>
      <% } %>
    </div>

    <% if (isEdit) { %>
    <div class="row">
      <label>Created At</label>
      <input type="text" readonly value="<%= sdf.format(q.getCreatedAt()) %>"/>
    </div>
    <div class="row">
      <label>Updated At</label>
      <input type="text" readonly value="<%= q.getUpdatedAt() != null ? sdf.format(q.getUpdatedAt()) : "" %>"/>
    </div>
    <% } %>

    <div class="actions">
      <button type="submit">Save</button>
    </div>
  </form>

  <div class="back">
    <a href="QuestionController?action=list&lessonId=<%= isEdit ? q.getLessonId() : "" %>">&larr; Back to Question List</a>
  </div>
</body>
</html>
