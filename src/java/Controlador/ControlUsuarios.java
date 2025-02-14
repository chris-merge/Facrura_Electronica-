/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import Modelo.*;

/**
 *
 * @author Gerardo
 */
public class ControlUsuarios extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        Usuarios usuarios;
        Roles roles;
        
        UsuariosDAO usuariosDAO = new UsuariosDAO();
        RolesDAO rolesDAO = new RolesDAO();        
        
        try (PrintWriter out = response.getWriter()) {
            RequestDispatcher rd;
            
            if(request.getParameter("mostrar") != null){
               request.setAttribute("DatosRoles", rolesDAO.MostrarRoles());
               request.setAttribute("DatosUsuarios", usuariosDAO.MostrarUsuarios());
           }
             if(request.getParameter("buscar") != null){
                String opc = request.getParameter("rb");
                String texto = request.getParameter("txt");
                request.setAttribute("DatosRoles", rolesDAO.MostrarRoles());
                request.setAttribute("Resultado", usuariosDAO.BuscarUsuarios(opc, texto));
           }
           if(request.getParameter("guardar") != null){
               roles = new Roles(Integer.parseInt(request.getParameter("roles")), "","");
               usuarios = new Usuarios(1, request.getParameter("usernombre"), request.getParameter("usercontraseña"),roles);
               usuariosDAO.InsertarUsuarios(usuarios);
           }
           
           if(request.getParameter("modificar") != null){
               roles = new Roles(Integer.parseInt(request.getParameter("roles")), "","");
               usuarios = new Usuarios(Integer.parseInt(request.getParameter("userid")), request.getParameter("usernombre"), request.getParameter("usercontraseña"),roles);
               usuariosDAO.ModificarUsuarios(usuarios);
           }
           if(request.getParameter("eliminar") != null){
               usuarios = new Usuarios(Integer.parseInt(request.getParameter("userid")), "",  "", null);
               usuariosDAO.EliminarUsuarios(usuarios);
           }                     
           
           rd = request.getRequestDispatcher("VistaUsuarios.jsp");
           rd.forward(request, response);
           
        }     
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
