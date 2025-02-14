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

public class RolesDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Roles roles;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
    
    public int InsertarRoles(Roles pRoles) {
        int n = 0;
        try {
            // Comprobar datos duplicados antes de insertar
            ps = conectar().prepareStatement("SELECT COUNT(*) FROM roles WHERE rol = ?");
            ps.setString(1, pRoles.getRol());
            rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) { // No hay roles duplicados, insertar
                ps.close();
                rs.close();

                ps = conectar().prepareStatement("INSERT INTO roles(rol, permisos ) VALUES(?,?)");
                ps.setString(1, pRoles.getRol());
                ps.setString(2, pRoles.getPermisos());
                n = ps.executeUpdate();
            } else{
                // El registro ya existe
               System.out.println("Error: se encontro rol duplicados found. Regisrto no insertado.");

            }
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
     }
    
    public int EliminarRoles(Roles pRoles){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM roles WHERE idrol=?");
            ps.setInt(1, pRoles.getIdrol());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    
    public int ModificarRoles(Roles pRoles) {
    int n = 0;
    try {
        // Check for duplicate username before modifying (excluding the current user)
        ps = conectar().prepareStatement("SELECT COUNT(*) FROM roles WHERE rol = ?");
        ps.setString(1, pRoles.getRol());
        rs = ps.executeQuery();
        rs.next();

            if (rs.getInt(1) == 0) {
            // Username doesn't exist or is the same as current user, and empdui has changed, modify
            ps.close();
            rs.close();

            ps = conectar().prepareStatement("UPDATE roles SET rol=?, permisos=? WHERE idrol=?");
            ps.setString(1, pRoles.getRol());
            ps.setString(2, pRoles.getPermisos());
            ps.setInt(3, pRoles.getIdrol());
            n = ps.executeUpdate();

        } else if (rs.getInt(1) > 0) { // 
            // Username already exists for another user, and empdui has changed, don't modify
            System.out.println("Error: Username already exists or empdui has changed. Record not modified.");
        }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
    
    public ArrayList<Roles> MostrarRoles(){
        ArrayList<Roles> ar = new ArrayList<Roles>();
        try{
            ps = conectar().prepareStatement("SELECT * FROM roles ORDER BY idrol ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                roles = new Roles(rs.getInt(1), rs.getString(2),rs.getString(3));
                ar.add(roles);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }    
}
