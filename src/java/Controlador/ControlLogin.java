package Controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import Modelo.*;

public class ControlLogin extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LoginDAO loginDAO = new LoginDAO();

        String usernombre = request.getParameter("usernombre");
        String usercontraseña = request.getParameter("usercontraseña");

        Login login = new Login(usernombre, usercontraseña);
       
       if (loginDAO.ValidarLogin(login)) {
            int userrol = loginDAO.obtenerRolUsuario(login);
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usernombre", usernombre);
            sesion.setAttribute("userrol", userrol);

            if (userrol == 3) { 
                response.sendRedirect("HomeVendedor.jsp");
            } else if (userrol == 2) {
                response.sendRedirect("HomeAdmin.jsp");
            } else {
                response.sendRedirect("Home.jsp"); // Página para otros roles
            }
        }else {
            request.setAttribute("r", "0");
            request.getRequestDispatcher("login.jsp").forward(request, response);
       }
     }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}