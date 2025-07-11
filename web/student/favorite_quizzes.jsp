<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Favorite Quizzes - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .quiz-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 1.5rem; }
        .quiz-card { background: white; border-radius: 1rem; padding: 1.5rem; box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); border: 1px solid rgba(0,0,0,0.05); position: relative; }
        .quiz-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem; }
        .quiz-title { font-size: 1.25rem; font-weight: 600; color: #2c3e50; margin-bottom: 0.25rem; }
        .quiz-subject { color: #6c757d; font-size: 0.9rem; }
        .favorite-btn { background: none; border: none; color: #dc3545; font-size: 1.2rem; cursor: pointer; transition: all 0.3s ease; padding: 0.25rem; }
        .favorite-btn.not-favorite { color: #6c757d; }
        .quiz-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
        .quiz-stat { text-align: center; padding: 0.75rem; background: #f8f9fa; border-radius: 0.5rem; }
        .quiz-stat .number { font-size: 1.1rem; font-weight: 700; color: #667eea; display: block; }
        .quiz-stat .label { font-size: 0.8rem; color: #6c757d; margin-top: 0.25rem; }
        .quiz-level { display: inline-block; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.8rem; font-weight: 600; margin-bottom: 1rem; }
        .level-easy { background-color: #d4edda; color: #155724; }
        .level-medium { background-color: #fff3cd; color: #856404; }
        .level-hard { background-color: #f8d7da; color: #721c24; }
        .quiz-actions { display: flex; gap: 0.5rem; }
        .btn-take-quiz { background: linear-gradient(135deg, #667eea, #764ba2); border: none; color: white; padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 500; transition: all 0.3s ease; flex: 1; }
        .btn-take-quiz:hover { transform: translateY(-2px); box-shadow: 0 0.25rem 0.5rem rgba(102, 126, 234, 0.4); color: white; }
        .btn-practice { background: #17a2b8; border: none; color: white; padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 500; transition: all 0.3s ease; }
        .btn-practice:hover { transform: translateY(-2px); box-shadow: 0 0.25rem 0.5rem rgba(23, 162, 184, 0.4); color: white; }
        .empty-state { text-align: center; padding: 3rem; color: #6c757d; }
        .empty-state i { font-size: 4rem; margin-bottom: 1rem; opacity: 0.5; }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    <div class="container py-4">
        <h2 class="mb-4">Your Favorite Quizzes</h2>
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
                                <form method="post" action="${pageContext.request.contextPath}/student/favorite-quiz" style="display:inline;">
                                    <input type="hidden" name="quizId" value="${quiz.id}" />
                                    <input type="hidden" name="action" value="remove" />
                                    <button type="submit" class="favorite-btn" title="Bỏ yêu thích">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </form>
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
                                <a href="${pageContext.request.contextPath}/student/quiz/${quiz.id}" class="btn btn-take-quiz">
                                    <i class="fas fa-play me-2"></i>Take Quiz
                                </a>
                                <a href="${pageContext.request.contextPath}/student/practice/${quiz.id}" class="btn btn-practice">
                                    <i class="fas fa-dumbbell"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-heart-broken"></i>
                        <h4>No Favorite Quizzes</h4>
                        <p>You haven't added any quizzes to your favorites yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html> 