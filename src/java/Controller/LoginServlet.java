package Controller;

import DAO.AccountDAO;
import Model.Account;
import org.json.JSONObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

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
        request.getRequestDispatcher(request.getContextPath() + "/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập response JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            // Lấy email & password từ form (hoặc AJAX)
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Validate cơ bản
            if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email và mật khẩu không được để trống.");
                out.print(jsonResponse.toString());
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

                // Trả JSON success kèm role và redirect URL
                jsonResponse.put("success", true);
                jsonResponse.put("role", acc.getRoleName());
                
                // Thêm redirect URL dựa vào role
                String redirectUrl;
                if ("Admin".equalsIgnoreCase(acc.getRoleName())) {
                    redirectUrl = request.getContextPath() + "/admin/dashboard.jsp";
                } else if ("Teacher".equalsIgnoreCase(acc.getRoleName())) {
                    redirectUrl = request.getContextPath() + "/teacher/home.jsp";
                } else if ("Student".equalsIgnoreCase(acc.getRoleName())) {
                    redirectUrl = request.getContextPath() + "/student/home.jsp";
                } else {
                    redirectUrl = request.getContextPath() + "/views/home.jsp";
                }
                System.out.println("Redirect URL: " + redirectUrl);
                jsonResponse.put("redirectUrl", redirectUrl);
            } else {
                // Đăng nhập thất bại
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email hoặc mật khẩu không đúng.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        out.print(jsonResponse.toString());
        out.flush();
    }
}
