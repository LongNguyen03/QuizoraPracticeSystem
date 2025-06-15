/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author dangd
 */
public class QuestionAnswer {
    private int id;  
    private int questionId;
    private String content;
    private boolean isCorrect;
    private int answerOrder;

    public QuestionAnswer() {
    }

    public QuestionAnswer(int id, int questionId, String content, boolean isCorrect, int answerOrder) {
        this.id = id;
        this.questionId = questionId;
        this.content = content;
        this.isCorrect = isCorrect;
        this.answerOrder = answerOrder;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    public int getAnswerOrder() {
        return answerOrder;
    }

    public void setAnswerOrder(int answerOrder) {
        this.answerOrder = answerOrder;
    }
}
