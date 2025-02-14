/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Joel
 */

import java.sql.*;
import java.util.*;

public class InventarioDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Proveedores proveedores;
    Inventario inventario;
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
    
     public int InsertarInventario(Inventario iInventario){
        int n = 0;
        try{
            ps = conectar().prepareStatement("INSERT INTO inventario(codproducto, nomproducto, idproveedor, serie, modelo, precio_unitario, cantidad) VALUES(?,?,?,?,?,?,?)");
            ps.setInt(1, iInventario.getCodproducto());
            ps.setString(2, iInventario.getNomproducto());
            ps.setInt(3,iInventario.getProveedores().getIdproveedores());            
            ps.setString(4, iInventario.getSerie());
            ps.setString(5, iInventario.getModelo());
            ps.setDouble(6, iInventario.getPrecio_unitario());
            ps.setInt(7, iInventario.getCantidad());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    } 
     public int ModificarInventario(Inventario iInventario) {
        int n = 0;
        try {
        // Preparar el statement para actualizar los datos del inventario
            ps = conectar().prepareStatement("UPDATE inventario SET codproducto=?, nomproducto=?, idproveedor=?, serie=?, modelo=?, precio_unitario=?, cantidad=? WHERE idinventario=?");
        
        // Asignar los valores a cada parámetro de la consulta
            ps.setInt(1, iInventario.getCodproducto());
            ps.setString(2, iInventario.getNomproducto());
            ps.setInt(3,iInventario.getProveedores().getIdproveedores()); 
            ps.setString(4, iInventario.getSerie());
            ps.setString(5, iInventario.getModelo());
            ps.setDouble(6, iInventario.getPrecio_unitario());
            ps.setInt(7, iInventario.getCantidad());                                                 
            ps.setInt(8, iInventario.getIdinventario());

        // Ejecutar la actualización y devolver el número de filas afectadas
            n = ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
     public int EliminarInventario(Inventario iInventario) {
        int n = 0;
        try {
        // Preparar el statement para eliminar el inventario
            ps = conectar().prepareStatement("DELETE FROM inventario WHERE idinventario=?");
        // Asignar el idinventario al parámetro de la consulta
            ps.setInt(1, iInventario.getIdinventario());
            
        // Ejecutar la eliminación y devolver el número de filas afectadas
            n = ps.executeUpdate();
           ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
     public ArrayList<Inventario> MostrarInventario(){
        ArrayList<Inventario> ar = new ArrayList<Inventario>();
        try{
            ps = conectar().prepareStatement("SELECT * FROM inventario i INNER JOIN proveedores p ON i.idproveedor = p.idproveedores ORDER BY idinventario ASC;");
            rs = ps.executeQuery();
            while(rs.next()){                
                proveedores = new Proveedores(rs.getInt("p.idproveedores"), rs.getString("p.nomproveedor"), 
                rs.getInt("p.telproveedor"), rs.getString("p.correoproveedor"),null);
                inventario = new Inventario(rs.getInt("i.idinventario"), rs.getInt("i.codproducto"),
                rs.getString("i.nomproducto"), rs.getString("i.serie"), rs.getString("i.modelo"), rs.getDouble("i.precio_unitario"),
                rs.getInt("i.cantidad"), proveedores );
                ar.add(inventario);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    } 
     public ArrayList<Inventario> BuscarInventario(String opc, String texto){
        ArrayList<Inventario> ar = new ArrayList<Inventario>();
        try{
            String sql = "SELECT * FROM inventario";
            if(texto != ""){
                if(opc.equals("inventario"))
                    sql += " WHERE p.codproducto LIKE '%" + texto + "%'";                
                else if (opc.equals("inventario"))
                   sql += " WHERE e.nomproducto LIKE '%" + texto + "%'";
             }
            ps = conectar().prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()){                
                proveedores = new Proveedores(rs.getInt("p.idproveedores"), rs.getString("p.nomproveedor"),rs.getInt("p.telproveedor"), rs.getString("p.correoproveedor"),null);
                inventario = new Inventario(rs.getInt("i.idinventario"), rs.getInt("i.codproducto"),rs.getString("i.nomproducto"),rs.getString("i.serie"),
                rs.getString("i.modelo"),rs.getDouble("i.precio_unitario"),rs.getInt("i.cantidad"),proveedores);
                ar.add(inventario);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }              
}
