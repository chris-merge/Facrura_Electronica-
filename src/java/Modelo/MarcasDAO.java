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
public class MarcasDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Marcas marcas;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
    public int InsertarMarcas(Marcas pMarcas) {
        int n = 0;
        try {
            // Comprobar datos duplicados antes de insertar
            ps = conectar().prepareStatement("SELECT COUNT(*) FROM marcas WHERE nommarcas = ?");
            ps.setString(1, pMarcas.getNommarcas());
            rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) { // No hay roles duplicados, insertar
                ps.close();
                rs.close();

                ps = conectar().prepareStatement("INSERT INTO marcas(nommarcas ) VALUES(?)");
                ps.setString(1, pMarcas.getNommarcas());
                n = ps.executeUpdate();
            } else{
                // El registro ya existe
               System.out.println("Error: Duplicate role found. Record not inserted.");

            }
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
     }
    
     public int ModificarMarcas(Marcas pMarcas) {
    int n = 0;
    try {
        // Check for duplicate username before modifying (excluding the current user)
        ps = conectar().prepareStatement("SELECT COUNT(*) FROM marcas WHERE nommarcas = ?");
        ps.setString(1, pMarcas.getNommarcas());
        rs = ps.executeQuery();
        rs.next();

            if (rs.getInt(1) == 0) {
            // Username doesn't exist or is the same as current user, and empdui has changed, modify
            ps.close();
            rs.close();

            ps = conectar().prepareStatement("UPDATE marcas SET nommarcas=? WHERE idmarcas=?");
            ps.setString(1, pMarcas.getNommarcas());
            ps.setInt(2, pMarcas.getIdmarcas());

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
    
    public int EliminarMarcas(Marcas pMarcas){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM marcas WHERE idmarcas=?");
            ps.setInt(1, pMarcas.getIdmarcas());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    
    public ArrayList<Marcas> MostrarMarcas(){
        ArrayList<Marcas> ar = new ArrayList<Marcas>();
        try{
            ps = conectar().prepareStatement("SELECT * FROM marcas ORDER BY idmarcas ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                marcas = new Marcas(rs.getInt(1), rs.getString(2));
                ar.add(marcas);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }      
}
