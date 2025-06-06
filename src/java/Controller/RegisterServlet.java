package Controller;

import Model.Account;
import Model.Role;
import Model.UserProfile;
import DAO.AccountDAO;
import DAO.RoleDAO;
import DAO.UserProfileDAO;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            // Lấy thông tin từ form
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String roleName = request.getParameter("role");
            String firstName = request.getParameter("firstName");
            String middleName = request.getParameter("middleName");
            String lastName = request.getParameter("lastName");
            String gender = request.getParameter("gender");
            String mobile = request.getParameter("mobile");
            String dateOfBirthStr = request.getParameter("dateOfBirth");

            // Debug log
            System.out.println("Received parameters:");
            System.out.println("Email: " + email);
            System.out.println("Password: " + password);
            System.out.println("Role: " + roleName);
            System.out.println("First Name: " + firstName);
            System.out.println("Middle Name: " + middleName);
            System.out.println("Last Name: " + lastName);
            System.out.println("Gender: " + gender);

            // Kiểm tra dữ liệu đầu vào
            if (email == null || email.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email không được để trống.");
                out.print(jsonResponse.toString());
                return;
            }
            if (password == null || password.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Mật khẩu không được để trống.");
                out.print(jsonResponse.toString());
                return;
            }
            if (roleName == null || roleName.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng chọn vai trò.");
                out.print(jsonResponse.toString());
                return;
            }
            if (firstName == null || firstName.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Họ không được để trống.");
                out.print(jsonResponse.toString());
                return;
            }
            if (lastName == null || lastName.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Tên không được để trống.");
                out.print(jsonResponse.toString());
                return;
            }
            if (gender == null || gender.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng chọn giới tính.");
                out.print(jsonResponse.toString());
                return;
            }

            // Kiểm tra email đã tồn tại chưa
            if (accountDAO.isEmailExists(email)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email đã tồn tại. Vui lòng chọn email khác.");
                out.print(jsonResponse.toString());
                return;
            }

            // Lấy role từ tên
            String formattedRoleName = roleName.equals("student") ? "Student" : "Teacher";
            System.out.println("Formatted role name: " + formattedRoleName);
            Role role = roleDAO.getRoleByName(formattedRoleName);
            System.out.println("Found role: " + (role != null ? role.getName() : "null"));
            if (role == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Role không hợp lệ. Vui lòng chọn Student hoặc Teacher.");
                out.print(jsonResponse.toString());
                return;
            }

            // 3. Tạo Account mới
            Account acc = new Account();
            acc.setEmail(email);
            acc.setPasswordHash(password);
            acc.setRoleId(role.getId());
            acc.setStatus("active");
            System.out.println("Creating new account with email: " + email + ", roleId: " + role.getId());
            
            if (!accountDAO.register(acc)) {
                System.out.println("Failed to register account");
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("views/register.jsp").forward(request, response);
                return;
            }
            System.out.println("Account registered successfully with ID: " + acc.getId());

            // 4. Tạo UserProfile
            UserProfile profile = new UserProfile();
            profile.setAccountId(acc.getId());
            profile.setFirstName(firstName);
            profile.setMiddleName(middleName);
            profile.setLastName(lastName);
            profile.setGender(gender);
            profile.setMobile(null);
            profile.setDateOfBirth(null);
            profile.setAvatarUrl("default-avatar.png");
            System.out.println("Creating user profile for accountId: " + acc.getId());
            
            if (!userProfileDAO.insertUserProfile(profile)) {
                System.out.println("Failed to create user profile");
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("views/register.jsp").forward(request, response);
                return;
            }
            System.out.println("User profile created successfully");

            jsonResponse.put("success", true);
            jsonResponse.put("message", "Đăng ký thành công.");
            jsonResponse.put("redirectUrl", request.getContextPath() + "/views/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        out.print(jsonResponse.toString());
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang đăng ký
        request.getRequestDispatcher(request.getContextPath() + "/views/register.jsp").forward(request, response);
    }
}
