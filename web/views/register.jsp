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
        /* Thay đổi màu cursor trong input fields */
        .form-control {
            caret-color: #667eea; /* Màu xanh tím */
        }
        /* Hoặc có thể dùng màu khác */
        /* .form-control {
            caret-color: #ff6b6b; 
        } */
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
                <button type="button" class="btn btn-outline-primary mt-2" id="sendOTP">Gửi mã xác thực</button>
                <div id="otpStatus" class="text-muted mt-1" style="display: none;"></div>
            </div>
            
            <div class="form-group" id="otpGroup" style="display: none;">
                <input type="text"
                       class="form-control"
                       id="otp"
                       name="otp"
                       placeholder="Nhập mã xác thực"
                       required>
                <div class="text-muted mt-1">Mã xác thực sẽ hết hạn sau 5 phút</div>
                <div id="otpError" class="text-danger mt-1" style="display: none;"></div>
                <button type="button" class="btn btn-link p-0 mt-1" id="resendOTP" style="display: none;">Gửi lại mã</button>
                <button type="button" class="btn btn-primary mt-2" id="verifyOTP">Xác thực</button>
            </div>
            
            <div id="registrationFields" style="display: none;">
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
            </div>
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

        // Validation real-time cho email
        document.getElementById('email').addEventListener('input', function() {
            const email = this.value.trim();
            if (!emailRegex.test(email)) {
                this.setCustomValidity('Vui lòng nhập email hợp lệ (ví dụ: example@domain.com)');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validation real-time cho tên
        document.getElementById('firstName').addEventListener('input', function() {
            const name = this.value.trim();
            if (name.length < 2) {
                this.setCustomValidity('Tên phải có ít nhất 2 ký tự');
            } else if (!/^[a-zA-ZÀ-ỹ\s]+$/.test(name)) {
                this.setCustomValidity('Tên chỉ được chứa chữ cái và khoảng trắng');
            } else {
                this.setCustomValidity('');
            }
        });

        document.getElementById('lastName').addEventListener('input', function() {
            const name = this.value.trim();
            if (name.length < 2) {
                this.setCustomValidity('Họ phải có ít nhất 2 ký tự');
            } else if (!/^[a-zA-ZÀ-ỹ\s]+$/.test(name)) {
                this.setCustomValidity('Họ chỉ được chứa chữ cái và khoảng trắng');
            } else {
                this.setCustomValidity('');
            }
        });

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Kiểm tra OTP
            const otpInput = document.getElementById('otp');
            if (otpInput.style.display !== 'none' && !otpInput.value) {
                alert('Vui lòng nhập mã xác thực');
                return;
            }
            
            // Kiểm tra mật khẩu
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Kiểm tra độ mạnh của mật khẩu
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumber = /[0-9]/.test(password);
            const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const isLongEnough = password.length >= 8;
            
            // Kiểm tra và hiển thị lỗi
            let errorMessage = '';
            if (!isLongEnough) {
                errorMessage += 'Mật khẩu phải có ít nhất 8 ký tự.\n';
            }
            if (!hasUpperCase) {
                errorMessage += 'Mật khẩu phải có ít nhất 1 chữ hoa.\n';
            }
            if (!hasLowerCase) {
                errorMessage += 'Mật khẩu phải có ít nhất 1 chữ thường.\n';
            }
            if (!hasNumber) {
                errorMessage += 'Mật khẩu phải có ít nhất 1 số.\n';
            }
            if (!hasSpecialChar) {
                errorMessage += 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt.\n';
            }
            
            // Kiểm tra xác nhận mật khẩu
            if (password !== confirmPassword) {
                errorMessage += 'Mật khẩu xác nhận không khớp.\n';
            }
            
            // Nếu có lỗi, hiển thị và dừng submit
            if (errorMessage) {
                alert(errorMessage);
                return;
            }
            
            // Nếu không có lỗi, submit form
            this.submit();
        });
        
        // Thêm sự kiện để hiển thị/ẩn yêu cầu mật khẩu khi focus/blur
        const passwordInput = document.getElementById('password');
        const requirements = document.querySelector('.password-requirements');
        
        passwordInput.addEventListener('focus', function() {
            requirements.style.display = 'block';
        });
        
        passwordInput.addEventListener('blur', function() {
            requirements.style.display = 'none';
        });
        
        // Thêm sự kiện để kiểm tra mật khẩu realtime
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumber = /[0-9]/.test(password);
            const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const isLongEnough = password.length >= 8;
            
            // Cập nhật màu sắc của các yêu cầu
            const requirements = document.querySelector('.password-requirements');
            requirements.innerHTML = `
                <div style="color: ${isLongEnough ? 'green' : 'red'}">• Độ dài tối thiểu 8 ký tự</div>
                <div style="color: ${hasUpperCase ? 'green' : 'red'}">• Ít nhất 1 chữ hoa</div>
                <div style="color: ${hasLowerCase ? 'green' : 'red'}">• Ít nhất 1 chữ thường</div>
                <div style="color: ${hasNumber ? 'green' : 'red'}">• Ít nhất 1 số</div>
                <div style="color: ${hasSpecialChar ? 'green' : 'red'}">• Ít nhất 1 ký tự đặc biệt</div>
            `;
        });

        // Xử lý gửi OTP
        document.getElementById('sendOTP').addEventListener('click', function() {
            const email = document.getElementById('email').value;
            if (!email || !emailRegex.test(email)) {
                alert('Vui lòng nhập email hợp lệ');
                return;
            }
            
            // Disable nút gửi OTP
            var sendBtn = document.getElementById('sendOTP');
            sendBtn.disabled = true;
            sendBtn.textContent = 'Đang gửi...';
            
            // Gửi request để lấy OTP
            fetch('${pageContext.request.contextPath}/send-otp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    document.getElementById('otpGroup').style.display = 'block';
                    document.getElementById('otpStatus').textContent = 'OTP đã được gửi đến email của bạn';
                    document.getElementById('otpStatus').style.display = 'block';
                    document.getElementById('otpStatus').className = 'text-success mt-1';
                    // Đếm ngược 5 phút
                    let timeLeft = 300;
                    window.otpTimer = setInterval(() => {
                        timeLeft--;
                        if (timeLeft <= 0) {
                            clearInterval(window.otpTimer);
                            var sendBtn = document.getElementById('sendOTP');
                            sendBtn.disabled = false;
                            sendBtn.textContent = 'Gửi lại mã';
                            sendBtn.style.display = '';
                            document.getElementById('otpGroup').style.display = 'none';
                            document.getElementById('otpStatus').style.display = 'none';
                            document.getElementById('resendOTP').style.display = 'block';
                        } else {
                            const minutes = Math.floor(timeLeft / 60);
                            const seconds = timeLeft % 60;
                            document.getElementById('otpStatus').textContent = 
                                `Mã xác thực còn hiệu lực trong ${minutes}:${seconds.toString().padStart(2, '0')}`;
                        }
                    }, 1000);
                } else {
                    document.getElementById('otpStatus').textContent = data;
                    document.getElementById('otpStatus').style.display = 'block';
                    document.getElementById('otpStatus').className = 'text-danger mt-1';
                    var sendBtn = document.getElementById('sendOTP');
                    sendBtn.disabled = false;
                    sendBtn.textContent = 'Gửi mã xác thực';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('otpStatus').textContent = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
                document.getElementById('otpStatus').style.display = 'block';
                document.getElementById('otpStatus').className = 'text-danger mt-1';
                var sendBtn = document.getElementById('sendOTP');
                sendBtn.disabled = false;
                sendBtn.textContent = 'Gửi mã xác thực';
            });
        });

        // Xử lý gửi lại OTP
        document.getElementById('resendOTP').addEventListener('click', function() {
            var sendBtn = document.getElementById('sendOTP');
            sendBtn.disabled = false;
            sendBtn.style.display = '';
            sendBtn.click();
            this.style.display = 'none';
        });

        // Thêm hàm xác thực OTP
        document.getElementById('verifyOTP').addEventListener('click', function() {
            const email = document.getElementById('email').value;
            const otp = document.getElementById('otp').value;
            const otpError = document.getElementById('otpError');
            
            if (!otp) {
                otpError.textContent = 'Vui lòng nhập mã xác thực';
                otpError.style.display = 'block';
                return;
            }
            
            // Gửi request kiểm tra OTP
            fetch('${pageContext.request.contextPath}/verify-otp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email) + '&otp=' + encodeURIComponent(otp)
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    // Hiển thị các trường đăng ký
                    document.getElementById('registrationFields').style.display = 'block';
                    document.getElementById('otpGroup').style.display = 'none';
                    document.getElementById('otpStatus').textContent = 'Email đã được xác thực';
                    document.getElementById('otpStatus').className = 'text-success mt-1';
                    document.getElementById('otpStatus').style.display = 'block';
                    otpError.style.display = 'none';
                    // Ẩn nút gửi OTP
                    document.getElementById('sendOTP').style.display = 'none';
                    // Ẩn/clear đồng hồ đếm ngược
                    if (window.otpTimer) {
                        clearInterval(window.otpTimer);
                    }
                    document.getElementById('otpStatus').style.display = 'none';
                    // Disable trường email
                    document.getElementById('email').readOnly = true;
                } else {
                    otpError.textContent = data;
                    otpError.style.display = 'block';
                    document.getElementById('otp').value = '';
                    // Nếu thông báo hết hạn, show lại nút gửi lại mã
                    if (data.includes('hết hạn')) {
                        var sendBtn = document.getElementById('sendOTP');
                        sendBtn.disabled = false;
                        sendBtn.textContent = 'Gửi lại mã';
                        sendBtn.style.display = '';
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                otpError.textContent = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
                otpError.style.display = 'block';
            });
        });

        // Thêm sự kiện để ẩn thông báo lỗi khi người dùng bắt đầu nhập lại OTP
        document.getElementById('otp').addEventListener('input', function() {
            document.getElementById('otpError').style.display = 'none';
        });
    </script>
    <script>
  setTimeout(function() {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
      alert.style.display = 'none';
    });
  }, 10000);
</script>
</body>
</html>
