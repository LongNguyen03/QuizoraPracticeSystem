package Controller;

import DAO.UserProfileDAO;
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
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendRedirect("login");
            return;
        }

        UserProfile profile = profileDAO.getProfileWithAccount(accountId);
        if (profile == null) {
            // Nếu chưa có profile, tạo profile mặc định
            String firstName = (String) session.getAttribute("firstName");
            String lastName = (String) session.getAttribute("lastName");
            if (profileDAO.createDefaultProfile(accountId, firstName, lastName)) {
                profile = profileDAO.getProfileWithAccount(accountId);
            } else {
                // Nếu không tạo được profile mặc định
                profile = new UserProfile();
                profile.setAccountId(accountId);
                profile.setFirstName("User");
                profile.setLastName("Name");
                profile.setGender("Other");
                profile.setEmail((String) session.getAttribute("email"));
                profile.setRoleName((String) session.getAttribute("role"));
            }
        }
        
        request.setAttribute("profile", profile);
        request.getRequestDispatcher("views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.sendRedirect("login");
            return;
        }

        // Validate input
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String dateOfBirthStr = request.getParameter("dateOfBirth");

        // Validation
        if (firstName == null || firstName.trim().isEmpty()) {
            session.setAttribute("error", "First name is required!");
            response.sendRedirect("profile");
            return;
        }
        
        if (lastName == null || lastName.trim().isEmpty()) {
            session.setAttribute("error", "Last name is required!");
            response.sendRedirect("profile");
            return;
        }
        
        // Validate mobile number format
        if (mobile != null && !mobile.trim().isEmpty()) {
            if (!mobile.matches("^[0-9+\\-\\s()]{10,15}$")) {
                session.setAttribute("error", "Invalid mobile number format!");
                response.sendRedirect("profile");
                return;
            }
        }

        UserProfile profile = new UserProfile();
        profile.setAccountId(accountId);
        profile.setFirstName(firstName.trim());
        profile.setMiddleName(middleName != null ? middleName.trim() : "");
        profile.setLastName(lastName.trim());
        profile.setGender(gender != null ? gender : "Other");
        profile.setMobile(mobile != null ? mobile.trim() : "");
        
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                profile.setDateOfBirth(Date.valueOf(dateOfBirthStr));
            } catch (IllegalArgumentException e) {
                session.setAttribute("error", "Invalid date format!");
                response.sendRedirect("profile");
                return;
            }
        }

        boolean success = profileDAO.updateUserProfile(profile);
        
        if (success) {
            // Cập nhật session với thông tin mới
            session.setAttribute("firstName", profile.getFirstName());
            session.setAttribute("lastName", profile.getLastName());
            session.setAttribute("middleName", profile.getMiddleName());
            session.setAttribute("mobile", profile.getMobile());
            session.setAttribute("gender", profile.getGender());
            session.setAttribute("dateOfBirth", profile.getDateOfBirth());
            
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
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        
        if (accountId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }
        
        try {
            Part filePart = request.getPart("avatar");
            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"No file uploaded\"}");
                return;
            }
            
            // Validate file type
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Only image files are allowed\"}");
                return;
            }
            
            // Validate file size (max 10MB)
            if (filePart.getSize() > 10 * 1024 * 1024) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"File size too large (max 10MB)\"}");
                return;
            }
            
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
            String avatarUrl = "uploads/avatars/" + fileName;
            
            boolean success = profileDAO.updateAvatar(accountId, avatarUrl);
            
            response.setContentType("application/json");
            if (success) {
                // Cập nhật session với avatar URL mới
                session.setAttribute("avatarUrl", avatarUrl);
                session.setAttribute("message", "Avatar updated successfully!");
                response.getWriter().write("{\"success\": true, \"avatarUrl\": \"" + avatarUrl + "\", \"reload\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update avatar\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Server error occurred\"}");
        }
    }

    private String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return ".jpg"; // Default extension
        }
        int lastDotIndex = submittedFileName.lastIndexOf(".");
        if (lastDotIndex > 0) {
            return submittedFileName.substring(lastDotIndex);
        }
        return ".jpg"; // Default extension
    }
} 