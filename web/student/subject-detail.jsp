<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Lesson" %>
<%@ page import="Model.Subject" %>
<%@ page import="Model.Quiz" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Subject Detail</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .badge {
            font-size: 0.95em;
        }
        .lesson-card {
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            padding: 1.2rem 1.5rem;
            box-shadow: 0 2px 8px rgba(60,60,120,0.08);
        }
        .lesson-title {
            font-weight: bold;
            font-size: 1.1rem;
        }
        .lesson-actions {
            margin-top: 0.5rem;
        }
        .btn-practice[disabled] {
            background: #ccc !important;
            color: #888 !important;
            border: none;
        }
        .quizzes-header {
            margin-top: 2rem;
        }
        .quizzes-list .quiz-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(60,60,120,0.08);
            margin-bottom: 1.5rem;
            padding: 1.2rem 1.5rem;
        }
        .quiz-title {
            font-weight: bold;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
<jsp:include page="../views/components/header.jsp" />
<div class="container mt-4">
    <%-- Breadcrumb --%>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/home">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Subject Detail</li>
        </ol>
    </nav>
    <c:if test="${not empty subject}">
        <h2 class="mb-4">${subject.title}</h2>
    </c:if>
    <% List<Model.Quiz> quizzes = (List<Model.Quiz>) request.getAttribute("quizzes"); %>
    <% if (quizzes != null && !quizzes.isEmpty()) { %>
    <div class="quizzes-header mt-4 mb-2">
        <h3>Quizzes in <%= subject != null ? subject.getTitle() : "Subject" %></h3>
    </div>
    <div class="quizzes-list mb-4">
        <% for (Model.Quiz quiz : quizzes) { %>
            <div class="quiz-card mb-3 p-3">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div>
                        <span class="fw-bold" style="font-size:1.1rem"><%= quiz.getName() %></span>
                        <span class="badge bg-primary ms-2">Số câu hỏi: <%= quiz.getQuestionCount() %></span>
                        <span class="badge bg-info ms-2">Thời lượng: <%= quiz.getDuration() %> phút</span>
                        <% if (quiz.isPracticeable()) { %>
                            <span class="badge bg-success ms-2">Practiceable</span>
                        <% } %>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/student/quiz/<%= quiz.getId() %>" class="btn btn-take-quiz" title="Làm quiz thật, kết quả sẽ được lưu vào lịch sử.">
                            <i class="fas fa-play me-2"></i>Take Quiz
                        </a>
                        <% if (quiz.isPracticeable()) { %>
                        <a href="${pageContext.request.contextPath}/student/practice-quiz?quizId=<%= quiz.getId() %>" class="btn btn-practice" title="Làm thử quiz này (Practice). Không lưu lịch sử, chỉ xem điểm ngay sau khi làm xong.">
                            <i class="fas fa-dumbbell"></i> Practice
                        </a>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
    <% } %>
    <% List<Model.Lesson> lessons = (List<Model.Lesson>) request.getAttribute("lessons"); %>
    <% if (lessons != null && !lessons.isEmpty()) { %>
    <div class="lessons-list" id="lessonsList">
        <% for (Lesson lesson : lessons) { %>
            <div class="lesson-card" data-dimension="<%= lesson.getDimension() %>" data-status="<%= lesson.getStatus() %>">
                <div class="lesson-title">
                    <%= lesson.getTitle() %>
                    <% if (lesson.getPracticeQuestionCount() != null && lesson.getPracticeQuestionCount() > 0) { %>
                        <span class="badge bg-success ms-2">Có luyện tập: <%= lesson.getPracticeQuestionCount() %> câu</span>
                    <% } %>
                </div>
                <div class="lesson-actions">
                    <form method="get" action="${pageContext.request.contextPath}/student/practice">
                        <input type="hidden" name="action" value="start" />
                        <input type="hidden" name="subjectId" value="<%= subject.getId() %>" />
                        <input type="hidden" name="lessonId" value="<%= lesson.getId() %>" />
                        <button type="submit" class="btn btn-practice"
                            <%= (lesson.getPracticeQuestionCount() == null || lesson.getPracticeQuestionCount() == 0) ? "disabled title='Chưa có câu hỏi luyện tập'" : "" %>>
                            <i class="fas fa-dumbbell me-1"></i>Luyện tập bài này
                        </button>
                    </form>
                </div>
            </div>
        <% } %>
    </div>
    <a href="${pageContext.request.contextPath}/student/practice?action=start&subjectId=<%= subject != null ? subject.getId() : 0 %>" class="btn btn-all">
        <i class="fas fa-dumbbell me-1"></i>Luyện tập toàn bộ môn học
    </a>
    <% } else { %>
        <div class="alert alert-info">No lessons found for this subject.</div>
    <% } %>
</div>
</body>
</html> 