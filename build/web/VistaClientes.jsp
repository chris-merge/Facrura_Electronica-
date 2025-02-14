<%@page import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="es">
<head>
    <!-- Bootstrap CSS -->
    <title>Gestión de Clientes</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="css/home.css" rel="stylesheet" type="text/css"/>
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="js/bootstrap.bundle.min.js"></script>
        <!-- Bootstrap JS, Popper.js, and jQuery  -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Agrega los archivos de DataTables -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>

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
                       <a class="nav-link" href="VistaDetalles.jsp" style="color: white">Generar Factura</a>
                    </li>
                      <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesion</a>                  
                </ul>
            </div>
        </nav>
     <%            
            ArrayList<Clientes> listaClientes = new ArrayList<Clientes>();
            try{
            if(request.getAttribute("DatosClientes") != null){
                listaClientes.addAll((Collection)request.getAttribute("DatosClientes"));
            }
            else
                response.sendRedirect("ControlClientes?mostrar");
            }catch(Exception ex){
            }
         %> 
    <h2 style="float: left;"> 
       <img width="130" height="100" src="imagen/logo.png">
    </h2>
     <div class="container mt-3">
            <h1 style="text-align:center" >Gestión Clientes</h1>
            <br>               

        <div> 
        <!-- Botón para abrir el modal de agregar/editar cliente -->
            <button type="button" class="btn btn-primary my-3 mr-5" data-toggle="modal" data-target="#modalCliente" onclick="limpiarFormulario()">
                Agregar Cliente
            </button>
            <button class="btn btn-success my-3 mr-5" style="float: right" id="btnGenerarPDF">Generar Reporte PDF</button>
        </div>
            
        <!-- Modal para agregar/editar cliente -->
        <div class="modal fade" id="modalCliente" tabindex="-1" aria-labelledby="modalClienteLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalClienteLabel">Agregar Cliente</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                    <form action="ControlClientes" method="post" id="formCliente" autocomplete="off" class="row g-3">                       
                            <input type="hidden" id="idcliente" name="idcliente" value="">
                            <div class="form-group">
                                <label for="nombre"><b>Nombre:</b></label>
                                <input type="text" class="form-control" id="nombre" name="nombre" onkeypress="validarSoloLetras(event)" required>
                            </div>

                            <div class="form-group">
                                <label for="direccion"><b>Dirección:</b></label>
                                <input type="text" class="form-control" id="direccion" name="direccion" required>
                            </div>

                            <div class="col-md-6">
                                <label for="telefono"><b>Teléfono:</b></label>
                                <input type="number" class="form-control" id="telefono" name="telefono"  required>
                                <h6><small>Solo se permiten numeros</small></h6>
                            </div>

                            <div class="col-md-6">
                                <label for="dui"><b>DUI:</b></label>
                                <input type="number" class="form-control" id="dui" name="dui" required>
                                <h6><small>Solo se permiten numeros</small></h6>
                            </div>

                            <div class="form-group">
                                <label for="correo"><b>Correo:</b></label>
                                <input type="email" class="form-control" id="correo" name="correo">
                            </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary" id="btnGuardar" disabled form="formCliente" onclick="habilitarYEnviar()" name="guardar">Guardar</button>
                        </div>
                    </form>
                   </div>
                </div>
            </div>
        </div>


