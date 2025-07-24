package Controller;

import DAO.FeedbackDAO;
import Model.Feedback;
import Model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherFeedbackServlet", urlPatterns = {"/teacher/feedback"})
public class TeacherFeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbackList = feedbackDAO.getFeedbacksByAccountId(account.getId());
        // Fetch replies for each feedback
        DAO.FeedbackReplyDAO replyDAO = new DAO.FeedbackReplyDAO();
        java.util.Map<Integer, java.util.List<Model.FeedbackReply>> feedbackRepliesMap = new java.util.HashMap<>();
        for (Feedback fb : feedbackList) {
            java.util.List<Model.FeedbackReply> replies = replyDAO.getRepliesByFeedbackId(fb.getId());
            feedbackRepliesMap.put(fb.getId(), replies);
        }
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("feedbackRepliesMap", feedbackRepliesMap);
        request.getRequestDispatcher("/teacher/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String content = request.getParameter("content");
        if (content != null && !content.trim().isEmpty()) {
            Feedback feedback = new Feedback();
            feedback.setAccountId(account.getId());
            feedback.setContent(content.trim());
            feedback.setStatus("Pending");
            feedbackDAO.addFeedback(feedback);
            // Có thể set thông báo vào session hoặc query string
            session.setAttribute("feedbackSuccess", "Gửi phản hồi thành công!");
        }
        response.sendRedirect(request.getContextPath() + "/teacher/home.jsp");
    }
} 