package Model;

import java.sql.Timestamp;

public class PracticeSession {
    private int id;
    private int accountId;
    private int subjectId;
    private Integer lessonId; // nullable
    private Timestamp startTime;
    private Timestamp endTime;
    private Double totalScore; // nullable
    private boolean completed;

    // Additional properties for JOIN queries
    private String accountEmail;
    private String subjectTitle;
    private String lessonTitle;

    public PracticeSession() {}

    public PracticeSession(int id, int accountId, int subjectId, Integer lessonId, 
                          Timestamp startTime, Timestamp endTime, Double totalScore, boolean completed) {
        this.id = id;
        this.accountId = accountId;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalScore = totalScore;
        this.completed = completed;
    }

    public PracticeSession(int id, int accountId, int subjectId, Integer lessonId, 
                          Timestamp startTime, Timestamp endTime, Double totalScore, boolean completed,
                          String accountEmail, String subjectTitle, String lessonTitle) {
        this(id, accountId, subjectId, lessonId, startTime, endTime, totalScore, completed);
        this.accountEmail = accountEmail;
        this.subjectTitle = subjectTitle;
        this.lessonTitle = lessonTitle;
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

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public Integer getLessonId() {
        return lessonId;
    }

    public void setLessonId(Integer lessonId) {
        this.lessonId = lessonId;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public Double getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Double totalScore) {
        this.totalScore = totalScore;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public String getAccountEmail() {
        return accountEmail;
    }

    public void setAccountEmail(String accountEmail) {
        this.accountEmail = accountEmail;
    }

    public String getSubjectTitle() {
        return subjectTitle;
    }

    public void setSubjectTitle(String subjectTitle) {
        this.subjectTitle = subjectTitle;
    }

    public String getLessonTitle() {
        return lessonTitle;
    }

    public void setLessonTitle(String lessonTitle) {
        this.lessonTitle = lessonTitle;
    }

    @Override
    public String toString() {
        return "PracticeSession{" +
                "id=" + id +
                ", accountId=" + accountId +
                ", subjectId=" + subjectId +
                ", lessonId=" + lessonId +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", totalScore=" + totalScore +
                ", completed=" + completed +
                ", accountEmail='" + accountEmail + '\'' +
                ", subjectTitle='" + subjectTitle + '\'' +
                ", lessonTitle='" + lessonTitle + '\'' +
                '}';
    }
} 