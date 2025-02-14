<%-- 
    Document   : backup
    Created on : 3 dic 2024, 09:54:03
    Author     : Gerardo
--%>

<%-- @page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html> --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Generar Backup</title>
</head>
<body>
    <h1>Generar Backup de la Base de Datos</h1>

    <form action="generateBackup" method="get">
        <button type="submit">Generar Backup</button>
    </form>

    <p>
        <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
    </p>
</body>
</html>
