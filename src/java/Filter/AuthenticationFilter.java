package Filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    private static final String[] PUBLIC_PATHS = {
        "/login.jsp", "/login", "/register.jsp", "/register",
        "/views/login.jsp", "/views/register.jsp", "/views/home.jsp",
        "/css/", "/js/", "/images/", "/uploads/", "/lib/",
        "/send-otp", "/verify-otp", "/forgot-password", "/reset-password",
        "/index.html", "/index.jsp", "/register.jsp", "/access-denied.jsp", "/access-denied"
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
        
        // Nếu là public path, cho phép truy cập
        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra authentication cho các path khác
        if (session != null && session.getAttribute("accountId") != null) {
            // Đã đăng nhập, cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập, chuyển hướng về login
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp gì thêm
    }
}