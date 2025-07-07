<%-- 
    Document   : quiz_result
    Created on : Jul 3, 2025, 10:29:52 PM
    Author     : kan3v
--%>

<%@ page import="com.quizora.model.*"%>
<%
  QuizResult result = (QuizResult) request.getAttribute("result");
%>
<html><body>
    <jsp:include page="views/components/header.jsp" />
  <h2>K?t qu? Quiz: <%= result.getQuiz().getName() %></h2>
  ?i?m: <%=result.getScore()%>%<br/>
  Passed: <%= result.isPassed() ? "Passed" : "Not Passed" %><br/>
  Ng�y l�m: <%= result.getAttemptDate() %><br/>
  <a href="quiz?action=list">V? danh s�ch Quiz</a>
</body></html>
