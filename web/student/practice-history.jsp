<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử luyện tập - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
<div class="container py-5">
    <h2 class="mb-4"><i class="fas fa-dumbbell me-2"></i>Lịch sử luyện tập</h2>
    <c:choose>
        <c:when test="${not empty practiceSessions}">
            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Subject</th>
                        <th>Lesson</th>
                        <th>Start Time</th>
                        <th>Score</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ps" items="${practiceSessions}">
                        <tr>
                            <td>${ps.subjectTitle}</td>
                            <td>${ps.lessonTitle != null ? ps.lessonTitle : '-'}</td>
                            <td><fmt:formatDate value="${ps.startTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                            <td>${ps.totalScore != null ? ps.totalScore : '-'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${ps.completed}">
                                        <span class="badge bg-success">Completed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark">In Progress</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info mt-4">
                <i class="fas fa-dumbbell me-2"></i>Chưa có lịch sử luyện tập nào.
            </div>
        </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/student/practice" class="btn btn-secondary mt-4">
        <i class="fas fa-arrow-left me-2"></i>Quay lại Practice
    </a>
</div>
</body>
</html> 