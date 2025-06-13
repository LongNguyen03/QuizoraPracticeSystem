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
        
        <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success" role="alert">
                <%= session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
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
                <a href="#" class="float-end" id="forgotPasswordLink">Quên mật khẩu?</a>
            </div>
            <button type="submit" class="btn btn-login">Login</button>
        </form>

        <!-- Modal Forgot Password -->
        <div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-labelledby="forgotPasswordModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="forgotPasswordModalLabel">Quên mật khẩu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="forgotPasswordForm">
                            <div class="mb-3">
                                <label for="resetEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="resetEmail" required>
                            </div>
                            <div id="otpSection" style="display: none;">
                                <div class="mb-3">
                                    <label for="resetOTP" class="form-label">Mã xác thực</label>
                                    <input type="text" class="form-control" id="resetOTP" required>
                                    <div class="text-muted small mt-1">Mã xác thực sẽ được gửi đến email của bạn</div>
                                </div>
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                    <input type="password" class="form-control" id="newPassword" required>
                                    <div class="password-requirements small text-muted mt-1">
                                        Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                    <input type="password" class="form-control" id="confirmNewPassword" required>
                                </div>
                            </div>
                            <div id="resetStatus" class="alert" style="display: none;"></div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" class="btn btn-primary" id="sendResetOTP">Gửi mã xác thực</button>
                        <button type="button" class="btn btn-primary" id="resetPassword" style="display: none;">Đặt lại mật khẩu</button>
                    </div>
                </div>
            </div>
        </div>

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

        <div class="login-link">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý quên mật khẩu
        document.getElementById('forgotPasswordLink').addEventListener('click', function(e) {
            e.preventDefault();
            const modal = new bootstrap.Modal(document.getElementById('forgotPasswordModal'));
            modal.show();
        });

        // Hàm hiển thị thông báo và tự động ẩn sau 5 giây
        function showMessage(element, message, type) {
            element.textContent = message;
            element.className = 'alert alert-' + type;
            element.style.display = 'block';
            
            // Tự động ẩn sau 5 giây
            setTimeout(() => {
                element.style.display = 'none';
            }, 5000);
        }

        // Xử lý gửi mã xác thực
        document.getElementById('sendResetOTP').addEventListener('click', function() {
            const email = document.getElementById('resetEmail').value;
            const resetStatus = document.getElementById('resetStatus');
            const sendOTPButton = document.getElementById('sendResetOTP');
            
            if (!email) {
                showMessage(resetStatus, 'Vui lòng nhập email', 'danger');
                return;
            }

            // Disable button and show loading state
            sendOTPButton.disabled = true;
            sendOTPButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang gửi...';

            console.log('Sending OTP request for email:', email);

            // Gửi request để lấy OTP
            fetch('${pageContext.request.contextPath}/forgot-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => {
                console.log('Response status:', response.status);
                return response.text();
            })
            .then(data => {
                console.log('Response data:', data);
                if (data === 'success') {
                    document.getElementById('otpSection').style.display = 'block';
                    sendOTPButton.style.display = 'none';
                    document.getElementById('resetPassword').style.display = 'block';
                    showMessage(resetStatus, 'Mã xác thực đã được gửi đến email của bạn', 'success');
                } else {
                    // Reset button state on error
                    sendOTPButton.disabled = false;
                    sendOTPButton.innerHTML = 'Gửi mã xác thực';
                    showMessage(resetStatus, data, 'danger');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // Reset button state on error
                sendOTPButton.disabled = false;
                sendOTPButton.innerHTML = 'Gửi mã xác thực';
                showMessage(resetStatus, 'Có lỗi xảy ra. Vui lòng thử lại sau.', 'danger');
            });
        });

        // Xử lý đặt lại mật khẩu
        document.getElementById('resetPassword').addEventListener('click', function() {
            const email = document.getElementById('resetEmail').value;
            const otp = document.getElementById('resetOTP').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmNewPassword = document.getElementById('confirmNewPassword').value;
            const resetStatus = document.getElementById('resetStatus');

            if (!otp || !newPassword || !confirmNewPassword) {
                showMessage(resetStatus, 'Vui lòng nhập đầy đủ thông tin', 'danger');
                return;
            }

            if (newPassword !== confirmNewPassword) {
                showMessage(resetStatus, 'Mật khẩu xác nhận không khớp', 'danger');
                return;
            }

            // Kiểm tra độ mạnh của mật khẩu
            const hasUpperCase = /[A-Z]/.test(newPassword);
            const hasLowerCase = /[a-z]/.test(newPassword);
            const hasNumber = /[0-9]/.test(newPassword);
            const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(newPassword);
            const isLongEnough = newPassword.length >= 8;

            if (!isLongEnough || !hasUpperCase || !hasLowerCase || !hasNumber || !hasSpecialChar) {
                showMessage(resetStatus, 'Mật khẩu không đủ mạnh', 'danger');
                return;
            }

            // Gửi request để đặt lại mật khẩu
            fetch('${pageContext.request.contextPath}/reset-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email) + 
                      '&otp=' + encodeURIComponent(otp) + 
                      '&newPassword=' + encodeURIComponent(newPassword)
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    showMessage(resetStatus, 'Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.', 'success');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }, 2000);
                } else {
                    showMessage(resetStatus, data, 'danger');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage(resetStatus, 'Có lỗi xảy ra. Vui lòng thử lại sau.', 'danger');
            });
        });
    </script>
</body>
</html>
