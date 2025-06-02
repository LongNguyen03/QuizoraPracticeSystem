/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.QuestionDAO;
import Model.Question;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author kan3v
 */
@WebServlet("/imageUrl")
public class ImageUrlServlet extends HttpServlet {
    private QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Question question = questionDAO.getQuestionById(id);

        if (question != null && question.getImageUrl() != null) {
            byte[] imageData = question.getImageUrl();
            // Giả sử ảnh là PNG, bạn có thể thêm kiểm tra MIME type nếu lưu metadata
            response.setContentType("image/png");
            response.setContentLength(imageData.length);
            response.getOutputStream().write(imageData);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // hoặc ảnh mặc định
        }
    }
}



