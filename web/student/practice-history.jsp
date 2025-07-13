<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Practice History - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .history-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        
        .session-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .session-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .score-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.9rem;
        }
        
        .score-excellent {
            background-color: #d4edda;
            color: #155724;
        }
        
        .score-good {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .score-average {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .score-poor {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .stats-label {
            font-size: 1rem;
            opacity: 0.9;
        }
        
        .filter-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    
    <!-- History Header -->
    <div class="history-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-4 fw-bold mb-3">
                        <i class="fas fa-history me-3"></i>Lịch sử Practice
                    </h1>
                    <p class="lead mb-0">
                        Xem lại các practice sessions đã hoàn thành
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/student/practice" class="btn btn-outline-light">
                        <i class="fas fa-plus me-2"></i>Practice mới
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">${fn:length(practiceSessions)}</div>
                    <div class="stats-label">Tổng Sessions</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">
                        <c:set var="totalScore" value="0" />
                        <c:forEach var="session" items="${practiceSessions}">
                            <c:set var="totalScore" value="${totalScore + (session.totalScore != null ? session.totalScore : 0)}" />
                        </c:forEach>
                        <c:choose>
                            <c:when test="${fn:length(practiceSessions) > 0}">
                                ${fn:formatNumber(totalScore / fn:length(practiceSessions), '#,##0.0')}%
                            </c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stats-label">Điểm trung bình</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">
                        <c:set var="completedCount" value="0" />
                        <c:forEach var="session" items="${practiceSessions}">
                            <c:if test="${session.completed}">
                                <c:set var="completedCount" value="${completedCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${completedCount}
                    </div>
                    <div class="stats-label">Đã hoàn thành</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">
                        <c:set var="excellentCount" value="0" />
                        <c:forEach var="session" items="${practiceSessions}">
                            <c:if test="${session.totalScore >= 80}">
                                <c:set var="excellentCount" value="${excellentCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${excellentCount}
                    </div>
                    <div class="stats-label">Xuất sắc (≥80%)</div>
                </div>
            </div>
        </div>
        
        <!-- Filters -->
        <div class="card filter-card">
            <div class="card-body">
                <h5 class="card-title mb-3">
                    <i class="fas fa-filter me-2"></i>Bộ lọc
                </h5>
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Môn học</label>
                        <select class="form-select" id="subjectFilter">
                            <option value="">Tất cả môn học</option>
                            <c:forEach var="session" items="${practiceSessions}">
                                <option value="${session.subjectTitle}">${session.subjectTitle}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Khoảng điểm</label>
                        <select class="form-select" id="scoreFilter">
                            <option value="">Tất cả điểm</option>
                            <option value="excellent">Xuất sắc (≥80%)</option>
                            <option value="good">Tốt (60-79%)</option>
                            <option value="average">Trung bình (40-59%)</option>
                            <option value="poor">Cần cải thiện (<40%)</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Thời gian</label>
                        <select class="form-select" id="timeFilter">
                            <option value="">Tất cả thời gian</option>
                            <option value="today">Hôm nay</option>
                            <option value="week">Tuần này</option>
                            <option value="month">Tháng này</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Practice Sessions -->
        <div class="row">
            <div class="col-12">
                <h3 class="mb-4">
                    <i class="fas fa-list me-2"></i>Danh sách Practice Sessions
                </h3>
                
                <c:choose>
                    <c:when test="${not empty practiceSessions}">
                        <div class="row" id="sessionsList">
                            <c:forEach var="session" items="${practiceSessions}">
                                <div class="col-lg-6 col-xl-4 session-item" 
                                     data-subject="${session.subjectTitle}"
                                     data-score="${session.totalScore}"
                                     data-date="${session.startTime}">
                                    <div class="card session-card">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-start mb-3">
                                                <div>
                                                    <h5 class="card-title mb-1">${session.subjectTitle}</h5>
                                                    <c:if test="${not empty session.lessonTitle}">
                                                        <p class="text-muted mb-0">${session.lessonTitle}</p>
                                                    </c:if>
                                                </div>
                                                <div class="text-end">
                                                    <c:choose>
                                                        <c:when test="${session.totalScore >= 80}">
                                                            <span class="score-badge score-excellent">
                                                                <i class="fas fa-star me-1"></i>${fn:formatNumber(session.totalScore, '#,##0.0')}%
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${session.totalScore >= 60}">
                                                            <span class="score-badge score-good">
                                                                <i class="fas fa-thumbs-up me-1"></i>${fn:formatNumber(session.totalScore, '#,##0.0')}%
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${session.totalScore >= 40}">
                                                            <span class="score-badge score-average">
                                                                <i class="fas fa-hand-paper me-1"></i>${fn:formatNumber(session.totalScore, '#,##0.0')}%
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="score-badge score-poor">
                                                                <i class="fas fa-exclamation-triangle me-1"></i>${fn:formatNumber(session.totalScore, '#,##0.0')}%
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            
                                            <div class="row text-center mb-3">
                                                <div class="col-4">
                                                    <div class="fw-bold">${session.startTime}</div>
                                                    <small class="text-muted">Bắt đầu</small>
                                                </div>
                                                <div class="col-4">
                                                    <div class="fw-bold">${session.endTime}</div>
                                                    <small class="text-muted">Kết thúc</small>
                                                </div>
                                                <div class="col-4">
                                                    <div class="fw-bold">
                                                        <c:choose>
                                                            <c:when test="${session.completed}">
                                                                <i class="fas fa-check text-success"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-clock text-warning"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <small class="text-muted">Trạng thái</small>
                                                </div>
                                            </div>
                                            
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/student/practice?action=result&sessionId=${session.id}" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                </a>
                                                <a href="${pageContext.request.contextPath}/student/practice?action=start&subjectId=${session.subjectId}&lessonId=${session.lessonId}" 
                                                   class="btn btn-outline-success btn-sm">
                                                    <i class="fas fa-redo me-2"></i>Practice lại
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Chưa có practice session nào</h4>
                            <p class="text-muted">Bắt đầu practice để xem lịch sử ở đây!</p>
                            <a href="${pageContext.request.contextPath}/student/practice" class="btn btn-primary">
                                <i class="fas fa-play me-2"></i>Bắt đầu Practice
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Filter functionality
        document.getElementById('subjectFilter').addEventListener('change', filterSessions);
        document.getElementById('scoreFilter').addEventListener('change', filterSessions);
        document.getElementById('timeFilter').addEventListener('change', filterSessions);
        
        function filterSessions() {
            const subjectFilter = document.getElementById('subjectFilter').value;
            const scoreFilter = document.getElementById('scoreFilter').value;
            const timeFilter = document.getElementById('timeFilter').value;
            
            const sessions = document.querySelectorAll('.session-item');
            
            sessions.forEach(session => {
                let show = true;
                
                // Subject filter
                if (subjectFilter && session.dataset.subject !== subjectFilter) {
                    show = false;
                }
                
                // Score filter
                if (scoreFilter && session.dataset.score) {
                    const score = parseFloat(session.dataset.score);
                    switch (scoreFilter) {
                        case 'excellent':
                            if (score < 80) show = false;
                            break;
                        case 'good':
                            if (score < 60 || score >= 80) show = false;
                            break;
                        case 'average':
                            if (score < 40 || score >= 60) show = false;
                            break;
                        case 'poor':
                            if (score >= 40) show = false;
                            break;
                    }
                }
                
                // Time filter
                if (timeFilter && session.dataset.date) {
                    const sessionDate = new Date(session.dataset.date);
                    const now = new Date();
                    
                    switch (timeFilter) {
                        case 'today':
                            if (sessionDate.toDateString() !== now.toDateString()) {
                                show = false;
                            }
                            break;
                        case 'week':
                            const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                            if (sessionDate < weekAgo) {
                                show = false;
                            }
                            break;
                        case 'month':
                            const monthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
                            if (sessionDate < monthAgo) {
                                show = false;
                            }
                            break;
                    }
                }
                
                session.style.display = show ? 'block' : 'none';
            });
        }
    </script>
</body>
</html> 