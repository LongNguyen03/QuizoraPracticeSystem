package Filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class RoleBasedAccessFilter implements Filter {
    
    // Định nghĩa các URL pattern và role được phép truy cập
    private static final Map<String, Set<String>> URL_ROLE_MAPPING = new HashMap<>();
    
    static {
        // Các URL chỉ dành cho Admin
        URL_ROLE_MAPPING.put("/admin", Set.of("Admin"));
        URL_ROLE_MAPPING.put("/admin/", Set.of("Admin"));
        URL_ROLE_MAPPING.put("/admin/dashboard", Set.of("Admin"));
        URL_ROLE_MAPPING.put("/admin/dashboard.jsp", Set.of("Admin"));
        
        // Các URL chỉ dành cho Teacher
        URL_ROLE_MAPPING.put("/teacher", Set.of("Teacher"));
        URL_ROLE_MAPPING.put("/teacher/", Set.of("Teacher"));
        URL_ROLE_MAPPING.put("/teacher/home", Set.of("Teacher"));
        URL_ROLE_MAPPING.put("/teacher/home.jsp", Set.of("Teacher"));
        
        // Các URL chỉ dành cho Student
        URL_ROLE_MAPPING.put("/student", Set.of("Student"));
        URL_ROLE_MAPPING.put("/student/", Set.of("Student"));
        URL_ROLE_MAPPING.put("/student/home", Set.of("Student"));
        URL_ROLE_MAPPING.put("/student/dashboard", Set.of("Student"));
        URL_ROLE_MAPPING.put("/student/dashboard.jsp", Set.of("Student"));
        URL_ROLE_MAPPING.put("/student/home.jsp", Set.of("Student"));
        
        // Các URL chung có thể truy cập bởi nhiều role
        URL_ROLE_MAPPING.put("/quiz", Set.of("Student", "Teacher", "Admin"));
        URL_ROLE_MAPPING.put("/question", Set.of("Teacher", "Admin"));
        URL_ROLE_MAPPING.put("/lesson", Set.of("Student", "Teacher", "Admin"));
        URL_ROLE_MAPPING.put("/profile", Set.of("Student", "Teacher", "Admin"));
        URL_ROLE_MAPPING.put("/users", Set.of("Admin"));
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì thêm
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // Kiểm tra xem URL có cần kiểm tra quyền không
        Set<String> allowedRoles = getRequiredRoles(path);
        
        if (allowedRoles != null) {
            // URL này cần kiểm tra quyền
            if (session != null && session.getAttribute("role") != null) {
                String userRole = (String) session.getAttribute("role");
                if (allowedRoles.contains(userRole)) {
                    // Có quyền truy cập
                    chain.doFilter(request, response);
                } else {
                    // Không có quyền truy cập
                    res.sendRedirect(req.getContextPath() + "/access-denied");
                }
            } else {
                // Chưa đăng nhập
                res.sendRedirect(req.getContextPath() + "/login");
            }
        } else {
            // URL không cần kiểm tra quyền, cho phép truy cập
            chain.doFilter(request, response);
        }
    }
    
    private Set<String> getRequiredRoles(String path) {
        // Kiểm tra exact match trước
        if (URL_ROLE_MAPPING.containsKey(path)) {
            return URL_ROLE_MAPPING.get(path);
        }
        
        // Kiểm tra prefix match
        for (String pattern : URL_ROLE_MAPPING.keySet()) {
            if (path.startsWith(pattern)) {
                return URL_ROLE_MAPPING.get(pattern);
            }
        }
        
        return null; // Không cần kiểm tra quyền
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp gì thêm
    }
} 