package com.elecstore.controller;

import com.elecstore.dao.DAOFactory;
import com.elecstore.dao.UserDAO;
import com.elecstore.model.User;
import com.elecstore.utils.PasswordUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {
    private  static final long serialVersionUID = 1L;
    private UserDAO userDAO = DAOFactory.getInstance().getUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Nếu user đã đăng nhập, redirect tới trang chủ
        if (req.getSession().getAttribute("user") != null) {
            resp.sendRedirect("home");
            return;
        }

        // Forward tới register.jsp
        req.getRequestDispatcher("WEB-INF/views/register.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        JsonObject json = new JsonObject();
        Gson gson = new Gson();

        try {
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String address = req.getParameter("address");
            String city = req.getParameter("city");
            String country = req.getParameter("country");

            if (firstName == null || firstName.trim().isEmpty()) {
                json.addProperty("success", false);
                json.addProperty("message", "Tên không được để trống");
                resp.getWriter().print(json);
                return;
            }

            if (lastName == null || lastName.trim().isEmpty()) {
                json.addProperty("success", false);
                json.addProperty("message", "Họ không được để trống");
                resp.getWriter().print(json);
                return;
            }

            if (firstName.trim().length() < 2) {
                json.addProperty("success", false);
                json.addProperty("message", "Tên phải có ít nhất 2 ký tự");
                resp.getWriter().print(json);
                return;
            }

            if (lastName.trim().length() < 2) {
                json.addProperty("success", false);
                json.addProperty("message", "Họ phải có ít nhất 2 ký tự");
                resp.getWriter().print(json);
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                json.addProperty("success", false);
                json.addProperty("message", "Email không được để trống");
                resp.getWriter().print(json);
                return;
            }

            email = email.trim().toLowerCase();

            if (!isValidEmail(email)) {
                json.addProperty("success", false);
                json.addProperty("message", "Email không hợp lệ");
                resp.getWriter().print(json);
                return;
            }

            if (userDAO.isEmailExists(email)) {
                json.addProperty("success", false);
                json.addProperty("message", "Email này đã được sử dụng. Vui lòng chọn email khác");
                resp.getWriter().print(json);
                return;
            }

            if (phone != null && !phone.trim().isEmpty()) {
                phone = phone.trim();
                if (!isValidPhone(phone)) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Số điện thoại phải có 10-11 chữ số");
                    resp.getWriter().print(json);
                    return;
                }
            } else {
                phone = null;
            }

            if (password == null || password.isEmpty()) {
                json.addProperty("success", false);
                json.addProperty("message", "Mật khẩu không được để trống");
                resp.getWriter().print(json);
                return;
            }

            if (password.length() < 6) {
                json.addProperty("success", false);
                json.addProperty("message", "Mật khẩu phải có ít nhất 6 ký tự");
                resp.getWriter().print(json);
                return;
            }

            if (!password.equals(confirmPassword)) {
                json.addProperty("success", false);
                json.addProperty("message", "Mật khẩu xác nhận không trùng khớp");
                resp.getWriter().print(json);
                return;
            }

            // ===== CREATE NEW USER =====
            User newUser = new User();
            newUser.setFirstName(firstName.trim());
            newUser.setLastName(lastName.trim());
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setPassword(PasswordUtil.hashPassword(password));
            newUser.setAddress(address != null ? address.trim() : null);
            newUser.setCity(city != null ? city.trim() : null);
            newUser.setCountry(country != null ? country.trim() : "Việt Nam");
            newUser.setRole("user");
            newUser.setStatus("active");

            // ===== SAVE TO DATABASE =====
            System.out.println("[REGISTER] Đang lưu user vào database...");
            boolean isRegistered = userDAO.save(newUser);

            if (isRegistered) {
                System.out.println("[REGISTER] ✓ User đăng ký thành công: " + email);
                req.getSession().setAttribute("registerSuccess",
                        "✓ Đăng ký thành công! Vui lòng đăng nhập.");
                resp.sendRedirect("login?email=" + email);
            } else {
                System.out.println("[REGISTER] ✗ Lỗi: insertRow trả về false");
                req.setAttribute("error", "❌ Đăng ký thất bại. Vui lòng thử lại");
                req.getRequestDispatcher("WEB-INF/views/register.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            System.err.println("[REGISTER] ❌ SQLException: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "❌ Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                req.getRequestDispatcher("WEB-INF/views/register.jsp").forward(req, resp);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        } catch (Exception e) {
            System.err.println("[REGISTER] ❌ Exception: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "❌ Đã xảy ra lỗi: " + e.getMessage());
            try {
                req.getRequestDispatcher("WEB-INF/views/register.jsp").forward(req, resp);
            } catch (ServletException | IOException e1) {
                e1.printStackTrace();
            }
        }

    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        return email.matches(emailRegex);
    }

    private boolean isValidPhone(String phone) {
        return phone.matches("^\\d{10,11}$");
    }
}
