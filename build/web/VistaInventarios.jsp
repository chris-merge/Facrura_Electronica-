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
                        <a class="nav-link" href="VistaEmpleado.jsp" style="color: white">Agregar Empleados</a>
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
                response.sendRedirect("Controlinventario?mostrar");
            
            } catch(Exception ex) {
                // Error handling
            }
        %>

        <h2 style="float: left;"> 
            <img width="130" height="100" src="imagen/logo.png">
        </h2> 
        <div class="container mt-3">
            <h1 style="text-align:center">Gestionar Inventario</h1>
            <br>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalInventario" onclick="limpiar()">
                Agregar Producto
            </button>
            <a href="VistaProveedores.jsp">
                <button type="button" class="btn btn-primary">Ver Proveedores</button>
            </a>
            <a href="VistaMarcas.jsp">
                <button type="button" class="btn btn-primary" >Ver Marcas</button>
            </a>

            <!-- Modal para agregar/editar Producto en Inventario -->
            <div class="modal fade" id="modalInventario" tabindex="-1" aria-labelledby="InventarioModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">   
                        <div class="modal-header">
                            <h5 class="modal-title" id="InventarioModalLabel">Agregar Producto</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="Controlinventario" method="post" id="inventarioForm" class="row g-3">
                               <input type="hidden" name="idinventario" id="idinventario"/>
                                <div class="col-md-5">
                                    <label for="codigo"><b>Codigo del Producto</b></label>
                                    <input type="number" name="codproducto" id="codproducto" required class="form-control" />
                                </div> 
                                <div class="col-md-7">
                                    <label for="nombreProducto"><b>Nombre del Producto</b></label>
                                    <input type="text" name="nomproducto" id="nomproducto" required class="form-control" onkeypress="validarSoloLetras(event)" />
                                </div>  
                                <div class="col-md-6">
                                    <label for="serie"><b>Serie</b></label>
                                    <input type="text" name="serie" id="serie" required class="form-control" />
                                </div>  
                                <div class="col-md-6">
                                    <label for="modelo"><b>Modelo</b></label>
                                    <input type="text" name="modelo" id="modelo" required class="form-control" />
                                </div>  
                                <div class="col-md-6">
                                    <Label for="proveedor"><b>Proveedor:</b></Label>
                                    <select id="proveedores" name="proveedores" class="form-select" required>
                                        <option value="" style="text-align:center">-- Seleccione el Proveedor --</option>
                                        <% for(Proveedores p : listaProveedores) { %>                                        
                                            <option style="text-align:center" value="<%= p.getIdproveedores() %>"> <%= p.getNomproveedor() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="precio"><b>Precio</b></label>
                                    <input type="number" name="precio_unitario" id="precio_unitario" required class="form-control" min="0" step="0.01"/>
                                </div>
                                <div class="col-md-3">
                                    <label for="cantidad"><b>Stock</b></label>
                                    <input type="number" name="cantidad" id="cantidad" required class="form-control" onkeypress="bloquearEspacios(event)" min="1"/>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                            <button type="submit" class="btn btn-primary" id="btnGuardar" name="guardar" disabled form="inventarioForm">Guardar</button>                        
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de inventario -->
            <h2 class="mt-5">Lista de Inventario</h2>                            
            <div class="container mt-3">
                <table class="table table-striped" id="myTable">
                   <thead class="thead-dark">
                    <tr>
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
                        <td style="text-align:center" >$<%= i.getPrecio_unitario() %></td>
                        <td style="text-align:center" ><%= i.getCantidad() %></td>                       
                        <td>          
                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalInventario"
                                onclick="editarProducto('<%= i.getIdinventario()%>', '<%= i.getCodproducto()%>', '<%= i.getNomproducto()%>','<%= i.getProveedores().getIdproveedores()%>','<%= i.getSerie()%>', '<%= i.getModelo()%>','<%= i.getPrecio_unitario()%>','<%= i.getCantidad()%>')">
                                Editar
                            </button>
                            <a href="javascript:eliminarProducto('e', '<%= i.getIdinventario()%>')" class="btn btn-danger btn-sm">Eliminar</a>
                        </td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
            </div>
        </div>
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
             <br/><br/> <br/><br/>
            <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
                <div class="container">
                    <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga - Enmanuel Sánchez</p>
                </div>
            </footer>
        </div>
    </body>
</html>
