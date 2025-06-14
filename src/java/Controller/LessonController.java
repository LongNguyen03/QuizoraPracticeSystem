/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
/**
 *
 * @author kan3v
 */
package Controller;

import DAO.LessonDAO;
import Model.Lesson;
import Model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/lesson")
public class LessonController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        LessonDAO dao = new LessonDAO();

        try {
            switch (action) {
                case "detail":
                    showDetail(request, response, dao);
                    break;
                case "delete":
                    deleteLesson(request, response, dao);
                    break;
                default:
                    showList(request, response, dao);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý yêu cầu");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response, LessonDAO dao)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String dimension = request.getParameter("dimension");
        String subjectIdParam = request.getParameter("subjectId");

        int subjectId = 0;
        if (subjectIdParam != null && !subjectIdParam.isEmpty()) {
            try {
                subjectId = Integer.parseInt(subjectIdParam);
            } catch (NumberFormatException e) {
                subjectId = 0;
            }
        }

        List<Lesson> lessons = dao.getAllLessons(subjectId, keyword, dimension);

        request.setAttribute("lessons", lessons);
        request.setAttribute("subjectId", subjectId);
        request.setAttribute("keyword", keyword);
        request.setAttribute("dimension", dimension);

        request.getRequestDispatcher("LessonList.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response, LessonDAO dao)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Lesson lesson = null;

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            lesson = dao.getLessonById(id);
            request.setAttribute("formAction", "edit");
        } else {
            request.setAttribute("formAction", "create");
        }

        // Lấy danh sách subjects từ chính LessonDAO
        List<Subject> subjects = dao.getAllSubjects();
        request.setAttribute("subjects", subjects);

        request.setAttribute("lesson", lesson);
        request.getRequestDispatcher("LessonDetail.jsp").forward(request, response);
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response, LessonDAO dao)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            dao.deleteLesson(id);
            response.sendRedirect("lesson?action=list&subjectId=" + subjectId);
        } catch (NumberFormatException e) {
            response.sendRedirect("lesson?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        LessonDAO dao = new LessonDAO();

        try {
            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String dimension = request.getParameter("dimension");
            String status = request.getParameter("status");

            Lesson lesson = new Lesson();
            lesson.setId(id);
            lesson.setSubjectId(subjectId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setDimension(dimension);
            lesson.setStatus(status);

            if (id > 0) {
                lesson.setUpdatedAt(new Date());
                dao.updateLesson(lesson);
            } else {
                lesson.setCreatedAt(new Date());
                dao.addLesson(lesson);
            }

            response.sendRedirect("lesson?action=list&subjectId=" + subjectId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi lưu bài học");
        }
    }
}
