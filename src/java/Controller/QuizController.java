//package controller;
//
//import DAO.QuestionDAO;
//import DAO.QuizDAO;
//import Model.Question;
//import Model.Quiz;
//import Model.QuizQuestion;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//import static java.lang.Integer.parseInt;
//import java.util.Collections;
//import java.util.List;
//
//@WebServlet("/quiz")
//public class QuizController extends HttpServlet {
//  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//    String action = req.getParameter("action");
//    if("list".equals(action)) {
//      List<Quiz> list = new QuizDAO().findByOwner(getUserId(req));
//      req.setAttribute("quizzes", list);
//      req.getRequestDispatcher("quiz_list.jsp").forward(req, resp);
//    } else {
//      // create hoặc edit
//      req.getRequestDispatcher("quiz_form.jsp").forward(req, resp);
//    }
//  }
//  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//    String action = req.getParameter("action");
//    if("save".equals(action)) {
//      Quiz q = new Quiz();
//      q.setId(parseInt(req.getParameter("id")));
//      q.setName(req.getParameter("name"));
//      q.setSubjectId(parseInt(req.getParameter("subjectId")));
//      q.setLevel("Dễ"); // hoặc lấy từ input
//      q.setNumberOfQuestions(parseInt(req.getParameter("numberOfQuestions")));
//      q.setDurationMinutes(parseInt(req.getParameter("durationMinutes")));
//      q.setPassRate(Double.parseDouble(req.getParameter("passRate")));
//      q.setType(req.getParameter("type"));
//      int newQuizId = new QuizDAO().insert(q);
//      // Lấy danh sách câu hỏi của Lesson đã chọn
//      List<Question> qs = new QuestionDAO().findByLessonId(parseInt(req.getParameter("lessonId")));
//      Collections.shuffle(qs);
//      // chỉ lấy đúng số qt
//      for(int i=0; i<q.getNumberOfQuestions(); i++){
//        QuizQuestion qq = new QuizQuestion();
//        qq.setQuizId(newQuizId);
//        qq.setQuestionId(qs.get(i).getId());
//        qq.setQuestionOrder(i+1);
//        new QuizQuestionDAO().insert(qq);
//      }
//    }
//    resp.sendRedirect("quiz?action=list");
//  }
//  // helper parseInt, getUserId...
//}
//
