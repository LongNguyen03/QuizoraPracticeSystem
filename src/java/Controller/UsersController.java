/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import Model.Account;
import DAO.AccountDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UsersController", urlPatterns = {"/admin/users"})
public class UsersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            // Hiển thị danh sách user
            List<Account> userList = AccountDAO.getAllUsers();
            request.setAttribute("userList", userList);
            request.getRequestDispatcher("/admin/userList.jsp").forward(request, response);
        } else if (action.equals("ban")) {
            handleBanUnban(request, response, "banned");
        } else if (action.equals("unban")) {
            handleBanUnban(request, response, "active");
        } else if (action.equals("delete")) {
            handleDelete(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleBanUnban(HttpServletRequest request, HttpServletResponse response, String status) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            AccountDAO.updateUserStatus(id, status);
        }
        response.sendRedirect("/admin/users?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            AccountDAO.updateUserStatus(id, "deleted");
        }
        response.sendRedirect("/admin/users?action=list");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
