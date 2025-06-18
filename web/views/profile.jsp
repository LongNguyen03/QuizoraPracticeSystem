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
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <div class="avatar-upload">
                        <img src="${profile.avatarUrl != null ? profile.avatarUrl : 'https://ui-avatars.com/api/?name=' + profile.firstName + '+' + profile.lastName + '&background=random'}" 
                             alt="Profile Avatar" 
                             class="profile-avatar">
                        <label for="avatar-input">
                            <i class="fas fa-camera"></i>
                        </label>
                        <input type="file" id="avatar-input" accept="image/*">
                    </div>
                </div>
                <div class="col-md-9">
                    <h1 class="mb-2">${profile.firstName} ${profile.middleName} ${profile.lastName}</h1>
                    <p class="mb-1"><i class="fas fa-envelope me-2"></i>${account.email}</p>
                    <p class="mb-0"><i class="fas fa-user-tag me-2"></i>${account.roleName}</p>
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
                                        <input type="text" class="form-control" name="firstName" value="${profile.firstName}" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Last Name</div>
                                    <div class="info-value">
                                        <input type="text" class="form-control" name="lastName" value="${profile.lastName}" readonly>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Middle Nam</div>
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
                                               value="${profile.mobile}" readonly>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4 d-none" id="save-buttons">
                            <button type="submit" class="btn btn-primary me-2">Save Changes</button>
                            <button type="button" class="btn btn-secondary" onclick="cancelEdit()">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
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
                const formData = new FormData();
                formData.append('avatar', file);
                
                fetch('upload-avatar', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Failed to upload avatar');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to upload avatar');
                });
            }
        });
    </script>
</body>
</html> 