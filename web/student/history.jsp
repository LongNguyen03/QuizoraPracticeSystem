<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz History - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .history-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .history-card:hover {
            transform: translateY(-2px);
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 1.5rem;
            color: white;
            text-align: center;
        }
        .score-badge {
            font-size: 1.2rem;
            font-weight: bold;
            padding: 0.5rem 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />

    <div class="container py-4">
        <!-- Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="display-6 fw-bold text-primary">
                    <i class="fas fa-history me-2"></i>
                    Quiz History
                </h1>
                <p class="text-muted">View all your quiz attempts and results</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-4 mb-3">
                <div class="stat-card">
                    <h3 class="mb-0">${totalQuizzes}</h3>
                    <p class="mb-0 opacity-75">Total Quizzes</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="stat-card">
                    <h3 class="mb-0">${passedQuizzes}</h3>
                    <p class="mb-0 opacity-75">Quizzes Passed</p>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="stat-card">
                    <h3 class="mb-0">${averageScore}%</h3>
                    <p class="mb-0 opacity-75">Average Score</p>
                </div>
            </div>
        </div>

        <!-- Quiz Results -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-list me-2"></i>
                            All Quiz Results
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty quizResults}">
                            <c:forEach var="result" items="${quizResults}">
                                <div class="history-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <h5 class="mb-1">${result.quizName}</h5>
                                            <p class="text-muted mb-0">
                                                <i class="fas fa-book me-1"></i>
                                                ${result.subjectTitle}
                                            </p>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>
                                                ${result.attemptDate}
                                            </small>
                                        </div>
                                        <div class="col-md-3 text-center">
                                            <span class="badge score-badge ${result.passed ? 'bg-success' : 'bg-danger'}">
                                                ${result.score}%
                                            </span>
                                            <br>
                                            <small class="text-muted">
                                                ${result.passed ? 'Passed' : 'Failed'}
                                            </small>
                                        </div>
                                        <div class="col-md-3 text-end">
                                            <a href="${pageContext.request.contextPath}/student/quiz-result?resultId=${result.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>
                                                View Details
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty quizResults}">
                            <div class="text-center py-5">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No quiz history yet</h5>
                                <p class="text-muted">Start taking quizzes to see your results here!</p>
                                <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-primary">
                                    <i class="fas fa-play me-1"></i>
                                    Take Your First Quiz
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 