<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Practice Result - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .result-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        
        .score-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .score-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: bold;
            color: white;
            margin: 0 auto 1rem;
        }
        
        .score-excellent {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .score-good {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
        }
        
        .score-average {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
        
        .score-poor {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
        }
        
        .answer-item {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .answer-item.correct {
            border-color: #28a745;
            background-color: #d4edda;
        }
        
        .answer-item.incorrect {
            border-color: #dc3545;
            background-color: #f8d7da;
        }
        
        .stats-item {
            text-align: center;
            padding: 1rem;
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 0.75rem 2rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    
    <!-- Result Header -->
    <div class="result-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-4 fw-bold mb-3">
                        <i class="fas fa-trophy me-3"></i>Kết quả Practice
                    </h1>
                    <p class="lead mb-0">
                        Chúc mừng! Bạn đã hoàn thành practice session.
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/student/practice" class="btn btn-outline-light">
                        <i class="fas fa-redo me-2"></i>Practice lại
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Score Summary -->
        <div class="row">
            <div class="col-lg-8">
                <div class="card score-card">
                    <div class="card-body text-center">
                        <div class="score-circle ${stats.scorePercentage >= 80 ? 'score-excellent' : 
                                                   stats.scorePercentage >= 60 ? 'score-good' : 
                                                   stats.scorePercentage >= 40 ? 'score-average' : 'score-poor'}">
                            ${scorePercentageFormatted}%
                        </div>
                        <h3 class="mb-3">
                            <c:choose>
                                <c:when test="${stats.scorePercentage >= 80}">
                                    <i class="fas fa-star text-warning me-2"></i>Xuất sắc!
                                </c:when>
                                <c:when test="${stats.scorePercentage >= 60}">
                                    <i class="fas fa-thumbs-up text-success me-2"></i>Tốt!
                                </c:when>
                                <c:when test="${stats.scorePercentage >= 40}">
                                    <i class="fas fa-hand-paper text-warning me-2"></i>Trung bình
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-exclamation-triangle text-danger me-2"></i>Cần cải thiện
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="text-muted">
                            Bạn đã trả lời đúng ${stats.correctAnswers} / ${stats.totalQuestions} câu hỏi
                        </p>
                    </div>
                </div>
                
                <!-- Detailed Results -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-list-alt me-2"></i>Chi tiết từng câu hỏi
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="answer" items="${practiceAnswers}" varStatus="status">
                            <div class="answer-item ${answer.correct ? 'correct' : 'incorrect'}">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-2">
                                            <i class="fas fa-question-circle me-2"></i>
                                            Câu ${status.index + 1}
                                        </h6>
                                        <p class="mb-2">${answer.questionContent}</p>
                                        <c:if test="${not empty answer.answerContent}">
                                            <p class="mb-1">
                                                <strong>Đáp án của bạn:</strong> ${answer.answerContent}
                                            </p>
                                        </c:if>
                                        <p class="mb-1">
                                            <strong>Đáp án đúng:</strong>
                                            <span style="color:green; font-weight:bold;">
                                                <c:forEach var="q" items="${questions}">
                                                    <c:if test="${q.id == answer.questionId}">
                                                        <c:forEach var="a" items="${q.answers}">
                                                            <c:if test="${a.correct}">
                                                                ${a.content}
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </c:forEach>
                                            </span>
                                        </p>
                                    </div>
                                    <div class="ms-3">
                                        <c:choose>
                                            <c:when test="${answer.correct}">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check me-1"></i>Đúng
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">
                                                    <i class="fas fa-times me-1"></i>Sai
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <!-- Statistics -->
                <div class="card mb-3">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-chart-bar me-2"></i>Thống kê
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-6">
                                <div class="stats-item">
                                    <div class="stats-number">${stats.totalQuestions}</div>
                                    <div class="text-muted">Tổng câu hỏi</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stats-item">
                                    <div class="stats-number">${stats.correctAnswers}</div>
                                    <div class="text-muted">Đúng</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stats-item">
                                    <div class="stats-number">${stats.totalQuestions - stats.correctAnswers}</div>
                                    <div class="text-muted">Sai</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stats-item">
                                    <div class="stats-number">${stats.answeredQuestions}</div>
                                    <div class="text-muted">Đã trả lời</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Session Info -->
                <div class="card mb-3">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>Thông tin Session
                        </h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <strong>Môn học:</strong> ${practiceSession.subjectTitle}
                            </li>
                            <c:if test="${not empty practiceSession.lessonTitle}">
                                <li class="mb-2">
                                    <strong>Bài học:</strong> ${practiceSession.lessonTitle}
                                </li>
                            </c:if>
                            <li class="mb-2">
                                <strong>Thời gian bắt đầu:</strong><br>
                                ${practiceSession.startTime}
                            </li>
                            <li class="mb-2">
                                <strong>Thời gian kết thúc:</strong><br>
                                ${practiceSession.endTime}
                            </li>
                        </ul>
                    </div>
                </div>
                
                <!-- Actions -->
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-cogs me-2"></i>Hành động
                        </h5>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/student/practice" class="action-btn">
                                <i class="fas fa-redo me-2"></i>Practice lại
                            </a>
                            <a href="${pageContext.request.contextPath}/student/practice?action=history" class="btn btn-outline-secondary">
                                <i class="fas fa-history me-2"></i>Xem lịch sử
                            </a>
                            <a href="${pageContext.request.contextPath}/student/home" class="btn btn-outline-primary">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 