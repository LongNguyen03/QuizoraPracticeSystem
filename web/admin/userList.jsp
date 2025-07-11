<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Account" %>
<html>
<head>
    <title>Quản lý người dùng</title>
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
        
        .status-banned {
            color: #dc3545;
            background: #f8d7da;
        }
        
        .role-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .role-teacher {
            background: #28a745;
        }
        
        .role-student {
            background: #17a2b8;
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
        
        .btn-ban {
            background: #dc3545;
            color: white;
        }
        
        .btn-ban:hover {
            background: #c82333;
            color: white;
            transform: translateY(-1px);
        }
        
        .btn-unban {
            background: #28a745;
            color: white;
        }
        
        .btn-unban:hover {
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
        
        .user-id {
            font-weight: 700;
            color: #495057;
            font-size: 1.1rem;
        }
        
        .user-email {
            color: #6c757d;
            font-weight: 500;
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
            <h1><i class="fas fa-users me-3"></i>Quản lý người dùng</h1>
            <p class="mb-0">Quản lý tài khoản giáo viên và học sinh trong hệ thống.</p>
        </div>
        
        <!-- Content Section -->
        <div class="content-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="/admin/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Quay lại Dashboard
                </a>
            </div>
            
            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag me-1"></i>ID</th>
                            <th><i class="fas fa-envelope me-1"></i>Email</th>
                            <th><i class="fas fa-user-tag me-1"></i>Vai trò</th>
                            <th><i class="fas fa-info-circle me-1"></i>Trạng thái</th>
                            <th><i class="fas fa-cogs me-1"></i>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Account> userList = (List<Account>) request.getAttribute("userList");
                        if (userList != null && !userList.isEmpty()) {
                            for (Account acc : userList) {
                    %>
                        <tr>
                            <td><span class="user-id">#<%= acc.getId() %></span></td>
                            <td><span class="user-email"><%= acc.getEmail() %></span></td>
                            <td>
                                <span class="role-badge <%= "Teacher".equals(acc.getRoleName()) ? "role-teacher" : "role-student" %>">
                                    <i class="fas <%= "Teacher".equals(acc.getRoleName()) ? "fa-chalkboard-teacher" : "fa-user-graduate" %> me-1"></i>
                                    <%= acc.getRoleName() %>
                                </span>
                            </td>
                            <td>
                                <span class="status-badge <%= "active".equals(acc.getStatus()) ? "status-active" : "status-banned" %>">
                                    <i class="fas <%= "active".equals(acc.getStatus()) ? "fa-check-circle" : "fa-ban" %> me-1"></i>
                                    <%= "active".equals(acc.getStatus()) ? "Hoạt động" : "Bị khóa" %>
                                </span>
                            </td>
                            <td>
                                <% if ("banned".equals(acc.getStatus())) { %>
                                    <form action="/admin/users" method="get" style="display:inline;">
                                        <input type="hidden" name="action" value="unban" />
                                        <input type="hidden" name="id" value="<%= acc.getId() %>" />
                                        <button class="action-btn btn-unban" type="submit">
                                            <i class="fas fa-unlock me-1"></i>Mở khóa
                                        </button>
                                    </form>
                                <% } else if ("active".equals(acc.getStatus())) { %>
                                    <form action="/admin/users" method="get" style="display:inline;">
                                        <input type="hidden" name="action" value="ban" />
                                        <input type="hidden" name="id" value="<%= acc.getId() %>" />
                                        <button class="action-btn btn-ban" type="submit">
                                            <i class="fas fa-lock me-1"></i>Khóa
                                        </button>
                                    </form>
                                <% } %>
                                <form action="/admin/users" method="get" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa user này?');">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="id" value="<%= acc.getId() %>" />
                                    <button class="action-btn btn-delete" type="submit">
                                        <i class="fas fa-trash me-1"></i>Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%      }
                        } else { %>
                        <tr>
                            <td colspan="5" class="no-data">
                                <i class="fas fa-users fa-2x mb-3 d-block"></i>
                                Không có người dùng nào.
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