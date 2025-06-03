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

        /* =======================================================
           Dropdown ngang (override Bootstrap)
           ======================================================= */

        /* Ban ??u ?n (display: none); s? chuy?n sang flex khi có class .show */
        .dropdown-menu-horizontal {
            display: none;                     /* ?n m?c ??nh */
            position: absolute !important;     /* N?i lên, không chi?m không gian d?c */
            width: auto !important;            /* R?ng v?a ?? n?i dung */
            flex-wrap: wrap;                   /* Cho phép wrap xu?ng dòng */
            gap: 10px 15px;                    /* Kho?ng cách ngang/d?c gi?a m?c */
            padding: 0.5rem 1rem;              /* Padding bên trong dropdown */
            white-space: normal;               /* Text trong item không c? g?ng xu?ng dòng */
            /* Lo?i b? m?i min-width m?c ??nh c?a Bootstrap */
            min-width: 0 !important;
        }

        /* Khi dropdown ???c m? (Bootstrap thêm class .show), ta cho hi?n th? flex */
        .dropdown-menu-horizontal.show {
            display: flex !important;
        }

        /* M?i m?c chi?m kho?ng 9% chi?u ngang, t?i thi?u 80px */
        .dropdown-menu-horizontal .dropdown-item {
            flex: 0 0 9%;       /* Kho?ng 10 m?c trên 1 dòng (9% * 10 ? 90%) */
            min-width: 80px;    /* ??m b?o item không quá nh? khi màn hình co h?p */
            white-space: nowrap;/* Không cho text t? xu?ng dòng trong 1 item */
            text-align: center;
        }
        /* ======================================================= */
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
        <!-- Ph?n nav chính bên trái -->
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <!-- HOME -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/home">HOME</a>
            </li>

            <!-- CATEGORIES (Dropdown) -->
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button"
                   data-bs-toggle="dropdown" aria-expanded="false">
                    CATEGORIES
                </a>
                <ul class="dropdown-menu dropdown-menu-horizontal">
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

            <!-- SUBJECTS -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/all-subjects">SUBJECTS</a>
            </li>

            <!-- PACKAGES -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/packages">PACKAGES</a>
            </li>

            <!-- QUIZZES -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/quizzes">QUIZZES</a>
            </li>

            <!-- PRACTICE -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/practice">PRACTICE</a>
            </li>

            <!-- BOARDS -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/boards">BOARDS</a>
            </li>
        </ul>

        <!-- Ph?n ??ng nh?p/??ng ký ho?c avatar user khi ?ã login -->
        <ul class="navbar-nav mb-2 mb-lg-0">
            <c:choose>
                <c:when test="${empty sessionScope.account}">
                    <li class="nav-item">
                        <a class="btn btn-sm btn-signin" href="${pageContext.request.contextPath}/login">Sign in</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-sm btn-register" href="${pageContext.request.contextPath}/register">Register</a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="${sessionScope.account.avatarUrl}" class="rounded-circle me-1" width="30" height="30"/>
                            <span>${sessionScope.account.firstName}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/settings">Settings</a></li>
                            <li><hr class="dropdown-divider"/></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
