package Controller;

import DAO.AccountDAO;
import DAO.UserProfileDAO;
import Model.Account;
import Model.UserProfile;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private UserProfileDAO userProfileDAO = new UserProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã có session và đã đăng nhập rồi, chuyển hướng thẳng
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("accountId") != null) {
            String role = (String) session.getAttribute("role");
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("Teacher".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/teacher/home.jsp");
            } else if ("Student".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/student/home.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/home.jsp");
            }
            return;
        }
        
        // Kiểm tra cookie Remember Me nếu chưa có session
        if (session == null || session.getAttribute("accountId") == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("rememberMe".equals(c.getName())) {
                        String value = c.getValue();
                        if (value != null && value.contains(":")) {
                            String[] parts = value.split(":", 2);
                            String email = parts[0];
                            String passwordHash = new String(java.util.Base64.getDecoder().decode(parts[1]));
                            // Kiểm tra thông tin đăng nhập từ DB
                            Account acc = accountDAO.loginWithHash(email, passwordHash);
                            if (acc != null) {
                                // Tạo session tự động
                                session = request.getSession();
                                session.setAttribute("accountId", acc.getId());
                                session.setAttribute("email", acc.getEmail());
                                session.setAttribute("role", acc.getRoleName());
                                session.setAttribute("account", acc);
                                // Lấy thông tin user profile (tùy chọn, giống như doPost)
                                UserProfile profile = userProfileDAO.getProfileWithAccount(acc.getId());
                                if (profile != null) {
                                    session.setAttribute("firstName", profile.getFirstName());
                                    session.setAttribute("lastName", profile.getLastName());
                                    session.setAttribute("middleName", profile.getMiddleName());
                                    session.setAttribute("avatarUrl", profile.getAvatarUrl());
                                    session.setAttribute("mobile", profile.getMobile());
                                    session.setAttribute("gender", profile.getGender());
                                    session.setAttribute("dateOfBirth", profile.getDateOfBirth());
                                }
                                // Chuyển hướng đúng role
                                if ("Admin".equalsIgnoreCase(acc.getRoleName())) {
                                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                                                } else if ("Teacher".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
                } else if ("Student".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/student/home");
                                } else {
                                    response.sendRedirect(request.getContextPath() + "/views/home.jsp");
                                }
                                return;
                            }
                        }
                    }
                }
            }
        }
        
        // Xử lý thông báo logout
        String message = request.getParameter("message");
        if (message != null && !message.trim().isEmpty()) {
            request.setAttribute("message", message);
        }
        
        // Nếu chưa đăng nhập, forward tới login.jsp
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy email & password từ form
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("rememberMe"); // Lấy giá trị checkbox Remember Me

            // Validate cơ bản
            if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Email và mật khẩu không được để trống.");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                return;
            }

            // Gọi DAO kiểm tra
            Account acc = accountDAO.login(email, password);
            if (acc != null) {
                // Kiểm tra trạng thái tài khoản
                String status = acc.getStatus();
                if ("banned".equals(status)) {
                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ admin.");
                    request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                    return;
                }
                if ("deleted".equals(status)) {
                    request.setAttribute("error", "Tài khoản đã bị xóa vì một số lý do.");
                    request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                    return;
                }
                
                // Đăng nhập thành công → lưu vào session
                HttpSession session = request.getSession();
                session.setAttribute("accountId", acc.getId());
                session.setAttribute("email", acc.getEmail());
                session.setAttribute("role", acc.getRoleName());
                session.setAttribute("account", acc);
                
                // Remember Me: nếu người dùng chọn, tạo cookie
                if ("on".equals(rememberMe)) {
                    // Tạo giá trị cookie (có thể dùng token bảo mật hơn)
                    String cookieValue = acc.getEmail() + ":" + java.util.Base64.getEncoder().encodeToString(acc.getPasswordHash().getBytes());
                    Cookie rememberCookie = new Cookie("rememberMe", cookieValue);
                    rememberCookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                    rememberCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(rememberCookie);
                } else {
                    // Nếu không chọn, xóa cookie nếu có
                    Cookie[] cookies = request.getCookies();
                    if (cookies != null) {
                        for (Cookie c : cookies) {
                            if ("rememberMe".equals(c.getName())) {
                                c.setMaxAge(0);
                                c.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                                response.addCookie(c);
                            }
                        }
                    }
                }
                
                // Lấy thông tin user profile
                UserProfile profile = userProfileDAO.getProfileWithAccount(acc.getId());
                if (profile != null) {
                    session.setAttribute("firstName", profile.getFirstName());
                    session.setAttribute("lastName", profile.getLastName());
                    session.setAttribute("middleName", profile.getMiddleName());
                    session.setAttribute("avatarUrl", profile.getAvatarUrl());
                    session.setAttribute("mobile", profile.getMobile());
                    session.setAttribute("gender", profile.getGender());
                    session.setAttribute("dateOfBirth", profile.getDateOfBirth());
                } else {
                    // Nếu chưa có profile, tạo profile mặc định
                    if (userProfileDAO.createDefaultProfile(acc.getId(), "User", "Name")) {
                        session.setAttribute("firstName", "User");
                        session.setAttribute("lastName", "Name");
                        session.setAttribute("avatarUrl", "default-avatar.png");
                    }
                }
                
                System.out.println("Login successful for user: " + acc.getEmail());
                System.out.println("Role from database: " + acc.getRoleName());

                // Chuyển hướng dựa vào role
                if ("Admin".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if ("Teacher".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
                } else if ("Student".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/student/home");
                } else {
                    response.sendRedirect(request.getContextPath() + "/views/home.jsp");
                }
            } else {
                // Đăng nhập thất bại
                request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
