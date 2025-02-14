/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import Modelo.Clientes;
import Modelo.ClientesDAO;
import Modelo.Detalles;
import Modelo.DetallesDAO;
import Modelo.Misfacturas;
import Modelo.MisfacturasDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Gerardo
 */
public class ControlFacturas extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            
            
                    // Leer el JSON del cuerpo de la solicitud
        StringBuilder jsonBuffer = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        // Convertir el JSON a un objeto
        JSONObject json = new JSONObject(jsonBuffer.toString());
        System.out.println("Datos recibidos: " + json.toString());

        // Procesar los datos del formulario
        String idFactura = json.getString("idfactura");
        String codFactura = json.getString("codfactura");
        String nombre = json.getString("nombre");
        String idCliente = json.getString("idcliente");
        String nit = json.getString("nit");
        String fecha = json.getString("datetime");
        String vendedor = "GERARDO";
        // Procesar otros datos del formulario...
        String id = "";
        String codProducto = "";
        String nombreProducto  = "";
        String cantidad =  "";
        String precioUnitario  = "";
        String subtotal =  "";

        // Procesar los detalles
        JSONArray detalles = json.getJSONArray("detalles");
        for (int i = 0; i < detalles.length(); i++) {
            JSONObject detalle = detalles.getJSONObject(i);
             id = detalle.getString("id");
             codProducto = detalle.getString("codProducto");
             nombreProducto = detalle.getString("nombreProducto");
             cantidad = detalle.getString("cantidad");
             precioUnitario = detalle.getString("precioUnitario");
             subtotal = detalle.getString("subtotal");

            // Guardar o procesar cada detalle...
        }
        //
       
        // Responder al cliente
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\"}");
    Detalles detalle;
        Clientes clientes;
        Misfacturas misfacturas;
        
        DetallesDAO detallesDAO = new DetallesDAO();
        ClientesDAO clientesDAO = new ClientesDAO();
        MisfacturasDAO misfacturasDAO = new MisfacturasDAO();
        
        //misfacturas = new Misfacturas(Integer.parseInt(iddetalle),codFactura,vendedor,Double.parseDouble( subtotal),Integer.parseInt(nit) ,fecha,Integer.parseInt(id),Integer.parseInt(idCliente));
       // misfacturasDAO.InsertarMisfacturas(misfacturas);


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
