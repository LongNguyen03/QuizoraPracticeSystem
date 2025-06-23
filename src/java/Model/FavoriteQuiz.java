package Model;

public class FavoriteQuiz {
    private int accountId;
    private int quizId;

    // Additional properties for JOIN queries
    private String accountEmail;
    private String quizName;
    private String subjectTitle;

    public FavoriteQuiz() {}

    public FavoriteQuiz(int accountId, int quizId) {
        this.accountId = accountId;
        this.quizId = quizId;
    }

    public FavoriteQuiz(int accountId, int quizId, String accountEmail, String quizName, String subjectTitle) {
        this(accountId, quizId);
        this.accountEmail = accountEmail;
        this.quizName = quizName;
        this.subjectTitle = subjectTitle;
    }

    // Getters & Setters
    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getAccountEmail() {
        return accountEmail;
    }

    public void setAccountEmail(String accountEmail) {
        this.accountEmail = accountEmail;
    }

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

    @Override
    public String toString() {
        return "FavoriteQuiz{" +
                "accountId=" + accountId +
                ", quizId=" + quizId +
                ", accountEmail='" + accountEmail + '\'' +
                ", quizName='" + quizName + '\'' +
                ", subjectTitle='" + subjectTitle + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        FavoriteQuiz that = (FavoriteQuiz) obj;
        return accountId == that.accountId && quizId == that.quizId;
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(accountId, quizId);
    }
} 