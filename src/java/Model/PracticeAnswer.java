package Model;

public class PracticeAnswer {
    private int id;
    private int practiceSessionId;
    private int questionId;
    private Integer answerId; // nullable
    private boolean isCorrect;
    private int displayOrder; // Thứ tự hiển thị câu hỏi

    // Additional properties for JOIN queries
    private String questionContent;
    private String answerContent;

    public PracticeAnswer() {}

    public PracticeAnswer(int id, int practiceSessionId, int questionId, Integer answerId, boolean isCorrect) {
        this.id = id;
        this.practiceSessionId = practiceSessionId;
        this.questionId = questionId;
        this.answerId = answerId;
        this.isCorrect = isCorrect;
    }

    public PracticeAnswer(int id, int practiceSessionId, int questionId, Integer answerId, boolean isCorrect,
                         String questionContent, String answerContent) {
        this(id, practiceSessionId, questionId, answerId, isCorrect);
        this.questionContent = questionContent;
        this.answerContent = answerContent;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPracticeSessionId() {
        return practiceSessionId;
    }

    public void setPracticeSessionId(int practiceSessionId) {
        this.practiceSessionId = practiceSessionId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getAnswerId() {
        return answerId;
    }

    public void setAnswerId(Integer answerId) {
        this.answerId = answerId;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getQuestionContent() {
        return questionContent;
    }

    public void setQuestionContent(String questionContent) {
        this.questionContent = questionContent;
    }

    public String getAnswerContent() {
        return answerContent;
    }

    public void setAnswerContent(String answerContent) {
        this.answerContent = answerContent;
    }

    @Override
    public String toString() {
        return "PracticeAnswer{" +
                "id=" + id +
                ", practiceSessionId=" + practiceSessionId +
                ", questionId=" + questionId +
                ", answerId=" + answerId +
                ", isCorrect=" + isCorrect +
                ", displayOrder=" + displayOrder +
                ", questionContent='" + questionContent + '\'' +
                ", answerContent='" + answerContent + '\'' +
                '}';
    }
} 