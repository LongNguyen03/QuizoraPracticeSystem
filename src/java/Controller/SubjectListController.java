package Controller;

import DAO.SubjectDAO;
import Model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubjectListController", urlPatterns = {"/all-subjects"})
public class SubjectListController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int page = 1;
        int size = 9; // Số subject mỗi trang
        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr); } catch (Exception ignored) {}
        }

        SubjectDAO subjectDao = new SubjectDAO();
        int offset = (page - 1) * size;
        List<Subject> subjects = subjectDao.getSubjectsPaging(offset, size, search);
        int totalSubjects = subjectDao.countSubjects(search);
        int totalPages = (int) Math.ceil(totalSubjects * 1.0 / size);

        request.setAttribute("subjects", subjects);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search == null ? "" : search);

        request.getRequestDispatcher("/views/subject/subject-list.jsp").forward(request, response);
    }
}
