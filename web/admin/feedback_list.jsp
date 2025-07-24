<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Feedback" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý phản hồi giáo viên - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-comments me-2"></i>Quản lý phản hồi từ giáo viên</h4>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 160px;">Thời gian</th>
                        <th style="width: 160px;">Giáo viên</th>
                        <th style="width: 200px;">Email</th>
                        <th>Nội dung</th>
                        <th style="width: 120px;">Trạng thái</th>
                        <th style="width: 150px;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
                        if (feedbackList != null && !feedbackList.isEmpty()) {
                            for (Feedback fb : feedbackList) {
                    %>
                    <tr>
                        <td><%= fb.getCreatedAt() %></td>
                        <td><%= fb.getAccountName() != null ? fb.getAccountName() : "-" %></td>
                        <td><%= fb.getAccountEmail() != null ? fb.getAccountEmail() : "-" %></td>
                        <td><%= fb.getContent() %></td>
                        <td>
                            <% if ("Pending".equalsIgnoreCase(fb.getStatus())) { %>
                                <span class="badge bg-warning text-dark">Chờ xử lý</span>
                            <% } else { %>
                                <span class="badge bg-success">Đã xử lý</span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("Pending".equalsIgnoreCase(fb.getStatus())) { %>
                            <form method="post" action="${pageContext.request.contextPath}/admin/feedback" style="display:inline;">
                                <input type="hidden" name="id" value="<%= fb.getId() %>"/>
                                <input type="hidden" name="action" value="resolve"/>
                                <button type="submit" class="btn btn-sm btn-success">
                                    <i class="fas fa-check"></i> Đánh dấu đã xử lý
                                </button>
                            </form>
                            <% } else { %>
                                <span class="text-muted">-</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" class="text-center text-muted">Chưa có phản hồi nào.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 