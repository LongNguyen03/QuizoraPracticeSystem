<%-- 
    Document   : dashboard.jsp
    Created on : Jun 6, 2025, 1:45:07 AM
    Author     : dangd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.AccountDAO" %>
<%@ page import="DAO.SubjectDAO" %>
<%@ page import="DAO.QuizDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Account" %>
<%@ page import="Model.Subject" %>
<%@ page import="Model.Quiz" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Quizora</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                transition: transform 0.3s ease;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .stat-card i {
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }
            .stat-card.users i { color: #667eea; }
            .stat-card.teachers i { color: #28a745; }
            .stat-card.students i { color: #17a2b8; }
            .stat-card.subjects i { color: #ffc107; }
            .stat-card.quizzes i { color: #dc3545; }
            .stat-card.active i { color: #28a745; }
            
            .stat-number {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }
            .stat-label {
                color: #6c757d;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .content-card {
                background: white;
                border-radius: 1rem;
                padding: 1.5rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                margin-bottom: 1rem;
            }
            
            .activity-item {
                background: white;
                border-radius: 0.5rem;
                padding: 1rem;
                margin-bottom: 1rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                transition: transform 0.2s ease;
            }
            .activity-item:hover {
                transform: translateX(5px);
            }
            
            .quick-action {
                background: white;
                border-radius: 0.5rem;
                padding: 1.5rem;
                margin-bottom: 1rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;
                display: block;
            }
            .quick-action:hover {
                transform: translateY(-3px);
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                color: inherit;
            }
            
            .chart-container {
                position: relative;
                height: 300px;
            }
            
            .recent-user {
                display: flex;
                align-items: center;
                padding: 0.75rem;
                border-bottom: 1px solid #f1f3f4;
            }
            .recent-user:last-child {
                border-bottom: none;
            }
            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                margin-right: 1rem;
            }
            
            @media (max-width: 768px) {
                .welcome-section h1 {
                    font-size: 2rem;
                }
                .stat-number {
                    font-size: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="../views/components/header.jsp" />

        <div class="dashboard-container">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h1><i class="fas fa-tachometer-alt me-3"></i>Admin Dashboard</h1>
                <p class="mb-0">Quản lý hệ thống Quizora một cách hiệu quả và thông minh.</p>
            </div>

            <!-- Stats Section -->
            <div class="row">
                <%
                    // Lấy thống kê thực tế từ database
                    List<Account> allUsers = AccountDAO.getAllUsers();
                    int totalUsers = allUsers.size();
                    int teachers = 0, students = 0;
                    for (Account acc : allUsers) {
                        if ("Teacher".equals(acc.getRoleName())) teachers++;
                        else if ("Student".equals(acc.getRoleName())) students++;
                    }
                    
                    List<Subject> allSubjects = new SubjectDAO().getAllSubjects();
                    int totalSubjects = allSubjects.size();
                    int activeSubjects = 0;
                    for (Subject sub : allSubjects) {
                        if ("active".equals(sub.getStatus())) activeSubjects++;
                    }
                    
                    // Giả sử có QuizDAO
                    int totalQuizzes = 0; // Sẽ cập nhật khi có QuizDAO
                %>
                <div class="col-md-3">
                    <div class="stat-card users">
                        <i class="fas fa-users"></i>
                        <div class="stat-number"><%= totalUsers %></div>
                        <div class="stat-label">Tổng người dùng</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card teachers">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <div class="stat-number"><%= teachers %></div>
                        <div class="stat-label">Giáo viên</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card students">
                        <i class="fas fa-user-graduate"></i>
                        <div class="stat-number"><%= students %></div>
                        <div class="stat-label">Học sinh</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card subjects">
                        <i class="fas fa-book"></i>
                        <div class="stat-number"><%= totalSubjects %></div>
                        <div class="stat-label">Môn học</div>
                    </div>
                </div>
            </div>

            <!-- Charts and Details -->
            <div class="row mt-4">
                <div class="col-md-8">
                    <div class="content-card">
                        <h4 class="mb-3"><i class="fas fa-chart-pie me-2"></i>Thống kê hệ thống</h4>
                        <div class="chart-container">
                            <canvas id="userChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="content-card">
                        <h4 class="mb-3"><i class="fas fa-users me-2"></i>Người dùng gần đây</h4>
                        <%
                            // Hiển thị 5 user gần nhất
                            int count = 0;
                            for (Account acc : allUsers) {
                                if (count >= 5) break;
                        %>
                        <div class="recent-user">
                            <div class="user-avatar">
                                <%= acc.getEmail().substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <div class="fw-bold"><%= acc.getEmail() %></div>
                                <small class="text-muted">
                                    <%
                                        String iconClass = "Teacher".equals(acc.getRoleName()) ? "fa-chalkboard-teacher" : "fa-user-graduate";
                                    %>
                                    <i class="fas <%= iconClass %> me-1"></i>
                                    <%= acc.getRoleName() %>
                                </small>
                            </div>
                        </div>
                        <%
                                count++;
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Quick Actions and Recent Activity -->
            <div class="row mt-4">
                <div class="col-md-8">
                    <div class="content-card">
                        <h4 class="mb-3"><i class="fas fa-clock me-2"></i>Hoạt động gần đây</h4>
                        <div class="activity-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-1">Quản lý người dùng</h5>
                                    <p class="text-muted mb-0">Hệ thống có <%= totalUsers %> người dùng đang hoạt động</p>
                                </div>
                                <span class="badge bg-primary">Users</span>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-1">Quản lý môn học</h5>
                                    <p class="text-muted mb-0"><%= activeSubjects %> môn học đang hoạt động trong tổng số <%= totalSubjects %> môn</p>
                                </div>
                                <span class="badge bg-success">Subjects</span>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="mb-1">Phân bố người dùng</h5>
                                    <p class="text-muted mb-0"><%= teachers %> giáo viên và <%= students %> học sinh</p>
                                </div>
                                <span class="badge bg-info">Distribution</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="content-card">
                        <h4 class="mb-3"><i class="fas fa-bolt me-2"></i>Thao tác nhanh</h4>
                        <a href="/admin/users" class="quick-action">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-users me-3 text-primary" style="font-size: 1.5rem;"></i>
                                <div>
                                    <h5 class="mb-1">Quản lý người dùng</h5>
                                    <p class="text-muted mb-0">Ban/Unban và xóa tài khoản</p>
                                </div>
                            </div>
                        </a>
                        <a href="/admin/subjects" class="quick-action">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-book me-3 text-success" style="font-size: 1.5rem;"></i>
                                <div>
                                    <h5 class="mb-1">Quản lý môn học</h5>
                                    <p class="text-muted mb-0">Thêm, sửa và xóa môn học</p>
                                </div>
                            </div>
                        </a>
                        <a href="/admin/dashboard" class="quick-action">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-chart-bar me-3 text-warning" style="font-size: 1.5rem;"></i>
                                <div>
                                    <h5 class="mb-1">Báo cáo thống kê</h5>
                                    <p class="text-muted mb-0">Xem báo cáo chi tiết</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Chart.js configuration
            const ctx = document.getElementById('userChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Giáo viên', 'Học sinh'],
                    datasets: [{
                        data: [<%= teachers %>, <%= students %>],
                        backgroundColor: [
                            '#28a745',
                            '#17a2b8'
                        ],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        </script>
    </body>
</html>
