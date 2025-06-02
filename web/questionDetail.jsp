<%-- 
    Document   : question_detail
    Created on : May 30, 2025, 8:40:31 AM
    Author     : kan3v
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.Question, Model.Subject, Model.Lesson, Model.SubjectDimension, Model.QuestionAnswer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>

<%
    Question q = (Question) request.getAttribute("question");
    boolean isEdit = q != null;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Lesson> lessons = (List<Lesson>) request.getAttribute("lessons");
    List<SubjectDimension> dimensions = (List<SubjectDimension>) request.getAttribute("dimensions");
    List<QuestionAnswer> answers = isEdit ? q.getAnswerOptions() : null;
%>

<html>
    <head>
        <title><%= isEdit ? "Edit" : "Create" %> Question</title>
        <style>
            /* Giữ nguyên style như cũ hoặc chỉnh tùy thích */
            body {
                font-family: Arial;
                background-color: #f9f9f9;
                margin: 40px;
            }
            h2 {
                color: #333;
            }
            table {
                width: 800px;
                padding: 20px;
                background-color: white;
                border-collapse: collapse;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            td {
                padding: 10px;
            }
            input[type="text"], input[type="number"], select {
                width: 100%;
                padding: 8px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }
            input[type="submit"], button {
                padding: 10px 20px;
                background-color: #007BFF;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            input[type="submit"]:hover, button:hover {
                background-color: #0056b3;
            }
            a {
                display: inline-block;
                margin-top: 20px;
                color: #007BFF;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            .answer-table {
                width: 100%;
                margin-top: 10px;
                border: 1px solid #ddd;
            }
            .answer-table th, .answer-table td {
                border: 1px solid #ddd;
                padding: 8px;
            }
            .remove-btn {
                background-color: red;
                color: white;
                border: none;
                border-radius: 3px;
                cursor: pointer;
            }
            .remove-btn:hover {
                background-color: darkred;
            }
        </style>

        <script>
            function addAnswerRow() {
                const table = document.getElementById("answersBody");

                const row = table.insertRow();
                row.innerHTML = `
                    <td><input type="text" name="answerContent" required /></td>
                    <td style="text-align: center"><input type="checkbox" name="answerIsCorrect" /></td>
                    <td><input type="number" name="answerOrder" min="1" value="${table.rows.length}" required /></td>
                    <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>
                `;
            }

            function removeRow(button) {
                const row = button.parentNode.parentNode;
                row.parentNode.removeChild(row);
                // Optional: update answerOrder values after removal
                updateAnswerOrders();
            }

            function updateAnswerOrders() {
                const orders = document.getElementsByName("answerOrder");
                for (let i = 0; i < orders.length; i++) {
                    orders[i].value = i + 1;
                }
            }
        </script>
    </head>

    <body>
        <h2><%= isEdit ? "Edit" : "Create" %> Question</h2>

        <!-- enctype="multipart/form-data" nếu bạn xử lý upload file sau -->
        <form id="questionForm" action="QuestionController" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= isEdit ? q.getId() : "" %>"/>
            <table>
                <tr>
                    <td>Content:</td>
                    <td><input type="text" name="content" value="<%= isEdit ? q.getContent() : "" %>" required/></td>
                </tr>
                <tr>
                    <td>Level:</td>
                    <td><input type="text" name="level" value="<%= isEdit ? q.getLevel() : "" %>" required/></td>
                </tr>
                <tr>
                    <td>Image:</td>
                    <td>
                        <input type="file" name="imageFile" accept="image/jpeg,image/png,image/jpg" />
                        <% if (q != null && q.getImageUrl() != null) { %>
                        <br/>
                        <img src="imageUrl?id=<%= q.getId() %>" style="max-width: 300px; height: auto;" />
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <td>Subject:</td>
                    <td>
                        <select name="subjectId" required>
                            <option value="">-- Select Subject --</option>
                            <% for (Subject s : subjects) { %>
                            <option value="<%= s.getId() %>" <%= isEdit && q.getSubjectId() == s.getId() ? "selected" : "" %>>
                                <%= s.getTitle() %>
                            </option>
                            <% } %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Lesson:</td>
                    <td>
                        <select name="lessonId" required>
                            <option value="">-- Select Lesson --</option>
                            <% for (Lesson l : lessons) { %>
                            <option value="<%= l.getId() %>" <%= isEdit && q.getLessonId() == l.getId() ? "selected" : "" %>>
                                <%= l.getTitle() %>
                            </option>
                            <% } %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Dimension:</td>
                    <td>
                        <select name="dimensionId" required>
                            <option value="">-- Select Dimension --</option>
                            <% for (SubjectDimension d : dimensions) { %>
                            <option value="<%= d.getId() %>" <%= isEdit && q.getDimensionId() == d.getId() ? "selected" : "" %>>
                                <%= d.getName() %>
                            </option>
                            <% } %>
                        </select>
                    </td>
                </tr>

                <% if (isEdit) { %>
                <tr>
                    <td>Created At:</td>
                    <td><input type="text" value="<%= sdf.format(q.getCreatedAt()) %>" readonly/></td>
                </tr>
                <tr>
                    <td>Updated At:</td>
                    <td><input type="text" value="<%= q.getUpdatedAt() != null ? sdf.format(q.getUpdatedAt()) : "" %>" readonly/></td>
                </tr>
                <% } %>

                <tr>
                    <td colspan="2">
                        <h3>Answer Options</h3>
                        <table class="answer-table">
                            <thead>
                                <tr>
                                    <th>Content</th>
                                    <th style="text-align:center;">Is Correct</th>
                                    <th>Order</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="answersBody">
                                <% if (isEdit && answers != null) {
                        for (QuestionAnswer a : answers) { %>
                                <tr>
                                    <td><input type="text" name="answerContent" value="<%= a.getContent() %>" required /></td>
                                    <td style="text-align: center"><input type="checkbox" name="answerIsCorrect" <%= a.isCorrect() ? "checked" : "" %> /></td>
                                    <td><input type="number" name="answerOrder" value="<%= a.getAnswerOrder() %>" min="1" required /></td>
                                    <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>
                                </tr>
                                <% }
                    } else { %>
                                <!-- Nếu tạo mới, thêm 1 dòng mặc định -->
                                <tr>
                                    <td><input type="text" name="answerContent" required /></td>
                                    <td style="text-align: center"><input type="checkbox" name="answerIsCorrect" /></td>
                                    <td><input type="number" name="answerOrder" value="1" min="1" required /></td>
                                    <td><button type="button" class="remove-btn" onclick="removeRow(this)">X</button></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <button type="button" onclick="addAnswerRow()">+ Add Answer</button>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" style="text-align: center;">
                        <input type="submit" value="Save"/>
                    </td>
                </tr>
            </table>
        </form>

        <a href="QuestionController">← Back to Question List</a>

    </body>
</html>

