<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Take Quiz - ${quiz.name}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .question-card { margin-bottom: 2rem; }
        .timer { font-size: 1.5rem; font-weight: bold; color: #dc3545; }
        .submit-btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .question-status { font-size: 0.9rem; color: #6c757d; }
        .answered { color: #28a745; }
        .unanswered { color: #dc3545; }
    </style>
</head>
<body>
<jsp:include page="../views/components/header.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>${quiz.name}</h2>
        <div class="timer" id="timer"></div>
    </div>
    
    <!-- Progress indicator -->
    <div class="alert alert-info mb-4">
        <strong>Tiến độ:</strong> <span id="progress">0/${fn:length(questions)}</span> câu đã trả lời
    </div>
    
    <form method="post" action="${pageContext.request.contextPath}/student/quiz/${quiz.id}" id="quizForm">
        <input type="hidden" name="quizId" value="${quiz.id}" />
        <input type="hidden" name="startTime" id="startTimeInput" />
        <c:forEach var="q" items="${questions}" varStatus="status">
            <div class="card question-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <b>Câu ${status.index + 1}:</b> ${q.content}
                    </div>
                    <span class="question-status unanswered" id="status_${status.index + 1}">
                        <i class="fas fa-times-circle"></i> Chưa trả lời
                    </span>
                </div>
                <div class="card-body">
                    <c:forEach var="ans" items="${q.answers}">
                        <div class="form-check">
                            <input class="form-check-input answer-radio" type="radio"
                                   name="answer_${status.index + 1}" value="${ans.id}" 
                                   id="q${q.id}_a${ans.id}" data-question="${status.index + 1}">
                            <label class="form-check-label" for="q${q.id}_a${ans.id}">
                                ${ans.content}
                            </label>
                        </div>
                    </c:forEach>
                    <input type="hidden" name="question_${status.index + 1}" value="${q.id}" />
                </div>
            </div>
        </c:forEach>
        <button type="submit" class="btn btn-primary btn-lg w-100 submit-btn" id="submitBtn" disabled>
            Nộp bài
        </button>
    </form>
</div>

<script>
    // Khai báo biến tổng số câu hỏi ở đầu script
    var totalQuestions = ${fn:length(questions)};
    // Lưu thời gian bắt đầu vào sessionStorage
    var totalDuration = ${quiz.durationMinutes} * 60; // seconds
    var startTime = sessionStorage.getItem('quizStartTime_${quiz.id}');
    if (!startTime) {
        startTime = Date.now();
        sessionStorage.setItem('quizStartTime_${quiz.id}', startTime);
        sessionStorage.setItem('quizDuration_${quiz.id}', totalDuration);
    } else {
        startTime = parseInt(startTime);
    }
    var elapsed = Math.floor((Date.now() - startTime) / 1000);
    var duration = totalDuration - elapsed;

    // Nếu đã hết giờ (do sessionStorage cũ), reset lại thời gian
    if (duration <= 0) {
        sessionStorage.removeItem('quizStartTime_${quiz.id}');
        sessionStorage.removeItem('quizDuration_${quiz.id}');
        for (var i = 1; i <= totalQuestions; i++) {
            sessionStorage.removeItem('quizAnswer_${quiz.id}_' + i);
        }
        // Reload lại trang để bắt đầu lại
        location.reload();
    }
    
    // Timer countdown
    var timerDisplay = document.getElementById('timer');
    var interval = setInterval(function() {
        var minutes = Math.floor(duration / 60);
        var seconds = duration % 60;
        timerDisplay.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
        
        if (--duration < 0) {
            clearInterval(interval);
            alert('Hết giờ! Bài làm sẽ được nộp tự động.');
            document.getElementById('quizForm').submit();
        }
    }, 1000);
    
    // Validation: Kiểm tra đã trả lời đủ câu chưa
    var answeredQuestions = new Set();
    
    // Hàm cập nhật trạng thái câu hỏi
    function updateQuestionStatus(questionNumber, isAnswered) {
        var statusElement = document.getElementById('status_' + questionNumber);
        if (isAnswered) {
            statusElement.innerHTML = '<i class="fas fa-check-circle"></i> Đã trả lời';
            statusElement.className = 'question-status answered';
            answeredQuestions.add(questionNumber);
        } else {
            statusElement.innerHTML = '<i class="fas fa-times-circle"></i> Chưa trả lời';
            statusElement.className = 'question-status unanswered';
            answeredQuestions.delete(questionNumber);
        }
        
        // Cập nhật progress
        document.getElementById('progress').textContent = answeredQuestions.size + '/' + totalQuestions;
        
        // Kiểm tra có thể nộp bài chưa
        var submitBtn = document.getElementById('submitBtn');
        if (answeredQuestions.size === totalQuestions) {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Nộp bài';
        } else {
            submitBtn.disabled = true;
            submitBtn.textContent = 'Nộp bài (' + answeredQuestions.size + '/' + totalQuestions + ')';
        }
    }
    
    // Hàm lưu đáp án vào sessionStorage
    function saveAnswer(questionNumber, answerId) {
        sessionStorage.setItem('quizAnswer_${quiz.id}_' + questionNumber, answerId);
    }
    
    // Hàm load đáp án từ sessionStorage
    function loadSavedAnswers() {
        for (var i = 1; i <= totalQuestions; i++) {
            var savedAnswer = sessionStorage.getItem('quizAnswer_${quiz.id}_' + i);
            if (savedAnswer) {
                var radio = document.querySelector('input[name="answer_' + i + '"][value="' + savedAnswer + '"]');
                if (radio) {
                    radio.checked = true;
                    updateQuestionStatus(i, true);
                }
            }
        }
    }
    
    // Lắng nghe sự kiện chọn đáp án
    document.querySelectorAll('.answer-radio').forEach(function(radio) {
        radio.addEventListener('change', function() {
            var questionNumber = parseInt(this.dataset.question);
            var answerId = this.value;
            saveAnswer(questionNumber, answerId);
            updateQuestionStatus(questionNumber, true);
        });
    });
    
    // Load đáp án đã lưu khi trang load
    loadSavedAnswers();
    
    // Ngăn chặn refresh trang
    window.addEventListener('beforeunload', function(e) {
        if (answeredQuestions.size > 0) {
            e.preventDefault();
            e.returnValue = 'Bạn có chắc muốn rời khỏi trang? Dữ liệu bài làm sẽ bị mất.';
        }
    });
    
    // Xóa dữ liệu khi rời khỏi trang (nếu không nộp bài)
    window.addEventListener('unload', function() {
        // Chỉ xóa nếu không phải do submit form
        if (answeredQuestions.size > 0 && answeredQuestions.size < totalQuestions) {
            sessionStorage.removeItem('quizStartTime_${quiz.id}');
            sessionStorage.removeItem('quizDuration_${quiz.id}');
            for (var i = 1; i <= totalQuestions; i++) {
                sessionStorage.removeItem('quizAnswer_${quiz.id}_' + i);
            }
        }
    });
    
    // Xử lý form submission
    document.getElementById('quizForm').addEventListener('submit', function(e) {
        if (answeredQuestions.size < totalQuestions) {
            e.preventDefault();
            alert('Vui lòng trả lời tất cả các câu hỏi trước khi nộp bài!');
            return false;
        }
        
        // Set start time value before submitting
        var startTime = sessionStorage.getItem('quizStartTime_${quiz.id}');
        if (startTime) {
            document.getElementById('startTimeInput').value = startTime;
        }
        
        // Xóa dữ liệu session khi nộp bài thành công
        sessionStorage.removeItem('quizStartTime_${quiz.id}');
        sessionStorage.removeItem('quizDuration_${quiz.id}');
        
        // Xóa tất cả đáp án đã lưu
        for (var i = 1; i <= totalQuestions; i++) {
            sessionStorage.removeItem('quizAnswer_${quiz.id}_' + i);
        }
    });
</script>
</body>
</html> 