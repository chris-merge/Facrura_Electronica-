<%-- 
    Document   : Home
    Created on : 18 oct 2024, 22:49:09
    Author     : Gerardo
--%>

<%@page session="true" import="java.util.*" import="Modelo.*" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">        
        <link href="css/home.css" rel="stylesheet" type="text/css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="js/bootstrap.bundle.min.js"></script>
        
        <style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.container {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 20px;
    padding: 2rem;
    backdrop-filter: blur(10px);
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
}

.social-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;    
    max-width: 1200px;
}

.social-item {
    text-align: center;
    transition: transform 0.3s ease;
    padding: 1.5rem;
    border-radius: 15px;
    border: #bcbebf;    
}

.social-item:hover {
    transform: translateY(-50px);
}

.social-name {
    color: blue;
    text-decoration: none;
    font-size: 2rem;
    font-weight: 500;
    display: block;
    margin-top: 1rem;
}

h1 {
    color: blue;
    text-align: center;
    margin-bottom: 2rem;
    font-size: 2.5rem;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}
</style> 
    </head>
    <body>
        <%
        HttpSession sesion = request.getSession();
        String usr = "";
        String rol = "";
       
        if (sesion.getAttribute("usernombre") != null && sesion.getAttribute("userrol") != null) {
            usr = sesion.getAttribute("usernombre").toString();
            rol = sesion.getAttribute("userrol").toString();
            
            if (!rol.equals("1")) {
                response.sendRedirect("HomeAdmin.jsp"); // Redirige si no es administrador
                return;
            }
            if (!rol.equals("1")) {
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
                            <a class="nav-link" href="Home.jsp" style="color: white">Home</a>
                        </li>
                        <a  type="btn" class="cerrar-sesion" href="?action=logout" >Cerrar sesion</a>                 
                    </ul>
                </div>
            </nav>
      <h2 style="float: left;"> 
        <img width="130" height="100" src="imagen/logo.png">
      </h2>
      <br>      
     <h2>Bienvenido al sistema, <%= usr %> </h2>
     <h2>¿Que proceso desea realizar?</h2>
    <br>   
    <div class="social-grid">
        <div>            
        </div>
        <div class="social-item">
            <%-- <a href="VistaEmpleado.jsp" target="_blank">--%>
            <a href="VistaEmpleado.jsp">
                <img  width="95" height="90" src="imagen/employeess.gif">
                <h2 class="social-name">Empleados</h2>
            </a>
        </div>
        <div class="social-item">
            <a href="VistaDetalles.jsp" >
                    <img  width="90" height="90" src="imagen/factura.gif">
                <h2 class="social-name">Facturación</h2>
            </a>
        </div>
        <div class="social-item">
            <a href="VistaInventarios.jsp">
                <img  width="90" height="90" src="imagen/inventario.gif">
                <h2 class="social-name">Inventario</h2>
            </a>
        </div>
        <div class="social-item">
            <a href="VistaUsuarios.jsp">                        
                <img  width="95" height="90" src="imagen/addusers.gif">
                <h2 class="social-name">Usuarios</h2>
            </a>
        </div>
    </div>
    <br>
    <div class="social-grid">
        <div>            
        </div>
        <div>            
        </div>
        <div class="social-item">
            <a href="VistaMisFacturas.jsp">
                <img  width="90" height="90" src="imagen/invoices.gif">
                <h2 class="social-name">Mis Facturas</h2>
            </a>
        </div>
        <div class="social-item">
           <a href="VistaClientes.jsp">
               <img  width="90" height="90" src="imagen/empleados.gif">
                <h2 class="social-name">Clientes</h2>
            </a>
        </div>
        
        <div>            
        </div>
        
        <div>            
        </div>
    </div>
 <!--<br/>-->
    <footer class="bg-dark navbar-dark text-white text-center py-3 mt-5">
       <!-- <div class="container">-->
        <div>
            <p class="mb-0">&copy; Facturación_Electronica, - Gerardo Tepas - Saúl Zúniga  - Enmanuel Sánchez</p>
        </div>
    </footer>  
   </body>    
</html>