package Filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class TeacherAuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì thêm ở đây
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        // Kiểm tra nếu đã login và role là "Teacher"
        if (session != null && "Teacher".equals(session.getAttribute("role"))) {
            // Cho phép tiếp tục request tới servlet/JSP bên trong /teacher/…
            chain.doFilter(request, response);
        } else {
            // Nếu chưa login hoặc không phải teacher, chuyển hướng đến servlet access-denied
            res.sendRedirect(req.getContextPath() + "/access-denied");
        }
    }

    @Override
    public void destroy() {
        // Không có gì cần dọn dẹp thêm
    }
}
