<%-- 
    Document   : VistaFactura
    Created on : 4 nov 2024, 21:29:56
    Author     : Gerardo
--%>

<%@page import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8" import="java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Generar Factura</title>
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
            <!-- jsPDF y jsPDF AutoTable -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>
        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
       
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
                response.sendRedirect("HomeAdmin.jsp"); // Redirige si no es administrador
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
            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
            String formattedNow = now.format(formatter);
        %>
        <%
             ArrayList<Detalles> listaDetalles= new ArrayList<Detalles>();
             ArrayList<Inventario> listaInventario = new ArrayList<Inventario>();
              ArrayList<Clientes> listaClientes = new ArrayList<Clientes>();
            try {
            if(request.getAttribute("DatosDetalles") != null){         
                listaInventario.addAll((Collection)request.getAttribute("DatosInventario"));
                listaClientes.addAll((Collection)request.getAttribute("DatosClientes"));
                listaDetalles.addAll((Collection)request.getAttribute("DatosDetalles"));
            } 
             else if(request.getAttribute("Resultado") != null){                           
                listaInventario.addAll((Collection)request.getAttribute("DatosInventario"));
                listaClientes.addAll((Collection)request.getAttribute("DatosClientes"));
                listaDetalles.addAll((Collection)request.getAttribute("DatosDetalles"));  
            }   
            else 
                response.sendRedirect("ControlDetalle?mostrar");
            }catch(Exception ex){
            }
        %>         
        
         <!-- Imagen de la empresa -->
        <h2 style="float: left;"> 
           <img width="130" height="100" src="imagen/logo.png">
        </h2>
                <div class="container mt-3">
                     <h1 style="text-align:center" >Datos del Cliente</h1>
                     <br/>
                <div id="content" > <!-- div para generar captura y pdf --> 
                          <!-- Modal para agregar/editar Producto en Inventario -->
                            <form action="ControlDetalle" method="post" id="facturaForm" class="row g-3" style="background-color: #fff">
                                <input type="hidden" name="idfactura" id="idfactura" > 
                                <div class="col-md-5">
                                    <label for="codigo"><b>Codigo del Generacion</b></label>
                                    <input type="text" name="codfactura" id="codfactura" required readonly  class="form-control" />
                                   
                                </div>
                                <div class="col-md-3">
                                        <label for="datetime"><b>Fecha y Hora</b></label>
                                        <input type="text" id="datetime" name="datetime" class="form-control"  value="<%= formattedNow %>"  ReadOnly/>
                                </div>
                                <div class="col-md-5">
                                    <label for="nombre"><b>Nombre del Cliente</b></label>                                    
                                    <%--<input type="text" class="form-control" id="nombre" name="nombre"  required ReadOnly>--%> <%--value="<%= Cliente.getNombre() %>"  --%>
                                    <input type="text" class="form-control" id="nombre" name="nombre" value="<%= request.getParameter("nombre") %>" required readonly >
                                    <input type="hidden" class="form-control" id="id" name="idcliente" value="<%= request.getParameter("idcliente") %>" readonly>
                                </div>  
                                <div class="col-md-3">
                                    <label for="dui"><b>DUI:</b></label>                                  
                                    <input type="text" class="form-control" id="dui" name="dui" value="<%= request.getParameter("dui") %>" required readonly >
                                </div>
                                <div class="form-group col-md-4"  style="display: flex; align-items: center;">
                                <div style="margin-right: 10px;">
                                    <label for="nifCheckbox"><b>¿Aplica NIT?</b></label><br>
                                    <input type="radio" id="nifSi" name="nifCheckbox" value="si" onclick="toggleNIFInput(true)" required> Sí
                                    <input type="radio" id="nifNo" name="nifCheckbox" value="no" onclick="toggleNIFInput(false)" required> No
                                </div>
                                <div class="form-group col-md-8" id="nifGroup" style="display: none;">
                                    <label for="nit"><b>NIT:</b></label>
                                    <input type="text" class="form-control" id="nit" name="nit" />
                                </div>
                               </div>
                                <div class="col-md-4">
                                    <label for="correo"><b>Correo:</b></label> 
                                    <input type="email" class="form-control" id="correo" name="correo" value="<%= request.getParameter("correo") %>" readonly required >                                    
                                </div>  
                                <div class="col-md-4">
                                    <label for="direccion"><b>Dirección:</b></label>                                                                        
                                    <input type="text" class="form-control" id="direccion" name="direccion" value="<%= request.getParameter("direccion") %>" readonly required  >
                                </div>
                                     <div type="hidden" class="mb-4" hidden>
                                    <label for="dui"><b>BUSCAR:</b></label>
                                    <select  id="datos" name="datos" class="form-select" style="width: 50%;" required onchange="completarFormulario(this)">
                                        <option id="datos" value=""  selected>Seleccione un DUI</option>
                                        <% for(Clientes m : listaClientes) { %> 
                                            <option  value="<%=m.getIdcliente()%>" 
                                                    data-dui="<%=m.getDui()%>" 
                                                    data-nombre="<%=m.getNombre()%>" 
                                                    data-correo="<%=m.getCorreo()%>" 
                                                    data-direccion="<%=m.getDireccion()%>"> 
                                             <%=m.getNombre()%> - <%=m.getDui()%> 
                                            </option> 
                                        <% } %>
                                    </select>
                                </div>
                                    
                                <div class="container mt-3">                                    
                                    <a href="VistaSeleccion.jsp">                                    
                                         <button type="button" class="btn btn-primary m-2" style="float: left" >Buscar Cliente</button>
                                    </a>                                    
                                    <button type="button" class="btn btn-secondary m-2" onclick="Cancelar()"  style= "float: right" >Limpiar Registro</button> 

                                    <button type="button" class="btn btn-primary m-2" id="btnGuardar" name="guardar" style="float: right">Enviar Factura</button>
                                    <!-- comment
                                    <button type="submit" class="btn btn-primary m-2" id="btnGuardar" name="guardar" style= "float: right" >Enviar Factura</button>                                     
                                    -->
                                    <!-- Agregar un botón de imprimir -->
                                    <button type="button" class="btn btn-primary m-2" id="imprimir" onclick="imprimirFactura()">Imprimir</button>
                                </div>
                         </form> 
                   </div>
               </div> <!-- div para generar captura y pdf -- >                                
                                    
           <!-- Modal para cambiar cantidad -->
           <div class="modal fade" id="modalInv" tabindex="-1" aria-labelledby="IntModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">   
                    <div class="modal-header">
                        <h5 class="modal-title" id="InvModalLabel">Lista de Productos</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                    <!-- Tabla de inventario -->                         
                    <div class="container mt-3">
                        <table class="table table-striped" id="myTableInv">
                           <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Cod. Producto</th> 
                                <th>Nombre del Producto</th>  
                                <%--<th>Proveedor</th>  
                                <th>Serie</th>
                                <th>Modelo</th>--%>
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
                                <%--- <td><%= i.getProveedores().getNomproveedor() %></td>
                                <td><%= i.getSerie() %></td>
                                <td><%= i.getModelo() %></td> --%>
                                <td style="text-align:center" >$ <%= i.getPrecio_unitario() %></td>
                                <td style="text-align:center" ><%= i.getCantidad() %></td>                       
                                <td>        
                                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-dismiss="modal" data-bs-target="#modalMarcas"
                                        onclick="Cantidad('<%=i.getIdinventario()%>','<%= i.getPrecio_unitario() %>')">
                                    Seleccionar
                                   </button> 
                                </td>
                            </tr>
                            <% } %>
                          </tbody>
                        </table>
                    </div>
                    </div>
                </div>
            </div>
        </div>                         
                         
                                                                
         <!-- Modal para cambiar cantidad -->
           <div class="modal fade" id="modalCant" tabindex="-1" aria-labelledby="CantModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">   
                    <div class="modal-header">
                        <h5 class="modal-title" id="CantModalLabel">Cantidad</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form form="cantForm" action="ControlDetalle" method="post" id="cantForm" autocomplete="off">  
                                    <div class="col-md-11">
                                    <label for="nommarcas" > <b>Cantidad </b></label>
                                    <input type="hidden" name="id_detalle" id="id_detalle"/> 
                                    <input type="hidden" name="inventario" id="inventario"/>                                    
                                    <input type="number" name="cantidad" id="cantidad" class="form-control" placeholder="Digite la Cantidad" oninput="calcularYValidar()"  oninput="calcularSubtotal()" required >   <%--oninput="validar()" onkeypress="validarSoloLetras(event)"--%>                                                             
                                    <input type="hidden" name="id_venta" id="id_venta">
                                    <input type="hidden" name="precio" id="precio" class="form-control" min="0" step="0.01"/>
                                    <input type="hidden" name="subtotal" id="subtotal" class="form-control"  required >
                                    
                                </div>  
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button> 
                        <%--   <button type="button" class="btn btn-primary" id="btnModificar" name="modificar" data-bs-dismiss="modal" form="cantForm" disabled >Guardar</button> --%>
                        <button type="submit" class="btn btn-primary" id="btnModificar" name="modificar" data-bs-dismiss="modal" form="cantForm" disabled >Guardar</button>
                     <!-- Botón para generar PDF -->
                       
                    </div>
                </div>
            </div>
        </div> 
        <%-- <div class="text-right">
            <button id="capture" class="btn btn-success">Generar PDF</button> <%--id="generatePdf" --%>
       <%-- </div> --%>
                                  
            <!-- Tabla de inventario -->
            <h2 class="mt-5">Lista de Productos</h2>            
            <div class="container mt-3">
                <a href="VistaInven.jsp">                                    
                      <button type="button" class="btn btn-primary" style="float: right">Agregar Producto</button>
                </a>
                <%--<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalInv" style="float: right">Agregar</button>--%>
                <table class="table table-striped" id="myTable">
                    <br/>
                   <thead class="thead-dark">
                       <br/>
                    <tr>
                        <th style="text-align:center" >ID</th>
                        <th>Cod. Producto</th> 
                        <th>Nombre del Producto</th>  
                        <th>Cantidad</th>  
                        <th>Precio Unitario</th>
                        <th>Subtotal</th>
                        <th>ACCIONES</th>
                    </tr>
                    </thead>
                    <tbody>
                         <%
                            for(Detalles p:listaDetalles) { 
                         %>
                    <tr style="background-color: #fff">
                        <td style="text-align:center" ><%= p.getId_detalle()%></td>
                        <td><%=p.getInventario().getCodproducto()%></td>
                        <td><%= p.getInventario().getNomproducto()%></td>
                        <td ><%= p.getCantidad() %></td>
                        <td class="precio">$ <%= p.getPrecio() %></td>   
                        <td class="subtotal">$ <%= p.getSubtotal() %></td>                             
                        <td>
                          <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalCant"
                                onclick="EditCantidad('<%= p.getId_detalle()%>','<%=p.getInventario().getIdinventario()%>','<%= p.getCantidad() %>','<%= p.getId_detalle()%>','<%= p.getPrecio()%>',' <%= p.getSubtotal()%>')">
                            Editar
                           </button>                            
                            <a href="javascript:EliminarProducto('e', '<%= p.getId_detalle() %>')" class="btn btn-danger btn-primary">Eliminar</a>
                            
                          
                        </td>
                    </tr>
                    
                        <% } %> 
                   </tbody>
                   <tfoot>
                        <tr style="background-color: #fff">
                            <td colspan="5"><b>Total</b></td>
                            <td id="totalSubtotal"> </td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>   
                   <script>
    document.getElementById("btnGuardar").addEventListener("click", function () {
    const formulario = document.getElementById("facturaForm");
    const formData = new FormData(formulario);

    const jsonData = {};
    formData.forEach((value, key) => {
        jsonData[key] = value;
    });

    const tabla = document.getElementById("myTable");
    const filas = tabla.querySelectorAll("tbody tr");
    const datosTabla = [];

    filas.forEach(fila => {
        const columnas = fila.querySelectorAll("td");
        const objeto = {
            id: columnas[0].innerText.trim(),
            codProducto: columnas[1].innerText.trim(),
            nombreProducto: columnas[2].innerText.trim(),
            cantidad: columnas[3].innerText.trim(),
            precioUnitario: columnas[4].innerText.replace('$', '').trim(),
            subtotal: columnas[5].innerText.replace('$', '').trim()
        };
        datosTabla.push(objeto);
    });

    jsonData.detalles = datosTabla;

    console.log("Datos combinados:", JSON.stringify(jsonData, null, 2));

    fetch("ControlFacturas", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(jsonData),
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error(`Error HTTP: ${response.status}`);
            }
            return response.json();
        })
        .then((data) => {
            console.log("Respuesta del servidor:", data);
            alert("Factura enviada con éxito.");
        })
        .catch((error) => {
            console.error("Error:", error);
            alert("Error al enviar la factura. Consulta la consola.");
        });
});


