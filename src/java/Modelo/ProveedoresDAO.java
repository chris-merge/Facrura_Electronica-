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

public class ProveedoresDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Marcas marcas;
    Proveedores proveedores;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
     public int InsertarProveedores(Proveedores pProveedores){
        int n = 0;
        try{
            ps = conectar().prepareStatement("INSERT INTO proveedores(nomproveedor, idmarca, telproveedor, correoproveedor) VALUES(?,?,?,?)");
            ps.setString(1, pProveedores.getNomproveedor());
            ps.setInt(2,pProveedores.getMarcas().getIdmarcas());
            ps.setInt(3, pProveedores.getTelproveedor());
            ps.setString(4, pProveedores.getCorreoproveedor());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
     public int ModificarProveedores(Proveedores pProveedores){
        int n = 0;
        try{             
            ps = conectar().prepareStatement("UPDATE proveedores SET nomproveedor=?, idmarca=?, telproveedor=?, correoproveedor=? WHERE idproveedores=?");
            ps.setString(1, pProveedores.getNomproveedor());
            ps.setInt(2,pProveedores.getMarcas().getIdmarcas());
            ps.setInt(3, pProveedores.getTelproveedor());
            ps.setString(4, pProveedores.getCorreoproveedor());
            ps.setInt(5, pProveedores.getIdproveedores());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }     
    public int EliminarProveedores(Proveedores pProveedores){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM proveedores WHERE idproveedores=?");
            ps.setInt(1, pProveedores.getIdproveedores());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    
    public ArrayList<Proveedores> MostrarProveedores(){
        ArrayList<Proveedores> ar = new ArrayList<Proveedores>();
        try{
            ps = conectar().prepareStatement("SELECT * FROM proveedores p INNER JOIN marcas e ON p.idmarca= e.idmarcas ORDER BY p.idproveedores ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                marcas = new Marcas(rs.getInt("e.idmarcas"), rs.getString("e.nommarcas"));
                proveedores = new Proveedores(rs.getInt("p.idproveedores"), rs.getString("p.nomproveedor"), 
                rs.getInt("p.telproveedor"), rs.getString("p.correoproveedor"),marcas);
                ar.add(proveedores);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }
    
   public Proveedores ObtenerProveedoresPorId(int pIdproveedores){
        try{
            ps = conectar().prepareStatement("SELECT * FROM proveedores p INNER JOIN clientes e ON p.idmarca = e.idmarcas  WHERE p.idproveedores=?;");
                                                    
            ps.setInt(1, pIdproveedores);
            rs = ps.executeQuery();
            while(rs.next()){
              marcas = new Marcas(rs.getInt("e.idmarcas"), rs.getString("e.nommarcas"));
                proveedores = new Proveedores(rs.getInt("p.idproveedores"), rs.getString("p.nomproveedor"),
                        rs.getInt("p.telproveedor"), rs.getString("p.correoproveedor"),marcas);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return proveedores;
    } 
    
    public ArrayList<Proveedores> BuscarProveedores(String opc, String texto){
        ArrayList<Proveedores> ar = new ArrayList<Proveedores>();
        try{
            String sql = "SELECT * FROM proveedores p INNER JOIN marcas e ON p.idmarca = e.idmarcas";
            if(texto != ""){
                if(opc.equals("proveedores"))
                    sql += " WHERE p.nomproveedor LIKE '%" + texto + "%'";                
                else if (opc.equals("marcas"))
                   sql += " WHERE e.nommarcas LIKE '%" + texto + "%'";
             }
            ps = conectar().prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()){                
                marcas = new Marcas(rs.getInt("e.idmarcas"), rs.getString("e.nommarcas"));
                proveedores = new Proveedores(rs.getInt("p.idproveedores"), rs.getString("p.nomproveedor"),
                        rs.getInt("p.telproveedor"), rs.getString("p.correoproveedor"),marcas);
                ar.add(proveedores);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }
}
