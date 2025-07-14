<%-- 
    Document   : quiz_handle
    Created on : Jul 3, 2025, 10:29:31 PM
    Author     : kan3v
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Model.*" %>
<%
    List<Model.QuizQuestion> quizQuestions = (List<Model.QuizQuestion>) request.getAttribute("quizQuestions");
    int quizId = (Integer) request.getAttribute("quizId");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Làm bài Quiz</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            max-width: 1000px;
            margin: 40px auto;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .sidebar {
            width: 25%;
            background: #004d99;
            color: #fff;
            padding: 20px;
        }

        .sidebar h3 {
            margin-top: 0;
        }

        #countdown {
            font-weight: bold;
            font-size: 20px;
        }

        .number-grid {
            margin-top: 30px;
            display: flex;
            flex-wrap: wrap;
        }

        .number-grid button {
            width: 35px;
            height: 35px;
            margin: 5px;
            background: #fff;
            color: #004d99;
            border: none;
            border-radius: 50%;
            font-weight: bold;
            cursor: pointer;
        }

        .number-grid button:hover {
            background: #ddd;
        }

        .content {
            width: 75%;
            padding: 30px;
        }

        .question {
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .hidden {
            display: none;
        }

        .question-title {
            font-weight: bold;
        }

        .answer-option {
            margin: 10px 0;
        }

        input[type="radio"] {
            margin-right: 8px;
        }

        .actions {
            margin-top: 20px;
        }

        button[type="submit"], .nav-btn {
            background: #004d99;
            color: #fff;
            border: none;
            padding: 10px 20px;
            margin-right: 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        button[type="submit"]:hover, .nav-btn:hover {
            background: #003366;
        }

    </style>
</head>
<body>

<div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
        <h3>Quiz ID: <%= quizId %></h3>
        <div><strong>Thời gian còn lại:</strong></div>
        <div id="countdown">00:00</div>

        <div class="number-grid">
            <% int index = 1; for (QuizQuestion qq : quizQuestions) { %>
                <button type="button" onclick="showQuestion(<%= index - 1 %>)"><%= index++ %></button>
            <% } %>
        </div>
    </div>

    <!-- Content -->
    <div class="content">
        <h2>Làm bài Quiz</h2>
        <form method="post" action="quiz-handle">
            <input type="hidden" name="quizId" value="<%= quizId %>">

            <% 
                int idx = 0;
                for (QuizQuestion qq : quizQuestions) { 
                    List<QuestionAnswer> answers = (List<QuestionAnswer>) request.getAttribute("answers_" + qq.getQuestionId());
            %>
            <div class="question hidden" id="question-<%= idx %>">
                <div class="question-title">Câu hỏi <%= qq.getQuestionOrder() %>:</div>
                <p><%= qq.getQuestionId() %></p>

                <% for (QuestionAnswer ans : answers) { %>
                <div class="answer-option">
                    <label>
                        <input type="radio" name="answer_<%= qq.getQuestionId() %>" value="<%= ans.getId() %>">
                        <%= ans.getContent() %>
                    </label>
                </div>
                <% } %>
            </div>
            <% idx++; } %>

            <div class="actions">
                <button type="button" class="nav-btn" onclick="prevQuestion()">Trước</button>
                <button type="button" class="nav-btn" onclick="nextQuestion()">Tiếp</button>
                <button type="submit">Nộp bài</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Đếm ngược
    var duration = 50 * 60; // 50 phút
    var display = document.getElementById('countdown');

    function startTimer(duration, display) {
        var timer = duration, minutes, seconds;
        var countdown = setInterval(function () {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);

            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            display.textContent = minutes + ":" + seconds;

            if (--timer < 0) {
                clearInterval(countdown);
                alert("Hết giờ! Bài thi sẽ tự nộp.");
                document.forms[0].submit();
            }
        }, 1000);
    }

    window.onload = function() {
        startTimer(duration, display);
        showQuestion(0);
    };

    // Điều hướng câu hỏi
    var currentIndex = 0;
    var totalQuestions = <%= quizQuestions.size() %>;

    function showQuestion(index) {
        var all = document.querySelectorAll('.question');
        all.forEach(q => q.classList.add('hidden'));

        if(index >= 0 && index < totalQuestions) {
            all[index].classList.remove('hidden');
            currentIndex = index;
        }
    }

    function nextQuestion() {
        if (currentIndex < totalQuestions - 1) {
            showQuestion(currentIndex + 1);
        }
    }

    function prevQuestion() {
        if (currentIndex > 0) {
            showQuestion(currentIndex - 1);
        }
    }
</script>

</body>
</html>
