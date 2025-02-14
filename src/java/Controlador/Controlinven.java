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
public class Controlinven extends HttpServlet {

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
        Inven inven;
        Proveedores proveedores;
        Detalles detalles;
        
        InvenDAO invenDAO = new InvenDAO();
        InventarioDAO inventarioDAO = new InventarioDAO();
        ProveedoresDAO proveedoresDAO = new ProveedoresDAO();
        DetallesDAO detallesDAO = new DetallesDAO();
        
        try (PrintWriter out = response.getWriter()) {
             RequestDispatcher rd;
        
        if(request.getParameter("mostrar") != null){
               
               request.setAttribute("DatosProveedores", proveedoresDAO.MostrarProveedores());
               request.setAttribute("DatosInventario", inventarioDAO.MostrarInventario());
           }
        
          String action = request.getParameter("action");
        
        if ("guardarfactura".equals(action)) {
            // Insertar el producto en otra tabla
            int idinventario = Integer.parseInt(request.getParameter("idinventario"));
            double precioUnitario = Double.parseDouble(request.getParameter("precio_unitario"));
            int cantidad = Integer.parseInt(request.getParameter("cantidaddetalles"));
            double subtotal = Double.parseDouble(request.getParameter("subtotal"));
            inven = new Inven(idinventario, precioUnitario, cantidad, subtotal);
            
              boolean success = invenDAO.guardarfactura(inven);
            if (success) {
                request.setAttribute("mensaje", "Producto guardado correctamente en la nueva tabla.");
            } else {
                request.setAttribute("error", "Error al guardar el producto.");
            }
        } 
       
           rd = request.getRequestDispatcher("VistaInven.jsp");
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
