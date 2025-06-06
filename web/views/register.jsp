<%--
    Document   : register.jsp
    Created on : Jun 6, 2025
    Author     : dangd
    (Đã bổ sung validation và thông báo lỗi)
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 550px;
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header h1 {
            color: #333;
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .register-header p {
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
        .btn-register {
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
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .role-select {
            margin-bottom: 20px;
        }
        .role-select label {
            display: block;
            margin-bottom: 10px;
            color: #333;
            font-weight: 500;
        }
        .role-options {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        .role-option {
            flex: 1;
            text-align: center;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .role-option:hover {
            border-color: #667eea;
        }
        .role-option.selected {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.1);
        }
        .role-option i {
            font-size: 24px;
            margin-bottom: 10px;
            color: #667eea;
        }
        .role-option p {
            margin: 0;
            color: #666;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .password-requirements {
            font-size: 0.85rem;
            color: #666;
            margin-top: -15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join Quizora to start your learning journey</p>
        </div>

        <%-- Nếu Servlet/Controller đẩy lên attribute "error", hiển thị lỗi server-side --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register"
              method="POST"
              id="registerForm"
              novalidate>
            <div class="form-group">
                <input type="email"
                       class="form-control"
                       id="email"
                       name="email"
                       placeholder="Email address"
                       required>
            </div>
            
            <div class="form-group">
                <input type="text"
                       class="form-control"
                       id="firstName"
                       name="firstName"
                       placeholder="First Name"
                       required>
            </div>
            
            <div class="form-group">
                <input type="text"
                       class="form-control"
                       id="middleName"
                       name="middleName"
                       placeholder="Middle Name">
            </div>
            
            <div class="form-group">
                <input type="text"
                       class="form-control"
                       id="lastName"
                       name="lastName"
                       placeholder="Last Name"
                       required>
            </div>
            
            <div class="form-group">
                <select class="form-control"
                        id="gender"
                        name="gender"
                        required>
                    <option value="">Select Gender</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                    <option value="other">Other</option>
                </select>
            </div>
            
            <div class="form-group">
                <input type="password"
                       class="form-control"
                       id="password"
                       name="password"
                       placeholder="Password"
                       required>
                <div class="password-requirements">
                    Password must be at least 8 characters long and include uppercase, lowercase, number and special character
                </div>
            </div>
            
            <div class="form-group">
                <input type="password"
                       class="form-control"
                       id="confirmPassword"
                       name="confirmPassword"
                       placeholder="Confirm password"
                       required>
            </div>

            <div class="role-select">
                <label>I want to join as:</label>
                <div class="role-options">
                    <div class="role-option selected" data-role="student">
                        <i class="fas fa-user-graduate"></i>
                        <p>Student</p>
                    </div>
                    <div class="role-option" data-role="teacher">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <p>Teacher</p>
                    </div>
                </div>
                <input type="hidden" name="role" id="selectedRole" value="student">
            </div>

            <div class="form-group form-check">
                <input type="checkbox"
                       class="form-check-input"
                       id="terms"
                       name="terms"
                       required>
                <label class="form-check-label" for="terms">
                    I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
                </label>
            </div>

            <button type="submit" class="btn btn-register">Create Account</button>
        </form>

        <div class="login-link">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Regex dùng kiểm tra định dạng email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        // Xử lý chọn role (student/teacher)
        document.querySelectorAll('.role-option').forEach(option => {
            option.addEventListener('click', function () {
                document.querySelectorAll('.role-option')
                        .forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');
                document.getElementById('selectedRole').value = this.dataset.role;
            });
        });

        // Hàm hiển thị alert-danger chung
        function showError(message) {
            const existingError = document.querySelector('.alert-danger');
            if (existingError) {
                existingError.remove();
            }
            const errorMessage = document.createElement('div');
            errorMessage.className = 'alert alert-danger alert-dismissible fade show';
            errorMessage.innerHTML = `
                <i class="fas fa-exclamation-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;
            const formElement = document.getElementById('registerForm');
            formElement.parentNode.insertBefore(errorMessage, formElement);
        }

        // Xử lý submit form
        document.getElementById('registerForm').addEventListener('submit', function (e) {
            e.preventDefault();
            const form = this;

            // 1. Kiểm tra validity toàn bộ form (required, type, v.v.)
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            // 2. Lấy giá trị để kiểm tra bổ sung (custom)
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');

            const email = emailInput.value.trim();
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            // Kiểm tra định dạng email
            if (!emailRegex.test(email)) {
                emailInput.setCustomValidity('Email không đúng định dạng. Vui lòng nhập email hợp lệ.');
                emailInput.reportValidity();
                return;
            } else {
                emailInput.setCustomValidity('');
            }

            // Kiểm tra confirm password
            if (password !== confirmPassword) {
                confirmPasswordInput.setCustomValidity('Mật khẩu xác nhận không khớp.');
                confirmPasswordInput.reportValidity();
                return;
            } else {
                confirmPasswordInput.setCustomValidity('');
            }

            // 3. Nếu qua hết validation, submit bằng fetch
            const formData = new FormData(form);
            const data = {};
            formData.forEach((value, key) => data[key] = value);

            fetch('${pageContext.request.contextPath}/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(resData => {
                if (resData.success) {
                    // Reset form và thông báo thành công
                    form.reset();
                    // Reset role selection về student
                    document.querySelectorAll('.role-option').forEach(opt => opt.classList.remove('selected'));
                    document.querySelector('.role-option[data-role="student"]').classList.add('selected');
                    document.getElementById('selectedRole').value = 'student';

                    const successMessage = document.createElement('div');
                    successMessage.className = 'alert alert-success alert-dismissible fade show';
                    successMessage.innerHTML = `
                        <i class="fas fa-check-circle me-2"></i>
                        ${resData.message || 'Đăng ký thành công!'}
                        <div class="mt-2">
                            Chuyển hướng đến trang đăng nhập sau <span id="countdown">2</span> giây...
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    `;
                    form.parentNode.insertBefore(successMessage, form);

                    // Countdown 2 giây rồi chuyển hướng
                    let count = 2;
                    const countdownElement = document.getElementById('countdown');
                    const interval = setInterval(() => {
                        count--;
                        countdownElement.textContent = count;
                        if (count <= 0) {
                            clearInterval(interval);
                            window.location.href = resData.redirectUrl || '${pageContext.request.contextPath}/login';
                        }
                    }, 1000);
                } else {
                    showError(resData.message || 'Đăng ký thất bại. Vui lòng thử lại.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showError('Có lỗi xảy ra. Vui lòng thử lại sau.');
            });
        });

        // Validation real-time cho password
        document.getElementById('password').addEventListener('input', function () {
            const pwd = this.value;
            const hasUpperCase = /[A-Z]/.test(pwd);
            const hasLowerCase = /[a-z]/.test(pwd);
            const hasNumber = /\d/.test(pwd);
            const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(pwd);
            const isLongEnough = pwd.length >= 8;

            if (!hasUpperCase || !hasLowerCase || !hasNumber || !hasSpecialChar || !isLongEnough) {
                this.setCustomValidity('Mật khẩu phải ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
