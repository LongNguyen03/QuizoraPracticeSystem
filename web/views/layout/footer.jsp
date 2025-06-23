<%-- 
    Document   : footer.jsp
    Created on : Jun 6, 2025, 1:28:06 PM
    Author     : dangd
--%>

<footer class="bg-dark text-light py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5 class="mb-4">Quizora</h5>
                <p class="text-muted">Your ultimate platform for learning and teaching through interactive quizzes.</p>
                <div class="social-links mt-4">
                    <a href="#" class="text-light me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" class="text-light"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="col-md-2 mb-4">
                <h5 class="mb-4">Quick Links</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/home" class="text-muted text-decoration-none">Home</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/all-subjects" class="text-muted text-decoration-none">Subjects</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/quizzes" class="text-muted text-decoration-none">Quizzes</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/practice" class="text-muted text-decoration-none">Practice</a></li>
                </ul>
            </div>
            <div class="col-md-2 mb-4">
                <h5 class="mb-4">Support</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Help Center</a></li>
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Contact Us</a></li>
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Privacy Policy</a></li>
                    <li class="mb-2"><a href="#" class="text-muted text-decoration-none">Terms of Service</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-4">
                <h5 class="mb-4">Newsletter</h5>
                <p class="text-muted">Subscribe to our newsletter for updates and exclusive offers.</p>
                <form class="mt-3">
                    <div class="input-group">
                        <input type="email" class="form-control" placeholder="Enter your email" required>
                        <button class="btn btn-primary" type="submit">Subscribe</button>
                    </div>
                </form>
            </div>
        </div>
        <hr class="my-4 bg-secondary">
        <div class="row">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-0 text-muted">&copy; 2024 Quizora. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <p class="mb-0 text-muted">Made with <i class="fas fa-heart text-danger"></i> for education</p>
            </div>
        </div>
    </div>
</footer>
