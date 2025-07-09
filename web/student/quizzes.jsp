<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Quizzes - Quizora</title>
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

        .page-container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
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

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .filters-section {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border-radius: 0.5rem;
            border: 1px solid #e9ecef;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-filter {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.25rem 0.5rem rgba(102, 126, 234, 0.4);
            color: white;
        }

        .quiz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }

        .quiz-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            border: 1px solid rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }

        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
        }

        .quiz-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .quiz-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.25rem;
        }

        .quiz-subject {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .favorite-btn {
            background: none;
            border: none;
            color: #dc3545;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 0.25rem;
        }

        .favorite-btn:hover {
            transform: scale(1.2);
        }

        .favorite-btn.not-favorite {
            color: #6c757d;
        }

        .quiz-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .quiz-stat {
            text-align: center;
            padding: 0.75rem;
            background: #f8f9fa;
            border-radius: 0.5rem;
        }

        .quiz-stat .number {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary-color);
            display: block;
        }

        .quiz-stat .label {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }

        .quiz-level {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .level-easy { background-color: #d4edda; color: #155724; }
        .level-medium { background-color: #fff3cd; color: #856404; }
        .level-hard { background-color: #f8d7da; color: #721c24; }

        .quiz-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-take-quiz {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
            flex: 1;
        }

        .btn-take-quiz:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.25rem 0.5rem rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-practice {
            background: var(--info-color);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-practice:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.25rem 0.5rem rgba(23, 162, 184, 0.4);
            color: white;
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

        .results-info {
            background: white;
            border-radius: 1rem;
            padding: 1rem 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .results-count {
            font-weight: 600;
            color: #2c3e50;
        }

        .clear-filters {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .clear-filters:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .page-container {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .quiz-grid {
                grid-template-columns: 1fr;
            }
            
            .quiz-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../views/components/header.jsp" />

    <div class="page-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1>Available Quizzes</h1>
            <p>Choose a quiz to test your knowledge and track your progress</p>
        </div>

        <!-- Filters Section -->
        <div class="filters-section">
            <form method="GET" action="${pageContext.request.contextPath}/student/quizzes">
                <div class="filter-row">
                    <div>
                        <label for="search" class="form-label">Search Quizzes</label>
                        <input type="text" class="form-control" id="search" name="search" 
                               placeholder="Search by quiz name..." 
                               value="${searchQuery != null ? searchQuery : ''}">
                    </div>
                    <div>
                        <label for="subject" class="form-label">Subject</label>
                        <select class="form-select" id="subject" name="subject">
                            <option value="">All Subjects</option>
                            <c:forEach var="subject" items="${subjects}">
                                <option value="${subject.id}" 
                                        ${selectedSubject != null && selectedSubject == subject.id ? 'selected' : ''}>
                                    ${subject.title}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label for="level" class="form-label">Level</label>
                        <select class="form-select" id="level" name="level">
                            <option value="">All Levels</option>
                            <c:forEach var="level" items="${levels}">
                                <option value="${level}" 
                                        ${selectedLevel != null && selectedLevel == level ? 'selected' : ''}>
                                    ${level}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-filter w-100">
                            <i class="fas fa-search me-2"></i>Filter
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Results Info -->
        <c:if test="${not empty quizzes}">
            <div class="results-info">
                <div class="results-count">
                    <i class="fas fa-list me-2"></i>
                    ${quizzes.size()} quiz${quizzes.size() != 1 ? 'es' : ''} found
                </div>
                <c:if test="${not empty selectedSubject || not empty selectedLevel || not empty searchQuery}">
                    <a href="${pageContext.request.contextPath}/student/quizzes" class="clear-filters">
                        <i class="fas fa-times me-1"></i>Clear Filters
                    </a>
                </c:if>
            </div>
        </c:if>

        <!-- Quizzes Grid -->
        <div class="quiz-grid">
            <c:choose>
                <c:when test="${not empty quizzes}">
                    <c:forEach var="quiz" items="${quizzes}">
                        <div class="quiz-card">
                            <div class="quiz-header">
                                <div>
                                    <h5 class="quiz-title">${quiz.name}</h5>
                                    <p class="quiz-subject">${quiz.subjectTitle}</p>
                                </div>
                                <button class="favorite-btn ${quiz.favorite ? '' : 'not-favorite'}" 
                                        onclick="toggleFavorite(${quiz.id}, this)">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                            
                            <div class="quiz-stats">
                                <div class="quiz-stat">
                                    <span class="number">${quiz.numberOfQuestions}</span>
                                    <span class="label">Questions</span>
                                </div>
                                <div class="quiz-stat">
                                    <span class="number">${quiz.durationMinutes}</span>
                                    <span class="label">Minutes</span>
                                </div>
                                <div class="quiz-stat">
                                    <span class="number">${quiz.passRate}%</span>
                                    <span class="label">Pass Rate</span>
                                </div>
                            </div>
                            
                            <div class="quiz-level level-${quiz.level.toLowerCase()}">
                                ${quiz.level} Level
                            </div>
                            
                            <div class="quiz-actions">
                                <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}" 
                                   class="btn btn-take-quiz">
                                    <i class="fas fa-play me-2"></i>Take Quiz
                                </a>
                                <a href="${pageContext.request.contextPath}/student/practice/${quiz.id}" 
                                   class="btn btn-practice">
                                    <i class="fas fa-dumbbell"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-search"></i>
                        <h4>No Quizzes Found</h4>
                        <p>
                            <c:choose>
                                <c:when test="${not empty selectedSubject || not empty selectedLevel || not empty searchQuery}">
                                    No quizzes match your current filters. Try adjusting your search criteria.
                                </c:when>
                                <c:otherwise>
                                    No quizzes are available at the moment. Check back later!
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleFavorite(quizId, button) {
            const isFavorite = button.classList.contains('not-favorite');
            const action = isFavorite ? 'add' : 'remove';
            
            fetch('${pageContext.request.contextPath}/student/favorite-quiz', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `quizId=${quizId}&action=${action}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (isFavorite) {
                        button.classList.remove('not-favorite');
                    } else {
                        button.classList.add('not-favorite');
                    }
                } else {
                    alert('Failed to update favorite status');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while updating favorite status');
            });
        }

        // Add some interactive animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate quiz cards on scroll
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

            // Observe all quiz cards
            document.querySelectorAll('.quiz-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(card);
            });
        });
    </script>
</body>
</html> 