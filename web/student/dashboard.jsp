<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Quizora</title>
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
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../views/components/header.jsp" />

    <div class="dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h1>Student Dashboard</h1>
            <p class="mb-0">This is your dashboard. More features coming soon!</p>
        </div>

        <!-- Stats Section -->
        <div class="row">
            <div class="col-md-4">
                <div class="stat-card">
                    <i class="fas fa-book"></i>
                    <h3>5</h3>
                    <p class="text-muted mb-0">Active Courses</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <i class="fas fa-tasks"></i>
                    <h3>3</h3>
                    <p class="text-muted mb-0">Pending Assignments</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <i class="fas fa-chart-line"></i>
                    <h3>85%</h3>
                    <p class="text-muted mb-0">Average Score</p>
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
                            <h5 class="mb-1">Math Quiz</h5>
                            <p class="text-muted mb-0">Completed with 90% score</p>
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
                <h4 class="mb-3">Upcoming Deadlines</h4>
                <div class="activity-item">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-1">Chemistry Lab Report</h5>
                            <p class="text-muted mb-0">Due tomorrow</p>
                        </div>
                        <span class="badge bg-danger">Urgent</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 