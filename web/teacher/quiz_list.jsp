<%-- 
    Document   : quiz_list
    Created on : Jul 3, 2025, 10:29:10 PM
    Author     : kan3v
--%>

<%@ page import="java.util.*, com.quizora.model.*" %>
<%
  List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
%>
<html><body>
  <a href="quiz?action=create">T?o Quiz m?i</a><br/><br/>
  <table border="1">
    <tr><th>ID</th><th>Tên</th><th>Ngày t?o</th><th>Hành ??ng</th></tr>
    <% for(Quiz q: quizzes){ %>
      <tr>
        <td><%=q.getId()%></td>
        <td><%=q.getName()%></td>
        <td><%=q.getCreatedAt()%></td>
        <td>
          <a href="quiz?action=edit&id=<%=q.getId()%>">S?a</a> |
          <a href="quiz?action=delete&id=<%=q.getId()%>">Xoá</a> |
          <a href="takeQuiz?quizId=<%=q.getId()%>">Làm Quiz</a>
        </td>
      </tr>
    <% } %>
  </table>
</body></html>
