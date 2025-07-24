<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
                        <th style="width: 200px;">Phản hồi</th>
                        <th style="width: 120px;">Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
                        Map<Integer, List<Model.FeedbackReply>> feedbackRepliesMap = (Map<Integer, List<Model.FeedbackReply>>) request.getAttribute("feedbackRepliesMap");
                        if (feedbackList != null && !feedbackList.isEmpty()) {
                            for (Feedback fb : feedbackList) {
                                List<Model.FeedbackReply> replies = feedbackRepliesMap != null ? feedbackRepliesMap.get(fb.getId()) : null;
                    %>
                    <tr>
                        <td><%= fb.getCreatedAt() %></td>
                        <td><%= fb.getAccountName() != null ? fb.getAccountName() : "-" %></td>
                        <td><%= fb.getAccountEmail() != null ? fb.getAccountEmail() : "-" %></td>
                        <td><%= fb.getContent() %></td>
                        <!-- Cột phản hồi -->
                        <td>
                            <% if (replies != null && !replies.isEmpty()) { %>
                                <ul class="list-group list-group-flush mb-2">
                                    <% for (Model.FeedbackReply reply : replies) { %>
                                        <li class="list-group-item px-2 py-1">
                                            <i class="fas fa-user-shield text-primary"></i>
                                            <span><%= reply.getContent() %></span>
                                            <span class="text-muted small">(<%= reply.getCreatedAt() %>)</span>
                                        </li>
                                    <% } %>
                                </ul>
                            <% } %>
                            <% if (!"Pending".equalsIgnoreCase(fb.getStatus())) { %>
                                <!-- Nút mở modal phản hồi -->
                                <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#replyModal<%= fb.getId() %>">
                                    <i class="fas fa-reply"></i> Phản hồi
                                </button>
                                <!-- Modal phản hồi -->
                                <div class="modal fade" id="replyModal<%= fb.getId() %>" tabindex="-1" aria-labelledby="replyModalLabel<%= fb.getId() %>" aria-hidden="true">
                                  <div class="modal-dialog">
                                    <div class="modal-content">
                                      <form method="post" action="${pageContext.request.contextPath}/admin/feedback">
                                        <div class="modal-header">
                                          <h5 class="modal-title" id="replyModalLabel<%= fb.getId() %>">Gửi phản hồi tới giáo viên</h5>
                                          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                          <input type="hidden" name="action" value="reply"/>
                                          <input type="hidden" name="feedbackId" value="<%= fb.getId() %>"/>
                                          <textarea name="replyContent" class="form-control" rows="4" placeholder="Nhập phản hồi..." required></textarea>
                                        </div>
                                        <div class="modal-footer">
                                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                          <button type="submit" class="btn btn-primary">Gửi phản hồi</button>
                                        </div>
                                      </form>
                                    </div>
                                  </div>
                                </div>
                            <% } %>
                        </td>
                        <!-- Cột trạng thái -->
                        <td>
                            <% if ("Pending".equalsIgnoreCase(fb.getStatus())) { %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/feedback" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= fb.getId() %>"/>
                                    <input type="hidden" name="action" value="resolve"/>
                                    <button type="submit" class="btn btn-warning btn-sm">
                                        <i class="fas fa-hourglass-half"></i> Chưa xử lý
                                    </button>
                                </form>
                            <% } else { %>
                                <span class="badge bg-success"><i class="fas fa-check"></i> Đã xử lý</span>
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