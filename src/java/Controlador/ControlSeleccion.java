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
import org.json.JSONObject;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Gerardo
 */
public class ControlSeleccion extends HttpServlet {

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
         Clientes clientes;
                  
         ClientesDAO clientesDAO = new ClientesDAO();

         try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            
            RequestDispatcher rd;
           if(request.getParameter("mostrar") != null){
               request.setAttribute("DatosClientes", clientesDAO.MostrarClientes());
          
           //rd = request.getRequestDispatcher("VistaSeleccion.jsp");
          // rd.forward(request, response);
           }
           

           if (request.getParameter("guardar") != null) {
           // Crear el objeto Clientes con los parámetros correctos
           clientes = new Clientes(
           0,  
           request.getParameter("nombre"),
           request.getParameter("direccion"),
           Integer.parseInt(request.getParameter("telefono")),      
           Integer.parseInt(request.getParameter("dui")),
           request.getParameter("correo")
       
           );

            // Llamar al método insertar del DAO
             clientesDAO.InsertarClientes(clientes);
}
           
           if(request.getParameter("modificar") != null){
               clientes = new Clientes(Integer.parseInt(request.getParameter("idcliente")), request.getParameter("nombre"),request.getParameter("direccion"),Integer.parseInt(request.getParameter("telefono")),Integer.parseInt(request.getParameter("dui")), request.getParameter("correo"));
               clientesDAO.ModificarClientes(clientes);
           }
           
           if(request.getParameter("eliminar") != null){
               clientes = new Clientes(Integer.parseInt(request.getParameter("idcliente")), "","",0,0, "");
               clientesDAO.EliminarClientes(clientes);
           }
           
           String action = request.getParameter("action");
        
        if ("guardarfactura".equals(action)) {
            int idcliente = Integer.parseInt(request.getParameter("clienteid"));
            clientes = new Clientes(idcliente);
            
              boolean success = clientesDAO.guardarfactura(clientes);
            if (success) {
                request.setAttribute("mensaje", "Producto guardado correctamente en la nueva tabla.");
            } else {
                request.setAttribute("error", "Error al guardar el producto.");
            }
        } 
        
        if (request.getParameter("envio") != null){
        //lista de clientes
       int id = Integer.parseInt(request.getParameter("id_detalle"));
       Clientes listaClientes = clientesDAO.BuscarClientes(id);
       ArrayList<Clientes> Busqueda= new ArrayList<Clientes>();
       Busqueda.add(listaClientes);
        
        Map<String, Object>Datos=new HashMap<>();
        Datos.put("envio",Busqueda);
        //convierte el mapa a JSON
        Gson gson = new Gson();
        String json = gson.toJson(Datos);        
        //
        out.print(json);
        out.flush();
        
        request.getRequestDispatcher("VistaDetalles.jsp").forward(request,response);
        }                
      rd = request.getRequestDispatcher("VistaSeleccion.jsp");
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
