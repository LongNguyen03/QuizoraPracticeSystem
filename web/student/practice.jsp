<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Practice Mode - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .practice-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        
        .subject-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
        }
        
        .subject-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .subject-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            margin-bottom: 1rem;
        }
        
        .lesson-item {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .lesson-item:hover {
            background-color: #f8f9fa;
            border-color: #667eea;
        }
        
        .lesson-item.selected {
            background-color: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .practice-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 0.75rem 2rem;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .practice-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
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
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    
    <!-- Practice Header -->
    <div class="practice-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-4 fw-bold mb-3">
                        <i class="fas fa-dumbbell me-3"></i>Practice Mode
                    </h1>
                    <p class="lead mb-0">
                        Luyện tập không áp lực thời gian. Học từ từ và xem đáp án ngay lập tức!
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/student/practice?action=history" 
                       class="btn btn-outline-light">
                        <i class="fas fa-history me-2"></i>Lịch sử Practice
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Practice Options -->
        <div class="row">
            <div class="col-lg-8">
                <h3 class="mb-4">
                    <i class="fas fa-book me-2"></i>Chọn môn học để practice
                </h3>
                
                <div class="row">
                    <c:forEach var="subject" items="${subjects}">
                        <div class="col-md-6">
                            <div class="card subject-card">
                                <div class="card-body text-center">
                                    <div class="subject-icon mx-auto">
                                        <i class="fas fa-graduation-cap"></i>
                                    </div>
                                    <h5 class="card-title">${subject.title}</h5>
                                    <p class="card-text text-muted">${subject.description}</p>
                                    <!-- Lesson Selection -->
                                    <div class="lesson-selection mt-3" id="lessons-${subject.id}" style="display: none;">
                                        <h6 class="mb-3">Chọn bài học:</h6>
                                        <div class="lesson-list">
                                            <div class="lesson-item" data-lesson-id="" onclick="startPractice('${subject.id}', '')">
                                                <i class="fas fa-book-open me-2"></i>
                                                Tất cả bài học
                                            </div>
                                            <c:forEach var="lesson" items="${subjectLessonsMap[subject.id]}">
                                                <div class="lesson-item" data-lesson-id="${lesson.id}" onclick="startPractice('${subject.id}', '${lesson.id}')">
                                                    <i class="fas fa-chapter me-2"></i>
                                                    ${lesson.title}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <button class="btn practice-btn mt-3" onclick="selectSubject('${subject.id}')">
                                        Bắt đầu Practice
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="stats-card">
                    <h4 class="mb-4">
                        <i class="fas fa-chart-line me-2"></i>Thống kê Practice
                    </h4>
                    <div class="row text-center">
                        <div class="col-6">
                            <div class="stats-number">0</div>
                            <div class="stats-label">Sessions</div>
                        </div>
                        <div class="col-6">
                            <div class="stats-number">0%</div>
                            <div class="stats-label">Trung bình</div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-info-circle me-2"></i>Hướng dẫn Practice
                        </h5>
                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <i class="fas fa-check text-success me-2"></i>
                                Không có thời gian giới hạn
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-check text-success me-2"></i>
                                Xem đáp án ngay sau khi trả lời
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-check text-success me-2"></i>
                                Làm lại nhiều lần
                            </li>
                            <li class="mb-2">
                                <i class="fas fa-check text-success me-2"></i>
                                Theo dõi tiến độ học tập
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Practice Form -->
    <form id="practiceForm" method="get" action="${pageContext.request.contextPath}/student/practice">
        <input type="hidden" name="action" value="start">
        <input type="hidden" name="subjectId" id="selectedSubjectId">
        <input type="hidden" name="lessonId" id="selectedLessonId">
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectSubject(subjectId) {
            // Show lesson selection
            const lessonDiv = document.getElementById('lessons-' + subjectId);
            if (lessonDiv.style.display === 'none') {
                lessonDiv.style.display = 'block';
            } else {
                lessonDiv.style.display = 'none';
            }
        }
        function startPractice(subjectId, lessonId) {
            document.getElementById('selectedSubjectId').value = subjectId;
            document.getElementById('selectedLessonId').value = lessonId;
            document.getElementById('practiceForm').submit();
        }
    </script>
</body>
</html> 