package Model;

public class Account {
    private int id;
    private String email;
    private String passwordHash;
    private int roleId;
    private String status;

    // Thêm thuộc tính phụ: tên vai trò (không có trong DB, dùng khi JOIN)
    private String roleName;

    public Account() {}

    public Account(int id, String email, String passwordHash, int roleId, String status) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.roleId = roleId;
        this.status = status;
    }

    public Account(int id, String email, String passwordHash, int roleId, String status, String roleName) {
        this(id, email, passwordHash, roleId, status);
        this.roleName = roleName;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
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

    // Optional: override toString() for debugging
    @Override
    public String toString() {
        return "Account{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", roleId=" + roleId +
                ", status='" + status + '\'' +
                ", roleName='" + roleName + '\'' +
                '}';
    }
}
