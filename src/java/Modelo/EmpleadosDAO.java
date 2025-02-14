/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */

import java.sql.*;
import java.util.*;

public class EmpleadosDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Roles roles;
    Empleados empleados;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
    
    public int InsertarEmpleados(Empleados pEmpleados) {
       int n = 0;    
       try {
             // Comprobar datos duplicados antes de insertar
            ps = conectar().prepareStatement("SELECT COUNT(*) FROM empleados WHERE empdui = ?");
            ps.setInt(1, pEmpleados.getEmpdui());
            rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {// No hay roles duplicados, insertar
            ps.close();
            rs.close();

            ps = conectar().prepareStatement("INSERT INTO empleados (empnombre, empapellido, empdui, emptelefono, empcorreo, empcargo) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setString(1, pEmpleados.getEmpnombre());  
            ps.setString(2, pEmpleados.getEmpapellido());  
            ps.setInt(3, pEmpleados.getEmpdui());  
            ps.setInt(4, pEmpleados.getEmptelefono());  
            ps.setString(5, pEmpleados.getEmpcorreo());  
            ps.setInt(6, pEmpleados.getRoles().getIdrol()); 
                n = ps.executeUpdate();
            } else {
                // El registro ya existe
                System.out.println("Error: Username already exists. Record not inserted.");
            }
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
    
    public int ModificarEmpleados(Empleados pEmpleados) {
        int n = 0;
        try {
              ps = conectar().prepareStatement("UPDATE empleados SET empnombre=?, empapellido=?, empdui=?, emptelefono=?, empcorreo=?, empcargo=? WHERE idempleado =?");
                ps.setString(1, pEmpleados.getEmpnombre());
                ps.setString(2, pEmpleados.getEmpapellido());
                ps.setInt(3, pEmpleados.getEmpdui());  //empdui=?,
                ps.setInt(4, pEmpleados.getEmptelefono());
                ps.setString(5, pEmpleados.getEmpcorreo());
                ps.setInt(6, pEmpleados.getRoles().getIdrol());  // Actualizar el cargo (referencia al ID del rol)
                ps.setInt(7, pEmpleados.getIdempleado());  // Condición: ID del empleado a modificar
            n = ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }

    public int EliminarEmpleados(Empleados pEmpleados){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM empleados WHERE idempleado=?"); 
            ps.setInt(1, pEmpleados.getIdempleado());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    

public ArrayList<Empleados> MostrarEmpleados(){
        ArrayList<Empleados> ar = new ArrayList<Empleados>();       
     try{
            ps = conectar().prepareStatement("SELECT * FROM empleados p INNER JOIN roles e ON p.empcargo = e.idrol ORDER BY p.idempleado ASC;");
            rs = ps.executeQuery();
         while(rs.next()){
                roles = new Roles(rs.getInt("e.idrol"), rs.getString("e.rol"), rs.getString("e.permisos"));
                empleados = new Empleados(rs.getInt("p.idempleado"), rs.getString("p.empnombre"), rs.getString("p.empapellido"), rs.getInt("p.empdui"), rs.getInt("p.emptelefono"), rs.getString("p.empcorreo"), roles);
                ar.add(empleados);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }


        // Método para obtener un empleado por su ID
    
    public Empleados ObtenerEmpleadosPorId(int pIdempleado){
        try{
            ps = conectar().prepareStatement("SELECT * FROM empleados p INNER JOIN roles e ON p.empcargo = e.idrol WHERE p.idempleado =?;");
            ps.setInt(1, pIdempleado);
            rs = ps.executeQuery();
            while(rs.next()){
                roles = new Roles(rs.getInt("e.idrol"), rs.getString("e.rol"), rs.getString("e.permisos"));
                empleados = new Empleados(rs.getInt("p.idempleado"), rs.getString("p.empnombre"), rs.getString("p.empapellido"), rs.getInt("p.empdui"), rs.getInt("p.emptelefono"), rs.getString("p.empcorreo"), roles);                
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return empleados;
    } 
    
    public ArrayList<Empleados> BuscarEmpleados(String opc, String texto){
        ArrayList<Empleados> ar = new ArrayList<Empleados>();
        try{
            String sql ="SELECT * FROM empleados p INNER JOIN roles e ON p.empcargo = e.idrol";
            if(texto != ""){
                if(opc.equals("roles"))
                    sql += " WHERE e.rol LIKE '%" + texto + "%'";               
                else if (opc.equals("empleados"))
                   sql += " WHERE p.empdui LIKE '%" + texto + "%'";
             }
            ps = conectar().prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()){                
               roles = new Roles(rs.getInt("e.idrol"), rs.getString("e.rol"), rs.getString("e.permisos"));
               empleados = new Empleados(rs.getInt("p.idempleado"), rs.getString("p.empnombre"), rs.getString("p.empapellido"), rs.getInt("p.empdui"), rs.getInt("p.emptelefono"), rs.getString("p.empcorreo"),roles);
                ar.add(empleados);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }
    
}