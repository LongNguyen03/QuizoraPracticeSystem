<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Practice Quiz</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .practice-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 2rem 0; margin-bottom: 2rem; }
        .question-card { border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .answer-option { border: 2px solid #e9ecef; border-radius: 10px; padding: 1rem; margin-bottom: 1rem; cursor: pointer; transition: all 0.3s ease; }
        .answer-option:hover { border-color: #667eea; background-color: #f8f9fa; }
        .answer-option.selected { border-color: #667eea; background-color: #e3f2fd; }
        .next-btn { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 25px; padding: 0.75rem 2rem; color: white; font-weight: 600; transition: all 0.3s ease; }
        .next-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); color: white; }
        .question-nav-btn { border-radius: 50%; width: 40px; height: 40px; margin: 2px; }
        .feedback-correct { background-color: #d4edda; border-color: #c3e6cb; color: #155724; }
        .feedback-incorrect { background-color: #f8d7da; border-color: #f5c6cb; color: #721c24; }
    </style>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    <div class="practice-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-2"><i class="fas fa-dumbbell me-2"></i>Practice Mode</h2>
                    <p class="mb-0">Luyện tập không áp lực thời gian</p>
                </div>
                <div class="col-md-4 text-end">
                    <button class="btn btn-outline-light" onclick="finishPractice()"><i class="fas fa-stop me-2"></i>Kết thúc</button>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="fw-bold">Tiến độ: <span id="currentQuestion">1</span> / <span id="totalQuestions">${fn:length(questions)}</span></span>
                    <span class="text-muted">Đã trả lời: <span id="answeredCount">0</span></span>
                </div>
                <div class="progress"><div class="progress-bar" id="progressBar" role="progressbar" style="width: 0%"></div></div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-8">
                <div class="card question-card">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-question-circle me-2"></i>Câu hỏi <span id="questionNumber">1</span></h4>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title mb-4" id="questionContent"><!-- Question content --></h5>
                        <div id="answerOptions"><!-- Answer options --></div>
                        <div id="feedback" class="alert mt-3" style="display: none;"><i class="fas fa-info-circle me-2"></i><span id="feedbackMessage"></span></div>
                        <div class="d-flex justify-content-between mt-4">
                            <button class="btn btn-secondary" onclick="previousQuestion()" id="prevBtn" disabled><i class="fas fa-chevron-left me-2"></i>Câu trước</button>
                            <button class="btn next-btn" onclick="nextQuestion()" id="nextBtn" disabled>Câu tiếp<i class="fas fa-chevron-right ms-2"></i></button>
                        </div>
                        <div class="d-flex justify-content-end mt-4">
                            <button class="btn btn-success" type="button" onclick="submitPractice()"><i class="fas fa-paper-plane me-2"></i>Nộp bài</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header"><h5 class="mb-0"><i class="fas fa-list me-2"></i>Danh sách câu hỏi</h5></div>
                    <div class="card-body">
                        <div class="row" id="questionNavigator">
                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <div class="col-3 mb-2">
                                    <button class="btn btn-sm btn-outline-secondary w-100 question-nav-btn" data-question="${status.index}" onclick="goToQuestion(${status.index})">${status.index + 1}</button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="card mt-3">
                    <div class="card-body">
                        <h6 class="card-title"><i class="fas fa-info-circle me-2"></i>Thông tin Practice</h6>
                        <ul class="list-unstyled small">
                            <li class="mb-1"><i class="fas fa-check text-success me-2"></i>Không có thời gian giới hạn</li>
                            <li class="mb-1"><i class="fas fa-check text-success me-2"></i>Xem đáp án ngay lập tức</li>
                            <li class="mb-1"><i class="fas fa-check text-success me-2"></i>Có thể quay lại sửa đáp án</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <form id="finishForm" method="post" action="${pageContext.request.contextPath}/student/practice">
        <input type="hidden" name="action" value="finish">
        <input type="hidden" name="sessionId" value="${practiceSession.id}">
        <input type="hidden" name="userAnswers" id="userAnswersInput">
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Truyền dữ liệu câu hỏi + đáp án sang JS
        var questionData = [
            <c:forEach var="question" items="${questions}" varStatus="qStatus">
            {
                id: ${question.id},
                content: `${question.content}`,
                answers: [
                    <c:forEach var="answer" items="${question.answers}" varStatus="aStatus">
                    { id: ${answer.id}, content: `${answer.content}` }<c:if test="${!aStatus.last}">,</c:if>
                    </c:forEach>
                ]
            }<c:if test="${!qStatus.last}">,</c:if>
            </c:forEach>
        ];
        let currentQuestionIndex = 0;
        let answeredQuestions = new Set();
        let userAnswers = {};
        document.addEventListener('DOMContentLoaded', function() {
            updateProgress();
            renderQuestion(currentQuestionIndex);
        });
        function renderQuestion(index) {
            const q = questionData[index];
            document.getElementById('questionNumber').textContent = index + 1;
            document.getElementById('questionContent').textContent = q.content;
            const answerOptions = document.getElementById('answerOptions');
            answerOptions.innerHTML = '';
            q.answers.forEach(ans => {
                const div = document.createElement('div');
                div.className = 'answer-option';
                div.setAttribute('data-answer-id', ans.id);
                div.onclick = function() { selectAnswer(ans.id); };
                div.innerHTML = ans.content;
                if (userAnswers[index] && userAnswers[index] == ans.id) div.classList.add('selected');
                answerOptions.appendChild(div);
            });
            document.getElementById('prevBtn').disabled = index === 0;
            document.getElementById('nextBtn').disabled = index === questionData.length - 1;
            updateQuestionNavigator();
            document.getElementById('feedback').style.display = 'none';
        }
        function selectAnswer(answerId) {
            userAnswers[currentQuestionIndex] = answerId;
            answeredQuestions.add(currentQuestionIndex);
            renderQuestion(currentQuestionIndex);
            updateProgress();
        }
        function submitPractice() {
            if (answeredQuestions.size < questionData.length) {
                if (!confirm('Bạn chưa trả lời hết các câu hỏi. Vẫn muốn nộp bài?')) return;
            }
            // Serialize userAnswers thành chuỗi questionId:answerId,questionId:answerId,...
            let pairs = [];
            Object.keys(userAnswers).forEach(function(idx) {
                let qid = questionData[parseInt(idx)].id;
                pairs.push(qid + ':' + userAnswers[idx]);
            });
            let userAnswersStr = pairs.join(',');
            document.getElementById('userAnswersInput').value = userAnswersStr;
            document.getElementById('finishForm').submit();
        }
        function nextQuestion() { if (currentQuestionIndex < questionData.length - 1) { currentQuestionIndex++; renderQuestion(currentQuestionIndex); } }
        function previousQuestion() { if (currentQuestionIndex > 0) { currentQuestionIndex--; renderQuestion(currentQuestionIndex); } }
        function goToQuestion(index) { currentQuestionIndex = index; renderQuestion(currentQuestionIndex); }
        function updateQuestionNavigator() {
            const navButtons = document.querySelectorAll('.question-nav-btn');
            navButtons.forEach((btn, index) => {
                btn.className = 'btn btn-sm w-100 question-nav-btn';
                if (index === currentQuestionIndex) btn.classList.add('btn-primary');
                else if (answeredQuestions.has(index)) btn.classList.add('btn-success');
                else btn.classList.add('btn-outline-secondary');
            });
        }
        function updateProgress() {
            const progress = (answeredQuestions.size / questionData.length) * 100;
            document.getElementById('progressBar').style.width = progress + '%';
            document.getElementById('answeredCount').textContent = answeredQuestions.size;
        }
        function finishPractice() {
            submitPractice();
        }
    </script>
</body>
</html> 