<%-- 
    Document   : quiz_form
    Created on : Jul 3, 2025, 10:27:55 PM
    Author     : kan3v
--%>

<%@ page import="java.util.*, com.quizora.dao.*, com.quizora.model.*" %>
<%
    SubjectDAO subjectDAO = new SubjectDAO();
    List<Subject> subjects = subjectDAO.findAll();
    // N?u edit: load Quiz q = quizDAO.findById(id);
%>
<html><head>
  <script>
    function loadLessons() {
      var subjId = document.getElementById("subject").value;
      var xhr = new XMLHttpRequest();
      xhr.open("GET", "lessons?subjectId=" + subjId, true);
      xhr.onload = function() {
        var lessons = JSON.parse(this.responseText);
        var sel = document.getElementById("lesson");
        sel.innerHTML = "<option value=''>--Ch?n lesson--</option>";
        lessons.forEach(function(l){
          sel.innerHTML += "<option value='"+l.id+"'>"+l.title+"</option>";
        });
      };
      xhr.send();
    }
  </script>
</head>
<body>
  <form action="quiz?action=save" method="post">
    <input type="hidden" name="id" value="<%= request.getParameter("id")%>"/>
    Tên Quiz: <input type="text" name="name" value="<%= /* q.getName() */ "" %>" required/><br/>
    Ch? ??:
    <select id="subject" name="subjectId" onchange="loadLessons()" required>
      <option value="">--Ch?n subject--</option>
      <% for(Subject s: subjects){ %>
        <option value="<%=s.getId()%>"><%=s.getTitle()%></option>
      <% } %>
    </select><br/>
    Lesson:
    <select id="lesson" name="lessonId" required>
      <option value="">--Ch?n lesson--</option>
    </select><br/>
    S? câu h?i: <input type="number" name="numberOfQuestions" min="1" required/><br/>
    Th?i gian (phút): <input type="number" name="durationMinutes" min="1" required/><br/>
    Pass rate (%): <input type="number" name="passRate" step="0.01" min="0" max="100" required/><br/>
    Lo?i: <input type="text" name="type" required/><br/>
    <button type="submit">L?u</button>
  </form>
</body></html>
