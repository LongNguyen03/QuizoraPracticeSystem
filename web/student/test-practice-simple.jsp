<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Practice Simple</title>
</head>
<body>
    <h1>Test Practice Simple</h1>
    
    <form method="post" action="${pageContext.request.contextPath}/student/practice">
        <input type="hidden" name="action" value="finish">
        <input type="hidden" name="sessionId" value="79">
        <input type="hidden" name="userAnswers" value="1:1,2:3,3:2">
        <button type="submit">Test Submit Practice</button>
    </form>
    
    <p><a href="${pageContext.request.contextPath}/student/practice?action=result&sessionId=79">Test View Result</a></p>
    
    <p><a href="${pageContext.request.contextPath}/student/practice">Go to Practice</a></p>
</body>
</html> 