</script>

           
   
<%--<script>
        let generatedCode = '';
        
        function generateCode() {
            if (!generatedCode) {
                const now = new Date();
                const year = now.getFullYear().toString().slice(-2);
                const month = (now.getMonth() + 1).toString().padStart(2, '0');
                const day = now.getDate().toString().padStart(2, '0');
                const hours = now.getHours().toString().padStart(2, '0');
                const minutes = now.getMinutes().toString().padStart(2, '0');
                
                // Genera un número aleatorio de 3 dígitos
                const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
                
                generatedCode = `${year}${month}${day}${hours}${minutes}${random}`;
                document.getElementById('codeDisplay').value = generatedCode;
            }
        }

        function saveCode() {
            // Aquí puedes agregar la lógica para guardar el código
            const savedMessage = document.getElementById('savedMessage');
            savedMessage.style.display = 'block';
            
            // Reset the generated code so a new one will be generated on refresh
            generatedCode = '';
            
            // Ocultar el mensaje después de 3 segundos
            setTimeout(() => {
                savedMessage.style.display = 'none';
            }, 3000);
        }

        // Generar código al cargar la página
        window.onload = generateCode;
    </script> --%>            
                   

    <script>
       // Añadimos el título del reporte
        document.getElementById('capture').addEventListener('click', async () => {
          const { jsPDF } = window.jspdf;

          // Seleccionar el elemento a capturar
          const content = document.getElementById('content');

          // Crear la captura de pantalla con html2canvas
          const canvas = await html2canvas(content);
          const imgData = canvas.toDataURL('image/png');

          // Crear el PDF con jsPDF
          const pdf = new jsPDF();
          const pageWidth = pdf.internal.pageSize.getWidth();
          const pageHeight = pdf.internal.pageSize.getHeight();


          // Agregar la imagen al PDF y ajustar al tamaño de la página
          const imgWidth = canvas.width;
          const imgHeight = canvas.height;
          const ratio = Math.min(pageWidth / imgWidth, pageHeight / imgHeight);
          pdf.addImage(imgData, 'PNG', 0, 0, imgWidth * ratio, imgHeight * ratio);

          // Convertir el PDF a Blob URL y abrir en una nueva ventana
          const pdfBlob = pdf.output('bloburl');
          window.open(pdfBlob, '_blank');
    });
    </script>               
                   
                   
    <script>
        function imprimirFactura() {
            // Obtener datos del formulario
            const codigo = document.getElementById('codfactura').value;
            const fechaHora = document.getElementById('datetime').value;
            const nombre = document.getElementById('nombre').value.console;
            const dui = document.getElementById('dui').value;
            const correo = document.getElementById('correo').value;
            const direccion = document.getElementById('direccion').value;

            // Obtener filas de la tabla
            const filas = document.querySelectorAll('#myTable tbody tr');
            let tablaHTML = '';
            filas.forEach(row => {
                const columnas = row.querySelectorAll('td');
                tablaHTML += `
                    <tr>
                        <td>${columnas[0].textContent}</td>                    
                        <td>${columnas[1].textContent}</td>
                        <td>${columnas[2].textContent}</td>
                        <td>${columnas[3].textContent}</td>
                        <td>${columnas[4].textContent}</td>
                        <td>${columnas[5].textContent}</td>
                    </tr>
                `;
            });

            // Crear ventana para mostrar la factura
            const ventana = window.open('', '_blank', 'width=800,height=600');
            ventana.document.write(`
                <html>
                <head>
                    <title>Factura</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid black; padding: 8px; text-align: left; }
                        th { background-color: #f2f2f2; }
                        .header { margin-bottom: 20px; }
                    </style>
                </head>
                <body>
                    <h2 style="text-align:center">Factura</h2>
                    <div class="header">
                        <p><b>Código:</b> ${codigo}</p>
                        <p><b>Fecha y Hora:</b> ${fechaHora}</p>
                        <p><b>Nombre del Cliente:</b> ${nombre}</p>
                        <p><b>DUI:</b> ${dui}</p>
                        <p><b>Correo:</b> ${correo}</p>
                        <p><b>Dirección:</b> ${direccion}</p>
                    </div>
                    <h3>Detalles de la Compra</h3>

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Código Producto</th>
                                <th>Nombre del Producto</th>
                                <th>Cantidad</th>
                                <th>Precio Unitario</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${tablaHTML}
                        </tbody>
                    </table>
                </body>
                </html>
            `);
            ventana.document.close();
            ventana.focus(); // Asegura que la ventana esté en primer plano
            ventana.print();
            ventana.close(); // Cierra la ventana después de imprimir
        }
    </script>
    
    <script>
        document.getElementById('generatePdf').addEventListener('click', function () {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();

            // Agregar encabezado de la factura
            doc.setFontSize(16);
            doc.text('Nombre de la Empresa', 10, 10);
            doc.setFontSize(12);
            doc.text('Dirección de la Empresa', 10, 16);
            doc.text('Teléfono: (123) 4356-7890', 10, 22);

            // Agregar datos del cliente
            doc.text('Datos del Cliente:', 10, 30);
            doc.text(`Nombre: ${document.getElementById('nombre').value}`, 10, 36);
            doc.text(`Dui: ${document.getElementById('dui').value}`, 10, 42);
            doc.text(`Correo: ${document.getElementById('correo').value}`, 10, 48);
            doc.text(`Dirección: ${document.getElementById('direccion').value}`, 10, 54);

            // Obtener datos de la tabla
            const rows = [];
           // let totalSubtotal = 0;

            document.querySelectorAll('#myTable tbody tr'  10, 22).forEach(row => {
                const cells = row.querySelectorAll('td');
                //const subtotal = parseFloat(cells[4].textContent);
               // totalSubtotal += subtotal;

                rows.push([
                   // cells[0].textContent,  // Producto
                    cells[1].textContent,  // codigo
                    cells[2].textContent,  // nombre
                    cells[3].textContent,  // Cantidad
                    cells[4].textContent,  // precio
                    cells[5].textContent,  // Cantidad
                   <%--`$${parseFloat(cells[4].textContent).toFixed(3)}`,  // Precio Unitario 
                    `$${subtotal.toFixed(3)}`  // Subtotal --%>
                ]);
            });

            // Agregar tabla de productos al PDF
            doc.autoTable({
                startY: 50,
                head: [['cod.', 'producto', 'cantidad','Precio Unitario', 'Subtotal']],
                body: rows,
                foot: [['', '','', 'Total:', `$${totalSubtotal.toFixed(2)}`]]
            });

            // Guardar PDF
            doc.save('factura.pdf');
        });
    </script>

       
   
    <script>
        $(document).ready(function() {
        $('#myTableInv').DataTable({
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
        function cargarDesdeLocalStorage() {
          // Recuperar los datos desde el localStorage
            const clienteSeleccionado = localStorage.getItem('registroGuardado');
             console.log('Datos guardados en localStorage xd:', clienteSeleccionado.correo);
            if (clienteSeleccionado) {
                // Convertir el string JSON a un objeto
                const clienteData = JSON.parse(clienteSeleccionado);

                // Mostrar los datos en la consola   idcliente
                console.log('DUI:', clienteData.dui);

                document.getElementById('dui').value = clienteData.dui;
                console.log('Nombre:', clienteData.nombre);
                document.getElementById('nombre').value = clienteData.nombre;
                console.log('Correo:', clienteData.correo);
                document.getElementById('correo').value = clienteData.correo;
                console.log('Dirección:', clienteData.direccion);
                document.getElementById('direccion').value = clienteData.direccion;
                 document.getElementById('id').value = clienteData.Id;
            } else {
                console.log('No hay datos almacenados en localStorage para "clienteSeleccionado".');
            }        
        }
    document.addEventListener('DOMContentLoaded', cargarDesdeLocalStorage);  
    </script> 


       
    <script>
    async function generarYEnviarPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Agregar datos del cliente al PDF
        doc.setFontSize(12);
        doc.text("Factura", 10, 10);
        doc.text(`Fecha y Hora: ${document.getElementById('datetime').value}`, 10, 20);
        doc.text(`Nombre: ${document.getElementById('nombre').value}`, 10, 30);
        doc.text(`DUI: ${document.getElementById('dui').value}`, 10, 40);
        doc.text(`Correo: ${document.getElementById('correo').value}`, 10, 50);
        doc.text(`Dirección: ${document.getElementById('direccion').value}`, 10, 60);

        // Agregar productos a la tabla en el PDF
        const productos = [];
        document.querySelectorAll('#myTable tbody tr').forEach(row => {
            const columnas = row.querySelectorAll('td');
            productos.push([
                columnas[1].innerText, // Código
                columnas[2].innerText, // Nombre
                columnas[3].innerText, // Cantidad
                columnas[4].innerText, // Precio Unitario
                columnas[5].innerText  // Subtotal
            ]);
        });

        doc.autoTable({
            startY: 70,
            head: [['Código', 'Nombre', 'Cantidad', 'Precio Unitario', 'Subtotal']],
            body: productos
        });

        doc.text(`Total: ${document.getElementById('totalSubtotal').innerText}`, 10, doc.lastAutoTable.finalY + 10);

        // Exportar como Blob y enviar
        const pdfBlob = doc.output('blob');

        // Preparar FormData
        const formData = new FormData();
        formData.append('correo', document.getElementById('correo').value);
        formData.append('pdf', pdfBlob, 'factura.pdf');

        // Enviar al backend
        try {
            const response = await fetch('EnviarCorreo', {
                method: 'POST',
                body: formData
            });
            const result = await response.text();
            alert(result);
        } catch (error) {
            console.error('Error al enviar el correo:', error);
        }
    }
</script>

    <script>
        function calcularYValidar() {
            var cantidad = document.getElementById('cantidad').value;
            var precioUnitario = document.getElementById('precio').value;
            var subtotal = cantidad * precioUnitario;
            document.getElementById('subtotal').value = subtotal;

            const btnModificar = document.getElementById('btnModificar');

            // Validar que el input no esté vacío y no comience con un espacio
            if (cantidad.trim() !== '' && cantidad[0] !== ' ') {
                btnModificar.disabled = false;
            } else {
                btnModificar.disabled = true;
            }
        }
        
         // Seleccionar todas las celdas con la clase "subtotal"
        const subtotalCells = document.querySelectorAll('.subtotal');

        // Inicializar un acumulador para el total
        let total = 0;

        // Iterar sobre cada celda de subtotal y sumar su valor
        subtotalCells.forEach(cell => {
            // Extraer el valor numérico (eliminando el símbolo de dólar y convirtiendo a número)
            const subtotalValue = parseFloat(cell.textContent.replace('$', ''));
            total += subtotalValue;
        });

        // Mostrar el total en la celda con el ID "totalSubtotal"
        document.getElementById('totalSubtotal').textContent = '$' + total.toFixed(2);
    </script>
    <script>
        function toggleNIFInput(show) {
            const nifGroup = document.getElementById('nifGroup');
            const nifInput = document.getElementById('nit');
            if (show) {
                nifGroup.style.display = 'block';
                nifInput.required = true;
                nifInput.value = ''; //oculta el N/A despues de seleccionar no y despues si
            } else {
                nifGroup.style.display = 'none';
                nifInput.value = 'N/A';
                nifInput.required = false;
            }
        }
    </script>     
    <script>
        function EditCantidad(id_detalle,inventario, cantidad, id_venta, precio, subtotal) {
            document.getElementById("id_detalle").value = id_detalle;
            document.getElementById("inventario").value = inventario;
            document.getElementById("cantidad").value = cantidad;
            document.getElementById("id_venta").value = id_venta;
            document.getElementById("precio").value = precio;
            document.getElementById("subtotal").value = subtotal;
            document.getElementById('CantModalLabel').innerText = 'Cambiar cantidad';
            document.getElementById('btnModificar').name = 'modificar'; // Cambiar la acción a "modificar"
        } 
        function Cancelar(){
            document.getElementById("id").value = "<%= request.getParameter("idcliente") %>"; 
            document.getElementById("nombre").value = "<%= request.getParameter("nombre") %>";                
            document.getElementById("dui").value = "<%= request.getParameter("dui") %>";
            document.getElementById("nifSi").checked = false;
            document.getElementById("nifNo").checked = false;
            document.getElementById("nifGroup").style.display = 'none';
            document.getElementById("correo").value = "<%= request.getParameter("correo") %>";
            document.getElementById("direccion").value = "<%= request.getParameter("direccion") %>";
            document.getElementById("datos").options = true;
            localStorage.removeItem('registroGuardado');
        }
        function EliminarProducto(elim, id_detalle){
            var r = confirm("¿Seguro que desea eliminar el empleado?");
            if(r)
                window.location.href = "ControlDetalle?eliminar=" + elim + "&id_detalle=" + id_detalle;
        }
    </script>   
         
    <script>
       window.onload = function() {
        // Generar un código único (UUID)
        function generateUUID() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
                return v.toString(16);
            });
        }

        // Mostrar el código único en una alerta
        const uniqueCode = generateUUID();


        // Asigna el código al input con id "codfactura"
        document.getElementById('codfactura').value = uniqueCode;
        };
    </script>
    <br/><br/> <br/><br/>
        <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
            <div class="container">
                <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga - Enmanuel Sánchez</p>
            </div>
        </footer>
    </body>
</html>
