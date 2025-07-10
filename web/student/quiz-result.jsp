<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Result</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .result-pass { color: #28a745; font-weight: bold; }
        .result-fail { color: #dc3545; font-weight: bold; }
        .answer-correct { background: #d4edda; }
        .answer-wrong { background: #f8d7da; }
        .answer-user { border: 2px solid #007bff; }
    </style>
</head>
<body>
<jsp:include page="../views/components/header.jsp" />

<div class="container py-4">
    <c:choose>
        <c:when test="${quiz == null || quizResult == null}">
            <div class="alert alert-danger mt-5">
                <h3>Lỗi dữ liệu hoặc quiz không tồn tại!</h3>
                <p>Không thể hiển thị kết quả quiz. Vui lòng thử lại hoặc liên hệ quản trị viên.</p>
                <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-primary mt-3">Về danh sách quiz</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="mb-4">
                <h2>Kết quả quiz: ${quiz.name}</h2>
                <p>Ngày làm: <b>${quizResult.attemptDate}</b></p>
                <p>Thời gian làm bài: <b>${quizResult.timeTakenFormatted}</b></p>
                <h3>
                    Điểm: <span>${quizResult.score}%</span>
                    <span class="${quizResult.passed ? 'result-pass' : 'result-fail'}">
                        (${quizResult.passed ? 'Đạt' : 'Không đạt'})
                    </span>
                </h3>
                <p>Điểm đạt: ${quiz.passRate}%</p>
            </div>
            <hr>
            <h4>Chi tiết từng câu hỏi</h4>
            <c:forEach var="ua" items="${userAnswers}" varStatus="status">
                <c:choose>
                    <c:when test="${not empty ua.questionContent}">
                        <div class="mb-3">
                            <div><b>Câu ${status.index + 1}:</b> ${ua.questionContent}</div>
                            <div>
                                <span class="badge ${ua.correct ? 'bg-success' : 'bg-danger'}">
                                    ${ua.correct ? 'Đúng' : 'Sai'}
                                </span>
                                <span>Đáp án của bạn: ${ua.answerContent}</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="mb-3 text-danger">Dữ liệu câu trả lời bị lỗi hoặc thiếu!</div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-secondary mt-4">Làm quiz khác</a>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html> 