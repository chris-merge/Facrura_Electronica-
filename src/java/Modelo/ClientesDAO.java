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
public class ClientesDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Clientes clientes;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
     public int InsertarClientes(Clientes pClientes){
       int n = 0;    
       try {
             // Comprobar datos duplicados antes de insertar
            ps = conectar().prepareStatement("SELECT COUNT(*) FROM clientes WHERE dui = ?");
            ps.setInt(1, pClientes.getDui());
            rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {// No hay roles duplicados, insertar
                ps.close();
                rs.close();

                ps = conectar().prepareStatement("INSERT INTO clientes(nombre, dirección, telefono, dui, correo ) VALUES(?,?,?,?,?)");
                ps.setString(1, pClientes.getNombre());
                ps.setString(2, pClientes.getDireccion());
                ps.setInt(3, pClientes.getTelefono());
                ps.setInt(4, pClientes.getDui());
                ps.setString(5, pClientes.getCorreo());
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
    
    public int ModificarClientes(Clientes pClientes){
        int n = 0;
        try{
            ps = conectar().prepareStatement("UPDATE clientes SET nombre=?, dirección=?, telefono=?, dui=?, correo=? WHERE idcliente =?");
            ps.setString(1, pClientes.getNombre());
            ps.setString(2, pClientes.getDireccion());
            ps.setInt(3, pClientes.getTelefono());
            ps.setInt(4, pClientes.getDui()); //dui=?
            ps.setString(5, pClientes.getCorreo());
            ps.setInt(6, pClientes.getIdcliente());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    public int EliminarClientes(Clientes pClientes){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM clientes WHERE idcliente=?");
            ps.setInt(1, pClientes.getIdcliente());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    
     public ArrayList<Clientes> MostrarClientes(){
        ArrayList<Clientes> ar = new ArrayList<Clientes>();
        try {
            ps = conectar().prepareStatement("SELECT * FROM clientes ORDER BY idcliente ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                clientes = new Clientes(rs.getInt(1), rs.getString(2),rs.getString(3), rs.getInt(4),rs.getInt(5), rs.getString(6));
                ar.add(clientes);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }   

    public Clientes BuscarClientes(int pid) {
        try{
            ps = conectar().prepareStatement("SELECT * FROM clientes WHERE idcliente =?");
                                                    
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            while(rs.next()){
             clientes = new Clientes(rs.getInt("idcliente"), rs.getString("nombre"), rs.getString("dirección"), 
                rs.getInt("telefono"), rs.getInt("dui"), rs.getString("correo"));
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return clientes;
    }
    
    public boolean guardarfactura(Clientes pClientes){
        try{
            ps = conectar().prepareStatement("INSERT INTO misfacturas (clienteid) VALUES (?)");
            ps.setInt(1, pClientes.getIdcliente());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        
     }

    public Clientes BuscarClientes(String clienteId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}

