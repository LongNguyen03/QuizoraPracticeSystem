package Controller;

import DAO.QuizDAO;
import DAO.SubjectDAO;
import Model.Quiz;
import Model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller hiển thị chi tiết môn học
 *
 * @author dangd
 */
@WebServlet(name = "SubjectDetailController", urlPatterns = {"/subject-detail"})
public class SubjectDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            int subjectId = Integer.parseInt(idRaw);

            SubjectDAO subjectDAO = new SubjectDAO();
            Subject subject = subjectDAO.getSubjectDetailById(subjectId);

            if (subject != null) {
                // Lấy danh sách quiz theo subjectId
                QuizDAO quizDAO = new QuizDAO();
                List<Quiz> quizzes = quizDAO.getQuizzesBySubjectId(subjectId);

                // Đặt dữ liệu vào request
                request.setAttribute("subject", subject);
                request.setAttribute("quizzes", quizzes);

                // Chuyển tiếp đến trang chi tiết môn học
                request.getRequestDispatcher("/views/subject/detail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Subject not found.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid subject ID.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Nếu cần xử lý POST như GET
    }

    @Override
    public String getServletInfo() {
        return "Subject Detail Controller";
    }
}
