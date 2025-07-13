<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DAO.*" %>
<%@ page import="Model.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Practice</title>
</head>
<body>
    <h1>Test Practice Functionality</h1>
    
    <%
    try {
        // Test database connection
        DBcontext db = new DBcontext();
        out.println("<p>Database connection: OK</p>");
        
        // Test PracticeSessionDAO
        PracticeSessionDAO sessionDao = new PracticeSessionDAO();
        out.println("<p>PracticeSessionDAO: OK</p>");
        
        // Test PracticeAnswerDAO
        PracticeAnswerDAO answerDao = new PracticeAnswerDAO();
        out.println("<p>PracticeAnswerDAO: OK</p>");
        
        // Test PracticeSessionQuestionDAO
        PracticeSessionQuestionDAO psqDao = new PracticeSessionQuestionDAO();
        out.println("<p>PracticeSessionQuestionDAO: OK</p>");
        
        // Test creating a practice session
        PracticeSession testSession = new PracticeSession();
        testSession.setAccountId(1);
        testSession.setSubjectId(1);
        testSession.setStartTime(new java.sql.Timestamp(System.currentTimeMillis()));
        testSession.setCompleted(false);
        
        int sessionId = sessionDao.createPracticeSession(testSession);
        out.println("<p>Created test session with ID: " + sessionId + "</p>");
        
        if (sessionId > 0) {
            // Test saving question order
            psqDao.save(sessionId, 1);
            psqDao.save(sessionId, 2);
            out.println("<p>Saved question order for session " + sessionId + "</p>");
            
            // Test saving practice answers
            PracticeAnswer answer1 = new PracticeAnswer();
            answer1.setPracticeSessionId(sessionId);
            answer1.setQuestionId(1);
            answer1.setAnswerId(1);
            answer1.setCorrect(true);
            answerDao.savePracticeAnswer(answer1);
            
            PracticeAnswer answer2 = new PracticeAnswer();
            answer2.setPracticeSessionId(sessionId);
            answer2.setQuestionId(2);
            answer2.setAnswerId(3);
            answer2.setCorrect(false);
            answerDao.savePracticeAnswer(answer2);
            
            out.println("<p>Saved practice answers for session " + sessionId + "</p>");
            
            // Test getting practice answers
            List<PracticeAnswer> answers = answerDao.getPracticeAnswersBySessionId(sessionId);
            out.println("<p>Retrieved " + answers.size() + " practice answers</p>");
            
            // Test getting stats
            PracticeAnswerDAO.PracticeAnswerStats stats = answerDao.getPracticeAnswerStats(sessionId);
            if (stats != null) {
                out.println("<p>Stats - Total: " + stats.getTotalQuestions() + 
                           ", Correct: " + stats.getCorrectAnswers() + 
                           ", Score: " + stats.getScorePercentage() + "%</p>");
            }
            
            // Test getting question order
            List<PracticeSessionQuestionDAO.QuestionOrder> questionOrders = psqDao.getQuestionOrderBySessionId(sessionId);
            out.println("<p>Retrieved " + questionOrders.size() + " question orders</p>");
            
            // Test updating session
            testSession.setId(sessionId);
            testSession.setEndTime(new java.sql.Timestamp(System.currentTimeMillis()));
            testSession.setCompleted(true);
            testSession.setTotalScore(stats != null ? stats.getScorePercentage() : 0.0);
            
            boolean updated = sessionDao.updatePracticeSession(testSession);
            out.println("<p>Updated session: " + updated + "</p>");
            
            // Test getting updated session
            PracticeSession retrievedSession = sessionDao.getPracticeSessionById(sessionId);
            if (retrievedSession != null) {
                out.println("<p>Retrieved session - ID: " + retrievedSession.getId() + 
                           ", Completed: " + retrievedSession.isCompleted() + 
                           ", Score: " + retrievedSession.getTotalScore() + "</p>");
            }
            
            // Clean up - delete test session
            sessionDao.deletePracticeSession(sessionId);
            out.println("<p>Cleaned up test session</p>");
        }
        
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
    
    <p><a href="student/practice">Go to Practice</a></p>
</body>
</html> 