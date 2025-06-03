<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Subject" %>
<%@ page import="Model.SubjectCategory" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Home - Quizora</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* Một số style nhỏ để làm đẹp */
        .category-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .category-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .subject-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .subject-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .hero-banner {
            background: url('https://via.placeholder.com/1200x300?text=Learn+with+Quizora') center/cover no-repeat;
            color: #ffffff;
            padding: 80px 0;
        }
        .hero-banner h1 {
            font-size: 3rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        .hero-banner p {
            font-size: 1.2rem;
        }
    </style>
</head>
<body>

    <!-- Header (Navbar) -->
    <jsp:include page="/views/layout/header.jsp"/>

    <!-- Hero / Banner -->
    <section class="hero-banner text-center mb-5">
        <div class="container">
            <h1 class="mb-3">Welcome to Quizora</h1>
            <p class="mb-4">Find your next course, practice quizzes, and master your skills.</p>
            <form action="${pageContext.request.contextPath}/search" method="get" class="d-flex justify-content-center">
                <input type="text" name="q" class="form-control w-50" placeholder="Search subjects, quizzes..." />
                <button class="btn btn-primary ms-2" type="submit">Search</button>
            </form>
        </div>
    </section>

    <div class="container">

        <!-- Browse by Category (chỉ hiển thị 4 mục, kèm nút View All) -->
        <section class="browse-categories mb-5">
            <h3 class="mb-4">Browse by Category</h3>
            <div class="row">
                <c:forEach var="cat" items="${categories}" varStatus="loop">
                    <c:if test="${loop.index < 4}">
                        <div class="col-md-3 col-sm-6 mb-4">
                            <div class="card category-card text-center shadow-sm p-3 h-100">
                                <i class="bi bi-bookmark-fill fa-2x mb-2"></i>
                                <h5 class="card-title mt-2">
                                    <a href="${pageContext.request.contextPath}/subjects?cat=${cat.id}" 
                                       class="text-decoration-none text-dark">
                                        ${cat.name}
                                    </a>
                                </h5>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <!-- Nút View All nằm ở hàng kế tiếp (col full) -->
            </div>
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline-primary">
                    View All Categories
                </a>
            </div>
        </section>

        <!-- Latest Subjects -->
        <section class="latest-subjects mb-5">
            <h3 class="mb-4">Latest Subjects</h3>
            <div class="row">
                <%
                    List<Subject> subjects = (List<Subject>) request.getAttribute("latestSubjects");
                    if (subjects != null) {
                        for (Subject s : subjects) {
                %>
                    <div class="col-md-4 col-sm-6 mb-4">
                        <div class="card subject-card h-100 shadow-sm">
                            <%
                                String thumb = s.getThumbnailUrl();
                                if (thumb == null || thumb.isEmpty()) {
                                    thumb = "https://via.placeholder.com/350x150?text=No+Image";
                                }
                            %>
                            <img src="<%= thumb %>" class="card-img-top" alt="Thumbnail for <%= s.getTitle() %>" />
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%= s.getTitle() %></h5>
                                <p class="text-muted small mb-2">Category: <%= s.getCategoryName() %></p>
                                <p class="card-text mb-4"><%= s.getTagline() %></p>
                                <a href="<%= request.getContextPath() %>/subject-detail?id=<%= s.getId() %>" 
                                   class="btn btn-primary mt-auto">View Details</a>
                            </div>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="col-12">
                        <p class="text-muted">No subjects found.</p>
                    </div>
                <%
                    }
                %>
            </div>
        </section>

        <!-- (Nếu cần thêm các phần khác như Featured Packages, Recent Quizzes, Testimonials) -->
        <%-- 
        <section class="featured-packages mb-5">
            ...
        </section>

        <section class="recent-quizzes mb-5">
            ...
        </section>

        <section class="testimonials mb-5">
            ...
        </section>
        --%>

    </div> <!-- end .container -->

    <!-- Footer (nếu bạn có) -->
    <%-- <jsp:include page="/views/layout/footer.jsp"/> --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Nếu bạn dùng Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
</body>
</html>
