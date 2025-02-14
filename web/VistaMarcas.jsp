<%-- 
    Document   : VistaMarcas
    Created on : 23 oct 2024, 20:40:11
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Marcas</title>
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
                <li>
                   <a class="nav-link" href="VistaInventario.jsp" style="color: white">Agregar Producto</a> 
                </li>
                <li>
                   <a class="nav-link" href="VistaProveedores.jsp" style="color: white">Agregar proveedores</a> 
                </li>
                  <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesión</a>                        
            </ul>
        </div>
    </nav>
    
     <%            
            ArrayList<Marcas> listaMarcas = new ArrayList<Marcas>();
            try{
            if(request.getAttribute("DatosMarcas") != null){
                listaMarcas.addAll((Collection)request.getAttribute("DatosMarcas"));
            }
            else
                response.sendRedirect("ControlMarcas?mostrar");
            }catch(Exception ex){
            }
         %>       
     <!-- Imagen de la empresa -->
    <h2 style="float: left;"> 
       <img width="130" height="100" src="imagen/logo.png">
    </h2>
          <div class="modal fade" id="modalMarcas" tabindex="-1" aria-labelledby="MarcaModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">   
                    <div class="modal-header">
                        <h5 class="modal-title" id="MarcaModalLabel">Modificar Marca</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form form="marcasForm" action="ControlMarcas" method="post" id="marcasForm" autocomplete="off">
                             <input type="hidden" name="idmarcas" id="idmarcas"/>
                                <br>
                                <div class="mb-3">
                                    <label for="nommarcas"> <b>Marca: </b></label>
                                    <input type="text" name="nommarcas" id="nommarca" class="form-control" placeholder="Digite la Marca " oninput="validar()" onkeypress="validarSoloLetras(event)" required />                                
                                </div>                                                       
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                        <button type="submit" class="btn btn-primary" id="btnModificar" name="modificar" disabled form="marcasForm">Modificar</button>                        
                    </div>
                </div>
            </div>
        </div> 
         
        <div class="container mt-3">
            <h1 style="text-align:center" >Agregar Marcas</h1>
            <br>
            <form class="row g-3" action="ControlMarcas" method="post">
                <br>
                <input type="hidden" name="idmarcas" id="idmarcas"/>                
                <div class="col-md-8 d-flex justify-content-start">
                    <label for="nombre"><h5> <b>Nombre: </h5></b></label>  
                    <input type="text" name="nommarcas"  id="nommarcas" placeholder="Digite la Marca " oninput="validarInput()" onkeypress="validarSoloLetras(event)" required class="form-control m-2"  />
                    <input type="submit" value="Guardar" id="btnGuardar" name="guardar" disabled class="btn btn-primary m-2"/>
                    <input type="button" value="Cancelar" class="btn btn-primary m-2"onclick="Cancelar()" />
                </div>
            </form>
        <h2 class="mt-5">Lista de Marcas</h2>                           
        <div class="container mt-3">
        <table class="table table-striped" id="myTable">
           <thead class="thead-dark">
                <tr>
                    <th style="text-align:center" >ID</th>
                    <th>NOMBRE</th>
                    <th>ACCIONES</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for(Marcas m:listaMarcas){
                %>
                <tr style="background-color: #fff">
                    <td style="text-align:center" ><%=m.getIdmarcas()%></td>
                    <td><%=m.getNommarcas()%></td>
                    <td>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalMarcas"
                            onclick=" editarMarca('<%=m.getIdmarcas()%>', '<%=m.getNommarcas()%>')">
                        Editar
                       </button>
                        <a href="javascript:Eliminar('e', '<%=m.getIdmarcas()%>')" class="btn btn-danger">Eliminar</a>
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
            "searching": true,
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
            
            function editarMarca(idmarcas, nommarcas) {
                document.getElementById('btnModificar').disabled = true;
                document.getElementById("idmarcas").value = idmarcas;
                document.getElementById("nommarca").value = nommarcas;
                document.getElementById('MarcaModalLabel').innerText = 'Editar Marca';
                document.getElementById('btnModificar').name = 'modificar'; // Cambiar la acción a "modificar"
            }
            function validar() {
                const input = document.getElementById('nommarcas').value;
                const botonModificar = document.getElementById('btnModificar');

                // Validar que el input no esté vacío y no comience con un espacio
                if (input.trim() !== ' ' && input[0] !== ' ') {
                    botonModificar.disabled = false;
                } else {
                    botonModificar.disabled = true;
                }
             }
             function validarInput() {
                const input = document.getElementById('nommarcas').value;
                const botonGuardar = document.getElementById('btnGuardar');

                // Validar que el input no esté vacío y no comience con un espacio
                if (input.trim() !== ' ' && input[0] !== ' ') {
                    botonGuardar.disabled = false;
                } else {
                    botonGuardar.disabled = true;
                }
             }
            
            function Eliminar(elim, idmarcas){
                var r = confirm("¿Seguro que desea eliminar el registro?");
                if(r)
                    window.location.href = "ControlMarcas?eliminar=" + elim + "&idmarcas=" + idmarcas;
            }            
            
            function Cancelar(){
                document.getElementById("idmarcas").value = "";
                document.getElementById("nommarcas").value = "";
                const botonGuardar = document.getElementById('btnGuardar');
                botonGuardar.disabled = true;

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