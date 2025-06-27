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
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-login">Login</button>
                <a href="${pageContext.request.contextPath}/views/home.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
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
                        <!-- Message container -->
                        <div id="messageContainer" class="alert" style="display: none;"></div>
                        
                        <div id="forgotPasswordStep1">
                            <form id="forgotPasswordForm" action="forgot-password" method="POST">
                                <div class="mb-3">
                                    <label for="forgotEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="forgotEmail" name="email" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Gửi mã xác thực</button>
                            </form>
                        </div>
                        <div id="forgotPasswordStep2" style="display: none;">
                            <form id="resetPasswordForm" action="reset-password" method="POST">
                                <input type="hidden" id="resetEmail" name="email">
                                <div class="mb-3">
                                    <label for="otp" class="form-label">Mã xác thực</label>
                                    <input type="text" class="form-control" id="otp" name="otp" required>
                                    <div class="form-text">Mã xác thực đã được gửi đến email của bạn. Mã có hiệu lực trong 5 phút.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                    <div class="form-text">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</div>
                                </div>
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Đặt lại mật khẩu</button>
                            </form>
                        </div>
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

        <div class="register-link">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Xử lý quên mật khẩu
        document.getElementById('forgotPasswordLink').addEventListener('click', function(e) {
            e.preventDefault();
            const modal = new bootstrap.Modal(document.getElementById('forgotPasswordModal'));
            modal.show();
            // Reset form khi mở modal
            $('#forgotPasswordStep1').show();
            $('#forgotPasswordStep2').hide();
            $('#forgotPasswordForm')[0].reset();
            $('#resetPasswordForm')[0].reset();
            $('#messageContainer').hide();
        });

        // Hàm hiển thị thông báo
        function showMessage(message, type) {
            const messageContainer = $('#messageContainer');
            messageContainer.removeClass('alert-success alert-danger').addClass('alert-' + type);
            messageContainer.text(message).show();
            
            // Tự động ẩn sau 5 giây
            setTimeout(() => {
                messageContainer.hide();
            }, 5000);
        }

        // Handle forgot password form submission
        $('#forgotPasswordForm').on('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = $(this).find('button[type="submit"]');
            const originalText = submitBtn.text();
            
            // Show loading state
            submitBtn.prop('disabled', true).text('Đang gửi...');
            $('#messageContainer').hide();
            
            console.log('Sending forgot password request...');
            console.log('URL:', $(this).attr('action'));
            console.log('Data:', $(this).serialize());
            
            $.ajax({
                url: $(this).attr('action'),
                type: 'POST',
                data: $(this).serialize(),
                success: function(response) {
                    console.log('Forgot password response:', response);
                    if (response.trim() === 'success') {
                        showMessage('Mã xác thực đã được gửi đến email của bạn!', 'success');
                        $('#forgotPasswordStep1').hide();
                        $('#forgotPasswordStep2').show();
                        $('#resetEmail').val($('#forgotEmail').val());
                    } else {
                        showMessage(response, 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.log('Forgot password error:', xhr, status, error);
                    showMessage('Có lỗi xảy ra. Vui lòng thử lại sau.', 'danger');
                },
                complete: function() {
                    // Reset button state
                    submitBtn.prop('disabled', false).text(originalText);
                }
            });
        });

        // Handle reset password form submission
        $('#resetPasswordForm').on('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = $(this).find('button[type="submit"]');
            const originalText = submitBtn.text();
            
            // Show loading state
            submitBtn.prop('disabled', true).text('Đang xử lý...');
            $('#messageContainer').hide();
            
            console.log('Sending reset password request...');
            console.log('URL:', $(this).attr('action'));
            console.log('Data:', $(this).serialize());
            
            $.ajax({
                url: $(this).attr('action'),
                type: 'POST',
                data: $(this).serialize(),
                success: function(response) {
                    console.log('Reset password response:', response);
                    if (response.trim() === 'success') {
                        showMessage('Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.', 'success');
                        setTimeout(() => {
                            const modal = bootstrap.Modal.getInstance(document.getElementById('forgotPasswordModal'));
                            modal.hide();
                            location.reload();
                        }, 2000);
                    } else {
                        showMessage(response, 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.log('Reset password error:', xhr, status, error);
                    showMessage('Có lỗi xảy ra. Vui lòng thử lại sau.', 'danger');
                },
                complete: function() {
                    // Reset button state
                    submitBtn.prop('disabled', false).text(originalText);
                }
            });
        });

        // Reset modal when closed
        $('#forgotPasswordModal').on('hidden.bs.modal', function () {
            $('#forgotPasswordStep1').show();
            $('#forgotPasswordStep2').hide();
            $('#forgotPasswordForm')[0].reset();
            $('#resetPasswordForm')[0].reset();
            $('#messageContainer').hide();
        });
    </script>
</body>
</html>
