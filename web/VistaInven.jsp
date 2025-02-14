<%-- 
    Document   : VistaInventarios
    Created on : 2 nov 2024, 1:50:55 a. m.
    Author     : Joel
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Inventario</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <link href="css/home.css" rel="stylesheet" type="text/css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <!-- Agrega los archivos de DataTables -->
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    </head>
    <body style="background-color: #A9CCE3;">
        <%
        HttpSession sesion = request.getSession();
        String usr = "";
        String rol = "";

        if (sesion.getAttribute("usernombre") != null && sesion.getAttribute("userrol") != null) {
            usr = sesion.getAttribute("usernombre").toString();
            rol = sesion.getAttribute("userrol").toString();
            
            if (!rol.equals("1") && !rol.equals("3")) {
                response.sendRedirect("HomeVendedor.jsp"); // Redirige si no es administrador
                return;
            }
        } else {
            response.sendRedirect("login.jsp"); // Si no hay sesión, redirige a login
            return;
        }

        if (request.getParameter("c") != null) {
            sesion.removeAttribute("s");
            sesion.invalidate();
            response.sendRedirect("login.jsp");
        }

        if (request.getParameter("action") != null && request.getParameter("action").equals("logout")) {
            sesion.invalidate(); // Invalida la sesión
            response.sendRedirect("login.jsp"); // Redirige a la página de inicio de sesión
        }
    %>
        
        <nav class="navbar navbar-expand-sm bg-dark navbar-dark">
           <div class="container-fluid">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="Home.jsp" style="color: white">Inicio</a>
                    </li>
                    <li class="nav-item">
                       <a class="nav-link" href="VistaDetalles.jsp" style="color: white">Volver a Factura</a>
                    </li>
                  <a type="btn" class="cerrar-sesion" href="?action=logout">Cerrar sesión</a>              
                </ul>
            </div>
        </nav>

        <%
            ArrayList<Proveedores> listaProveedores = new ArrayList<Proveedores>();
            ArrayList<Inventario> listaInventario = new ArrayList<Inventario>();
            try {
            if(request.getAttribute("DatosInventario") != null){
               listaProveedores.addAll((Collection)request.getAttribute("DatosProveedores"));
               listaInventario.addAll((Collection)request.getAttribute("DatosInventario"));
            } 
               
            else if(request.getAttribute("Resultado") != null){                           
                listaProveedores.addAll((Collection)request.getAttribute("DatosProveedores"));
                listaInventario.addAll((Collection)request.getAttribute("Resultado"));  
            }   
            else 
                response.sendRedirect("Controlinven?mostrar");
            
            } catch(Exception ex) {
                // Error handling
            }
        %>

        <h2 style="float: left;"> 
            <img width="130" height="100" src="imagen/logo.png">
        </h2>
        <% for(Inventario i : listaInventario) { %>
        <div class="modal fade" id="modalMarcas" tabindex="-1" aria-labelledby="MarcaModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">   
                    <div class="modal-header">
                        <h5 class="modal-title" id="MarcaModalLabel">Cantidad</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="Controlinven" method="POST">
                       <%-- <form form="marcasForm" action="Controlinven" method="post" id="marcasForm" autocomplete="off">
                             <input type="hidden" name="idinventario" id="idinventario"/> --%>
                                <div class="col-md-11">
                                    <label for="nommarcas" > <b>Cantidad </b></label>
                                    <input type="hidden" name="idinventario" id="idinventario"/>
                                    <input type="hidden" name="codigo" id="codigo"/>
                                    <input type="hidden" name="nombre" id="nombre"/>
                                    <input type="hidden" name="precio_unitario" id="precio_unitario" class="form-control" min="0" step="0.01"/>
                                    <input type="number" name="cantidaddetalles" id="cantidaddetalles" class="form-control" placeholder="Digite la Cantidad"  required oninput="calcularSubtotal()"  >   <%--oninput="validar()" onkeypress="validarSoloLetras(event)"--%>                                                             
                                    <input type="hidden" name="subtotal" id="subtotal" class="form-control" placeholder="Digite la Cantidad"  required >
                                </div>                                                       
                     <%--</form>--%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                      <%-- <form action="Controlinven" method="POST">--%>
                            <input type="hidden" name="idinventario" value="<%= i.getIdinventario() %>">
                            <input type="hidden" name="codigo" value="<%= i.getCodproducto() %>" >
                           <input type="hidden" name="nombre" value="<%= i.getNomproducto() %>" >
                            <input type="hidden" name="precio_unitario" value="<%= i.getPrecio_unitario() %>">
                            <input type="hidden" name="cantidaddetalles" value="cantidaddetalles" >
                            <input type="hidden" name="subtotal" value="subtotal" >
                            <button type="submit" class="btn btn-warning btn-primary" name="action" id="btnEnviar" value="guardarfactura"  onclick="AVISO()" >Enviar</button>
                        </form>                        
                    </div>
                </div>
            </div>
        </div> 
       <% } %>
       
       
        <div class="container mt-3">
            <!-- Tabla de inventario -->
            <h2 class="mt-5">Lista de Productos</h2>                            
            <div class="container mt-3">
                <table class="table table-striped" id="myTable">
                   <thead class="thead-dark">
                    <tr>
                        <%--<th></th>--%>
                        <th>ID</th>
                        <th>Cod. Producto</th> 
                        <th>Nombre del Producto</th>  
                        <th>Proveedor</th>  
                        <th>Serie</th>
                        <th>Modelo</th>
                        <th>Precio Unit</th>
                        <th>Stock</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for(Inventario i : listaInventario) { %>
                    <tr style="background-color: #fff">
                        <td style="text-align:center" ><%= i.getIdinventario() %></td>
                        <td style="text-align:center" ><%= i.getCodproducto() %></td>
                        <td><%= i.getNomproducto() %></td>
                        <td><%= i.getProveedores().getNomproveedor() %></td>
                        <td><%= i.getSerie() %></td>
                        <td><%= i.getModelo() %></td>
                        <td style="text-align:center" >$ <%= i.getPrecio_unitario() %></td>
                        <td style="text-align:center" ><%= i.getCantidad() %></td>                       
                        <td>      
                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalMarcas"
                                onclick="Cantidad('<%=i.getIdinventario()%>','<%= i.getCodproducto() %>','<%= i.getNomproducto() %>','<%= i.getPrecio_unitario() %>')">
                                Seleccionar
                           </button>
                        </td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
            </div>
        </div>  
            <script>
                function calcularSubtotal() {
                    var cantidad = document.getElementById('cantidaddetalles').value;
                    var precioUnitario = document.getElementById('precio_unitario').value;
                    var subtotal = cantidad * precioUnitario;
                    document.getElementById('subtotal').value = subtotal;
                }
            </script>
            <script>
                function AVISO() {
                    alert('Producto cargado la vista de factura');
                }
            </script>
            <script>
                    $(document).ready(function() {
                    $('#myTable').DataTable({
                        "paging": true,
                        "lengthChange": true,
                        "searching ": true,
                        "ordering": true,
                        "info": true,
                        "autoWidth": false,
                        "pageLength": 5, // Número de registros que deseas mostrar por página
                        "lengthMenu": [2,5, 10, 25, 50, 100] // Opciones de cantidad de registros por página
                    });
                });
            </script> 
            <script>
                function validarCantidad() {
                    var cantidad = document.getElementById('cantidaddetalles').value;
                    var botonEnviar = document.getElementById('btnEnviar');

                    if (/^\d+$/.test(cantidad)) {
                        botonEnviar.disabled = false;
                    } else {
                        botonEnviar.disabled = true;
                    }
                }
                
                
                function Cantidad(idinventario,codigo,nombre,precio_unitario) {
                document.getElementById("idinventario").value = idinventario;
                document.getElementById("codigo").value = codigo;
                document.getElementById("nombre").value = nombre;
                document.getElementById("precio_unitario").value = precio_unitario;
                document.getElementById('MarcaModalLabel').innerText = 'Digite la cantidad';
                
            }
            </script>
            <br/><br/> <br/><br/><br/><br/>
            <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
                <div class="container">
                    <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga - Enmanuel Sánchez</p>
                </div>
            </footer>       
    </body>
</html>
