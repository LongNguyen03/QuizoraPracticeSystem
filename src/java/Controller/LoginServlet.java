package Controller;

import DAO.AccountDAO;
import Model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã có session và đã đăng nhập rồi, chuyển hướng thẳng
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("accountId") != null) {
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else if ("teacher".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/teacher/home.jsp");
            } else if ("student".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/student/home.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/home.jsp");
            }
            return;
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
                // Đăng nhập thành công → lưu vào session
                HttpSession session = request.getSession();
                session.setAttribute("accountId", acc.getId());
                session.setAttribute("email", acc.getEmail());
                session.setAttribute("role", acc.getRoleName());
                
                System.out.println("Login successful for user: " + acc.getEmail());
                System.out.println("Role from database: " + acc.getRoleName());

                // Chuyển hướng dựa vào role
                if ("Admin".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                } else if ("Teacher".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/teacher/home.jsp");
                } else if ("Student".equalsIgnoreCase(acc.getRoleName())) {
                    response.sendRedirect(request.getContextPath() + "/student/home.jsp");
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
