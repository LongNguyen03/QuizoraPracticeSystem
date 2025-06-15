<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .navbar-custom {
                background: white;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .navbar-brand {
                color: #667eea !important;
                font-weight: 700;
            }
            .nav-link {
                color: #333 !important;
                font-weight: 500;
                margin: 0 10px;
                transition: all 0.3s ease;
            }
            .nav-link:hover {
                color: #667eea !important;
            }
            .nav-link.active {
                color: #667eea !important;
                border-bottom: 3px solid #667eea;
            }
            .btn-signin {
                border: 2px solid #667eea;
                background-color: white;
                color: #667eea;
                margin-right: 10px;
                padding: 8px 20px;
                border-radius: 30px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .btn-signin:hover {
                background-color: #667eea;
                color: white;
            }
            .btn-register {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 8px 20px;
                border-radius: 30px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }
            .dropdown-menu.categories-dropdown {
                min-width: 300px;
                padding: 1rem;
                border: none;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                border-radius: 15px;
            }
            .dropdown-menu.categories-dropdown .dropdown-item {
                padding: 8px 15px;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .dropdown-menu.categories-dropdown .dropdown-item:hover {
                background-color: #f8f9fa;
                color: #667eea;
            }
            .user-dropdown .dropdown-toggle::after {
                display: none;
            }
            .user-dropdown .dropdown-item {
                padding: 0.5rem 1rem;
            }
            .user-dropdown .dropdown-item:hover {
                background-color: #f8f9fa;
            }
            .user-dropdown .dropdown-item.text-danger:hover {
                background-color: #dc3545;
                color: white !important;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-custom fixed-top">
            <div class="container">
                <!-- Logo with role-based redirect -->
                <c:choose>
                    <c:when test="${sessionScope.role == 'Admin'}">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Quizora</a>
                    </c:when>
                    <c:when test="${sessionScope.role == 'Teacher'}">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/teacher/home.jsp">Quizora</a>
                    </c:when>
                    <c:when test="${sessionScope.role == 'Student'}">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/student/home.jsp">Quizora</a>
                    </c:when>
                    <c:otherwise>
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">Quizora</a>
                    </c:otherwise>
                </c:choose>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
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
                    <ul class="navbar-nav mb-2 mb-lg-0">
                        <c:choose>
                            <c:when test="${sessionScope.accountId != null}">
                                <li class="nav-item dropdown user-dropdown">
                                    <button class="btn btn-link text-dark text-decoration-none dropdown-toggle d-flex align-items-center" 
                                            type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png" 
                                             alt="Avatar" class="rounded-circle me-2" style="width: 32px; height: 32px;">
                                        <span>${sessionScope.email}</span>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                            <i class="fas fa-user me-2"></i>Profile
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <form action="${pageContext.request.contextPath}/logout" method="POST" class="dropdown-item p-0">
                                                <button type="submit" class="dropdown-item text-danger">
                                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                                                </button>
                                            </form>
                                        </li>
                                    </ul>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item">
                                    <a class="btn btn-signin" href="${pageContext.request.contextPath}/login">Sign in</a>
                                </li>
                                <li class="nav-item">
                                    <a class="btn btn-register" href="${pageContext.request.contextPath}/register">Register</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
