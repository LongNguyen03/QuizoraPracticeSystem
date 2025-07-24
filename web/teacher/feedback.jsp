<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Feedback" %>
<%
    String feedbackSuccess = null;
    if (session.getAttribute("feedbackSuccess") != null) {
        feedbackSuccess = (String) session.getAttribute("feedbackSuccess");
        session.removeAttribute("feedbackSuccess");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gửi phản hồi - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-comment-dots me-2"></i>Gửi phản hồi tới Admin</h5>
                </div>
                <div class="card-body">
                    <% if (feedbackSuccess != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <%= feedbackSuccess %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>
                    <form method="post" action="${pageContext.request.contextPath}/teacher/feedback">
                        <div class="mb-3">
                            <label for="feedbackContent" class="form-label">Nội dung phản hồi</label>
                            <textarea class="form-control" id="feedbackContent" name="content" rows="4" required placeholder="Nhập phản hồi, góp ý hoặc khiếu nại..."></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="fas fa-paper-plane"></i> Gửi phản hồi
                        </button>
                    </form>
                </div>
            </div>
            <div class="card shadow-sm">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0"><i class="fas fa-list me-2"></i>Phản hồi bạn đã gửi</h5>
                </div>
                <div class="card-body p-0">
                    <table class="table table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 160px;">Thời gian</th>
                                <th>Nội dung</th>
                                <th style="width: 120px;">Trạng thái</th>
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
                                <td><%= fb.getContent() %></td>
                                <td>
                                    <% if ("Pending".equalsIgnoreCase(fb.getStatus())) { %>
                                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                    <% } else { %>
                                        <span class="badge bg-success">Đã xử lý</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="3" class="text-center text-muted">Bạn chưa gửi phản hồi nào.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



