<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .navbar-custom {
                background-color: #e0e0e0;
            }
            .nav-link.active {
                border-bottom: 3px solid orange;
            }
            .btn-signin {
                border: 1px solid black;
                background-color: white;
                color: black;
                margin-right: 5px;
            }
            .btn-register {
                background-color: black;
                color: white;
            }
            /* Dropdown ngang cho categories */
            .dropdown-menu.categories-dropdown {
                min-width: 300px;
                padding: 0.5rem 1rem;

                white-space: normal; /* cho phép xu?ng dòng */

                flex-wrap: wrap;
                gap: 10px 15px;
            }

            .dropdown-menu.categories-dropdown .dropdown-item {
                flex: 0 0 30%;
                min-width: 80px;
                white-space: nowrap;
                text-align: center;
            }

        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-custom px-4">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">Quizora</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Nav menu trái -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'home' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/home">HOME</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle ${activePage == 'categories' ? 'active' : ''}" href="#" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            CATEGORIES
                        </a>
                        <ul class="dropdown-menu categories-dropdown">
                            <c:forEach var="cat" items="${categories}">
                                <li>
                                    <a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/subjects?cat=${cat.id}">
                                        ${cat.name}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'subjects' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/all-subjects">SUBJECTS</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'packages' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/packages">PACKAGES</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'quizzes' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/quizzes">QUIZZES</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'practice' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/practice">PRACTICE</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'boards' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/boards">BOARDS</a>
                    </li>
                </ul>
                <!-- ??ng nh?p/Avatar: Ch? hi?n Sign in/Register -->
                <ul class="navbar-nav mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="btn btn-sm btn-signin" href="${pageContext.request.contextPath}/login">Sign in</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-sm btn-register" href="${pageContext.request.contextPath}/register">Register</a>
                    </li>
                </ul>
            </div>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
