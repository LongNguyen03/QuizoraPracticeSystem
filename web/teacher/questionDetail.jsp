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
    .answer-table { width:100%; border-collapse: collapse; margin-bottom:15px; }
    .answer-table th, .answer-table td { border:1px solid #ddd; padding:8px; }
    .remove-btn { background:red; color:#fff; border:none; padding:4px 8px; border-radius:4px; cursor:pointer; }
    .remove-btn:hover { background:darkred; }
    .actions { text-align:center; margin-top:20px; }
    .actions button { padding:10px 20px; background:#007BFF; color:#fff; border:none; border-radius:4px; cursor:pointer; }
    .actions button:hover { background:#0056b3; }
    .back { text-align:center; margin-top:20px; }
    .back a { color:#007BFF; text-decoration:none; }
    .back a:hover { text-decoration:underline; }
  </style>
  <script>
    // Dimensions lookup
    var lessonsData = [
      <% for (Lesson l : lessons) { %>
        { id: <%=l.getId()%>, dimension: "<%=l.getDimension().replace("\"","\\\"")%>" },
      <% } %>
    ];
    function onLessonChange(el) {
      var dimInput = document.getElementById('dimField');
      var selId = parseInt(el.value);
      var found = lessonsData.find(function(item){return item.id === selId;});
      dimInput.value = found ? found.dimension : '';
    }
    function addAnswerRow() {
      var tbody = document.getElementById('answersBody');
      var idx = tbody.rows.length + 1;
      var row = tbody.insertRow();
      row.innerHTML = `
        <td><input type="hidden" name="answerId[]" value="0"/><input type="text" name="answerContent[]" required/></td>
        <td style="text-align:center"><input type="checkbox" name="answerIsCorrect[]" value="true"/></td>
        <td><input type="number" name="answerOrder[]" value="${idx}" min="1" required/></td>
        <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>`;
    }
    function removeRow(btn) {
      var row = btn.closest('tr');
      row.parentNode.removeChild(row);
      // reorder
      var orders = document.getElementsByName('answerOrder[]');
      for (var i=0;i<orders.length;i++) orders[i].value = i+1;
    }
  </script>
</head>
<body>
  <h2 style="text-align:center"><%= isEdit ? "Edit" : "Create" %> Question</h2>
  <form action="${pageContext.request.contextPath}/QuestionController" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>"/>
    <% if(isEdit){ %><input type="hidden" name="id" value="<%=q.getId()%>"/><% } %>

    <div class="row"><label>Content</label>
      <textarea name="content" rows="3" required><%=isEdit?q.getContent():""%></textarea>
    </div>
    <div class="row"><label>Level</label>
      <input type="text" name="level" value="<%=isEdit?q.getLevel():""%>" required/>
    </div>
    <div class="row"><label>Subject</label>
      <select name="subjectId" required><option value="">-- Select Subject --</option>
        <%for(Subject s:subjects){%>
        <option value="<%=s.getId()%>" <%=isEdit&&q.getSubjectId()==s.getId()?"selected":""%>><%=s.getTitle()%></option>
        <%}%>
      </select>
    </div>
    <div class="row"><label>Lesson</label>
      <select name="lessonId" onchange="onLessonChange(this)" required><option value="">-- Select Lesson --</option>
        <%for(Lesson l:lessons){%>
        <option value="<%=l.getId()%>" <%=isEdit&&q.getLessonId()==l.getId()?"selected":""%>><%=l.getTitle()%></option>
        <%}%>
      </select>
    </div>
    <div class="row"><label>Dimension</label>
      <input type="text" id="dimField" name="dimension" readonly value="<%=isEdit?lessons.stream().filter(x->x.getId()==q.getLessonId()).findFirst().map(x->x.getDimension()).orElse(""):""%>"/>
    </div>
    <div class="row"><label>Image</label>
      <input type="file" name="image" accept="image/*"/>
      <% if(isEdit&&q.getImage()!=null){%>
        <div style="margin-top:10px;"><img src="${pageContext.request.contextPath}/questionImage?id=<%=q.getId()%>" style="max-width:200px;"/></div>
      <%}%>
    </div>

    <!-- answer section -->
    <div class="row">
      <label>Answer Options</label>
      <table class="answer-table">
        <thead><tr><th>Content</th><th>Correct</th><th>Order</th><th>Action</th></tr></thead>
        <tbody id="answersBody">
          <%if(answers!=null){for(QuestionAnswer a:answers){%>
          <tr>
            <td><input type="hidden" name="answerId[]" value="<%=a.getId()%>"/><input type="text" name="answerContent[]" value="<%=a.getContent()%>" required/></td>
            <td style="text-align:center"><input type="checkbox" name="answerIsCorrect[]" value="true" <%=a.isCorrect()?"checked":""%>/></td>
            <td><input type="number" name="answerOrder[]" value="<%=a.getAnswerOrder()%>" min="1" required/></td>
            <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>
          </tr>
          <%}}else{%>
          <tr>
            <td><input type="hidden" name="answerId[]" value="0"/><input type="text" name="answerContent[]" required/></td>
            <td style="text-align:center"><input type="checkbox" name="answerIsCorrect[]" value="true"/></td>
            <td><input type="number" name="answerOrder[]" value="1" min="1" required/></td>
            <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>
          </tr>
          <%}%>
        </tbody>
      </table>
      <button type="button" class="btn" onclick="addAnswerRow()">+ Add Answer</button>
    </div>

    <div class="actions"><button type="submit">Save</button></div>
  </form>
  <div class="back"><a href="${pageContext.request.contextPath}/QuestionController?action=list&lessonId=<%=isEdit?q.getLessonId():""%>">&larr; Back</a></div>
</body>
</html>