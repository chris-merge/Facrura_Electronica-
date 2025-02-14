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
 * @author Joel
 */
public class Controlinventario extends HttpServlet {

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
        Inventario inventario;
        Proveedores proveedores;
        InventarioDAO inventarioDAO = new InventarioDAO();
        ProveedoresDAO proveedoresDAO = new ProveedoresDAO();
        
        try (PrintWriter out = response.getWriter()) {
             RequestDispatcher rd;
        
        if(request.getParameter("mostrar") != null){
               
               request.setAttribute("DatosProveedores", proveedoresDAO.MostrarProveedores());
               request.setAttribute("DatosInventario", inventarioDAO.MostrarInventario());
           }
         if(request.getParameter("buscar") != null){
                String opc = request.getParameter("rb");
                String texto = request.getParameter("txt");
                request.setAttribute("Resultado", inventarioDAO.BuscarInventario(opc, texto));
           }
         if(request.getParameter("guardar") != null){
               proveedores = new Proveedores(Integer.parseInt(request.getParameter("proveedores")), "", 0,"", null);
               inventario = new Inventario(1, Integer.parseInt(request.getParameter("codproducto")), 
               request.getParameter("nomproducto"),request.getParameter("serie"),request.getParameter("modelo"),Double.parseDouble(request.getParameter("precio_unitario")),
               Integer.parseInt(request.getParameter("cantidad")),proveedores);
               inventarioDAO.InsertarInventario(inventario);
           }
         if(request.getParameter("modificar") != null){
               proveedores = new Proveedores(Integer.parseInt(request.getParameter("proveedores")), "", 0,"", null);
               inventario = new Inventario (Integer.parseInt(request.getParameter("idinventario")), Integer.parseInt(request.getParameter("codproducto")), 
               request.getParameter("nomproducto"),request.getParameter("serie"),request.getParameter("modelo"),Double.parseDouble(request.getParameter("precio_unitario")),
               Integer.parseInt(request.getParameter("cantidad")),proveedores);
               inventarioDAO.ModificarInventario(inventario);
               
           }
           if(request.getParameter("eliminar") != null){
              inventario = new Inventario(Integer.parseInt(request.getParameter("idinventario")),0, "", "", "", 0, 0, null);
              inventarioDAO.EliminarInventario(inventario);
           }
           
           rd = request.getRequestDispatcher("VistaInventarios.jsp");
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
