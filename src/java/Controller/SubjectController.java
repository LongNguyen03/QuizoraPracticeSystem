package Controller;

import DAO.SubjectDAO;
import Model.Subject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "SubjectController", urlPatterns = {"/admin/subjects", "/admin/subject/create", "/admin/subject/edit", "/admin/subject/delete", "/admin/subject/toggle"})
public class SubjectController extends HttpServlet {
    private SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/admin/subjects")) {
            List<Subject> subjects = subjectDAO.getAllSubjects();
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("/admin/subjectList.jsp").forward(request, response);
        } else if (uri.endsWith("/admin/subject/create")) {
            request.setAttribute("action", "create");
            request.getRequestDispatcher("/admin/subjectForm.jsp").forward(request, response);
        } else if (uri.endsWith("/admin/subject/edit")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Subject subject = subjectDAO.getSubjectById(id);
                request.setAttribute("subject", subject);
                request.setAttribute("action", "edit");
                request.getRequestDispatcher("/admin/subjectForm.jsp").forward(request, response);
            } else {
                response.sendRedirect("/admin/subjects");
            }
        } else if (uri.endsWith("/admin/subject/delete")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                subjectDAO.deleteSubject(id);
            }
            response.sendRedirect("/admin/subjects");
        } else if (uri.endsWith("/admin/subject/toggle")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Subject subject = subjectDAO.getSubjectById(id);
                if (subject != null) {
                    String newStatus = "active".equals(subject.getStatus()) ? "inactive" : "active";
                    subject.setStatus(newStatus);
                    subject.setUpdatedAt(new Date());
                    subjectDAO.updateSubject(subject);
                }
            }
            response.sendRedirect("/admin/subjects");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/admin/subject/create")) {
            Subject s = new Subject();
            String title = request.getParameter("title");
            if (subjectDAO.isSubjectTitleExists(title)) {
                request.setAttribute("error", "Tên môn học đã tồn tại, vui lòng chọn tên khác!");
                request.setAttribute("action", "create");
                request.getRequestDispatcher("/admin/subjectForm.jsp").forward(request, response);
                return;
            }
            s.setTitle(title);
            s.setTagline(request.getParameter("tagline"));
            Integer ownerId = (Integer) request.getSession().getAttribute("accountId");
            if (ownerId != null) {
                s.setOwnerId(ownerId);
            }
            s.setStatus(request.getParameter("status"));
            s.setDescription(request.getParameter("description"));
            s.setCreatedAt(new Date());
            s.setUpdatedAt(new Date());
            s.setThumbnailUrl(request.getParameter("thumbnailUrl"));
            subjectDAO.insertSubject(s);
            response.sendRedirect("/admin/subjects");
        } else if (uri.endsWith("/admin/subject/edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Subject s = subjectDAO.getSubjectById(id);
            if (s != null) {
                s.setTitle(request.getParameter("title"));
                s.setTagline(request.getParameter("tagline"));
                s.setStatus(request.getParameter("status"));
                s.setDescription(request.getParameter("description"));
                s.setUpdatedAt(new Date());
                s.setThumbnailUrl(request.getParameter("thumbnailUrl"));
                subjectDAO.updateSubject(s);
            }
            response.sendRedirect("/admin/subjects");
        }
    }
} 