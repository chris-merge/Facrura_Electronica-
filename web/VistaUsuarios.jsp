<%-- 
    Document   : VistaUsuarios
    Created on : 18 oct 2024, 22:49:26
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Crear usuario</title>
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
                        <a class="nav-link" href="VistaEmpleado.jsp" style="color: white">Agregar Empleados</a>
                    </li>
                    <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesion</a>                  
                </ul>
            </div>
        </nav>
        <%
            ArrayList<Usuarios> listaUsuarios = new ArrayList<Usuarios>();
            ArrayList<Roles> listaRoles = new ArrayList<Roles>();
            try{
            if(request.getAttribute("DatosUsuarios") != null){
                listaRoles.addAll((Collection)request.getAttribute("DatosRoles"));
                listaUsuarios.addAll((Collection)request.getAttribute("DatosUsuarios"));
            }
            else if(request.getAttribute("Resultado") != null){
                listaRoles.addAll((Collection)request.getAttribute("DatosRoles"));                             
                listaUsuarios.addAll((Collection)request.getAttribute("Resultado"));
            }
            else
                response.sendRedirect("ControlUsuarios?mostrar");
            }catch(Exception ex){
            }
         %>
         <!-- Imagen de la empresa -->
        <h2 style="float: left;"> 
           <img width="130" height="100" src="imagen/logo.png">
        </h2> 
       <div class="container mt-3">
            <h1 style="text-align:center" >Agregar Usuario</h1>
            <br>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalUser" onclick="limpiar()">
            Crear usuario
        </button>
        <a href="VistaRoles.jsp">
            <button type="button" class="btn btn-primary" >Ver Roles</button>
        </a>    
         <!-- Modal para agregar/editar empleado -->
        <div class="modal fade" id="modalUser" tabindex="-1" aria-labelledby="UserModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">   

                    <div class="modal-header">
                        <h5 class="modal-title" id="UserModalLabel">Agregar Roles</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form form="userForm" action="ControlUsuarios" method="post" id="userForm" autocomplete="off">
                         <input type="hidden" name="userid" id="userid"/>
                            <br>
                            <div class="mb-3">
                                <label for="usernombre"><b>Usuario</b></label>
                                <input type="text" name="usernombre" id="usernombre" required class="form-control" onkeydown="bloquearEspacios(event)"  onkeypress="validarSoloLetras(event)"/>
                            </div>
                            <div class="mb-3">
                               <Label for="usercontraseña"><b>Contraseña</b></Label>
                               <input type="password" name="usercontraseña" id="usercontraseña" value="password"  required placeholder="Ingrese su contraseña" class="form-control" onkeydown="bloquearEspacios(event)"/>
                               <input type="checkbox" id="showPassword" onclick="togglePasswordVisibility()"> Show password
                           </div>
                            <div class="mb-3">
                                <Label for="roles" ><b>Rol:</b></Label>
                                <select id="roles" name="roles" class="form-select" required>
                                    <option value="" style="text-align:center">-- Seleccione el rol --</option>
                                    <% for(Roles m:listaRoles){ %>                                        
                                        <option value="<%=m.getIdrol()%>"> <%=m.getRol()%></option>
                                    <% } %>
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                        <button type="submit" class="btn btn-primary" id="btnGuardar" disabled name="guardar" form="userForm">Guardar</button>                        
                    </div>
                </div>
            </div>
    </div>                                   
     <!-- Tabla de empleados -->
    <h2 class="mt-5">Lista de Usuarios</h2                           
    <div class="container mt-3">
        <table class="table table-striped mt-3" id="myTable">
            <thead class="thead-dark">
                <tr>
                    <th></th>
                    <th>ID</th>
                    <th>USUARIO</th>                  
                    <th>CONTRASEÑA</th>
                    <th>ROL</th>
                    <th>ACCIONES</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for(Usuarios p:listaUsuarios){
                %>
                <tr style="background-color: #fff">
                    <td></td>
                    <td><%=p.getUserid()%></td>
                    <td><%=p.getUsernombre()%></td>                  
                    <td><%=p.getUsercontraseña()%></td>
                    <td><%=p.getRoles().getRol()%></td>
                    <td>          
                       <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalUser" 
                            onclick="editarUsuarios('<%=p.getUserid()%>', '<%=p.getUsernombre()%>', '***********', '<%=p.getRoles().getIdrol()%>')">
                            Editar
                        </button>  
                        <a href="javascript:Eliminar('e', '<%=p.getUserid()%>')" class="btn btn-danger btn-sm">Eliminar</a>
                    </td>                 
                </tr>
              <% } %>
              </tbody>
      </table>
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
        function cambiarTextoBoton() {
            const botonBuscar = document.getElementById("btnBuscar");
            if (botonBuscar.value === "Buscar") {
                
            } else {
               botonBuscar.value = "Ver Todo";
            }
            
        }    
      //Valida solo letras en los inputs
        function validarSoloLetras(event) {
            const char = String.fromCharCode(event.keyCode);
            const regex = /^[a-zA-Z\s]*$/;
            if (!regex.test(char)) {
                event.preventDefault();
            }
        }
        //bloquea los espacio en los inputs
        function bloquearEspacios(event) {
            if (event.key === ' ') {
                event.preventDefault();
            }
        }
         document.addEventListener('input', function() {
          const inputs = document.querySelectorAll('#userForm input[required]');
          const saveButton = document.getElementById('btnGuardar');
          let allFilled = true;

          inputs.forEach(input => {
            if (!input.value.trim()) { //input.value.trim() elimina los espacios
              allFilled = false;
            }
          });

          saveButton.disabled = !allFilled;
        });
      //Cambia el tipo de contraseña a texto
      function togglePasswordVisibility() {
            var usercontraseña = document.getElementById("usercontraseña");
            var showPasswordCheckbox = document.getElementById("showPassword");   


            if (showPasswordCheckbox.checked) {
                usercontraseña.type = "text";
            } else {
                usercontraseña.type = "password";
            }
       }       
   function editarUsuarios(userid, usernombre, usercontraseña,userrol) {
        document.getElementById('showPassword').checked = false;
        document.getElementById("userid").value = userid;
        document.getElementById("usernombre").value = usernombre;
        document.getElementById('usernombre').disabled = true;
        document.getElementById("usercontraseña").value = usercontraseña;
        document.getElementById("roles").value = userrol;
        document.getElementById('UserModalLabel').innerText = 'Editar Usuario';
        document.getElementById('btnGuardar').name = 'modificar'; // Cambiar la acción a "modificar"
        }
               
    function limpiar() {
        document.getElementById('usernombre').disabled = false;
        document.getElementById('showPassword').checked = false;
        document.getElementById("userid").value ='';
        document.getElementById("usernombre").value = '';
        document.getElementById("usercontraseña").value = '';
        document.getElementById("roles").value = '';
        document.getElementById('UserModalLabel').innerText = 'Agregar Usuario';
        document.getElementById('btnGuardar').name = 'guardar'; // Cambiar la acción a "guardar"
    }                   
            
    function Eliminar(elim, userid){
        var r = confirm("¿Seguro que desea eliminar el usuario?");
        if(r)
        window.location.href = "ControlUsuarios?eliminar=" + elim + "&userid=" + userid;
    }
    
         // Recarga la página cuando se cierra el modal
    $('#modalUser').on('hidden.bs.modal', function () {
        location.reload(); // Recarga la página al cerrar el modal
    });
    </script>
    <br/><br/>
    <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
        <div class="container">
            <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga  - Enmanuel Sánchez</p>
        </div>
    </footer>
 </body>    
</html>