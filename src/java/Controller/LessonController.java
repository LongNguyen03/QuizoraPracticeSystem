package Controller;

import DAO.LessonDAO;
import DAO.SubjectDAO;
import Model.Lesson;
import Model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/lesson")
public class LessonController extends HttpServlet {
    private LessonDAO lessonDAO;
    private SubjectDAO subjectDAO;

    @Override
    public void init() throws ServletException {
        lessonDAO = new LessonDAO();
        subjectDAO = new SubjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "detail":
                    showDetail(request, response);
                    break;
                case "delete":
                    deleteLesson(request, response);
                    break;
                default:
                    showList(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý yêu cầu");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword     = request.getParameter("keyword");
        String dimension   = request.getParameter("dimension");
        String subjectIdParam = request.getParameter("subjectId");

        int subjectId = 0;
        if (subjectIdParam != null && !subjectIdParam.isEmpty()) {
            try { subjectId = Integer.parseInt(subjectIdParam); }
            catch (NumberFormatException ignored) {}
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountId") == null ||
            session.getAttribute("role") == null ||
            !"Teacher".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int teacherId = (int) session.getAttribute("accountId");
        List<Lesson> lessons = lessonDAO.getAllLessons(subjectId, keyword, dimension);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<String> dimensionList = lessonDAO.getAllDimensions();
        request.setAttribute("dimensionList", dimensionList);

        request.setAttribute("lessons", lessons);
        request.setAttribute("subjects", subjects);
        request.setAttribute("subjectId", subjectId);
        request.setAttribute("keyword", keyword);
        request.setAttribute("dimension", dimension);

        request.getRequestDispatcher("teacher/LessonList.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Lesson lesson = null;

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            lesson = lessonDAO.getLessonById(id);
            request.setAttribute("formAction", "edit");
        } else {
            request.setAttribute("formAction", "create");
        }

        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<String> dimensionList = lessonDAO.getAllDimensions();
        request.setAttribute("dimensionList", dimensionList);
        request.setAttribute("subjects", subjects);
        request.setAttribute("lesson", lesson);
        request.getRequestDispatcher("teacher/LessonDetail.jsp").forward(request, response);
    }

    private void deleteLesson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            lessonDAO.deleteLesson(id);
            response.sendRedirect("lesson?action=list&subjectId=" + subjectId);
        } catch (NumberFormatException e) {
            response.sendRedirect("lesson?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String title     = request.getParameter("title");
            String content   = request.getParameter("content");
            String dimension = request.getParameter("dimension");
            String status    = request.getParameter("status");

            Lesson lesson = new Lesson();
            lesson.setId(id);
            lesson.setSubjectId(subjectId);
            lesson.setTitle(title);
            lesson.setContent(content);
            lesson.setDimension(dimension);
            lesson.setStatus(status);

            if (id > 0) {
                lesson.setUpdatedAt(new Date());
                lessonDAO.updateLesson(lesson);
            } else {
                lesson.setCreatedAt(new Date());
                lessonDAO.addLesson(lesson);
            }

            response.sendRedirect("lesson?action=list&subjectId=" + subjectId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi lưu bài học");
        }
    }
}

