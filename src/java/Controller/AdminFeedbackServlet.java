package Controller;

import DAO.FeedbackDAO;
import DAO.FeedbackReplyDAO;
import Model.Feedback;
import Model.FeedbackReply;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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
        // Lấy danh sách phản hồi cho từng feedback
        FeedbackReplyDAO replyDAO = new FeedbackReplyDAO();
        Map<Integer, List<FeedbackReply>> feedbackRepliesMap = new HashMap<>();
        for (Feedback fb : feedbackList) {
            List<FeedbackReply> replies = replyDAO.getRepliesByFeedbackId(fb.getId());
            feedbackRepliesMap.put(fb.getId(), replies);
        }
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("feedbackRepliesMap", feedbackRepliesMap);
        request.getRequestDispatcher("/admin/feedback_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        HttpSession session = request.getSession();
        // Ensure adminId is set in session if role is Admin
        if (session.getAttribute("adminId") == null && "Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            Object accountId = session.getAttribute("accountId");
            if (accountId != null) {
                session.setAttribute("adminId", accountId);
            }
        }
        if ("approve".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            feedbackDAO.updateFeedbackStatus(id, "Approve");
            session.setAttribute("adminFeedbackSuccess", "Đã duyệt phản hồi!");
        } else if ("reject".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            feedbackDAO.updateFeedbackStatus(id, "Reject");
            session.setAttribute("adminFeedbackSuccess", "Đã từ chối phản hồi!");
        } else if ("reply".equals(action)) {
            String feedbackIdStr = request.getParameter("feedbackId");
            String content = request.getParameter("replyContent");
            Integer responderId = (Integer) session.getAttribute("adminId");
            // Fallback: if adminId is still null, try accountId
            if (responderId == null && session.getAttribute("accountId") != null) {
                responderId = (Integer) session.getAttribute("accountId");
            }
            if (feedbackIdStr != null && responderId != null && content != null && !content.trim().isEmpty()) {
                int feedbackId = Integer.parseInt(feedbackIdStr);
                FeedbackReply reply = new FeedbackReply();
                reply.setFeedbackId(feedbackId);
                reply.setResponderId(responderId);
                reply.setContent(content);
                FeedbackReplyDAO replyDAO = new FeedbackReplyDAO();
                replyDAO.addReply(reply);
                session.setAttribute("adminFeedbackSuccess", "Đã gửi phản hồi tới giáo viên!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }
} 