/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;
import java.util.List;

public class Question {
    private int id;
    private int subjectId;
    private int lessonId;
    private int dimensionId;
    private String level;
    private String content;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private byte[] imageUrl; // Sửa thành byte[] để lưu ảnh nhị phân

    private List<QuestionAnswer> answerOptions; // Danh sách đáp án

    public Question() {
    }

    public Question(int id, int subjectId, int lessonId, int dimensionId, String level,
                    String content, String status, Date createdAt, Date updatedAt,
                    byte[] imageUrl, List<QuestionAnswer> answerOptions) {
        this.id = id;
        this.subjectId = subjectId;
        this.lessonId = lessonId;
        this.dimensionId = dimensionId;
        this.level = level;
        this.content = content;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.imageUrl = imageUrl;
        this.answerOptions = answerOptions;
    }

    // Getters và setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public int getDimensionId() {
        return dimensionId;
    }

    public void setDimensionId(int dimensionId) {
        this.dimensionId = dimensionId;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
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

    public byte[] getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(byte[] imageUrl) {
        this.imageUrl = imageUrl;
    }

    public List<QuestionAnswer> getAnswerOptions() {
        return answerOptions;
    }

    public void setAnswerOptions(List<QuestionAnswer> answerOptions) {
        this.answerOptions = answerOptions;
    }
}

