<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="home">Quizora</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <c:if test="${sessionScope.account != null}">
                    <c:choose>
                        <c:when test="${sessionScope.account.roleId == 1}">
                            <!-- Admin Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="admin/dashboard">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="admin/users">User Management</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="admin/subjects">Subject Management</a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.account.roleId == 2}">
                            <!-- Teacher Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="teacher/dashboard">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="teacher/quizzes">My Quizzes</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="teacher/classes">My Classes</a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.account.roleId == 3}">
                            <!-- Student Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="student/dashboard">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="student/quizzes">Available Quizzes</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="student/history">Quiz History</a>
                            </li>
                        </c:when>
                    </c:choose>
                </c:if>
            </ul>
            
            <ul class="navbar-nav">
                <c:if test="${sessionScope.account != null}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" 
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i>${sessionScope.account.email}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="profile"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="change-password"><i class="fas fa-key me-2"></i>Change Password</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</header>

<!-- Message Alert -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert alert-success alert-dismissible fade show m-3" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
</c:if>

<!-- Error Alert -->
<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show m-3" role="alert">
        ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("error"); %>
</c:if> 