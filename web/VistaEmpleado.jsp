<%-- 
    Document   : VistaEmpleado
    Created on : 22 oct 2024, 23:41:16
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Gestion de empleados</title>
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
        <!-- agrega al pdf -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>
    
        <script>
        function correo() {
                //document.getElementById('btnEnviarr').disabled = true;
                document.getElementById("emisor").value = '';
                document.getElementById("receptor").value = '';
                document.getElementById("contraseña").value = '';
                document.getElementById('CorreoModalLabel').innerText = 'Enviar Formulario';
                document.getElementById('btnEnviarr').name = 'modificar'; // Cambiar la acción a "modificar"
            }
         </script>
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
                      <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesion</a>                  
                </ul>
            </div>
        </nav>
          <%
            ArrayList<Empleados> listaEmpleados = new ArrayList<Empleados>();
            ArrayList<Roles> listaRoles = new ArrayList<Roles>();
            try{
            if(request.getAttribute("DatosEmpleados") != null){
                listaRoles.addAll((Collection)request.getAttribute("DatosRoles"));
                listaEmpleados.addAll((Collection)request.getAttribute("DatosEmpleados"));
            }
            else if(request.getAttribute("Resultado") != null){
                listaRoles.addAll((Collection)request.getAttribute("DatosRoles"));                             
                listaEmpleados.addAll((Collection)request.getAttribute("Resultado"));
            }
            else
                response.sendRedirect("ControlEmpleados?mostrar");
            }catch(Exception ex){
            }
         %>
         <h2 style="float: left;"> 
           <img width="130" height="100" src="imagen/logo.png">
         </h2>
         
        <!-- Formulario para mandar registros -->
         <div class="modal fade" id="modalCorreo" tabindex="-1" aria-labelledby="CorreoModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">   
                    <div class="modal-header">
                        <h5 class="modal-title" id="CorreoModalLabel">Enviar Reporte</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form form="correoForm" action="ControlMarcas" method="post" id="correoForm" autocomplete="off">
                             <input type="hidden" name="idmarcas" id="idmarcas"/>
                                <br>
                                <div class="mb-3">
                                    <label for="emisor"> <b>Emisor: </b></label>
                                    <input type="email" name="emisor" id="emisor" class="form-control" placeholder="Digite el correo " onkeypress="bloquearEspacios(event)" required />                                
                                </div>
                                <div class="mb-3">
                                    <label for="nommarcas"> <b>Receptor: </b></label>
                                    <input type="email" name="receptor" id="receptor" class="form-control" placeholder="Digite el correo " onkeypress="bloquearEspacios(event)" required />                                
                                </div>
                                <div class="mb-3">
                                    <label for="nommarcas"> <b>Contraseña: </b></label>
                                    <input type="password" name="contraseña" id="contraseña" class="form-control" placeholder="Digite la contraseña "  required />                                
                                </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                        <button type="submit" class="btn btn-primary" id="btnEnviarr" name="enviar"  form="correoForm">Enviar</button>                        
                    </div>
                </div>
            </div>
        </div> 
         
        <!-- Modal para cambiar cantidad -->
           <div class="modal fade" id="modalCant" tabindex="-1" aria-labelledby="CantModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg-sm">
                <div class="modal-content">   
                    <div class="modal-header">
                        <h5 class="modal-title" id="CantModalLabel" >ACCIONES</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-footer">
                      <!--   <button type="submit" class="btn btn-success m-2" iid="reporte" onclick="window.open('generatePdf', '_blank')" data-bs-dismiss="modal">Ver Reporte</button>-->
                        <button class="btn btn-success m-2" style="float: right" data-bs-dismiss="modal" id="btnGenerarPDF">Ver Reporte PDF</button>
                     <!--  <a href="generatePdf" class="btn btn-success">Generar PDF</a> -->
                        <!-- Agrega un botón para enviar el PDF al correo -->
                        <button class="btn btn-success btn-primary m-2" data-bs-toggle="modal" data-bs-dismiss="modal" data-bs-target="#modalCorreo" onclick="correo()">Enviar Reporte</button>                            
                        <button class="btn btn-success m-2" target="_blank" data-bs-dismiss="modal" onclick="Imprimir()">Imprimir Reporte</button>
                    </div>
                </div>
            </div>
        </div>
        
        
         <div class="container mt-3">
             <h1 style="text-align:center" >Gestión de Empleados</h1>
            <br>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalEmpleado" onclick="limpiar()">
             agregar empleado
            </button>
            <a href="VistaUsuarios.jsp">
                <button type="button" class="btn btn-primary" >Crear Usuario</button>
            </a>            
            <button style="float: right" class="btn btn-primary m-2"data-bs-toggle="modal" data-bs-target="#modalCant"
                onclick="EditCantidad()"> Acciones </button>
            
                <!-- Modal para agregar/editar empleado -->
                <div class="modal fade" id="modalEmpleado" tabindex="-1" aria-labelledby="EmpleadosModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            
                            <div class="modal-header">
                                <h5 class="modal-title" id="EmpleadosModalLabel">Agregar Empleado</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form form="userForm" action="ControlEmpleados" method="post" id="empleadoForm" autocomplete="off" class="row g-3">
                                 <input type="hidden" name="idempleado" id="idempleado"/>
                                    <br>
                                    <div class="col-md-12">
                                        <label for="empnombre"><b>Nombres:</b></label>
                                        <input type="text" class="form-control" id="empnombre" name="empnombre" onkeypress="validarSoloLetras(event)" required>
                                    </div>
                                   <div class="col-md-12">
                                        <label for="empapellido"><b>Apellidos:</b></label>
                                        <input type="text" class="form-control" id="empapellido" name="empapellido" onkeypress="validarSoloLetras(event)" required>
                                    </div>                                    
                                    <div class="col-md-6">
                                        <label for="emptelefono"><b>Teléfono:</b></label>
                                        <input type="number" class="form-control" id="emptelefono" name="emptelefono" oninput="validarTeslefono()" required>
                                        <h6><small>Solo se permiten numeros</small></h6>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="empdui"><b>DUI:</b></label>
                                        <input type="number" class="form-control" id="empdui" name="empdui" required>
                                        <h6><small>Solo se permiten numeros</small></h6>
                                    </div>
                                    <div class="col-md-12">
                                         <label for="empcorreo"><b>Correo:</b></label>
                                         <input type="email" class="form-control" id="empcorreo" name="empcorreo" required>
                                    </div>
                                    <div class="col-md-12">
                                        <Label for="roles" ><b>Rol:</b></Label>
                                        <select id="roles" name="roles" class="form-select" required>
                                          <option value="" style="text-align:center">-- Seleccione el rol --</option>
                                           <% for(Roles m:listaRoles){ %>
                                            <option style="text-align:center" value="<%=m.getIdrol()%>"> <%=m.getRol()%></option>
                                          <% } %>
                                        </select>
                                    </div>
                                </form>
                            </div>
                             
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                                <button type="submit" class="btn btn-primary" id="btnGuardar" disabled name="guardar" onclick="habilitarYEnviar()" form="empleadoForm">Guardar</button>                        
                            </div>
                        </div>                           
                    </div>
                </div>           
              <!-- Tabla de empleados -->
              <h2 class="mt-5">Lista de Empleados</h2>                           
              <div class="container mt-3">                                
                   <table class="table table-striped" id="myTable">
                       <thead class="thead-dark">
                        <tr>
                            <th>ID</th>
                            <th>NOMBRE</th>
                            <th>APELLIDO</th>
                            <th>DUI</th>
                            <th>TELÉFONO</th>
                            <th>CORREO</th>
                            <th>ROL</th>
                            <th>ACCIONES</th> 
                        </tr>
                      </thead>
                      <tbody>
                        <%
                            for(Empleados p:listaEmpleados){
                         %>
                        <tr style="background-color: #fff">
                            <td style="text-align:center"><%=p.getIdempleado()%></td>
                            <td><%=p.getEmpnombre()%></td>
                            <td><%=p.getEmpapellido()%></td>
                            <td><%=p.getEmpdui()%></td>
                            <td><%=p.getEmptelefono()%></td>
                            <td><%=p.getEmpcorreo()%></td>
                            <td><%=p.getRoles().getRol()%></td>
                            <td>                                                       
                                <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalEmpleado"
                                    onclick=" editarEmpleado('<%=p.getIdempleado()%>', '<%=p.getEmpnombre()%>', '<%=p.getEmpapellido()%>', '<%=p.getEmpdui ()%>', '<%=p.getEmptelefono()%>', '<%=p.getEmpcorreo()%>', '<%=p.getRoles().getIdrol()%>')">
                                    Editar
                               </button>
                               <a href="javascript:Eliminar('e', '<%=p.getIdempleado()%>')" class="btn btn-danger btn-sm">Eliminar</a>
                               
                            </td>                          
                       </tr>
                       <% } %>
                       </tbody>
                 </table>
              </div>
             </div>                       
                       
        <script>
            document.getElementById('btnGenerarPDF').addEventListener('click', function () {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF();

                // Configurar título del reporte
                doc.setFontSize(18);
                doc.text('Reporte de Empleados', 14, 22);

                // Configurar tabla con datos
                const table = document.getElementById('myTable');
                const headers = [];
                const rows = [];
        
             table.querySelectorAll('thead th').forEach((th, index) => {
            if (index !== 0 && index !== 7) { // Excluir columnas 0 (ID) y 6 (Acciones)
                headers.push(th.innerText);
            }
            });
        
        // Extraer datos de las filas, excluyendo las columnas de ID y Acciones
        table.querySelectorAll('tbody tr').forEach(tr => {
            const row = [];
            tr.querySelectorAll('td').forEach((td, index) => {
                if (index !== 7) { // Excluir columnas 0 (ID) y 6 (Acciones)
                    row.push(td.innerText);
                }
            });
            rows.push(row);
        });

                // Añadir la tabla al PDF
                doc.autoTable({
                    head: [headers],
                    body: rows,
                    startY: 30,
                });

                // Abrir el PDF en una nueva pestaña
                const pdfUrl = doc.output('bloburl');
                window.open(pdfUrl, '_blank');
            });
        </script>

 <!-- AQUI TERMINA EL CODIGO DEL REPORTE -->                
        
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
        function Imprimir() {
            const tabla = document.getElementById('myTable').cloneNode(true);

            // Eliminar filas y columnas no deseadas
            eliminarFilasYColumnas(tabla);

            const ventanaImpresion = window.open('', '', 'height=600,width=800');
            ventanaImpresion.document.write('<html><head><title>Empleados Registrados</title>');
            ventanaImpresion.document.write('<style>table { width: 100%; border-collapse: collapse; } table, th, td { border: 1px solid black; } th, td { padding: 8px; text-align: left; }</style>');
            ventanaImpresion.document.write('</head><body > <h2>Listado de Empleados</h2>');
            ventanaImpresion.document.write(tabla.outerHTML);
            ventanaImpresion.document.write('</body></html>');
            ventanaImpresion.document.close();
            ventanaImpresion.print();
        }

        function eliminarFilasYColumnas(tabla) {
            // Ejemplo: Eliminar la segunda columna
            const columnasAEliminar = [7]; // Índices de las columnas a eliminar (0-based)
            const filas = tabla.rows;

            for (let i = 0; i < filas.length; i++) {
                for (let j = columnasAEliminar.length - 1; j >= 0; j--) {
                    filas[i].deleteCell(columnasAEliminar[j]);
                }
            }
        }
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
        
         //bloquea los espacio en los inputs
        function bloquearEspacios(event) {
            if (event.key === ' ') {
                event.preventDefault();
            }
        }
            
        document.addEventListener('input', function() {
          const inputs = document.querySelectorAll('#empleadoForm input[required]');
          const saveButton = document.getElementById('btnGuardar');
          let allFilled = true;

          inputs.forEach(input => {
            if (!input.value.trim()) { //input.value.trim() elimina los espacios
              allFilled = false;
            }
          });

          saveButton.disabled = !allFilled;
        });
        
        function editarEmpleado(idempleado, empnombre, empapellido, empdui, emptelefono, empcorreo, empcargo) {            
            document.getElementById('idempleado').value = idempleado;
            document.getElementById('empnombre').value = empnombre;
            document.getElementById('empapellido').value = empapellido;
            document.getElementById('empdui').value = empdui;
            document.getElementById('empdui').disabled = true;
            document.getElementById('emptelefono').value = emptelefono;
            document.getElementById('empcorreo').value = empcorreo;
            document.getElementById('roles').value = empcargo;
            document.getElementById('EmpleadosModalLabel').innerText = 'Editar Empleado';
            document.getElementById('btnGuardar').name = 'modificar'; // Cambiar la acción a "modificar"
         }
         
        function habilitarYEnviar() {
            const empdui = document.getElementById('empdui');
            empdui.disabled = false; // Habilitar el campo
            document.getElementById('empleadoForm'); // Enviar el formulario
            usernombre.disabled = true; // Volver a deshabilitar el campo
        }

        function limpiar() {
            document.getElementById('empdui').disabled = false;
            document.getElementById('idempleado').value = '';
            document.getElementById('empnombre').value = '';
            document.getElementById('empapellido').value = '';
            document.getElementById('empdui').value = '';
            document.getElementById('emptelefono').value = '';
            document.getElementById('empcorreo').value = '';
            document.getElementById('roles').value = '';
            document.getElementById('EmpleadosModalLabel').innerText = 'Agregar Empleado';
            document.getElementById('btnGuardar').name = 'guardar'; // Cambiar la acción a "guardar"
        }
        
        function Eliminar(elim, idempleado){
            var r = confirm("¿Seguro que desea eliminar el empleado?");
            if(r)
                window.location.href = "ControlEmpleados?eliminar=" + elim + "&idempleado=" + idempleado;
        }
        
            document.getElementById("btnGuardar").addEventListener("click", function(event) {            
            const duiInput = document.getElementById('empdui');
            const dui = duiInput.value;
            const telefonoInput = document.getElementById('emptelefono');
            const telefono = telefonoInput.value;


            // Validaciones para teléfono y DUI
            if ( dui.length !== 9) {
                alert("El número de DUI debe tener 9 caracteres");
                event.preventDefault(); // Evitamos que se envíe el formulario
            }
            if ( telefono.length !== 8 ) {
                alert("El teléfono debe tener 8 caracteres ");
                event.preventDefault(); // Evitamos que se envíe el formulario
            }
          }
        );  
    </script>
    <br/><br/><br/><br/><br/><br/>
    <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
        <div class="container">
            <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga  - Enmanuel Sánchez</p>
        </div>
    </footer>
 </body>  
</html>
