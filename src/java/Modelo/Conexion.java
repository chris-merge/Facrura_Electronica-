////CONEXION DE LA BASE DE DATOS EN AWS
//
///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package Modelo;
//
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;
///**
// *
// * @author Gerardo
// */
//public class Conexion {
//    private String driver = "com.mysql.cj.jdbc.Driver";
//    private String url = "jdbc:mysql://facturaelectronica.chuc0ewu2438.us-east-2.rds.amazonaws.com:3307/factura_electronica";
//    private String user = "admin";
//    private String password = "Uma#2024";
//
//    public Connection getConnection() {
//        Connection connection = null;
//        try {
//            Class.forName(driver);
//            connection = DriverManager.getConnection(url, user, password);
//        } catch (ClassNotFoundException e) {
//            System.out.println("Error al cargar el driver: " + e.getMessage());
//        } catch (SQLException e) {
//            System.out.println("Error al conectar a la base de datos: " + e.getMessage());
//        }
//        return connection;
//    }
//
//    public String getDriver() {
//        return driver;
//    }
//
//    public void setDriver(String driver) {
//        this.driver = driver;
//    }
//
//    public String getUrl() {
//        return url;
//    }
//
//    public void setUrl(String url) {
//        this.url = url;
//    }
//
//    public String getUser() {
//        return user;
//    }
//
//    public void setUser(String user) {
//        this.user = user;
//    }
//
//    public String getPassword() {
//        return password;
//    }
//
//    public void setPassword(String password) {
//        this.password = password;
//    }
//
////    Connection conectar() {
////        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
////    }
//        public Connection conectar() throws SQLException, ClassNotFoundException {
//        Class.forName(driver);
//        return DriverManager.getConnection(url, user, password);
//    }
//}
//




////CONEXION LOCAL DE LA BASE DE DATOS
///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
package Modelo;

/**
 *
 * @author Gerardo
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private String driver = "com.mysql.cj.jdbc.Driver";
    private String url = "jdbc:mysql://localhost:3306/factura_electronica";
    //String url = "jdbc:mysql://4.tcp.ngrok.io:3306/sistema_SIGC";
    private String user ="root";
    private String password ="";

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    public Connection conectar() throws SQLException, ClassNotFoundException {
        Class.forName(driver);
        return DriverManager.getConnection(url, user, password);
    }
}
