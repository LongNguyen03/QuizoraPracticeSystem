package Controller;

import DAO.UserProfileDAO;
import Model.Account;
import Model.UserProfile;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.UUID;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ProfileServlet extends HttpServlet {

    private UserProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        profileDAO = new UserProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        UserProfile profile = profileDAO.getProfileWithAccount(account.getId());
        request.setAttribute("profile", profile);
        request.setAttribute("account", account);
        request.getRequestDispatcher("views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        // Handle profile update
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        UserProfile profile = new UserProfile();
        profile.setAccountId(account.getId());
        profile.setFirstName(firstName);
        profile.setMiddleName(middleName);
        profile.setLastName(lastName);
        profile.setGender(gender);
        profile.setMobile(mobile);
        
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            profile.setDateOfBirth(Date.valueOf(dateOfBirthStr));
        }

        boolean success = profileDAO.updateUserProfile(profile);
        
        if (success) {
            session.setAttribute("message", "Profile updated successfully!");
        } else {
            session.setAttribute("error", "Failed to update profile!");
        }
        
        response.sendRedirect("profile");
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle avatar upload
        Part filePart = request.getPart("avatar");
        String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
        
        // Create uploads directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("/uploads/avatars");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Save the file
        filePart.write(uploadPath + File.separator + fileName);
        
        // Update profile with new avatar URL
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        String avatarUrl = "uploads/avatars/" + fileName;
        
        boolean success = profileDAO.updateAvatar(account.getId(), avatarUrl);
        
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + "}");
    }

    private String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        return submittedFileName.substring(submittedFileName.lastIndexOf("."));
    }
} 