<script>
    document.getElementById('btnGenerarPDF').addEventListener('click', function () {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
      /*  doc.setFontSize(14);
        doc.text('Nombre de la Empresa : Developers JR:', 10, 10);
        doc.setFontSize(12);
        doc.text('Dirección de la Empresa : Sonsonate - Sonsonate', 10, 16);
        doc.text('Teléfono: (+503) 4563-7890', 10, 22);*/
        
        // Configurar título del reporte
        doc.setFontSize(20);
        doc.text('Reporte de Clientes', 14, 28);

        // Configurar tabla con datos
        const table = document.getElementById('myTable');
        const headers = [];
        const rows = [];

        // Extraer encabezados
       /* table.querySelectorAll('thead th').forEach(th => {
            headers.push(th.innerText);
        }); */
        table.querySelectorAll('thead th').forEach((th, index) => {
        if (index !== 0 && index !== 6) { // Excluir columnas 0 (ID) y 6 (Acciones)
            headers.push(th.innerText);
        }
        });

        // Extraer datos de Todas las filas
       /* table.querySelectorAll('tbody tr').forEach(tr => {
            const row = [];
            tr.querySelectorAll('td').forEach(td => {
                row.push(td.innerText);
            });
            rows.push(row);
        }); */
        
        // Extraer datos de las filas, excluyendo las columnas de ID y Acciones
        table.querySelectorAll('tbody tr').forEach(tr => {
            const row = [];
            tr.querySelectorAll('td').forEach((td, index) => {
                if (index !== 0 && index !== 6) { // Excluir columnas 0 (ID) y 6 (Acciones)
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
                            
        <!-- Tabla de clientes -->
        <h2 class="mt-5">Lista de Clientes</h2>
        <table class="table table-striped mt-4" id="myTable">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Dirección</th>
                    <th>Teléfono</th>
                    <th>DUI</th>
                    <th>Correo</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for(Clientes Cliente:listaClientes) { %>
                    <tr style="background-color: #fff">
                        <td style="text-align:center" ><%= Cliente.getIdcliente() %></td>
                        <td><%= Cliente.getNombre() %></td>
                        <td><%= Cliente.getDireccion() %></td>
                        <td><%= Cliente.getTelefono() %></td>
                        <td><%= Cliente.getDui() %></td>
                        <td><%= Cliente.getCorreo() %></td>
                        <td>
                            <button type="button" class="btn btn-warning btn-sm" 
                                    data-toggle="modal" data-target="#modalCliente"
                                    onclick="editarCliente('<%=Cliente.getIdcliente() %>', '<%=Cliente.getNombre() %>', '<%=Cliente.getDireccion() %>', '<%= Cliente.getTelefono() %>', '<%=Cliente.getDui() %>', '<%=Cliente.getCorreo() %>')">
                                Editar
                            </button>
                                <form action="ControlClientes" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${cliente.idcliente}">
                                 <a href="javascript:EliminarCliente('e', '<%= Cliente.getIdcliente() %>')" class="btn btn-danger btn-sm">Eliminar</a>                                
                            </form>
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
        
        document.addEventListener('input', function() {
          const inputs = document.querySelectorAll('#formCliente input[required]');
          const saveButton = document.getElementById('btnGuardar');
          let allFilled = true;

          inputs.forEach(input => {
            if (!input.value.trim()) { //input.value.trim() elimina los espacios
              allFilled = false;
            }
          });

          saveButton.disabled = !allFilled;
        });
        
        function editarCliente(idcliente, nombre, direccion, telefono, dui, correo) {
            document.getElementById('dui').disabled = true;
            document.getElementById('idcliente').value = idcliente;
            document.getElementById('nombre').value = nombre;
            document.getElementById('direccion').value = direccion;
            document.getElementById('telefono').value = telefono;
            document.getElementById('dui').value = dui;
            document.getElementById('correo').value = correo;
            document.getElementById('modalClienteLabel').innerText = 'Editar Cliente';
            document.getElementById('btnGuardar').name = 'modificar'; // Cambiar la acción a "modificar"
        }
        
        function habilitarYEnviar() {
            const dui = document.getElementById('dui');
            dui.disabled = false; // Habilitar el campo
            document.getElementById('formCliente'); // Enviar el formulario
            usernombre.disabled = true; // Volver a deshabilitar el campo
        }

        function limpiarFormulario() {
            document.getElementById('dui').disabled = false;
            document.getElementById('idcliente').value = '';
            document.getElementById('nombre').value = '';
            document.getElementById('direccion').value = '';
            document.getElementById('telefono').value = '';
            document.getElementById('dui').value = '';
            document.getElementById('correo').value = '';
            document.getElementById('modalClienteLabel').innerText = 'Agregar Cliente';
            document.getElementById('btnGuardar').name = 'guardar'; // Cambiar la acción a "guardar"
        }
        
    function EliminarCliente(elim, idcliente) {
            var r = confirm("¿Seguro que desea eliminar el cliente?");
            if(r)
                window.location.href = "ControlClientes?eliminar=" + elim + "&idcliente=" + idcliente;
        }
        
        document.getElementById("btnGuardar").addEventListener("click", function(event) {            
            const duiInput = document.getElementById('dui');
            const dui = duiInput.value;
            const telefonoInput = document.getElementById('telefono');
            const telefono = telefonoInput.value;


            // Validaciones para teléfono y DUI
            if ( telefono.length !== 8 ) {
                alert("El teléfono debe tener 8 caracteres ");
                event.preventDefault(); // Evitamos que se envíe el formulario
            }
            if ( dui.length !== 9) {
                alert("El número de DUI debe tener 9 caracteres");
                event.preventDefault(); // Evitamos que se envíe el formulario
            }            
        }
    ); 
    </script>

    <br/><br/><br/><br/><br/><br/><br/><br/>
    <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
        <div class="container">
            <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga - Enmanuel Sánchez</p>
        </div>
    </footer>
</body>
</html>


