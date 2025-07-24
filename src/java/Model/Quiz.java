package Model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author dangd
 */
import java.util.Date;

public class Quiz {
    private int id;
    private String name;
    private int subjectId;
    private String level;
    private int numberOfQuestions;
    private int durationMinutes;
    private double passRate;
    private String type;
    private Date createdAt;
    private Date updatedAt;

    // Additional properties for UI
    private boolean isFavorite;
    private String subjectTitle;
    private int ownerId;
    private boolean isPracticeable;

    public Quiz() {
    }

    public Quiz(int id, String name, int subjectId, int ownerId, String level, int numberOfQuestions, int durationMinutes, double passRate, String type, boolean isPracticeable, Date createdAt, Date updatedAt) {
        this.id = id;
        this.name = name;
        this.subjectId = subjectId;
        this.ownerId = ownerId;
        this.level = level;
        this.numberOfQuestions = numberOfQuestions;
        this.durationMinutes = durationMinutes;
        this.passRate = passRate;
        this.type = type;
        this.isPracticeable = isPracticeable;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public int getNumberOfQuestions() {
        return numberOfQuestions;
    }

    public void setNumberOfQuestions(int numberOfQuestions) {
        this.numberOfQuestions = numberOfQuestions;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public double getPassRate() {
        return passRate;
    }

    public void setPassRate(double passRate) {
        this.passRate = passRate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Additional getters and setters
    public boolean isFavorite() {
        return isFavorite;
    }

    public void setFavorite(boolean favorite) {
        isFavorite = favorite;
    }

    public String getSubjectTitle() {
        return subjectTitle;
    }

    public void setSubjectTitle(String subjectTitle) {
        this.subjectTitle = subjectTitle;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public boolean isPracticeable() {
        return isPracticeable;
    }

    public void setPracticeable(boolean isPracticeable) {
        this.isPracticeable = isPracticeable;
    }
}

