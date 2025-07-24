<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Practice Quiz - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header bg-info text-white">
            <h3 class="mb-0"><i class="fas fa-dumbbell me-2"></i>Practice Quiz: ${quiz.name}</h3>
        </div>
        <div class="card-body">
            <p><strong>Subject:</strong> ${quiz.subjectTitle}</p>
            <p><strong>Level:</strong> ${quiz.level}</p>
            <p><strong>Number of Questions:</strong> ${quiz.numberOfQuestions}</p>
            <form id="practiceForm" method="post" action="${pageContext.request.contextPath}/student/practice-quiz">
                <input type="hidden" name="quizId" value="${quiz.id}" />
                <c:forEach var="question" items="${questions}" varStatus="qIdx">
                    <div class="mb-4">
                        <div class="fw-bold mb-2">Question ${qIdx.index + 1}: ${question.content}</div>
                        <c:forEach var="answer" items="${question.answers}" varStatus="aIdx">
                            <div class="form-check mb-1">
                                <input class="form-check-input" type="radio" name="answer_${question.id}" id="q${question.id}_a${aIdx.index}" value="${answer.id}" required>
                                <label class="form-check-label" for="q${question.id}_a${aIdx.index}">
                                    ${answer.content}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </c:forEach>
                <button type="submit" class="btn btn-success px-4"><i class="fas fa-check"></i> Submit</button>
            </form>
            <c:if test="${not empty score}">
                <div class="alert alert-info mt-4">
                    <strong>Your Score:</strong> ${score} / ${questions.size()}
                </div>
            </c:if>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 