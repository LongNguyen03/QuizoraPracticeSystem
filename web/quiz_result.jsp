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
  <h2>Kết quả Quiz: <%= result.getQuiz().getName() %></h2>
  Điểm: <%=result.getScore()%>%<br/>
  Passed: <%= result.isPassed() ? "Passed" : "Not Passed" %><br/>
  Ngày làm: <%= result.getAttemptDate() %><br/>
  Thời gian làm bài: <%= result.getTimeTakenFormatted() %><br/>
  <a href="quiz?action=list">Về danh sách Quiz</a>
</body></html>
