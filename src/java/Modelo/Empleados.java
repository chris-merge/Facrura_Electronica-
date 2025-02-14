/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */
public class Empleados {
    private int idempleado;         
    private String empnombre;        
    private String empapellido;     
    private int empdui;                     
    private int emptelefono;     
    private String empcorreo; 
    private Roles roles;
    
    public Empleados() {
    }

    public Empleados(int idempleado, String empnombre, String empapellido, int empdui, int emptelefono, String empcorreo, Roles roles) {
        this.idempleado = idempleado;
        this.empnombre = empnombre;
        this.empapellido = empapellido;
        this.empdui = empdui;
        this.emptelefono = emptelefono;
        this.empcorreo = empcorreo;
        this.roles = roles;
    }

    public int getIdempleado() {
        return idempleado;
    }

    public void setIdempleado(int idempleado) {
        this.idempleado = idempleado;
    }

    public String getEmpnombre() {
        return empnombre;
    }

    public void setEmpnombre(String empnombre) {
        this.empnombre = empnombre;
    }

    public String getEmpapellido() {
        return empapellido;
    }

    public void setEmpapellido(String empapellido) {
        this.empapellido = empapellido;
    }

    public int getEmpdui() {
        return empdui;
    }

    public void setEmpdui(int empdui) {
        this.empdui = empdui;
    }

    public int getEmptelefono() {
        return emptelefono;
    }

    public void setEmptelefono(int emptelefono) {
        this.emptelefono = emptelefono;
    }

    public String getEmpcorreo() {
        return empcorreo;
    }

    public void setEmpcorreo(String empcorreo) {
        this.empcorreo = empcorreo;
    }

    public Roles getRoles() {
        return roles;
    }

    public void setRoles(Roles roles) {
        this.roles = roles;
    }

}
