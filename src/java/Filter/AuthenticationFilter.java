package Filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    private static final String[] PUBLIC_PATHS = {
        "/login.jsp", "/login", "/register.jsp", "/register",
        "/views/login.jsp", "/views/register.jsp", "/views/home.jsp",
        "/css/", "/js/", "/images/", "/index.jsp",
        "/student/", "/teacher/", "/admin/", "/send-otp"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì thêm
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        boolean isPublic = false;
        for (String p : PUBLIC_PATHS) {
            if (path.startsWith(p)) {
                isPublic = true;
                break;
            }
        }

        HttpSession session = req.getSession(false);
        if (isPublic || (session != null && session.getAttribute("accountId") != null)) {
            // Nếu là guest và cố truy cập các trang cần quyền
            if (session != null && "guest".equals(session.getAttribute("role"))) {
                if (path.startsWith("/admin/") || path.startsWith("/teacher/") || 
                    path.startsWith("/student/") || path.startsWith("/quiz/") || 
                    path.startsWith("/exam/")) {
                    res.sendRedirect(req.getContextPath() + "/views/home.jsp");
                    return;
                }
            }
            chain.doFilter(request, response);
        } else {
            // Nếu chưa đăng nhập, tạo session guest
            if (session == null) {
                session = req.getSession();
                session.setAttribute("role", "guest");
            }
            res.sendRedirect(req.getContextPath() + "/views/home.jsp");
        }
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp gì thêm
    }
}