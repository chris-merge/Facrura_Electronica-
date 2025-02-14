<%-- 
    Document   : VistaRoles
    Created on : 18 oct 2024, 22:48:22
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
       <title>Roles</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <link href="css/home.css" rel="stylesheet" type="text/css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                    <li>
                       <a class="nav-link" href="VistaEmpleado.jsp" style="color: white">Agregar Empleado</a> 
                    </li>
                    <li>
                       <a class="nav-link" href="VistaUsuarios.jsp" style="color: white">Agregar Usuario</a> 
                    </li>
                      <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesion</a>  
                </ul>
            </div>
        </nav>

        <%            
            ArrayList<Roles> listaRoles = new ArrayList<Roles>();
            try{
            if(request.getAttribute("DatosRoles") != null){
                listaRoles.addAll((Collection)request.getAttribute("DatosRoles"));
            }
            else
                response.sendRedirect("ControlRoles?mostrar");
            }catch(Exception ex){
            }
         %>
  
         <!-- Imagen de la empresa -->
        <h2 style="float: left;"> 
           <img width="130" height="100" src="imagen/logo.png">
        </h2> 
        <br>
        <div class="container mt-3">
            <h1 style="text-align:center" >Agregar Roles</h1>
            <br>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRoles" onclick="limpiar()">
            Crear Roles
        </button>
        <!-- Modal para agregar/editar empleado -->
        <div class="modal fade" id="modalRoles" tabindex="-1" aria-labelledby="RolesModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">   

                    <div class="modal-header">
                        <h5 class="modal-title" id="RolesModalLabel">Agregar Roles</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form form="rolesForm" action="ControlRoles" method="post" id="rolesForm">
                         <input type="hidden" name="idrol" id="idrol"/>
                            <br>
                            <div class="mb-3">
                                <label for="rol"> <b>Rol: </b></label>
                                <!--<input type="text" name="rol" id="rol" required class="form-control"/>-->
                                <select name="rol" id="rol" class="form-select" aria-label="Default select example"  required>
                                    <option value="" style="text-align:center">-- Agregar Rol --</option>
                                    <option value="Gerente">Gerente</option>
                                    <option value="Administrador">Administrador</option>
                                    <option value="Vendedor">Vendedor</option>                                    
                                    <!--<option value="SUPERADMIN">SUPERADMIN</option>-->
                                </select>
                            </div>
                            <div class="mb-3">
                                <div id="viewContainer"> 
                                    <label for="permisos"> <b>Permisos: </b></label>                                    
                                    <select name="permisos" id="permisos" class="form-select" aria-label="Default select example" required>
                                        <option value="" style="text-align:center">-- Asignar Permisos --</option>
                                        <option value="Todos los permisos">Todos los permisos</option>
                                        <option value="Historial de Factura, Empleados, Usuario, Roles">Historial de Factura, Empleados, Usuario, Roles</option>
                                        <option value="Generar Factura, Inventario, Clientes">Generar Factura,Inventario,Clientes</option>                                        
                                    </select>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                        <button type="submit" class="btn btn-primary" id="btnGuardar" name="guardar" form="rolesForm" onclick="guardarPermisos()">Guardar</button>                        
                    </div>
                </div>
            </div>
        </div>  
                                  
         <!-- Tabla de empleados -->
        <h2 class="mt-5">Lista de Roles</h2                           
        <div class="container mt-3">
        <table class="table table-striped-sm" id="myTable">
            <thead class="thead-dark">
                <tr>
                    <th></th>
                    <th>ID</th>
                    <th>ROL</th>
                    <th>PERMISOS</th>
                    <%--<th>ACCIONES</th>--%>
                </tr>
            </thead>
            <tbody>
            <%
                for(Roles m:listaRoles){
            %>
                <tr style="background-color: #fff">
                    <td></td>
                    <td><%=m.getIdrol()%></td>
                    <td><%=m.getRol()%></td>
                    <td><%=m.getPermisos()%></td>
                    <%--  <td>          
                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalRoles"
                            onclick=" editarRoles('<%=m.getIdrol()%>', '<%=m.getRol()%>', '<%=m.getPermisos()%>')">
                            Editar
                        </button>
                        <a href="javascript:Eliminar('e', '<%=m.getIdrol()%>')" class="btn btn-danger btn-sm" >Eliminar</a>
                    </td> --%>            
                </tr>
           <% } %> 
           </tbody>
      </table>
      <div id="pagination" class="d-flex justify-content-center mt-3"></div>
    </div>
           <%-- <script>
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
    </script> --%>
       <script>
            const rowsPerPage = 5;  // Define el número de empleados por página
        </script>
        <script>
    document.addEventListener('DOMContentLoaded', function() {
        const table = document.getElementById("myTable");
        const rows = table.getElementsByTagName("tr");
        const pagination = document.getElementById("pagination");
        const totalPages = Math.ceil((rows.length - 1) / rowsPerPage);
        let currentPage = 1;

        function displayRows(page) {
            const start = (page - 1) * rowsPerPage + 1;
            const end = start + rowsPerPage - 1;

            // Oculta todas las filas y muestra solo las de la página actual
            for (let i = 1; i < rows.length; i++) {
                rows[i].style.display = (i >= start && i <= end) ? "" : "none";
            }
        }

        function setupPagination() {
            pagination.innerHTML = "";
            for (let i = 1; i <= totalPages; i++) {
                const btn = document.createElement("button");
                btn.classList.add("btn", "btn-primary", "m-1");
                btn.textContent = i;
                btn.addEventListener("click", function() {
                    currentPage = i;
                    displayRows(currentPage);
                    updatePaginationButtons();
                });
                pagination.appendChild(btn);
            }
            updatePaginationButtons();
        }

        function updatePaginationButtons() {
            const buttons = pagination.getElementsByTagName("button");
            for (let i = 0; i < buttons.length; i++) {
                buttons[i].classList.toggle("active", i === currentPage - 1);
            }
        }

        // Inicializa la paginación
        displayRows(currentPage);
        setupPagination();
    });
</script>


    <script>
    document.getElementById('seleccionarTodos').addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.opcion');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
    });

    const checkboxes = document.querySelectorAll('.opcion:not(#seleccionarTodos)');
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const allChecked = Array.from(checkboxes).every(checkbox => checkbox.checked);
            document.getElementById('seleccionarTodos').checked = allChecked;
        });
    });    
</script>
 
    <script>        
        function editarRoles(idrol, rol, permisos) {
            document.getElementById("idrol").value = idrol;
            document.getElementById("rol").value = rol;
            document.getElementById("permisos").value = permisos;
            document.getElementById('RolesModalLabel').innerText = 'Editar Empleado';
            document.getElementById('btnGuardar').name = 'modificar'; // Cambiar la acción a "modificar"
        }      

        function limpiar() {
            document.getElementById("idrol").value ='';
            document.getElementById("rol").value = '';
            document.getElementById("permisos").value = '';
            document.getElementById('RolesModalLabel').innerText = 'Agregar Empleado';
            document.getElementById('btnGuardar').name = 'guardar'; // Cambiar la acción a "guardar"
        }


       function Eliminar(elim, idrol){
            var r = confirm("¿Seguro que desea eliminar el rol?");
            if(r)
            window.location.href = "ControlRoles?eliminar=" + elim + "&idrol=" + idrol;
        }
    </script>
    
<br/><br/><br/><br/><br/><br/><br/><br/>
    <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
        <div class="container">
            <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga  - Enmanuel Sánchez</p>
        </div>
    </footer>
    </body>             
</html>
