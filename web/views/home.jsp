<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.SubjectDAO" %>
<%@ page import="Model.Subject" %>
<%
    java.util.List<Subject> subjects = new SubjectDAO().getAllSubjects();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quizora - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            text-align: center;
            margin-top: 56px; /* Add margin for fixed navbar */
        }
        .hero-section h1 {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        .hero-section p {
            font-size: 1.2rem;
            margin-bottom: 30px;
        }
        .btn-hero {
            background: white;
            color: #667eea;
            padding: 12px 30px;
            border-radius: 30px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-hero:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .features-section {
            padding: 80px 0;
        }
        .feature-card {
            text-align: center;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(102,126,234,0.08);
            margin-bottom: 30px;
            transition: all 0.3s cubic-bezier(.25,.8,.25,1);
            background: #fff;
            border: 2px solid #f3f6fd;
            position: relative;
            overflow: hidden;
        }
        .feature-card:hover {
            transform: translateY(-8px) scale(1.03);
            box-shadow: 0 12px 32px rgba(102,126,234,0.18);
            border-color: #667eea;
        }
        .feature-card .subject-thumb {
            max-height: 120px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 16px;
            width: 100%;
        }
        .feature-card .fallback-icon {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 16px;
        }
        .feature-card .btn {
            border-radius: 20px;
            font-size: 0.95rem;
            padding: 6px 20px;
        }
        .about-section {
            background: #f8f9fa;
            padding: 80px 0;
        }
        .about-content {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        .contact-section {
            padding: 80px 0;
        }
        .contact-info {
            text-align: center;
            margin-bottom: 40px;
        }
        .contact-info i {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 15px;
        }
        .contact-form {
            max-width: 600px;
            margin: 0 auto;
        }
        .testimonials-section {
            background: #f8f9fa;
            padding: 80px 0;
        }
        .testimonial-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .testimonial-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-bottom: 15px;
        }
        .cta-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <h1>Welcome to Quizora</h1>
            <p>Your ultimate platform for learning and teaching through interactive quizzes</p>
            <a href="${pageContext.request.contextPath}/views/register.jsp" class="btn btn-hero">Get Started</a>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <h2 class="text-center mb-5">Why Choose Quizora?</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card">
                        <i class="fas fa-graduation-cap feature-icon"></i>
                        <h3>For Students</h3>
                        <p>Practice with interactive quizzes, track your progress, and improve your knowledge</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <i class="fas fa-chalkboard-teacher feature-icon"></i>
                        <h3>For Teachers</h3>
                        <p>Create engaging quizzes, monitor student performance, and provide instant feedback</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <i class="fas fa-chart-line feature-icon"></i>
                        <h3>Analytics</h3>
                        <p>Get detailed insights into learning progress and quiz performance</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Subjects Section -->
    <section class="features-section" id="subjects">
        <div class="container">
            <h2 class="text-center mb-5">Danh sách môn học nổi bật</h2>
            <div class="row">
                <% for (Subject s : subjects) { 
                    if (!"active".equals(s.getStatus())) continue;
                %>
                <div class="col-md-4">
                    <div class="feature-card">
                        <% if (s.getThumbnailUrl() != null && !s.getThumbnailUrl().isEmpty()) { %>
                            <img src="<%= s.getThumbnailUrl() %>" alt="Thumbnail" class="subject-thumb" />
                        <% } else { %>
                            <i class="fas fa-book-open fallback-icon"></i>
                        <% } %>
                        <h4 class="mb-2"><%= s.getTitle() %></h4>
                        <p class="text-muted mb-1"><%= s.getTagline() != null ? s.getTagline() : "" %></p>
                        <p style="min-height:48px;"><%= s.getDescription() != null ? s.getDescription() : "" %></p>
                        <a href="/subject/detail?id=<%= s.getId() %>" class="btn btn-outline-primary btn-sm mt-2">Xem chi tiết</a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section" id="about">
        <div class="container">
            <div class="about-content">
                <h2 class="mb-4">About Quizora</h2>
                <p class="lead mb-4">
                    Quizora is a comprehensive learning platform designed to make education more interactive and engaging. 
                    Our mission is to help students learn better and teachers teach more effectively through the power of 
                    interactive quizzes and real-time feedback.
                </p>
                <div class="row">
                    <div class="col-md-4">
                        <h4>Our Mission</h4>
                        <p>To revolutionize education through interactive learning</p>
                    </div>
                    <div class="col-md-4">
                        <h4>Our Vision</h4>
                        <p>To be the leading platform for interactive learning</p>
                    </div>
                    <div class="col-md-4">
                        <h4>Our Values</h4>
                        <p>Innovation, Quality, and User Experience</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <h2 class="mb-4">Ready to Start Learning?</h2>
            <p class="lead mb-4">Join thousands of students and teachers who are already using Quizora</p>
            <a href="${pageContext.request.contextPath}/views/register.jsp" class="btn btn-hero">Get Started Now</a>
        </div>
    </section>

    <jsp:include page="layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>