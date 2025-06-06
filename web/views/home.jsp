<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .feature-icon {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 20px;
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
    <jsp:include page="layout/header.jsp" />

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