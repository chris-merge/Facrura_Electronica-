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
public class ControlDetalle extends HttpServlet {

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
        Detalles detalles;
        Inventario inventario;
        Clientes clientes;
        DetallesDAO detallesDAO = new DetallesDAO();
        InventarioDAO inventarioDAO = new InventarioDAO();
        ClientesDAO clientesDAO = new ClientesDAO();
        MisfacturasDAO misfacturasDAO = new MisfacturasDAO();
        try (PrintWriter out = response.getWriter()) {
            RequestDispatcher rd;
            
            if(request.getParameter("mostrar") != null){
                 request.setAttribute("DatosDetalles", detallesDAO.MostrarDetalles()); 
                 request.setAttribute("DatosInventario", inventarioDAO.MostrarInventario());
                 request.setAttribute("DatosClientes", clientesDAO.MostrarClientes());
                 request.setAttribute("DatosMisfacturas", misfacturasDAO.MostrarMisfacturas());
              
           }
            if(request.getParameter("guardar") != null){
               inventario = new Inventario(Integer.parseInt(request.getParameter("inventario")), Integer.parseInt(request.getParameter("codproducto")),"","", "",Double.parseDouble(request.getParameter("precio_unitario")), Integer.parseInt(request.getParameter("cantidad")),null);
               detalles = new Detalles(1, Integer.parseInt(request.getParameter("cantidad")),Integer.parseInt(request.getParameter("id_venta")),Double.parseDouble(request.getParameter("precio")),Double.parseDouble(request.getParameter("subtotal")),inventario);
              detallesDAO.InsertarDetalles(detalles);
               //clientes = new Clientes(Integer.parseInt(request.getParameter("clientes")), "","",Integer.parseInt(request.getParameter("telefono")),Integer.parseInt(request.getParameter("dui")),"");
           }
            if(request.getParameter("modificar") != null){
               inventario = new Inventario (Integer.parseInt(request.getParameter("inventario")), 0, "","","",0, 0,null);
               detalles = new Detalles(Integer.parseInt(request.getParameter("id_detalle")), Integer.parseInt(request.getParameter("cantidad")),Integer.parseInt(request.getParameter("id_venta")),Double.parseDouble(request.getParameter("precio")),Double.parseDouble(request.getParameter("subtotal")),inventario);
               detallesDAO.ModificarDetalles(detalles);
               
           }
           if(request.getParameter("eliminar") != null){
              // proveedores = new Proveedores(Integer.parseInt(request.getParameter("idproveedores")), "", Integer.parseInt(request.getParameter("telproveedor")), "", null);
              // proveedoresDAO.EliminarProveedores(proveedores);
              detalles = new Detalles(Integer.parseInt(request.getParameter("id_detalle")),0, 0, 0,0, null);
             detallesDAO.EliminarDetalles(detalles);
           }           

           rd = request.getRequestDispatcher("VistaDetalles.jsp");
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
