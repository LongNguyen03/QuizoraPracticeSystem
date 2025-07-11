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

public class QuizResult {
    private int id;
    private int quizId;
    private int accountId;
    private double score;
    private boolean passed;
    private Date attemptDate;
    private Date completionTime; // Thời gian hoàn thành quiz

    // Additional properties for JOIN queries
    private String quizName;
    private String subjectTitle;

    public QuizResult() {
    }

    public QuizResult(int id, int quizId, int accountId, double score, boolean passed, Date attemptDate) {
        this.id = id;
        this.quizId = quizId;
        this.accountId = accountId;
        this.score = score;
        this.passed = passed;
        this.attemptDate = attemptDate;
    }

    public QuizResult(int id, int quizId, int accountId, double score, boolean passed, Date attemptDate, Date completionTime) {
        this.id = id;
        this.quizId = quizId;
        this.accountId = accountId;
        this.score = score;
        this.passed = passed;
        this.attemptDate = attemptDate;
        this.completionTime = completionTime;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public boolean isPassed() {
        return passed;
    }

    public void setPassed(boolean passed) {
        this.passed = passed;
    }

    public Date getAttemptDate() {
        return attemptDate;
    }

    public void setAttemptDate(Date attemptDate) {
        this.attemptDate = attemptDate;
    }
    
    public Date getCompletionTime() {
        return completionTime;
    }

    public void setCompletionTime(Date completionTime) {
        this.completionTime = completionTime;
    }
    
    /**
     * Tính thời gian làm bài (tính bằng giây)
     */
    public long getTimeTakenSeconds() {
        if (attemptDate != null && completionTime != null) {
            return (completionTime.getTime() - attemptDate.getTime()) / 1000;
        }
        return 0;
    }
    
    /**
     * Lấy thời gian làm bài dạng chuỗi (phút:giây)
     */
    public String getTimeTakenFormatted() {
        long seconds = getTimeTakenSeconds();
        if (seconds == 0) return "Không có dữ liệu";
        
        long minutes = seconds / 60;
        long remainingSeconds = seconds % 60;
        return String.format("%d:%02d", minutes, remainingSeconds);
    }
    
    // Additional getters and setters
    public String getQuizName() {
        return quizName;
    }

    public void setQuizName(String quizName) {
        this.quizName = quizName;
    }

    public String getSubjectTitle() {
        return subjectTitle;
    }

    public void setSubjectTitle(String subjectTitle) {
        this.subjectTitle = subjectTitle;
    }
}
