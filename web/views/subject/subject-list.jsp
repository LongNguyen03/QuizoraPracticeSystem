<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Subject" %>
<%@ page import="Model.SubjectCategory" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Subjects - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .subject-card { transition: transform 0.2s, box-shadow 0.2s; }
        .subject-card:hover { transform: translateY(-3px); box-shadow: 0 4px 10px rgba(0,0,0,0.1);}
        .sidebar-card { border: none; box-shadow: 0 1px 8px rgba(0,0,0,0.03);}
        .card-img-top { border-radius: 12px 12px 0 0; object-fit: cover; height: 180px;}
        .pagination .page-link { border-radius: 6px;}
    </style>
</head>
<body>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container-fluid py-4">
    <div class="row">
        <!-- Sidebar Filter -->
        <aside class="col-lg-3 mb-4">
            <div class="card sidebar-card p-3">
                <h6 class="mb-3">Filter</h6>
                <form method="get" action="${pageContext.request.contextPath}/all-subjects">
                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="categoryId">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" <c:if test="${param.categoryId == cat.id}">selected</c:if>>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="subject" class="form-label">Subject</label>
                        <select class="form-select" id="subject" name="subjectId">
                            <option value="">All Subjects</option>
                            <c:forEach var="sub" items="${allSubjects}">
                                <option value="${sub.id}" <c:if test="${param.subjectId == sub.id}">selected</c:if>>${sub.title}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <button class="btn btn-primary btn-sm w-100" type="submit">Apply</button>
                </form>
            </div>
        </aside>
        <!-- Main content: List and Filter Info -->
        <main class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">All Subjects</h4>
                <div>
                    <c:if test="${not empty param.categoryId}">
                        <span class="badge bg-info text-dark me-1">
                            Category: 
                            <c:forEach var="cat" items="${categories}">
                                <c:if test="${cat.id == param.categoryId}">${cat.name}</c:if>
                            </c:forEach>
                        </span>
                    </c:if>
                    <c:if test="${not empty param.subjectId}">
                        <span class="badge bg-success text-white me-1">
                            Subject: 
                            <c:forEach var="sub" items="${allSubjects}">
                                <c:if test="${sub.id == param.subjectId}">${sub.title}</c:if>
                            </c:forEach>
                        </span>
                    </c:if>
                </div>
            </div>
            <!-- Grid of cards -->
            <div class="row g-4">
                <c:forEach var="s" items="${subjects}">
                    <div class="col-md-4 col-sm-6">
                        <div class="card subject-card h-100">
                            <img src="${empty s.thumbnailUrl ? 'https://via.placeholder.com/350x150?text=No+Image' : s.thumbnailUrl}"
                                 class="card-img-top" alt="${s.title}">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${s.title}</h5>
                                <p class="text-muted small mb-2">Category: ${s.categoryName}</p>
                                <p class="card-text mb-4">${s.tagline}</p>
                                <a href="${pageContext.request.contextPath}/subject-detail?id=${s.id}" class="btn btn-primary mt-auto">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty subjects}">
                    <div class="col-12">
                        <p class="text-muted">No subjects found.</p>
                    </div>
                </c:if>
            </div>
            <!-- Pagination -->
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link"
                               href="?page=${currentPage-1}&categoryId=${param.categoryId}&subjectId=${param.subjectId}">&laquo; Previous</a>
                        </li>
                    </c:if>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&categoryId=${param.categoryId}&subjectId=${param.subjectId}">${i}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link"
                               href="?page=${currentPage+1}&categoryId=${param.categoryId}&subjectId=${param.subjectId}">Next &raquo;</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
