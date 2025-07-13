<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 1.5rem;
            color: white;
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.8;
        }
        .quick-action-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .quick-action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
            text-decoration: none;
            color: inherit;
        }
        .recent-quiz-card {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .recent-quiz-card:hover {
            transform: translateY(-2px);
        }
        .progress-ring {
            width: 80px;
            height: 80px;
        }
        .progress-ring circle {
            fill: none;
            stroke-width: 8;
        }
        .progress-ring .bg {
            stroke: #e9ecef;
        }
        .progress-ring .progress {
            stroke: #28a745;
            stroke-linecap: round;
            transition: stroke-dasharray 0.3s ease;
        }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />

    <div class="container py-4">
        <!-- Welcome Section -->
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="display-6 fw-bold text-primary">
                    <i class="fas fa-user-graduate me-2"></i>
                    Welcome back, ${sessionScope.firstName}!
                </h1>
                <p class="text-muted">Here's your learning progress and recent activities</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${completedQuizzes}</h3>
                            <p class="mb-0 opacity-75">Quizzes Completed</p>
                        </div>
                        <i class="fas fa-clipboard-check stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${passedQuizzes}</h3>
                            <p class="mb-0 opacity-75">Quizzes Passed</p>
                        </div>
                        <i class="fas fa-trophy stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${averageScore}%</h3>
                            <p class="mb-0 opacity-75">Average Score</p>
                        </div>
                        <i class="fas fa-chart-line stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${totalFavorites}</h3>
                            <p class="mb-0 opacity-75">Favorite Quizzes</p>
                        </div>
                        <i class="fas fa-heart stat-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <h4 class="mb-3">
                    <i class="fas fa-bolt me-2 text-warning"></i>
                    Quick Actions
                </h4>
            </div>
            <div class="col-md-3 mb-3">
                <a href="${pageContext.request.contextPath}/student/quizzes" class="quick-action-card">
                    <div class="text-center">
                        <i class="fas fa-question-circle fa-2x text-primary mb-3"></i>
                        <h5>Take Quiz</h5>
                        <p class="text-muted small">Start a new quiz</p>
                    </div>
                </a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="${pageContext.request.contextPath}/student/practice" class="quick-action-card">
                    <div class="text-center">
                        <i class="fas fa-dumbbell fa-2x text-success mb-3"></i>
                        <h5>Practice</h5>
                        <p class="text-muted small">Practice questions</p>
                    </div>
                </a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="${pageContext.request.contextPath}/student/favorite-quizzes" class="quick-action-card">
                    <div class="text-center">
                        <i class="fas fa-heart fa-2x text-danger mb-3"></i>
                        <h5>Favorites</h5>
                        <p class="text-muted small">View saved quizzes</p>
                    </div>
                </a>
            </div>
            <div class="col-md-3 mb-3">
                <a href="${pageContext.request.contextPath}/student/history" class="quick-action-card">
                    <div class="text-center">
                        <i class="fas fa-history fa-2x text-info mb-3"></i>
                        <h5>History</h5>
                        <p class="text-muted small">View past results</p>
                    </div>
                </a>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="row">
            <div class="col-md-8 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-clock me-2"></i>
                            Recent Quiz Results
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty recentResults}">
                            <c:forEach var="result" items="${recentResults}">
                                <div class="recent-quiz-card">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="mb-1">${result.quizName}</h6>
                                            <p class="text-muted small mb-0">
                                                ${result.subjectTitle} • ${result.attemptDate}
                                            </p>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge ${result.passed ? 'bg-success' : 'bg-danger'}">
                                                ${result.score}%
                                            </span>
                                            <br>
                                            <small class="text-muted">
                                                ${result.passed ? 'Passed' : 'Failed'}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty recentResults}">
                            <div class="text-center py-4">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No quiz results yet. Start your first quiz!</p>
                                <a href="${pageContext.request.contextPath}/student/quizzes" class="btn btn-primary">
                                    Take Your First Quiz
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-heart me-2"></i>
                            Favorite Quizzes
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty favoriteQuizzes}">
                            <c:forEach var="favorite" items="${favoriteQuizzes}">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0">${favorite.quizName}</h6>
                                        <small class="text-muted">${favorite.subjectTitle}</small>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/student/quiz/${favorite.quizId}" 
                                       class="btn btn-sm btn-outline-primary">
                                        Take Quiz
                                    </a>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty favoriteQuizzes}">
                            <div class="text-center py-3">
                                <i class="fas fa-heart fa-2x text-muted mb-2"></i>
                                <p class="text-muted small">No favorite quizzes yet</p>
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