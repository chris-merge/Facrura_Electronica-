<%-- 
    Document   : VistaMisFacturas
    Created on : 10 nov 2024, 21:15:14
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Mis Facturas</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <link href="css/home.css" rel="stylesheet" type="text/css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/cssmarcas.css" rel="stylesheet" type="text/css"/>
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
            
            if (!rol.equals("1") && !rol.equals("2")) {
                response.sendRedirect("login.jsp"); // Redirige si no es administrador
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
                       <a class="nav-link" href="VistaDetalles.jsp" style="color: white">Generar Factura</a>
                    </li>
                  <a type="btn" class="cerrar-sesion" href="?action=logout">Cerrar sesión</a>              
                </ul>
            </div>
        </nav>

        <%
            ArrayList<Misfacturas> listaMisfacturas = new ArrayList<Misfacturas>(); 
            ArrayList<Detalles> listaDetalles= new ArrayList<Detalles>();            
            ArrayList<Clientes> listaClientes = new ArrayList<Clientes>();
            try {
            if(request.getAttribute("DatosMisfacturas") != null){                                         
                listaDetalles.addAll((Collection)request.getAttribute("DatosDetalles"));
                listaClientes.addAll((Collection)request.getAttribute("DatosClientes"));
                listaMisfacturas.addAll((Collection)request.getAttribute("DatosMisfacturas"));
            } 
             else if(request.getAttribute("Resultado") != null){                           
                listaClientes.addAll((Collection)request.getAttribute("DatosClientes"));
                listaDetalles.addAll((Collection)request.getAttribute("DatosDetalles"));
                listaMisfacturas.addAll((Collection)request.getAttribute("Resultado"));
            }   
            else 
                response.sendRedirect("ControlMisFacturas?mostrar");
            }catch(Exception ex){
            }
        %>

        <h2 style="float: left;"> 
            <img width="130" height="100" src="imagen/logo.png">
        </h2> 
        <div class="container mt-3">
            <!-- Tabla de inventario -->
            <h2 class="mt-5">Lista de Facturas</h2>                            
            <div class="container mt-3">
                <table class="table table-striped" id="myTable">
                   <thead class="thead-dark">
                    <tr>
                        <%--<th></th>--%>
                        <th>ID</th>
                        <th>Cod. Factura</th>
                        <th>Vendedor</th>
                        <th>Cliente</th>
                        <th>N° Venta</th>
                        <th>Total</th>
                        <th>Fecha</th>
                        <th>ACCIONES</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                    for(Misfacturas p:listaMisfacturas){ 
                    %>
                    <%--
                    for(Clientes p:listaClientes){ 
                    --%>
                    <%--
                    for(Detalles p:listaDetalles){ 
                    --%>
                        <tr style="background-color: #fff">
                        <%--<td></td>--%>
                        <td style="text-align:center" ><%= p.getId_misfacturas()%></td>
                        <%--<td><%= p.getVendedor()%></td>
                        <td><%= p.getClientes().getNombre()%></td>
                        <td style="text-align:center" >$ <%= p.getTotal()%></td>
                        <td style="text-align:center" ><%= p.getNit()%></td>
                        <td style="text-align:center" ><%= p.getFecha()%></td> --%>                                              
                        <td>
                              <%--<form action="ControlDetalle" method="POST">
                                <input type="hidden" name="id_pro" value="<%= i.getIdinventario() %>">
                                <input type="hidden" name="precio" value="<%= i.getPrecio_unitario() %>">
                               <button type="submit" class="btn btn-warning btn-sm" name="action" value="guardarfactura">Seleccionar</button>
                            </form><input type="hidden" name="precio_unitario" value="<%= i.getPrecio_unitario() %>">
                         <%--<input type="hidden" name="nomproducto" value="<%= i.getNomproducto() %>"> --%>
                             <%--<form action="Controlinven" method="POST">
                                <input type="hidden" name="idinventario" value="<%= i.getIdinventario() %>">
                                <input type="hidden" name="precio_unitario" value="<%= i.getPrecio_unitario() %>">
                               <button type="submit" class="btn btn-warning btn-sm" name="action" value="guardarfactura">Seleccionar</button>
                            </form>--%>
                             <button type="submit" class="btn btn-warning btn-sm" name="action" value="guardarfactura">Seleccionar</button>
                        </td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
            </div>
        </div>             
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
                //Valida solo letras y bloquea el espacio al inicio
                 function validarSoloLetras(event) {
                        const input = event.target;
                        const char = String.fromCharCode(event.keyCode);
                        const regex = /^[a-zA-Z\s]*$/;

                        // Bloquear espacios al inicio
                        if (event.keyCode === 32 && input.value.length === 0) {
                            event.preventDefault();
                        }
                        //Valida solo las letras
                        if (!regex.test(char)) {
                            event.preventDefault();
                        }
                    }
                    //vaida que los inputs esten llenos
                     document.addEventListener('input', function() {
                     const inputs = document.querySelectorAll('#inventarioForm input[required]');
                     const saveButton = document.getElementById('btnGuardar');
                     let allFilled = true;

                     inputs.forEach(input => {
                        if (!input.value.trim()) { //input.value.trim() elimina los espacios
                          allFilled = false;
                        }
                      });

                      saveButton.disabled = !allFilled;
                    });
                 //bloquea los espacio en los inputs
                function bloquearEspacios(event) {
                    if (event.key === ' ') {
                        event.preventDefault();
                    }
                }
                function editarProducto(idinventario, codproducto, nomproducto, idproveedor, serie, modelo, precio_unitario, cantidad) {
                    document.getElementById("idinventario").value = idinventario;
                    document.getElementById("codproducto").value = codproducto;
                    document.getElementById("nomproducto").value = nomproducto;
                    document.getElementById("proveedores").value = idproveedor;
                    document.getElementById("serie").value = serie;
                    document.getElementById("modelo").value = modelo;
                    document.getElementById("precio_unitario").value = precio_unitario;
                    document.getElementById("cantidad").value = cantidad;                    
                    document.getElementById('InventarioModalLabel').innerText = 'Editar Producto en Inventario';
                    document.getElementById('btnGuardar').name = 'modificar';
                }

                function limpiar() {
                    document.getElementById('btnGuardar').disabled = true;
                    document.getElementById("idinventario").value = '';
                    document.getElementById("codproducto").value = '';
                    document.getElementById("nomproducto").value = '';
                    document.getElementById("proveedores").value = '';
                    document.getElementById("serie").value = '';
                    document.getElementById("modelo").value = '';
                    document.getElementById("precio_unitario").value = '';
                    document.getElementById("cantidad").value = ''; 
                    document.getElementById('InventarioModalLabel').innerText = 'Agregar Producto al Inventario';
                    document.getElementById('btnGuardar').name = 'guardar';
                }

                function eliminarProducto(elim, idinventario) {
                    var r = confirm("¿Seguro que desea eliminar este producto del inventario?");
                    if (r) 
                    window.location.href = "Controlinventario?eliminar="  + elim + "&idinventario=" + idinventario;
                } 
            </script>

    <br/><br/> <br/><br/><br/><br/> <br/><br/>
        <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
            <div class="container">
                <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga - Enmanuel Sánchez</p>
            </div>
        </footer>
    </body>
</html>
