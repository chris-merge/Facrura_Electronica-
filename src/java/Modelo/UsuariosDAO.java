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

public class UsuariosDAO{
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();
    Roles roles;
    Usuarios usuarios;
    
    Connection conectar() throws SQLException, ClassNotFoundException{
        Class.forName(con.getDriver());
        return DriverManager.getConnection(con.getUrl(), con.getUser(), con.getPassword());
    }
   
    public int InsertarUsuarios(Usuarios pUsuarios){
       int n = 0;    
       try {
             // Comprobar datos duplicados antes de insertar
            ps = conectar().prepareStatement("SELECT COUNT(*) FROM usuarios WHERE usernombre = ?");
            ps.setString(1, pUsuarios.getUsernombre());
            rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) == 0) {// No hay roles duplicados, insertar
                ps.close();
                rs.close();

                ps = conectar().prepareStatement("INSERT INTO usuarios(usernombre, usercontraseña, userrol) VALUES(?,?,?)");
                ps.setString(1, pUsuarios.getUsernombre());
                ps.setString(2, pUsuarios.getUsercontraseña());
                ps.setInt(3, pUsuarios.getRoles().getIdrol());
                n = ps.executeUpdate();
            } else {
                // El registro ya existe
                System.out.println("<script>Swal.fire('Credenciales incorrectas');</script>");
            }
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return n;
    }
  public int ModificarUsuarios(Usuarios pUsuarios){
        int n = 0;
        try{
             ps = conectar().prepareStatement("UPDATE usuarios SET  usercontraseña=?, userrol=? WHERE userid=?");
            ps.setString(1, pUsuarios.getUsercontraseña());
            ps.setInt(2, pUsuarios.getRoles().getIdrol());
            ps.setInt(3, pUsuarios.getUserid());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }        
     public int EliminarUsuarios(Usuarios pUsuarios){
        int n = 0;
        try{
            ps = conectar().prepareStatement("DELETE FROM usuarios WHERE userid=?");
            ps.setInt(1, pUsuarios.getUserid());
            n = ps.executeUpdate();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return n;
    }
     
    public ArrayList<Usuarios> MostrarUsuarios(){
        ArrayList<Usuarios> ar = new ArrayList<Usuarios>();
        try{
            ps = conectar().prepareStatement("SELECT * FROM usuarios p INNER JOIN roles e ON p.userrol= e.idrol ORDER BY p.userid ASC;");
            rs = ps.executeQuery();
            while(rs.next()){
                roles = new Roles(rs.getInt("e.idrol"), rs.getString("e.rol"), rs.getString("e.permisos"));
                usuarios = new Usuarios(rs.getInt("p.userid"), rs.getString("p.usernombre"), rs.getString("p.usercontraseña"),roles);
                ar.add(usuarios);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }        
    public ArrayList<Usuarios> BuscarUsuarios(String opc, String texto){
        ArrayList<Usuarios> ar = new ArrayList<Usuarios>();
        try{
            String sql ="SELECT * FROM usuarios p INNER JOIN roles e ON p.userrol = e.idrol";
            if(texto != ""){
                if(opc.equals("usuarios"))
                    sql += " WHERE p.usernombre LIKE '%" + texto + "%'";                
                else if (opc.equals("roles"))
                   sql += " WHERE e.rol LIKE '%" + texto + "%'";
             }
            ps = conectar().prepareStatement(sql);
            rs = ps.executeQuery();
            while(rs.next()){                
               roles = new Roles(rs.getInt("e.idrol"), rs.getString("e.rol"), rs.getString("e.permisos"));
                usuarios = new Usuarios(rs.getInt("p.userid"), rs.getString("p.usernombre"), rs.getString("p.usercontraseña"),roles);
                ar.add(usuarios);
            }
            ps.close();
            rs.close();
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return ar;
    }
}

