<%-- 
    Document   : quiz_handle
    Created on : Jul 3, 2025, 10:29:31 PM
    Author     : kan3v
--%>

<%@ page import="com.quizora.model.*"%>
<%
  List<Question> questions = (List<Question>) session.getAttribute("questions");
  int current = (Integer) session.getAttribute("currentIndex");
  Question q = questions.get(current);
  List<QuestionAnswer> answers = new QuestionAnswerDAO().findByQuestion(q.getId());
%>
<html><head>
<script>
  function goTo(idx){
    document.getElementById("navForm").questionIndex.value = idx;
    document.getElementById("navForm").submit();
  }
</script>
</head><body>
    <jsp:include page="views/components/header.jsp" />
  <div style="width:25%; float:left; border-right:1px solid #ccc; height: 100vh; overflow:auto;">
    <% for(int i=0; i<questions.size(); i++){ %>
      <button onclick="goTo(<%=i%>)"><%=i+1%></button>
      <% if((i+1)%5==0) out.print("<br/>"); %>
    <% } %>
    <form id="navForm" action="takeQuiz" method="post">
      <input type="hidden" name="questionIndex" value="" />
    </form>
  </div>
  <div style="width:75%; float:right; padding:20px;">
    <h3>C�u <%= current+1 %>: <%= q.getContent() %></h3>
    <% if(q.getImage()!=null){ %>
      <img src="data:image/png;base64,<%= Base64.getEncoder().encodeToString(q.getImage()) %>" />
    <% } %>
    <form action="takeQuiz" method="post">
      <input type="hidden" name="questionIndex" value="<%=current%>" />
      <% for(QuestionAnswer a: answers){ %>
        <input type="radio" name="answerId" value="<%=a.getId()%>" 
            <%= (session.getAttribute("userAnswers_"+current)!=null 
                   && ((Integer)session.getAttribute("userAnswers_"+current)).intValue()==a.getId()) 
                 ? "checked":"" %> />
        <%=a.getContent()%><br/>
      <% } %>
      <button type="submit">L?u c�u tr? l?i & Chuy?n</button>
      <button type="submit" name="finish" value="true">Ho�n th�nh</button>
    </form>
  </div>
</body></html>
