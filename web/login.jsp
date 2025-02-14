+<%-- 
    Document   : login
    Created on : 18 oct 2024, 22:49:51
    Author     : Gerardo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/styles.css" rel="stylesheet" type="text/css"/>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link href="fontawesome/css/all.min.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <div id="cuadro">
            <form action="ControlLogin" method="post" autocomplete="off">
                <P id="titulo">Login</p>
                <hr>
                <br/><br/>
                <label id="subtitulo1" for="usernombre"> USUARIO</label>
                <br/><br/>
                 <input type="text" name="usernombre" class="entrada" required onkeypress="bloquearEspacios(event)"/>
                <br/><br/>
                <label id="subtitulo2" for="usercontraseña">CONTRASEÑA</label> 
                <br/><br/>
                <input type="password" id="passwordInput" name="usercontraseña" class="entrada" required/>
                <br/><br/>
                <input type="checkbox" id="showPassword" onclick="togglePasswordVisibility()"> Show password
                <br/><br/>
                <input type="submit" value="Iniciar sesion" name="btn" class="boton"/>  
            </form>
            <br>                     
        <%
            HttpSession sesion = request.getSession();
            if(request.getAttribute("r") != null){
                if(request.getAttribute("r").equals("1")){
                    sesion.setAttribute("s", request.getAttribute("usr"));
                    response.sendRedirect("Home.jsp");
                }
                else
                    out.println("<script>Swal.fire('Credenciales incorrectas');</script>");
            }
        %>                          
      </div>
    </body>
    <script>
         //bloquea los espacio en los inputs
        function bloquearEspacios(event) {
            if (event.key === ' ') {
                event.preventDefault();
            }
        }
        function togglePasswordVisibility() {
            var passwordInput = document.getElementById("passwordInput");
            var showPasswordCheckbox = document.getElementById("showPassword");   


            if (showPasswordCheckbox.checked) {
                passwordInput.type = "text";
            } else {
                passwordInput.type = "password";
            }
        }
         
    </script>  
</html>
