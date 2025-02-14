/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.*;

/**
 *
 * @author Gerardo
 */
public class MisfacturasDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Detalles detalles;
    Clientes clientes;
    Misfacturas misfacturas;
    
     Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
     
      public int InsertarMisfacturas(Misfacturas pMisfacturas){
        int n = 0;
        try{
            ps = conectar().prepareStatement("INSERT INTO misfacturas(iddetalle, codigofactura, clienteid, vendedor, total, nit, fecha ) VALUES(?,?,?,?,?,?,?)");
            ps.setInt(1, pMisfacturas.getDetalles().getId_detalle());
            ps.setInt(2, pMisfacturas.getClientes().getIdcliente());
            ps.setString(3, pMisfacturas.getVendedor());
             ps.setString(4, pMisfacturas.getCodigofactura());
            ps.setDouble(5, pMisfacturas.getTotal());
            ps.setInt(6, pMisfacturas.getNit());
            ps.setString(7, pMisfacturas.getFecha());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    
    public int ModificarMisfacturas(Misfacturas pMisfacturas){
        int n = 0;
        try{
            ps = conectar().prepareStatement("UPDATE misfacturas SET iddetalle=?, clienteid=?, vendedor=?, codigofactura=?, total=?, nit=?, fecha=? WHERE id_misfacturas=?");
            ps.setInt(1, pMisfacturas.getDetalles().getId_detalle());
            ps.setInt(2, pMisfacturas.getClientes().getIdcliente());
            ps.setString(3, pMisfacturas.getVendedor());
            ps.setString(4, pMisfacturas.getCodigofactura());
            ps.setDouble(5, pMisfacturas.getTotal());
            ps.setInt(6, pMisfacturas.getNit());
            ps.setString(7, pMisfacturas.getFecha());
            ps.setInt(8, pMisfacturas.getId_misfacturas());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    public int EliminarMisfacturas(Misfacturas pMisfacturas){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM misfacturas WHERE id_misfacturas=?");
            ps.setInt(1, pMisfacturas.getId_misfacturas());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
      public ArrayList<Misfacturas> MostrarMisfacturas(){
        ArrayList<Misfacturas> ar = new ArrayList<Misfacturas>();
        try{
            ps = conectar().prepareStatement("SELECT * FROM misfacturas p INNER JOIN clientes e ON p.clienteid = e.idcliente INNER JOIN detallesfactura m ON p.iddetalle = m.id_detalle ORDER BY p.id_misfacturas ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                clientes = new Clientes(rs.getInt("e.idcliente"), rs.getString("e.nombre"), rs.getString("e.dirección"),rs.getInt("e.telefono"),rs.getInt("e.dui"),rs.getString("e.correo"));             
                detalles = new Detalles(rs.getInt("m.id_detalle"), rs.getInt("m.cantidad"),rs.getInt("m.id_venta"),  rs.getDouble("m.precio"),rs.getDouble("m.subtotal"),null);               
                misfacturas = new Misfacturas(rs.getInt("p.id_misfacturas"), rs.getString("p.vendedor"),rs.getString("p.codigofactura"), rs.getDouble("p.total"),rs.getInt("p.nit"),rs.getString("p.fecha"), detalles, clientes);            
                ar.add(misfacturas);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }
}
