<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Chi tiết môn học</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 0;
                margin: 0;
                background: #fafafa;
            }

            header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 60px;
                background-color: #004080;
                color: white;
                display: flex;
                align-items: center;
                padding: 0 30px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                z-index: 1000;
            }
            header h1 {
                margin: 0;
                font-size: 24px;
                flex-grow: 1;
            }
            header nav a {
                color: white;
                text-decoration: none;
                font-weight: bold;
                margin-left: 20px;
                transition: color 0.3s ease;
            }
            header nav a:hover {
                color: #ffcc00;
            }

            .content-wrapper {
                max-width: 800px;
                margin: 90px auto 40px;
                background: white;
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 0 10px #ccc;
            }

            h1 {
                margin-bottom: 10px;
            }

            .thumbnail {
                width: 100%;
                max-height: 300px;
                object-fit: cover;
                border-radius: 8px;
            }

            .meta {
                margin-top: 15px;
                font-size: 14px;
                color: #555;
            }

            .description {
                margin-top: 20px;
            }

            .btn-back {
                display: inline-block;
                margin-bottom: 20px;
                padding: 8px 16px;
                background-color: #004080;
                color: white;
                border-radius: 6px;
                text-decoration: none;
                font-weight: bold;
                transition: background-color 0.3s ease;
            }
            .btn-back:hover {
                background-color: #003060;
            }

            .quiz-list {
                margin-top: 30px;
            }
        </style>
    </head>
    <body>

        <!-- Gọi header dùng chung -->
        <jsp:include page="/views/layout/header.jsp"/>

        <div class="content-wrapper">

            <a href="${pageContext.request.contextPath}/home" class="btn-back">← Quay về trang chủ</a>

            <h1>${subject.title}</h1>
            <h3>${subject.tagline}</h3>

            <c:if test="${not empty subject.thumbnailUrl}">
                <img src="${subject.thumbnailUrl}" alt="Thumbnail" class="thumbnail" />
            </c:if>

            <div class="meta">
                <p><strong>Chuyên ngành:</strong> ${subject.categoryName}</p>
                <p><strong>Người tạo:</strong> ID ${subject.ownerId}</p>
                <p><strong>Ngày tạo:</strong> ${subject.createdAt}</p>
                <p><strong>Ngày cập nhật:</strong> ${subject.updatedAt}</p>
                <p><strong>Trạng thái:</strong> ${subject.status}</p>
            </div>

            <div class="description">
                <h3>Mô tả</h3>
                <p>${subject.description}</p>
            </div>

            <div class="quiz-list">
                <h2>Danh sách Quiz của môn học</h2>
                <c:if test="${empty quizzes}">
                    <p>Chưa có quiz nào cho môn học này.</p>
                </c:if>
                <c:if test="${not empty quizzes}">
                    <table border="1" cellpadding="8" cellspacing="0" width="100%" style="border-collapse: collapse;">
                        <thead style="background-color: #f0f0f0;">
                            <tr>
                                <th>Tên Quiz</th>
                                <th>Level</th>
                                <th>Số câu hỏi</th>
                                <th>Thời gian (phút)</th>
                                <th>Tỉ lệ đậu (%)</th>
                                <th>Loại</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="quiz" items="${quizzes}">
                                <tr>
                                    <td>${quiz.name}</td>
                                    <td>${quiz.level}</td>
                                    <td>${quiz.numberOfQuestions}</td>
                                    <td>${quiz.durationMinutes}</td>
                                    <td>${quiz.passRate}</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/quiz/detail" method="get">
                                            <input type="hidden" name="id" value="${quiz.id}" />
                                            <button type="submit" style="padding: 4px 8px; border: none; background-color: #004080; color: white; border-radius: 4px;">
                                                ${quiz.type}
                                            </button>
                                        </form>
                                    </td>

                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

        </div>

    </body>
</html>
