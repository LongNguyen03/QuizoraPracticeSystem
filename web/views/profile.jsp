<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - Quizora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .profile-header {
            background: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            object-fit: cover;
            margin-bottom: 1rem;
        }
        .profile-info {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 2rem;
        }
        .info-item {
            margin-bottom: 1.5rem;
        }
        .info-label {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.3rem;
            font-weight: 500;
        }
        .info-value {
            font-size: 1.1rem;
            color: #333;
        }
        .edit-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
        }
        .avatar-upload {
            position: relative;
            display: inline-block;
        }
        .avatar-upload input[type="file"] {
            display: none;
        }
        .avatar-upload label {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #007bff;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .avatar-upload label:hover {
            background: #0056b3;
        }
        .form-control:read-only {
            background-color: #f8f9fa;
            border-color: #e9ecef;
        }
        .form-control:read-only:focus {
            background-color: #f8f9fa;
            border-color: #e9ecef;
            box-shadow: none;
        }
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .role-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

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

    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <div class="avatar-upload">
                        <img src="${profile.avatarDisplayUrl}" 
                             alt="Profile Avatar" 
                             class="profile-avatar"
                             id="profile-avatar">
                        <label for="avatar-input">
                            <i class="fas fa-camera"></i>
                        </label>
                        <input type="file" id="avatar-input" accept="image/*">
                    </div>
                </div>
                <div class="col-md-9">
                    <h1 class="mb-2">${profile.displayName}</h1>
                    <p class="mb-1"><i class="fas fa-envelope me-2"></i>${profile.email}</p>
                    <p class="mb-1">
                        <span class="role-badge me-2">${profile.roleName}</span>
                        <span class="status-badge ${profile.status == 'active' ? 'status-active' : 'status-inactive'}">
                            ${profile.status}
                        </span>
                    </p>
                    <!-- Nút đổi mật khẩu -->
                    <button type="button" class="btn btn-outline-warning mt-2" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                        <i class="fas fa-key me-1"></i> Đổi mật khẩu
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="profile-info position-relative">
                    <button class="btn btn-primary edit-btn" onclick="toggleEditMode()">
                        <i class="fas fa-edit me-2"></i>Edit Profile
                    </button>
                    
                    <form id="profile-form" action="profile" method="POST" class="needs-validation" novalidate>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">First Name</div>
                                    <div class="info-value">
                                        <input type="text" class="form-control" name="firstName" value="${profile.firstName}" readonly required>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Last Name</div>
                                    <div class="info-value">
                                        <input type="text" class="form-control" name="lastName" value="${profile.lastName}" readonly required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Middle Name</div>
                                    <div class="info-value">
                                        <input type="text" class="form-control" name="middleName" value="${profile.middleName}" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value">
                                        <select class="form-select" name="gender" disabled>
                                            <option value="Male" ${profile.gender == 'Male' ? 'selected' : ''}>Male</option>
                                            <option value="Female" ${profile.gender == 'Female' ? 'selected' : ''}>Female</option>
                                            <option value="Other" ${profile.gender == 'Other' ? 'selected' : ''}>Other</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Date of Birth</div>
                                    <div class="info-value">
                                        <input type="date" class="form-control" name="dateOfBirth" 
                                               value="${profile.dateOfBirth}" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Mobile</div>
                                    <div class="info-value">
                                        <input type="tel" class="form-control" name="mobile" 
                                               value="${profile.mobile}" readonly 
                                               pattern="[0-9+\-\\s()]{10,15}"
                                               title="Please enter a valid phone number">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4 d-none" id="save-buttons">
                            <button type="submit" class="btn btn-primary me-2">
                                <i class="fas fa-save me-2"></i>Save Changes
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="cancelEdit()">
                                <i class="fas fa-times me-2"></i>Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- Change Password Modal -->
        <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="changePasswordModalLabel"><i class="fas fa-key me-2"></i>Change Password</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="change-password" method="POST" autocomplete="off">
                            <div class="mb-3">
                                <label for="oldPassword" class="form-label">Old Password</label>
                                <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                            </div>
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <div class="form-text">At least 8 characters, include uppercase, lowercase, number, and special character.</div>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Change Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Change Password Modal -->
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleEditMode() {
            const inputs = document.querySelectorAll('input, select');
            const saveButtons = document.getElementById('save-buttons');
            const editBtn = document.querySelector('.edit-btn');
            
            inputs.forEach(input => {
                input.readOnly = !input.readOnly;
                if (input.tagName === 'SELECT') {
                    input.disabled = !input.disabled;
                }
            });
            
            saveButtons.classList.toggle('d-none');
            editBtn.classList.toggle('d-none');
        }

        function cancelEdit() {
            location.reload();
        }

        // Handle avatar upload
        document.getElementById('avatar-input').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Show loading state
                const avatar = document.getElementById('profile-avatar');
                const originalSrc = avatar.src;
                avatar.style.opacity = '0.5';
                
                const formData = new FormData();
                formData.append('avatar', file);
                
                fetch('profile', {
                    method: 'PUT',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update avatar immediately
                        avatar.src = data.avatarUrl;
                        avatar.style.opacity = '1';
                        // Show success message
                        showAlert('Avatar updated successfully!', 'success');
                    } else {
                        avatar.src = originalSrc;
                        avatar.style.opacity = '1';
                        showAlert(data.message || 'Failed to upload avatar', 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    avatar.src = originalSrc;
                    avatar.style.opacity = '1';
                    showAlert('Failed to upload avatar', 'danger');
                });
            }
        });
        
        function showAlert(message, type) {
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type} alert-dismissible fade show m-3`;
            alertDiv.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;
            document.body.insertBefore(alertDiv, document.body.firstChild);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }
    </script>
</body>
</html> 