package Filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class StudentAuthorizationFilter implements Filter {

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
        // Kiểm tra nếu đã login và role là "Student"
        if (session != null && "Student".equals(session.getAttribute("role"))) {
            // Cho phép tiếp tục request tới servlet/JSP bên trong /student/…
            chain.doFilter(request, response);
        } else {
            // Nếu chưa login hoặc không phải student, chuyển hướng về trang home
            res.sendRedirect(req.getContextPath() + "/views/home.jsp");
        }
    }

    @Override
    public void destroy() {
        // Không có gì cần dọn dẹp thêm
    }
}
