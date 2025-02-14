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
public class DetallesDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Inventario inventario;
    Detalles detalles;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
    
    public int InsertarDetalles(Detalles pDetalles){
        int n = 0;
        try{
            ps = conectar().prepareStatement("INSERT INTO detallesfactura( id_pro, cantidad, id_venta, precio, subtotal) VALUES(?,?,?,?,?)");
            ps.setInt(1, pDetalles.getInventario().getIdinventario());
            ps.setInt(2,pDetalles.getCantidad());
            ps.setInt(3, pDetalles.getId_venta());
            ps.setDouble(4, pDetalles.getPrecio());
            ps.setDouble(5, pDetalles.getSubtotal());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
    
    public int ModificarDetalles(Detalles pDetalles){
        int n = 0;
        try {
        // Preparar el statement para actualizar los datos del inventario
            ps = conectar().prepareStatement("UPDATE detallesfactura SET cantidad=?, id_venta=?, id_pro=?, precio=?, subtotal=? WHERE id_detalle =?");
        // Asignar los valores a cada parámetro de la consulta
            ps.setInt(1, pDetalles.getCantidad());
            ps.setInt(2,pDetalles.getId_venta()); 
            ps.setInt(3,pDetalles.getInventario().getIdinventario()); 
            ps.setDouble(4, pDetalles.getPrecio());  
            ps.setDouble(5, pDetalles.getSubtotal());
            ps.setInt(6, pDetalles.getId_detalle());

        // Ejecutar la actualización y devolver el número de filas afectadas
            n = ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
    
     public int EliminarDetalles(Detalles pDetalles){
        int n = 0;
        try {
        // Preparar el statement para eliminar el inventario
            ps = conectar().prepareStatement("DELETE FROM detallesfactura WHERE id_detalle=?");
        // Asignar el idinventario al parámetro de la consulta
            ps.setInt(1, pDetalles.getId_detalle());
            
        // Ejecutar la eliminación y devolver el número de filas afectadas
            n = ps.executeUpdate();
           ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
    public ArrayList<Detalles> MostrarDetalles(){
        ArrayList<Detalles> ar= new ArrayList<Detalles>();
            try (Connection connection = conectar()){
            ps = connection.prepareStatement("SELECT * FROM detallesfactura p INNER JOIN inventario e ON p.id_pro= e.idinventario ORDER BY id_detalle ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                inventario = new Inventario(rs.getInt("e.idinventario"),rs.getInt("e.codproducto"), rs.getString("e.nomproducto"), rs.getString("e.serie"), rs.getString("e.modelo"), rs.getDouble("e.precio_unitario"), rs.getInt("e.cantidad"), null);
                detalles = new Detalles(rs.getInt("p.id_detalle"), rs.getInt("p.cantidad"),rs.getInt("p.id_venta"),  rs.getDouble("p.precio"),rs.getDouble("p.subtotal"),inventario);
                ar.add(detalles);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }    
}
