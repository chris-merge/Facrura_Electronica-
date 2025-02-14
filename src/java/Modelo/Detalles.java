/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */
public class Detalles {
    private int id_detalle;
    private int cantidad;           
    private int id_venta ;
    private double precio;
    private double subtotal;
     
    private Inventario inventario;

    
    public Detalles() {
    }
    
    public Detalles(int id_detalle, int cantidad, int id_venta, double precio,double subtotal, Inventario inventario) {
        this.id_detalle = id_detalle;
        this.cantidad = cantidad;
        this.id_venta = id_venta;
        this.precio = precio;
        this.subtotal = subtotal;
        this.cantidad = cantidad;
        this.inventario = inventario;
    }
    
    public Detalles(int inventario, double precio, int cantidad, double subtotal) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int getId_detalle() {
        return id_detalle;
    }

    public void setId_detalle(int id_detalle) {
        this.id_detalle = id_detalle;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public int getId_venta() {
        return id_venta;
    }

    public void setId_venta(int id_venta) {
        this.id_venta = id_venta;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public Inventario getInventario() {
        return inventario;
    }

    public void setInventario(Inventario inventario) {
        this.inventario = inventario;
    }
    
    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
    
    public Detalles(  Inventario inventario, double precio) {       
        this.inventario = inventario;
         this.precio = precio;
    }
}
