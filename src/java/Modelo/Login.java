/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */
public class Login {
    private String usernombre;
    private String usercontraseña;

    public Login(String usernombre, String usercontraseña) {
        this.usernombre = usernombre;
        this.usercontraseña = usercontraseña;
    }

    public String getUsernombre() {
        return usernombre;
    }

    public String getUsercontraseña() {
        return usercontraseña;
    }

    void setRol(String rol) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Object getRol() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
