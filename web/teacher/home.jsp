<%-- 
    Document   : home
    Created on : Jun 6, 2025, 1:45:58 AM
    Author     : dangd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Teacher Dashboard - Quizora</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .dashboard-container {
                padding: 2rem;
            }
            .welcome-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem;
                border-radius: 1rem;
                margin-bottom: 2rem;
            }
            .welcome-section h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
            }
            .welcome-section p {
                font-size: 1.1rem;
                opacity: 0.9;
            }
            .stat-card {
                background: white;
                border-radius: 1rem;
                padding: 1.5rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                margin-bottom: 1rem;
            }
            .stat-card i {
                font-size: 2rem;
                color: #667eea;
                margin-bottom: 1rem;
            }
            .activity-item {
                background: white;
                border-radius: 0.5rem;
                padding: 1rem;
                margin-bottom: 1rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../views/components/header.jsp" />

        <div class="dashboard-container">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h1>Welcome back, Teacher!</h1>
                <p class="mb-0">Manage your courses and quizzes efficiently.</p>
            </div>

            <!-- Stats Section -->
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-book"></i>
                        <h3>5</h3>
                        <p class="text-muted mb-0">Active Courses</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-question-circle"></i>
                        <h3>25</h3>
                        <p class="text-muted mb-0">Total Quizzes</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-user-graduate"></i>
                        <h3>120</h3>
                        <p class="text-muted mb-0">Total Students</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-tasks"></i>
                        <h3>8</h3>
                        <p class="text-muted mb-0">Pending Reviews</p>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="row mt-4">
                <div class="col-md-8">
                    <h4 class="mb-3">Recent Activity</h4>
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1">Math Quiz Results</h5>
                                <p class="text-muted mb-0">15 students completed the quiz</p>
                            </div>
                            <span class="badge bg-success">Completed</span>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1">Physics Assignment</h5>
                                <p class="text-muted mb-0">Due in 2 days</p>
                            </div>
                            <span class="badge bg-warning">Pending</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <h4 class="mb-3">Quick Actions</h4>
                    <div class="activity-item">
                        <a href="${pageContext.request.contextPath}/lesson?action=list" class="text-decoration-none">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-list me-3 text-primary"></i>
                                <div>
                                    <h5 class="mb-1 text-dark">Manage Lessons</h5>
                                    <p class="text-muted mb-0">View or update your lessons</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="activity-item">
                        <a href="${pageContext.request.contextPath}/QuestionController?action=list" class="text-decoration-none">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-plus-circle me-3 text-primary"></i>
                                <div>
                                    <h5 class="mb-1 text-dark">Create New Quiz</h5>
                                    <p class="text-muted mb-0"><a href="${pageContext.request.contextPath}/quiz">Quản lý Quiz</a>
</p>
                                    
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
