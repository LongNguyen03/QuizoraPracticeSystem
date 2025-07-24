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
            // Giả sử admin đã đăng nhập và lưu trong session với key "adminId"
            Integer responderId = (Integer) session.getAttribute("adminId");
            if (feedbackIdStr != null && responderId != null && content != null && !content.trim().isEmpty()) {
                int feedbackId = Integer.parseInt(feedbackIdStr);
                // Check feedback status before allowing reply
                Feedback fb = feedbackDAO.getAllFeedbacks().stream().filter(f -> f.getId() == feedbackId).findFirst().orElse(null);
                if (fb != null && "Pending".equalsIgnoreCase(fb.getStatus())) {
                    FeedbackReply reply = new FeedbackReply();
                    reply.setFeedbackId(feedbackId);
                    reply.setResponderId(responderId);
                    reply.setContent(content);
                    FeedbackReplyDAO replyDAO = new FeedbackReplyDAO();
                    replyDAO.addReply(reply);
                    session.setAttribute("adminFeedbackSuccess", "Đã gửi phản hồi tới giáo viên!");
                } else {
                    session.setAttribute("adminFeedbackError", "Chỉ có thể phản hồi khi trạng thái là Pending!");
                }
            } else {
                session.setAttribute("adminFeedbackError", "Thiếu thông tin phản hồi hoặc chưa đăng nhập!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/feedback");
    }
} 