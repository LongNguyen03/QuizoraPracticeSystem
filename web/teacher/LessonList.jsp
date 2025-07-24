<%-- 
    Document   : LessonList
    Created on : Jun 14, 2025, 8:07:40 PM
    Author     : kan3v
--%>
<%@page import="java.util.List"%>
<%@page import="Model.Lesson, Model.Subject"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lesson List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f7f7f7;
            margin: 0;
            padding: 0;
        }
        .lesson-list-container {
            max-width: 900px;
            margin: 40px auto 0 auto;
            padding: 0 16px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .header h2 {
            margin: 0;
            font-size: 2rem;
            color: #4a4a4a;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .add-btn {
            padding: 10px 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            font-size: 1rem;
            box-shadow: 0 2px 8px rgba(102,126,234,0.10);
            transition: background 0.3s, box-shadow 0.3s;
            border: none;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .add-btn:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            box-shadow: 0 4px 16px rgba(102,126,234,0.18);
            color: #fff;
        }
        .lesson-card {
            display: flex;
            align-items: flex-start;
            background: #fff;
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(102,126,234,0.08);
            margin-bottom: 18px;
            padding: 20px 24px;
            transition: box-shadow 0.3s, transform 0.1s;
            cursor: pointer;
        }
        .lesson-card:hover {
            box-shadow: 0 6px 24px rgba(102,126,234,0.18);
            transform: translateY(-2px);
        }
        .lesson-info {
            flex-grow: 1;
        }
        .lesson-info div {
            margin-bottom: 6px;
            line-height: 1.5;
            color: #333;
            font-size: 1rem;
        }
        .lesson-info strong {
            color: #764ba2;
            font-weight: 600;
        }
        .lesson-actions {
            margin-left: 28px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .lesson-actions a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #f3f3fa;
            color: #667eea;
            font-size: 1.2rem;
            transition: background 0.2s, color 0.2s;
            text-decoration: none;
        }
        .lesson-actions a:hover {
            background: #667eea;
            color: #fff;
        }
        @media (max-width: 600px) {
            .lesson-list-container {
                padding: 0 4px;
            }
            .lesson-card {
                flex-direction: column;
                padding: 16px 10px;
            }
            .lesson-actions {
                flex-direction: row;
                margin-left: 0;
                margin-top: 10px;
                gap: 16px;
            }
        }
    </style>
    <script>
        window.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.lesson-card').forEach(function(card) {
                card.addEventListener('click', function(e) {
                    if (e.target.tagName.toLowerCase() === 'a') return;
                    var id = this.getAttribute('data-id');
                    window.location.href = '${pageContext.request.contextPath}/QuestionController?action=list&lessonId=' + id;
                });
            });
        });
    </script>
</head>
<body>
    <jsp:include page="../views/components/header.jsp" />
    <div class="lesson-list-container">
        <div class="header">
            <h2>📚 Danh sách bài học</h2>
            <a href="${pageContext.request.contextPath}/lesson?action=detail" class="add-btn"><span>➕</span> Thêm bài học mới</a>
        </div>

    <%-- Helper --%>
    <%! public String getSubjectName(int id, List<Subject> subjects) {
        for (Subject s : subjects) {
            if (s.getId() == id) return s.getTitle();
        }
        return "";
    }
%>
    <%
            }
        } else {
    %>
    <p>Không có bài học nào được tìm thấy...</p>
    <%
        }
    %>
    </div>
</body>
</html>

