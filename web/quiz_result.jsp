<%-- 
    Document   : quiz_result
    Created on : Jul 3, 2025, 10:29:52 PM
    Author     : kan3v
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.QuizResultDAO, Model.QuizResult" %>
<%
    int resultId = Integer.parseInt(request.getParameter("resultId"));
    QuizResultDAO dao = new QuizResultDAO();
    QuizResult result = dao.getQuizResultById(resultId);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {
            background: #f4f6f9;
        }
        .result-box {
            max-width: 500px;
            margin: 100px auto;
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            text-align: center;
        }
        .result-box h1 {
            margin-bottom: 30px;
        }
        .score {
            font-size: 2rem;
            font-weight: bold;
            margin: 20px 0;
        }
        .passed {
            color: green;
        }
        .failed {
            color: red;
        }
    </style>
</head>
<body>
<div class="result-box">
    <h1>Kết quả Làm Bài</h1>
    <p class="score">Điểm số: <%= result.getScore() %></p>
    <p class="<%= result.isPassed() ? "passed" : "failed" %>">
        <strong><%= result.isPassed() ? "Đạt 🎉" : "Không đạt ❌" %></strong>
    </p>
    <a href="quiz" class="btn btn-primary mt-3">
        <i class="fas fa-home"></i> Quay về trang chính
    </a>
</div>

<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>

