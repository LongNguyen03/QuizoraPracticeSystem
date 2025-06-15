//package Controller;
//
//import DAO.SubjectCategoryDAO;
//import DAO.SubjectDAO;
//import Model.Subject;
//import Model.SubjectCategory;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//
//import java.io.IOException;
//import java.util.List;
//
//@WebServlet(name = "HomeController", urlPatterns = {"/home"})
//public class HomeController extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // 1. Lấy dữ liệu từ DAO
//        SubjectCategoryDAO categoryDao = new SubjectCategoryDAO();
//        SubjectDAO subjectDao = new SubjectDAO();
//
//        List<SubjectCategory> categories = categoryDao.getAllCategories();
//        List<Subject> latestSubjects = subjectDao.getAllSubjectsWithCategory();
//
//        // 2. Đưa vào request
//        request.setAttribute("categories", categories);
//        request.setAttribute("latestSubjects", latestSubjects);
//
//        // 3. Forward đến JSP
//        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // Nếu bạn không dùng POST cho home thì có thể chỉ redirect về GET
//        doGet(request, response);
//    }
//}
