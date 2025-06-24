package Controller;

import DAO.SubjectDAO;
import Model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ DAO
            SubjectDAO subjectDao = new SubjectDAO();
            List<Subject> subjects = subjectDao.getAllSubjects();

            // 2. Đưa vào request
            request.setAttribute("subjects", subjects);

            // 3. Forward đến JSP
            request.getRequestDispatcher("/views/home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, vẫn forward đến home.jsp nhưng không có data
            request.getRequestDispatcher("/views/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu bạn không dùng POST cho home thì có thể chỉ redirect về GET
        doGet(request, response);
    }
}
