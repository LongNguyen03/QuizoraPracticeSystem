<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container-fluid">
        <!-- Logo -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <c:choose>
                <c:when test="${sessionScope.role == 'Admin'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Quizora" height="40">
                    </a>
                </c:when>
                <c:when test="${sessionScope.role == 'Teacher'}">
                    <a href="${pageContext.request.contextPath}/teacher/home.jsp">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Quizora" height="40">
                    </a>
                   
                </c:when>
                <c:when test="${sessionScope.role == 'Student'}">
                    <a href="${pageContext.request.contextPath}/student/home.jsp">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Quizora" height="40">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/views/home.jsp">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Quizora" height="40">
                    </a>
                </c:otherwise>
            </c:choose>
        </a>

        <!-- User Info & Logout -->
        <div class="d-flex align-items-center">
            <c:if test="${sessionScope.accountId != null}">
                <div class="dropdown">
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
                </div>
            </c:if>
        </div>
    </div>
</header>

<style>
.navbar {
    padding: 0.5rem 1rem;
}

.dropdown-toggle::after {
    display: none;
}

.dropdown-item {
    padding: 0.5rem 1rem;
}

.dropdown-item:hover {
    background-color: #f8f9fa;
}

.dropdown-item.text-danger:hover {
    background-color: #dc3545;
    color: white !important;
}

.btn-link {
    padding: 0.5rem;
}

.btn-link:hover {
    background-color: #f8f9fa;
    border-radius: 0.375rem;
}
</style> 