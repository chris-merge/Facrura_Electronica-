<%-- 
    Document   : VistaProveedores
    Created on : 23 oct 2024, 20:41:15
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Crear Proveedores</title>
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
                        <a class="nav-link" href="VistaEmpleado.jsp" style="color: white">Agregar Empleados</a>
                    </li>
                    <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesion</a>                  
                </ul>
            </div>
        </nav>
         <%
            ArrayList<Proveedores> listaProveedores = new ArrayList<Proveedores>();
            ArrayList<Marcas> listaMarcas = new ArrayList<Marcas>();
            try{
            if(request.getAttribute("DatosProveedores") != null){
                listaMarcas.addAll((Collection)request.getAttribute("DatosMarcas"));
                listaProveedores.addAll((Collection)request.getAttribute("DatosProveedores"));
            }
            else if(request.getAttribute("Resultado") != null){
                listaMarcas.addAll((Collection)request.getAttribute("DatosMarcas"));                             
                listaProveedores.addAll((Collection)request.getAttribute("Resultado"));
            }
            else
                response.sendRedirect("ControlProveedores?mostrar");
            }catch(Exception ex){
            }
         %>
          <!-- Imagen de la empresa -->
          <h2 style="float: left;"> 
             <img width="130" height="100" src="imagen/logo.png">
          </h2> 
          <div class="container mt-3">
            <h1 style="text-align:center" >Agregar Proveedores</h1>
            <br>
             <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalProv" onclick="limpiar()">
            Crear Proveedores
            </button>
            <a href="VistaMarcas.jsp">
                <button type="button" class="btn btn-primary" >Ver Marcas</button>
            </a> 
           <!-- Modal para agregar/editar Proveedor -->
        <div class="modal fade" id="modalProv" tabindex="-1" aria-labelledby="ProvModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">   

                    <div class="modal-header">
                        <h5 class="modal-title" id="ProvModalLabel">Agregar Proveedor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form form="provForm" action="ControlProveedores" method="post" id="provForm" autocomplete="off">
                         <input type="hidden" name="idproveedores" id="idproveedores"/>
                            <br>
                            <div class="mb-3">
                                <label for="Nombre"><b>Nombre del proveedor</b></label>
                                <input type="text" name="nomproveedor" id="nomproveedor" required class="form-control"  onkeypress="validarSoloLetras(event)"/>
                                
                            </div>                           
                            <div class="mb-3">
                                <Label for="marca" ><b>Marca:</b></Label>
                                <select id="marcas" name="marcas" class="form-select" required>
                                    <option value="" style="text-align:center">-- Seleccione la marca --</option>
                                    <% for(Marcas m:listaMarcas){ %>                                        
                                        <option value="<%=m.getIdmarcas()%>"> <%=m.getNommarcas()%></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                               <Label for="Telefono"><b>Telefono</b></Label>
                               <input type="number" name="telproveedor" id="telproveedor" value="telproveedor" required class="form-control"/>
                                <h6><small>Solo se permiten numeros</small></h6>
                            </div>
                            <div class="mb-3">
                               <Label for="Correo"><b>Correo</b></Label>
                               <input type="email" name="correoproveedor" id="correoproveedor" required class="form-control"/>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                        <button type="submit" class="btn btn-primary" id="btnGuardar" name="guardar" disabled form="provForm">Guardar</button>                        
                    </div>
                </div>
            </div>
       </div>
        
     <!-- Tabla de empleados -->
    <h2 class="mt-5">Lista de Proveedores</h2                           
    <div class="container mt-3">
        <table class="table table-striped" id="myTable">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>NOMBRE DEL PROVEEDOR</th>                  
                    <th>MARCAS</th>
                    <th>TELEFONO</th>
                    <th>CORREO</th>
                    <th>ACCIONES</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for(Proveedores p:listaProveedores){
                %>
                <tr style="background-color: #fff">
                    <td style="text-align:center" ><%=p.getIdproveedores()%></td>
                    <td><%=p.getNomproveedor()%></td>                    
                    <td><%=p.getMarcas().getNommarcas()%></td>
                    <td><%=p.getTelproveedor()%></td>
                    <td><%=p.getCorreoproveedor()%></td>
                    <td>          
                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalProv"
                        onclick=" editarProveedor('<%=p.getIdproveedores()%>', '<%=p.getNomproveedor()%>', '<%=p.getMarcas().getIdmarcas()%>', '<%=p.getTelproveedor()%>','<%=p.getCorreoproveedor()%>')">
                        Editar
                    </button>
                    <a href="javascript:Eliminar('e', '<%=p.getIdproveedores()%>')" class="btn btn-danger btn-sm">Eliminar</a>
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
          const inputs = document.querySelectorAll('#provForm input[required]');
          const saveButton = document.getElementById('btnGuardar');
          let allFilled = true;

          inputs.forEach(input => {
            if (!input.value.trim()) { //input.value.trim() elimina los espacios
              allFilled = false;
            }
          });

          saveButton.disabled = !allFilled;
        });
    function editarProveedor(idproveedores, nomproveedor, idmarca,telproveedor,correoproveedor) {
        document.getElementById("idproveedores").value = idproveedores;
        document.getElementById("nomproveedor").value = nomproveedor;
        document.getElementById("marcas").value = idmarca;
        document.getElementById("telproveedor").value = telproveedor;
        document.getElementById("correoproveedor").value = correoproveedor;
        document.getElementById('ProvModalLabel').innerText = 'Editar Empleado';
        document.getElementById('btnGuardar').name = 'modificar'; // Cambiar la acción a "modificar"
    }      
                
    function limpiar() {
        document.getElementById('btnGuardar').disabled = true;
        document.getElementById("idproveedores").value ='';
        document.getElementById("nomproveedor").value = '';
        document.getElementById("marcas").value = '';
        document.getElementById("telproveedor").value = '';
        document.getElementById("correoproveedor").value = '';
        document.getElementById('ProvModalLabel').innerText = 'Agregar Proveedor';
        document.getElementById('btnGuardar').name = 'guardar'; // Cambiar la acción a "guardar"
    }                   
            
    function Eliminar(elim, idproveedores){
        var r = confirm("¿Seguro que desea eliminar el proveedores?");
        if(r)
        window.location.href = "ControlProveedores?eliminar=" + elim + "&idproveedores=" + idproveedores;
    }
    
     document.getElementById("btnGuardar").addEventListener("click", function(event) {            
            const telefonoInput = document.getElementById('telproveedor');
            const telefono = telefonoInput.value;


            // Validaciones para teléfono
            if (  telefono.length !== 8 ) {
                alert("El teléfono debe tener 8 caracteres ");
                event.preventDefault(); // Evitamos que se envíe el formulario
            }
           }
           );
    </script>
    <br/><br/> <br/><br/> <br/><br/>
    <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
        <div class="container">
            <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga  - Enmanuel Sánchez</p>
        </div>
    </footer>
 </body>
</html>