/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */
public class Usuarios {
    private int userid;
    private String usernombre;
    private String usercontraseña;
    private Roles roles;
            
    public Usuarios() {
    }
    
    public Usuarios(int userid, String usernombre, String usercontraseña, Roles roles) {
        this.userid = userid;
        this.usernombre = usernombre;
        this.usercontraseña = usercontraseña;
        this.roles = roles;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getUsernombre() {
        return usernombre;
    }

    public void setUsernombre(String usernombre) {
        this.usernombre = usernombre;
    }

    public String getUsercontraseña() {
        return usercontraseña;
    }

    public void setUsercontraseña(String usercontraseña) {
        this.usercontraseña = usercontraseña;
    }

    public Roles getRoles() {
        return roles;
    }

    public void setRoles(Roles roles) {
        this.roles = roles;
    }
}
