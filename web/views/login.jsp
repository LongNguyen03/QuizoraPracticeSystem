<%-- 
    Document   : login.jsp
    Created on : Jun 6, 2025, 1:07:55 PM
    Author     : dangd
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 450px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h1 {
            color: #333;
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .login-header p {
            color: #666;
            font-size: 1rem;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            border-color: #667eea;
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 12px;
            color: white;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .social-login {
            margin-top: 20px;
            text-align: center;
        }
        .social-login p {
            color: #666;
            margin-bottom: 15px;
        }
        .social-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .social-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .social-btn:hover {
            transform: translateY(-2px);
        }
        .google-btn {
            background: #DB4437;
        }
        .facebook-btn {
            background: #4267B2;
        }
        .github-btn {
            background: #333;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Welcome Back!</h1>
            <p>Please login to your account</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success" role="alert">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
            <div class="form-group">
                <input type="email" class="form-control" id="email" name="email" 
                       placeholder="Email address" required>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="Password" required>
            </div>
            <div class="form-group form-check">
                <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                <label class="form-check-label" for="rememberMe">Remember me</label>
            </div>
            <button type="submit" class="btn btn-login">Login</button>
        </form>

        <div class="social-login">
            <p>Or login with</p>
            <div class="social-buttons">
                <a href="#" class="social-btn google-btn">
                    <i class="fab fa-google"></i>
                </a>
                <a href="#" class="social-btn facebook-btn">
                    <i class="fab fa-facebook-f"></i>
                </a>
                <a href="#" class="social-btn github-btn">
                    <i class="fab fa-github"></i>
                </a>
            </div>
        </div>

        <div class="register-link">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
