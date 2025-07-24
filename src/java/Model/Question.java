        /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;
import java.util.List;

/**
 *
 * @author annt
 */

public class Question {
    private int id;
    private int subjectId;
    private int ownerId;
    private int lessonId;
    private String level;
    private String content;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private byte[] image;
    private boolean isPracticeOnly;

    public Question() {
    }

    public Question(int id, int subjectId, int ownerId, int lessonId, String level, String content, String status, Date createdAt, Date updatedAt, byte[] image, boolean isPracticeOnly) {
        this.id = id;
        this.subjectId = subjectId;
        this.ownerId = ownerId;
        this.lessonId = lessonId;
        this.level = level;
        this.content = content;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.image = image;
        this.isPracticeOnly = isPracticeOnly;
    }

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

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
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

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image= image;
    }
    
    public boolean isPracticeOnly() {
        return isPracticeOnly;
    }

    public void setPracticeOnly(boolean practiceOnly) {
        isPracticeOnly = practiceOnly;
    }
    
    // Additional properties for quiz questions
    private List<QuestionAnswer> answers;
    
    public List<QuestionAnswer> getAnswers() {
        return answers;
    }

    public void setAnswers(List<QuestionAnswer> answers) {
        this.answers = answers;
    }
}