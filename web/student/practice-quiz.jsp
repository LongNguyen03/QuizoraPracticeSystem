<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Practice Quiz - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .practice-quiz-container { max-width: 800px; margin: 40px auto; }
        .quiz-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; border-radius: 10px 10px 0 0; padding: 24px 32px; }
        .quiz-title { font-size: 2rem; font-weight: 700; }
        .quiz-meta { font-size: 1rem; opacity: 0.9; }
        .question-block { background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 24px; padding: 24px; }
        .question-title { font-weight: 600; margin-bottom: 12px; }
        .form-check { margin-bottom: 8px; }
        .btn-submit { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; font-weight: 600; border: none; border-radius: 8px; padding: 12px 32px; }
        .btn-submit:hover { background: linear-gradient(135deg, #764ba2 0%, #667eea 100%); }
        .score-alert { font-size: 1.2rem; font-weight: 600; }
    </style>
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
<div class="practice-quiz-container">
    <div class="quiz-header mb-4">
        <div class="quiz-title"><i class="fas fa-dumbbell me-2"></i>Làm thử Quiz: ${quiz.name}</div>
        <div class="quiz-meta mt-2">
            <span><strong>Môn học:</strong> ${quiz.subjectTitle}</span> |
            <span><strong>Level:</strong> ${quiz.level}</span> |
            <span><strong>Số câu hỏi:</strong> ${quiz.numberOfQuestions}</span>
        </div>
    </div>
    <div class="card p-4">
        <form id="practiceForm" method="post" action="${pageContext.request.contextPath}/student/practice-quiz">
            <input type="hidden" name="quizId" value="${quiz.id}" />
            <c:forEach var="question" items="${questions}" varStatus="qIdx">
                <div class="question-block">
                    <div class="question-title">Câu ${qIdx.index + 1}: ${question.content}</div>
                    <c:forEach var="answer" items="${question.answers}" varStatus="aIdx">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="answer_${question.id}" id="q${question.id}_a${aIdx.index}" value="${answer.id}" required>
                            <label class="form-check-label" for="q${question.id}_a${aIdx.index}">
                                ${answer.content}
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>
            <div class="text-center">
                <button type="submit" class="btn btn-submit mt-3"><i class="fas fa-check"></i> Nộp bài</button>
            </div>
        </form>
        <c:if test="${not empty score}">
            <div class="alert alert-info score-alert mt-4 text-center">
                <i class="fas fa-star me-2"></i><strong>Kết quả:</strong> Bạn đúng <span class="text-success">${score}</span> / <span class="text-primary">${questions.size()}</span> câu hỏi.
            </div>
        </c:if>
    </div>
    <div class="mt-4 text-center">
        <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách Quiz</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 