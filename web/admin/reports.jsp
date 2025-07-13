<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Reports - Quizora Admin</title>
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
        .teacher-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .teacher-card:hover {
            transform: translateY(-2px);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.3rem 0.6rem;
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
                    <i class="fas fa-chart-bar me-2"></i>
                    Teacher Reports
                </h1>
                <p class="text-muted">Overview of teacher activities and system statistics</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${teacherCount}</h3>
                            <p class="mb-0 opacity-75">Total Teachers</p>
                        </div>
                        <i class="fas fa-chalkboard-teacher fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${activeTeachers}</h3>
                            <p class="mb-0 opacity-75">Active Teachers</p>
                        </div>
                        <i class="fas fa-user-check fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${totalQuizzes}</h3>
                            <p class="mb-0 opacity-75">Total Quizzes</p>
                        </div>
                        <i class="fas fa-question-circle fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-0">${totalSubjects}</h3>
                            <p class="mb-0 opacity-75">Total Subjects</p>
                        </div>
                        <i class="fas fa-book fa-2x opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Teacher List -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-users me-2"></i>
                            Teacher Directory
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty teachers}">
                            <c:forEach var="teacher" items="${teachers}">
                                <div class="teacher-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <h6 class="mb-1">${teacher.email}</h6>
                                            <p class="text-muted mb-0">
                                                <i class="fas fa-user me-1"></i>
                                                Teacher Account
                                            </p>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>
                                                Joined: ${teacher.createdAt}
                                            </small>
                                        </div>
                                        <div class="col-md-3 text-center">
                                            <span class="badge status-badge ${teacher.status == 'active' ? 'bg-success' : 'bg-danger'}">
                                                ${teacher.status}
                                            </span>
                                        </div>
                                        <div class="col-md-3 text-end">
                                            <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${teacher.id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-edit me-1"></i>
                                                Manage
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty teachers}">
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No teachers found</h5>
                                <p class="text-muted">No teacher accounts have been created yet.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="row mt-4">
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-question-circle me-2"></i>
                            Recent Quizzes
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty recentQuizzes}">
                            <c:forEach var="quiz" items="${recentQuizzes}">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0">${quiz.name}</h6>
                                        <small class="text-muted">${quiz.level} • ${quiz.numberOfQuestions} questions</small>
                                    </div>
                                    <span class="badge bg-primary">${quiz.type}</span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty recentQuizzes}">
                            <p class="text-muted text-center">No quizzes created yet</p>
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-book me-2"></i>
                            Recent Subjects
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty recentSubjects}">
                            <c:forEach var="subject" items="${recentSubjects}">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-0">${subject.title}</h6>
                                        <small class="text-muted">${subject.description}</small>
                                    </div>
                                    <span class="badge bg-success">${subject.status}</span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty recentSubjects}">
                            <p class="text-muted text-center">No subjects created yet</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 