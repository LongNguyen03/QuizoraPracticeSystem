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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <style>
        /* Hero Banner */
        :root {
            --hero-bg: #eafdff;
            --hero-title: #222;
            --hero-highlight: #222;
            --hero-desc: #888;
            --hero-btn-practice: #17a2b8;
            --hero-btn-test: #6c757d;
        }
        .hero-banner {
            background: var(--hero-bg);
            padding: 60px 0 40px 0;
        }
        .hero-banner__row {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 32px;
        }
        .hero-banner__content {
            flex: 1 1 350px;
            min-width: 280px;
        }
        .hero-banner__image {
            flex: 1 1 320px;
            min-width: 220px;
            text-align: center;
        }
        .hero-banner__image img {
            max-width: 100%;
            height: auto;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
        }
        .hero-banner__title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--hero-title);
            margin-bottom: 0.5rem;
        }
        .hero-banner__subtitle {
            font-size: 1.1rem;
            color: #444;
            margin-bottom: 0.25rem;
        }
        .hero-banner__highlight {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--hero-highlight);
            margin-bottom: 1rem;
        }
        .hero-banner__desc {
            color: var(--hero-desc);
            font-size: 1rem;
            margin-bottom: 1.5rem;
        }
        .hero-banner__actions {
            display: flex;
            gap: 18px;
            margin-bottom: 1rem;
        }
        .hero-banner__btn {
            border-radius: 20px;
            font-weight: 600;
            padding: 0.7rem 2.2rem;
            font-size: 1.05rem;
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(23,162,184,0.07);
        }
        .hero-banner__btn--practice {
            background: var(--hero-btn-practice);
            color: #fff;
            border: none;
        }
        .hero-banner__btn--practice:hover {
            background: #138496;
            color: #fff;
        }
        .hero-banner__btn--test {
            background: var(--hero-btn-test);
            color: #fff;
            border: none;
        }
        .hero-banner__btn--test:hover {
            background: #495057;
            color: #fff;
        }
        @media (max-width: 991.98px) {
            .hero-banner__row { flex-direction: column; gap: 24px;}
            .hero-banner__content, .hero-banner__image { min-width: 0;}
            .hero-banner__title { font-size: 2rem;}
            .hero-banner__highlight { font-size: 1.2rem;}
        }
        /* Card hiệu ứng */
        .category-card, .subject-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .category-card:hover, .subject-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .category-icon {
            font-size: 2.5rem;
            color: #17a2b8;
        }
        .card-img-top {
            border-radius: 12px 12px 0 0;
            object-fit: cover;
            height: 180px;
        }
    </style>
</head>
<body>

    <!-- Header (Navbar) -->
    <jsp:include page="/views/layout/header.jsp"/>

    <!-- Hero / Banner -->
    <section class="hero-banner mb-5">
        <div class="container">
            <div class="hero-banner__row">
                <div class="hero-banner__content">
                    <h2 class="hero-banner__title">Welcome to Quizora</h2>
                    <div class="hero-banner__subtitle">One destination for</div>
                    <div class="hero-banner__highlight">Practice and study</div>
                    <div class="hero-banner__desc">Learn • Practice • Improve • Take Exam • Succeed</div>
                    <div class="hero-banner__actions">
                        <a href="${pageContext.request.contextPath}/practice" class="hero-banner__btn hero-banner__btn--practice">Practice</a>
                        <a href="${pageContext.request.contextPath}/quizzes" class="hero-banner__btn hero-banner__btn--test">Test</a>
                    </div>
                </div>
                <div class="hero-banner__image">
                    <img src="https://pplx-res.cloudinary.com/image/private/user_uploads/33222200/9706de0d-c372-4de7-989c-aef0aa39a14f/image.jpg"
                         alt="Quizora illustration">
                </div>
            </div>
            <!-- Search form -->
            <form action="${pageContext.request.contextPath}/search" method="get" class="d-flex justify-content-center mt-4">
                <input type="text" name="q" class="form-control w-50" placeholder="Search subjects, quizzes..." />
                <button class="btn btn-primary ms-2" type="submit"><i class="bi bi-search"></i> Search</button>
            </form>
        </div>
    </section>

    <div class="container">

        <!-- Browse by Category (4 mục đầu, nút View All) -->
        <section class="browse-categories mb-5">
            <h3 class="mb-4">Browse by Category</h3>
            <div class="row">
                <c:forEach var="cat" items="${categories}" varStatus="loop">
                    <c:if test="${loop.index < 4}">
                        <div class="col-md-3 col-sm-6 mb-4">
                            <div class="card category-card text-center shadow-sm p-3 h-100">
                                <div class="category-icon mb-2"><i class="bi bi-bookmark-fill"></i></div>
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
            </div>
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline-primary">
                    View All Categories
                </a>
            </div>
        </section>

        <!-- Latest Subjects (3 subject mới nhất, nút View All) -->
        <section class="latest-subjects mb-5">
            <h3 class="mb-4">Latest Subjects</h3>
            <div class="row">
                <%
                    List<Subject> subjects = (List<Subject>) request.getAttribute("latestSubjects");
                    int count = 0;
                    if (subjects != null) {
                        for (Subject s : subjects) {
                            if (count >= 3) break;
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
                            count++;
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
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/all-subjects" class="btn btn-outline-primary">
                    View All Subjects
                </a>
            </div>
        </section>

        <!-- (Có thể thêm các phần khác như Featured Packages, Recent Quizzes, Testimonials nếu cần) -->

    </div> <!-- end .container -->

    <!-- Footer (nếu có) -->
    <%-- <jsp:include page="/views/layout/footer.jsp"/> --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
