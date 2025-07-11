<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Subject" %>
<html>
<head>
    <title>Quản lý môn học</title>
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
        
        .content-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 1rem;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            color: #495057;
            font-weight: 600;
            padding: 1rem;
            text-align: center;
            border-bottom: 2px solid #dee2e6;
            font-size: 0.9rem;
        }
        
        .table td {
            padding: 1rem;
            text-align: center;
            vertical-align: middle;
            border-bottom: 1px solid #f1f3f4;
            font-size: 0.9rem;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.3s ease;
        }
        
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            color: #28a745;
            background: #d4edda;
        }
        
        .status-inactive {
            color: #6c757d;
            background: #e9ecef;
        }
        
        .action-btn {
            padding: 0.5rem 1rem;
            margin: 0 0.25rem;
            border-radius: 20px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.8rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-edit {
            background: #007bff;
            color: white;
        }
        
        .btn-edit:hover {
            background: #0056b3;
            color: white;
            transform: translateY(-1px);
        }
        
        .btn-create {
            background: #28a745;
            color: white;
        }
        
        .btn-create:hover {
            background: #218838;
            color: white;
            transform: translateY(-1px);
        }
        
        .btn-delete {
            background: #6c757d;
            color: white;
        }
        
        .btn-delete:hover {
            background: #5a6268;
            color: white;
            transform: translateY(-1px);
        }
        
        .no-data {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
            font-style: italic;
            font-size: 1.1rem;
        }
        
        .subject-id {
            font-weight: 700;
            color: #495057;
            font-size: 1.1rem;
        }
        
        .subject-title {
            color: #495057;
            font-weight: 600;
        }
        
        .subject-tagline {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .owner-badge {
            background: #17a2b8;
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .date-info {
            color: #6c757d;
            font-size: 0.8rem;
        }
        
        @media (max-width: 768px) {
            .welcome-section {
                text-align: center;
            }
            
            .table th,
            .table td {
                padding: 0.75rem 0.5rem;
                font-size: 0.8rem;
            }
            
            .action-btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.7rem;
                margin: 0.1rem;
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
            <h1><i class="fas fa-book me-3"></i>Quản lý môn học</h1>
            <p class="mb-0">Quản lý các môn học và khóa học trong hệ thống.</p>
        </div>
        
        <!-- Content Section -->
        <div class="content-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="/admin/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Quay lại Dashboard
                </a>
                <a href="/admin/subject/create" class="btn btn-create">
                    <i class="fas fa-plus me-1"></i>Tạo môn học mới
                </a>
            </div>
            
            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-1"></i>ID</th>
                            <th><i class="fas fa-book me-1"></i>Tên môn học</th>
                            <th><i class="fas fa-tag me-1"></i>Tagline</th>
                            <th><i class="fas fa-user me-1"></i>Chủ sở hữu</th>
                            <th><i class="fas fa-info-circle me-1"></i>Trạng thái</th>
                            <th><i class="fas fa-calendar-plus me-1"></i>Ngày tạo</th>
                            <th><i class="fas fa-calendar-check me-1"></i>Ngày cập nhật</th>
                            <th><i class="fas fa-cogs me-1"></i>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
                        if (subjects != null && !subjects.isEmpty()) {
                            for (Subject s : subjects) {
                    %>
                        <tr>
                            <td><span class="subject-id">#<%= s.getId() %></span></td>
                            <td><span class="subject-title"><%= s.getTitle() %></span></td>
                            <td><span class="subject-tagline"><%= s.getTagline() %></span></td>
                            <td><span class="owner-badge"><%= s.getOwnerId() %></span></td>
                            <td>
                                <span class="status-badge <%= "active".equals(s.getStatus()) ? "status-active" : "status-inactive" %>">
                                    <i class="fas <%= "active".equals(s.getStatus()) ? "fa-check-circle" : "fa-pause-circle" %> me-1"></i>
                                    <%= "active".equals(s.getStatus()) ? "Active" : "Inactive" %>
                                </span>
                            </td>
                            <td><span class="date-info"><%= s.getCreatedAt() != null ? s.getCreatedAt() : "N/A" %></span></td>
                            <td><span class="date-info"><%= s.getUpdatedAt() != null ? s.getUpdatedAt() : "N/A" %></span></td>
                            <td>
                                <a href="/admin/subject/edit?id=<%= s.getId() %>" class="action-btn btn-edit">
                                    <i class="fas fa-edit me-1"></i>Chỉnh sửa
                                </a>
                                <a href="/admin/subject/toggle?id=<%= s.getId() %>" class="action-btn <%= "active".equals(s.getStatus()) ? "btn-ban" : "btn-unban" %>">
                                    <i class="fas <%= "active".equals(s.getStatus()) ? "fa-pause" : "fa-play" %> me-1"></i>
                                    <%= "active".equals(s.getStatus()) ? "Tạm dừng" : "Kích hoạt" %>
                                </a>
                                <a href="/admin/subject/delete?id=<%= s.getId() %>" class="action-btn btn-delete" 
                                   onclick="return confirm('Bạn có chắc muốn xóa môn học này?');">
                                    <i class="fas fa-trash me-1"></i>Xóa
                                </a>
                            </td>
                        </tr>
                    <%      }
                        } else { %>
                        <tr>
                            <td colspan="8" class="no-data">
                                <i class="fas fa-book fa-2x mb-3 d-block"></i>
                                Không có môn học nào.
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 