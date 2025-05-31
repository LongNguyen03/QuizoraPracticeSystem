/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author dangd
 */
public class QuizAnswer {
    private int id;
    private int quizResultId;
    private int questionId;
    private int selectedAnswerId;
    private boolean isCorrect;

    public QuizAnswer() {
    }

    public QuizAnswer(int id, int quizResultId, int questionId, int selectedAnswerId, boolean isCorrect) {
        this.id = id;
        this.quizResultId = quizResultId;
        this.questionId = questionId;
        this.selectedAnswerId = selectedAnswerId;
        this.isCorrect = isCorrect;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuizResultId() {
        return quizResultId;
    }

    public void setQuizResultId(int quizResultId) {
        this.quizResultId = quizResultId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getSelectedAnswerId() {
        return selectedAnswerId;
    }

    public void setSelectedAnswerId(int selectedAnswerId) {
        this.selectedAnswerId = selectedAnswerId;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }
}
