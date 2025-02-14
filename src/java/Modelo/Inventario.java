/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Joel
 */
public class Inventario {
    private int idinventario;
    private int codproducto;
    private String nomproducto;
    private String serie;
    private String modelo;
    private double precio_unitario;
    //private double subtotal;
    private int cantidad;
    private Proveedores proveedores;
    
    public Inventario() {
        
    }

    public Inventario(int idinventario, int codproducto, String nomproducto, String serie, String modelo, double precio_unitario, int cantidad, Proveedores proveedores) {
        this.idinventario = idinventario;
        this.codproducto = codproducto;
        this.nomproducto = nomproducto;
        this.serie = serie;
        this.modelo = modelo;
        this.precio_unitario = precio_unitario;
        this.cantidad = cantidad;
        this.proveedores = proveedores;
    }

    public int getIdinventario() {
        return idinventario;
    }

    public void setIdinventario(int idinventario) {
        this.idinventario = idinventario;
    }

    public int getCodproducto() {
        return codproducto;
    }

    public void setCodproducto(int codproducto) {
        this.codproducto = codproducto;
    }

    public String getNomproducto() {
        return nomproducto;
    }

    public void setNomproducto(String nomproducto) {
        this.nomproducto = nomproducto;
    }

    public String getSerie() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public double getPrecio_unitario() {
        return precio_unitario;
    }

    public void setPrecio_unitario(double precio_unitario) {
        this.precio_unitario = precio_unitario;
    }
        
    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public Proveedores getProveedores() {
        return proveedores;
    }

    public void setProveedores(Proveedores proveedores) {
        this.proveedores = proveedores;
    }
    
   public Inventario( int codproducto, String nomproducto, double precio_unitario) {
        this.codproducto = codproducto;
        this.nomproducto = nomproducto;
        this.precio_unitario = precio_unitario;

    }
}
