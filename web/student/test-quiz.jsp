<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Quiz Submission</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="../views/components/header.jsp" />

<div class="container py-4">
    <h2>Test Quiz Submission</h2>
    
    <div class="alert alert-info">
        <strong>Debug Info:</strong><br>
        Quiz ID: ${param.quizId}<br>
        Account ID: ${sessionScope.accountId}<br>
        Session ID: ${sessionScope.id}
    </div>
    
    <form method="post" action="${pageContext.request.contextPath}/student/quiz/1">
        <input type="hidden" name="quizId" value="1" />
        
        <div class="card mb-3">
            <div class="card-header">
                <b>Câu 1:</b> Test Question 1
            </div>
            <div class="card-body">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_1" value="1" id="q1_a1">
                    <label class="form-check-label" for="q1_a1">Answer 1</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_1" value="2" id="q1_a2">
                    <label class="form-check-label" for="q1_a2">Answer 2</label>
                </div>
                <input type="hidden" name="question_1" value="1" />
            </div>
        </div>
        
        <div class="card mb-3">
            <div class="card-header">
                <b>Câu 2:</b> Test Question 2
            </div>
            <div class="card-body">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_2" value="3" id="q2_a3">
                    <label class="form-check-label" for="q2_a3">Answer 3</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_2" value="4" id="q2_a4">
                    <label class="form-check-label" for="q2_a4">Answer 4</label>
                </div>
                <input type="hidden" name="question_2" value="2" />
            </div>
        </div>
        
        <button type="submit" class="btn btn-primary btn-lg w-100">Test Submit Quiz</button>
    </form>
    
    <div class="mt-4">
        <a href="${pageContext.request.contextPath}/student/home" class="btn btn-secondary">Back to Home</a>
    </div>
</div>
</body>
</html> 