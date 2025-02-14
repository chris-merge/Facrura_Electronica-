
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class LoginDAO {
    PreparedStatement ps;
    ResultSet rs;
    Conexion con = new Conexion();

    public boolean ValidarLogin(Login login) {
        try (Connection conn = con.conectar()) {
            ps = conn.prepareStatement("SELECT * FROM usuarios WHERE usernombre=? AND usercontraseña=?");
            ps.setString(1, login.getUsernombre());
            ps.setString(2, encryptPassword(login.getUsercontraseña()));
            rs = ps.executeQuery();
            return rs.next();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public int obtenerRolUsuario(Login login) {
        int rol = 0;
        try (Connection conn = con.conectar()) {
            ps = conn.prepareStatement("SELECT userrol FROM usuarios WHERE usernombre=? AND usercontraseña=?");
            ps.setString(1, login.getUsernombre());
            ps.setString(2, encryptPassword(login.getUsercontraseña()));
            rs = ps.executeQuery();
            if (rs.next()) {
                rol = rs.getInt("userrol");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return rol;
    }

    private String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();

            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}