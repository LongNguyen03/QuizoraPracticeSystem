///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package Controller;
//
//import DAO.QuestionDAO;
//import Model.Question;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.util.List;
//
///**
// *
// * @author kan3v
// */
//@WebServlet(name = "QuestionController", urlPatterns = {"/QuestionController"})
//public class QuestionController extends HttpServlet {
//
//    private QuestionDAO questionDAO = new QuestionDAO();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//        if (action == null) action = "list";
//
//        switch (action) {
//            case "create":
//                request.getRequestDispatcher("questionDetail.jsp").forward(request, response);
//                break;
//
//            case "edit":
//                int editId = Integer.parseInt(request.getParameter("id"));
//                Question q = questionDAO.getQuestionById(editId);
//                request.setAttribute("question", q);
//                request.getRequestDispatcher("questionDetail.jsp").forward(request, response);
//                break;
//
//            case "delete":
//                int deleteId = Integer.parseInt(request.getParameter("id"));
//                questionDAO.deleteQuestion(deleteId);
//                response.sendRedirect("QuestionController");
//                break;
//
//            default: // list
//                List<Question> list = questionDAO.getActiveQuestions();
//                request.setAttribute("questions", list);
//                request.getRequestDispatcher("questionList.jsp").forward(request, response);
//                break;
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
//                ? 0 : Integer.parseInt(request.getParameter("id"));
//
//        String content = request.getParameter("content");
//        String level = request.getParameter("level");
//        String media = request.getParameter("media");
//        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
//        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
//        int dimensionId = Integer.parseInt(request.getParameter("dimensionId"));
//
//        Question q = new Question(id, content, level, "active", media, subjectId, lessonId, dimensionId);
//
//        if (id == 0) {
//            questionDAO.createQuestion(q);
//        } else {
//            questionDAO.updateQuestion(q);
//        }
//
//        response.sendRedirect("QuestionController");
//    }
//}
