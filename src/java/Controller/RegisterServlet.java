package Controller;

import Model.Account;
import Model.Role;
import Model.UserProfile;
import DAO.AccountDAO;
import DAO.RoleDAO;
import DAO.UserProfileDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final UserProfileDAO userProfileDAO = new UserProfileDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin từ form
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleName = request.getParameter("role");
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");

        // Kiểm tra dữ liệu đầu vào
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Email không đúng định dạng.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Mật khẩu không được để trống.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng xác nhận mật khẩu.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (!isPasswordStrong(password)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (roleName == null || roleName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn vai trò.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (firstName == null || firstName.trim().isEmpty()) {
            request.setAttribute("error", "Họ không được để trống.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (lastName == null || lastName.trim().isEmpty()) {
            request.setAttribute("error", "Tên không được để trống.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (gender == null || gender.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn giới tính.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        if (accountDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại. Vui lòng chọn email khác.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        String formattedRoleName = roleName.equals("student") ? "Student" : "Teacher";
        Role role = roleDAO.getRoleByName(formattedRoleName);
        if (role == null) {
            request.setAttribute("error", "Role không hợp lệ. Vui lòng chọn Student hoặc Teacher.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        // Tạo Account mới
        Account acc = new Account();
        acc.setEmail(email);
        acc.setPasswordHash(password); // Sẽ hash trong DAO
        acc.setRoleId(role.getId());
        acc.setStatus("active");
        if (!accountDAO.register(acc)) {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        // Tạo UserProfile
        UserProfile profile = new UserProfile();
        profile.setAccountId(acc.getId());
        profile.setFirstName(firstName);
        profile.setMiddleName(middleName);
        profile.setLastName(lastName);
        profile.setGender(gender);
        profile.setMobile(null);
        profile.setDateOfBirth(null);
        profile.setAvatarUrl("default-avatar.png");
        if (!userProfileDAO.insertUserProfile(profile)) {
            accountDAO.deleteAccount(acc.getId());
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        // Thành công, chuyển hướng sang login với thông báo thành công
        request.getSession().setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.");
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private boolean isPasswordStrong(String password) {
        // Kiểm tra độ dài tối thiểu
        if (password.length() < 8) {
            return false;
        }

        // Kiểm tra có chữ hoa
        boolean hasUpperCase = false;
        // Kiểm tra có chữ thường
        boolean hasLowerCase = false;
        // Kiểm tra có số
        boolean hasNumber = false;
        // Kiểm tra có ký tự đặc biệt
        boolean hasSpecialChar = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpperCase = true;
            } else if (Character.isLowerCase(c)) {
                hasLowerCase = true;
            } else if (Character.isDigit(c)) {
                hasNumber = true;
            } else if ("!@#$%^&*(),.?\":{}|<>".indexOf(c) != -1) {
                hasSpecialChar = true;
            }
        }

        return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang đăng ký
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }
}
