<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="container">
        <!-- Logo/Brand -->
        <c:choose>
            <c:when test="${sessionScope.role == 'Admin'}">
                <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fas fa-graduation-cap me-2" style="font-size: 1.5rem;"></i>
                    <span style="font-weight: 700; font-size: 1.3rem;">Quizora</span>
                </a>
            </c:when>
            <c:when test="${sessionScope.role == 'Student'}">
                <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/student/home">
                    <i class="fas fa-graduation-cap me-2" style="font-size: 1.5rem;"></i>
                    <span style="font-weight: 700; font-size: 1.3rem;">Quizora</span>
                </a>
            </c:when>
            <c:otherwise>
                <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}./home.jsp">
                    <i class="fas fa-graduation-cap me-2" style="font-size: 1.5rem;"></i>
                    <span style="font-weight: 700; font-size: 1.3rem;">Quizora</span>
                </a>
            </c:otherwise>
        </c:choose>
        
        <!-- Mobile Toggle Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Main Navigation -->
            <ul class="navbar-nav me-auto">
                <c:if test="${sessionScope.accountId != null}">
                    <c:choose>
                        <c:when test="${sessionScope.role == 'Admin'}">
                            <!-- Admin Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                                    <i class="fas fa-users me-1"></i>User Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/subjects">
                                    <i class="fas fa-book me-1"></i>Subject Management
                                </a>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                                    <i class="fas fa-chart-bar me-1"></i>Reports
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/feedback">
                                    <i class="fas fa-comment-dots me-1"></i>Feedback
                                </a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.role == 'Teacher'}">
                            <!-- Teacher Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/dashboard">
                                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/quizzes">
                                    <i class="fas fa-question-circle me-1"></i>My Quizzes
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/quiz?action=new">
                                    <i class="fas fa-plus me-1"></i>Create Quiz
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/classes">
                                    <i class="fas fa-chalkboard-teacher me-1"></i>My Classes
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/results">
                                    <i class="fas fa-chart-line me-1"></i>Results
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/feedback">
                                    <i class="fas fa-comment-dots me-1"></i>Feedback
                                </a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.role == 'Student'}">
                            <!-- Student Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard">
                                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/quizzes">
                                    <i class="fas fa-question-circle me-1"></i>Available Quizzes
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/history">
                                    <i class="fas fa-history me-1"></i>Quiz History
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/favorite-quizzes">
                                    <i class="fas fa-heart me-1"></i>Favorite Quizzes
                                </a>
                            </li>
                        </c:when>
                    </c:choose>
                    
                    <!-- Common Menu Items for all users -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/lessons">
                            <i class="fas fa-book-open me-1"></i>Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/student/practice">
                            <i class="fas fa-dumbbell me-1"></i>Practice
                        </a>
                    </li>
                </c:if>
            </ul>
            
            <!-- User Menu -->
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${sessionScope.accountId != null}">
                        <!-- User Avatar and Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" 
                               id="navbarDropdown" role="button" 
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="d-flex align-items-center">
                                    <c:choose>
                                        <c:when test="${sessionScope.avatarUrl != null and sessionScope.avatarUrl != ''}">
                                            <img src="${sessionScope.avatarUrl}" 
                                                 alt="Avatar" 
                                                 class="rounded-circle me-2" 
                                                 style="width: 32px; height: 32px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="avatarName" value="${sessionScope.firstName != null ? sessionScope.firstName : 'User'}" />
                                            <c:set var="avatarLastName" value="${sessionScope.lastName != null ? sessionScope.lastName : 'Name'}" />
                                            <img src="https://ui-avatars.com/api/?name=${avatarName}+${avatarLastName}&background=random&size=32" 
                                                 alt="Avatar" 
                                                 class="rounded-circle me-2" 
                                                 style="width: 32px; height: 32px; object-fit: cover;">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="d-none d-md-block text-start">
                                        <c:choose>
                                            <c:when test="${sessionScope.firstName != null}">
                                                <div style="font-size: 0.9rem; font-weight: 500;">
                                                    ${sessionScope.firstName}
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="font-size: 0.9rem; font-weight: 500;">
                                                    ${sessionScope.email}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div style="font-size: 0.75rem; opacity: 0.8;">
                                            ${sessionScope.role}
                                        </div>
                                    </div>
                                </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg" aria-labelledby="navbarDropdown" 
                                style="min-width: 200px; border: none; border-radius: 10px;">
                                <li>
                                    <div class="dropdown-header px-3 py-2">
                                        <c:choose>
                                            <c:when test="${sessionScope.firstName != null and sessionScope.lastName != null}">
                                                <div class="fw-bold">${sessionScope.firstName} ${sessionScope.lastName}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="fw-bold">${sessionScope.email}</div>
                                            </c:otherwise>
                                        </c:choose>
                                        <small class="text-muted">${sessionScope.role}</small>
                                    </div>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                        <i class="fas fa-user me-2 text-primary"></i>Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/settings">
                                        <i class="fas fa-cog me-2 text-secondary"></i>Settings
                                    </a>
                                </li>
                                
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- Login/Register buttons for non-authenticated users -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm ms-2" href="${pageContext.request.contextPath}/register">
                                <i class="fas fa-user-plus me-1"></i>Register
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</header>

<!-- Message Alert -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert alert-success alert-dismissible fade show m-3 shadow-sm" role="alert" 
         style="border: none; border-radius: 10px;">
        <i class="fas fa-check-circle me-2"></i>
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
</c:if>

<!-- Error Alert -->
<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show m-3 shadow-sm" role="alert" 
         style="border: none; border-radius: 10px;">
        <i class="fas fa-exclamation-triangle me-2"></i>
        ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("error"); %>
</c:if>

<!-- Warning Alert -->
<c:if test="${not empty sessionScope.warning}">
    <div class="alert alert-warning alert-dismissible fade show m-3 shadow-sm" role="alert" 
         style="border: none; border-radius: 10px;">
        <i class="fas fa-exclamation-circle me-2"></i>
        ${sessionScope.warning}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("warning"); %>
</c:if>

<!-- Info Alert -->
<c:if test="${not empty sessionScope.info}">
    <div class="alert alert-info alert-dismissible fade show m-3 shadow-sm" role="alert" 
         style="border: none; border-radius: 10px;">
        <i class="fas fa-info-circle me-2"></i>
        ${sessionScope.info}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("info"); %>
</c:if>

<style>
/* Custom styles for header */
.navbar-brand:hover {
    transform: scale(1.05);
    transition: transform 0.2s ease;
}

.nav-link {
    position: relative;
    transition: all 0.3s ease;
}

.nav-link:hover {
    transform: translateY(-1px);
}

.nav-link::after {
    content: '';
    position: absolute;
    width: 0;
    height: 2px;
    bottom: 0;
    left: 50%;
    background-color: #fff;
    transition: all 0.3s ease;
    transform: translateX(-50%);
}

.nav-link:hover::after {
    width: 100%;
}

.dropdown-menu {
    animation: fadeInDown 0.3s ease;
}

@keyframes fadeInDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.dropdown-item {
    transition: all 0.2s ease;
}

.dropdown-item:hover {
    background-color: #f8f9fa;
    transform: translateX(5px);
}

.alert {
    animation: slideInDown 0.5s ease;
}

@keyframes slideInDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .navbar-brand span {
        font-size: 1.1rem !important;
    }
    
    .dropdown-menu {
        margin-top: 0.5rem;
    }
}
</style> 