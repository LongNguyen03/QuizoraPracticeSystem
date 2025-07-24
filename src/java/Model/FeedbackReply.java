package Model;

import java.sql.Timestamp;

public class FeedbackReply {
    private int id;
    private int feedbackId;
    private int responderId;
    private String content;
    private Timestamp createdAt;

    // Getters & Setters
    // ...

    public FeedbackReply() {
    }

    public FeedbackReply(int id, int feedbackId, int responderId, String content, Timestamp createdAt) {
        this.id = id;
        this.feedbackId = feedbackId;
        this.responderId = responderId;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getResponderId() {
        return responderId;
    }

    public void setResponderId(int responderId) {
        this.responderId = responderId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
