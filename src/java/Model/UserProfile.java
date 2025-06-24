/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author dangd
 */
import java.util.Date;

public class UserProfile {
    private int accountId;
    private String firstName;
    private String middleName;
    private String lastName;
    private String gender;
    private String mobile;
    private Date dateOfBirth;
    private String avatarUrl;
    
    // Thêm thông tin từ Account
    private String email;
    private String status;
    private String roleName;

    public UserProfile() {}

    public UserProfile(int accountId, String firstName, String middleName, String lastName, String gender, String mobile, Date dateOfBirth, String avatarUrl) {
        this.accountId = accountId;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.gender = gender;
        this.mobile = mobile;
        this.dateOfBirth = dateOfBirth;
        this.avatarUrl = avatarUrl;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
    // Thêm getter/setter cho thông tin Account
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
    // Thêm các phương thức tiện ích
    public String getFullName() {
        StringBuilder fullName = new StringBuilder();
        if (firstName != null && !firstName.trim().isEmpty()) {
            fullName.append(firstName.trim());
        }
        if (middleName != null && !middleName.trim().isEmpty()) {
            if (fullName.length() > 0) fullName.append(" ");
            fullName.append(middleName.trim());
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            if (fullName.length() > 0) fullName.append(" ");
            fullName.append(lastName.trim());
        }
        return fullName.toString();
    }
    
    public String getDisplayName() {
        String fullName = getFullName();
        return fullName.isEmpty() ? "User" : fullName;
    }
    
    public String getInitials() {
        StringBuilder initials = new StringBuilder();
        if (firstName != null && !firstName.trim().isEmpty()) {
            initials.append(firstName.trim().charAt(0));
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            initials.append(lastName.trim().charAt(0));
        }
        return initials.toString().toUpperCase();
    }
    
    public boolean hasAvatar() {
        return avatarUrl != null && !avatarUrl.trim().isEmpty() && !avatarUrl.equals("default-avatar.png");
    }
    
    public String getAvatarDisplayUrl() {
        if (hasAvatar()) {
            return avatarUrl;
        } else {
            // Tạo avatar từ tên người dùng
            return "https://ui-avatars.com/api/?name=" + getInitials() + "&background=random&size=150";
        }
    }
}
