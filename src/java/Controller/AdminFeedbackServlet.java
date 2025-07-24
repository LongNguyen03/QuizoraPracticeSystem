package Controller;

import DAO.FeedbackDAO;
import Model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminFeedbackServlet", urlPatterns = {"/admin/feedback"})
public class AdminFeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Feedback> feedbackList = feedbackDAO.getAllFeedbacks();
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("/admin/feedback_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        if ("resolve".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            feedbackDAO.updateFeedbackStatus(id, "Resolved");
            request.getSession().setAttribute("adminFeedbackSuccess", "Đã đánh dấu phản hồi là đã xử lý!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }
} 