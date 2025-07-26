<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --card-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            --card-shadow-hover: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .dashboard-container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2.5rem;
            border-radius: 1.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        .welcome-section h1 {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
        }

        .welcome-section p {
            font-size: 1.2rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }

        .stat-card i {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-card h3 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }

        .stat-card p {
            color: #6c757d;
            margin-bottom: 0;
            font-weight: 500;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--primary-color);
        }

        .subject-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .subject-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--card-shadow-hover);
        }

        .subject-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .subject-card h5 {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }

        .subject-card p {
            color: #6c757d;
            margin-bottom: 1rem;
            line-height: 1.5;
        }

        .subject-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .subject-stat {
            text-align: center;
        }

        .subject-stat .number {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .subject-stat .label {
            font-size: 0.8rem;
            color: #6c757d;
        }

        .btn-quiz {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-quiz:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.25rem 0.5rem rgba(102, 126, 234, 0.4);
            color: white;
        }

        .recent-quiz-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            margin-bottom: 1rem;
        }

        .recent-quiz-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--card-shadow-hover);
        }

        .quiz-score {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .score-excellent { background-color: #d4edda; color: #155724; }
        .score-good { background-color: #d1ecf1; color: #0c5460; }
        .score-average { background-color: #fff3cd; color: #856404; }
        .score-poor { background-color: #f8d7da; color: #721c24; }

        .progress-ring {
            width: 60px;
            height: 60px;
            position: relative;
        }

        .progress-ring svg {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }

        .progress-ring circle {
            fill: none;
            stroke-width: 4;
        }

        .progress-ring .bg {
            stroke: #e9ecef;
        }

        .progress-ring .progress {
            stroke: var(--primary-color);
            stroke-linecap: round;
            transition: stroke-dasharray 0.5s ease;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .quick-action-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            text-align: center;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            text-decoration: none;
            color: inherit;
        }

        .quick-action-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--card-shadow-hover);
            text-decoration: none;
            color: inherit;
        }

        .quick-action-card i {
            font-size: 2rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .quick-action-card h5 {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }

        .quick-action-card p {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                padding: 1rem;
            }
            
            .welcome-section {
                padding: 2rem;
            }
            
            .welcome-section h1 {
                font-size: 2rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
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
            <h1>
                <c:choose>
                    <c:when test="${not empty sessionScope.firstName}">
                        Welcome back, ${sessionScope.firstName}!
                    </c:when>
                    <c:otherwise>
                        Welcome back, Student!
                    </c:otherwise>
                </c:choose>
            </h1>
            <p class="mb-0">Ready to ace your next quiz? Let's get started!</p>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/student/quizzes" class="quick-action-card">
                <i class="fas fa-question-circle"></i>
                <h5>Take Quiz</h5>
                <p>Start a new quiz session</p>
            </a>
            <a href="${pageContext.request.contextPath}/student/history" class="quick-action-card">
                <i class="fas fa-history"></i>
                <h5>Quiz History</h5>
                <p>Review your past attempts</p>
            </a>
        </div>

        <!-- Statistics Section -->
        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-book"></i>
                <h3>${not empty totalSubjects ? totalSubjects : '0'}</h3>
                <p>Active Subjects</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-question-circle"></i>
                <h3>${not empty totalQuizzes ? totalQuizzes : '0'}</h3>
                <p>Available Quizzes</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-trophy"></i>
                <h3>${not empty completedQuizzes ? completedQuizzes : '0'}</h3>
                <p>Completed Quizzes</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-chart-line"></i>
                <h3>${not empty averageScore ? averageScore : '0'}%</h3>
                <p>Average Score</p>
            </div>
        </div>

        <!-- Subjects Section -->
        <div class="row">
            <div class="col-12">
                <h3 class="section-title">
                    <i class="fas fa-graduation-cap"></i>
                    My Subjects
                </h3>
            </div>
        </div>

        <div class="row">
            <c:choose>
                <c:when test="${not empty subjects}">
                    <c:forEach var="subject" items="${subjects}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="subject-card">
                                <h5>${subject.title}</h5>
                                <p>${subject.description}</p>
                                
                                <div class="subject-stats">
                                    <div class="subject-stat">
                                        <div class="number">${subject.quizCount != null ? subject.quizCount : '0'}</div>
                                        <div class="label">Quizzes</div>
                                    </div>
                                    <div class="subject-stat">
                                        <div class="number">${subject.lessonCount != null ? subject.lessonCount : '0'}</div>
                                        <div class="label">Lessons</div>
                                    </div>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/student/subject/${subject.id}/lessons" 
                                   class="btn btn-quiz w-100">
                                    <i class="fas fa-play me-2"></i>Chi tiết môn học
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h4>No Subjects Available</h4>
                            <p>You haven't been enrolled in any subjects yet. Contact your teacher to get started.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recent Quiz Results -->
        <div class="row">
            <div class="col-12">
                <h3 class="section-title">
                    <i class="fas fa-clock"></i>
                    Recent Quiz Results
                </h3>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${not empty recentQuizResults}">
                        <c:forEach var="result" items="${recentQuizResults}">
                            <div class="recent-quiz-card">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h5 class="mb-1">${result.quizName}</h5>
                                        <p class="text-muted mb-0">${result.subjectTitle}</p>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${result.attemptDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </small>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <div class="progress-ring">
                                            <svg>
                                                <circle class="bg" cx="30" cy="30" r="26"></circle>
                                                <circle class="progress" cx="30" cy="30" r="26" 
                                                        stroke-dasharray="${result.score * 1.64} 164"></circle>
                                            </svg>
                                        </div>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <div class="quiz-score 
                                            ${result.score >= 90 ? 'score-excellent' : 
                                              result.score >= 80 ? 'score-good' : 
                                              result.score >= 70 ? 'score-average' : 'score-poor'}">
                                            ${result.score}%
                                        </div>
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${result.passed}">
                                                    <span class="badge bg-success">Passed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Failed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-chart-bar"></i>
                            <h4>No Quiz Results Yet</h4>
                            <p>Complete your first quiz to see your results here.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Practice History Section -->
        <!-- Đã xóa mục này theo yêu cầu -->
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add some interactive animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate stat cards on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe all stat cards and subject cards
            document.querySelectorAll('.stat-card, .subject-card, .recent-quiz-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(card);
            });

            // Add hover effects for quick action cards
            document.querySelectorAll('.quick-action-card').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px) scale(1.02)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });
        });
    </script>
</body>
</html>
