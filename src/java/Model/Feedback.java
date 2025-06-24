package Model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private int accountId;
    private String content;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Additional properties for JOIN queries
    private String accountEmail;
    private String accountName;

    public Feedback() {}

    public Feedback(int id, int accountId, String content, String status, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.accountId = accountId;
        this.content = content;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Feedback(int id, int accountId, String content, String status, Timestamp createdAt, Timestamp updatedAt,
                    String accountEmail, String accountName) {
        this(id, accountId, content, status, createdAt, updatedAt);
        this.accountEmail = accountEmail;
        this.accountName = accountName;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getAccountEmail() {
        return accountEmail;
    }

    public void setAccountEmail(String accountEmail) {
        this.accountEmail = accountEmail;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", accountId=" + accountId +
                ", content='" + content + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", accountEmail='" + accountEmail + '\'' +
                ", accountName='" + accountName + '\'' +
                '}';
    }
} 