<%-- 
    Document   : dashboard.jsp
    Created on : Jun 6, 2025, 1:45:07 AM
    Author     : dangd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Quizora</title>
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
                <h1>Welcome to Admin Dashboard</h1>
                <p class="mb-0">Manage your Quizora platform efficiently.</p>
            </div>

            <!-- Stats Section -->
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-users"></i>
                        <h3>150</h3>
                        <p class="text-muted mb-0">Total Users</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <h3>25</h3>
                        <p class="text-muted mb-0">Teachers</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-user-graduate"></i>
                        <h3>125</h3>
                        <p class="text-muted mb-0">Students</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <i class="fas fa-book"></i>
                        <h3>12</h3>
                        <p class="text-muted mb-0">Subjects</p>
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
                                <h5 class="mb-1">New Teacher Registration</h5>
                                <p class="text-muted mb-0">John Doe joined as a teacher</p>
                            </div>
                            <span class="badge bg-info">New</span>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-1">New Subject Added</h5>
                                <p class="text-muted mb-0">Advanced Mathematics added to courses</p>
                            </div>
                            <span class="badge bg-success">Added</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <h4 class="mb-3">Quick Actions</h4>
                    <div class="activity-item">
                        <a href="${pageContext.request.contextPath}/admin/users.jsp" class="text-decoration-none">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-user-plus me-3 text-primary"></i>
                                <div>
                                    <h5 class="mb-1 text-dark">Add New User</h5>
                                    <p class="text-muted mb-0">Create new teacher or student account</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="activity-item">
                        <a href="${pageContext.request.contextPath}/admin/subjects.jsp" class="text-decoration-none">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-book-medical me-3 text-primary"></i>
                                <div>
                                    <h5 class="mb-1 text-dark">Add New Subject</h5>
                                    <p class="text-muted mb-0">Create new course subject</p>
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
