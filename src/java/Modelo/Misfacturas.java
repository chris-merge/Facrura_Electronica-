/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author Gerardo
 */
public class Misfacturas {
    private int id_misfacturas;    
    private String codigofactura;
    private String vendedor;
    private double total;
    private int nit;   
    private String fecha;
    private Detalles detalles;
    private Clientes clientes;

    public Misfacturas() {
    }

    public Misfacturas(int id_misfacturas,String codigofactura, String vendedor, double total, int nit, String fecha, Detalles detalles, Clientes clientes) {
        this.id_misfacturas = id_misfacturas;
        this.codigofactura = codigofactura;
        this.vendedor = vendedor;
        this.total = total;
        this.nit = nit;
        this.fecha = fecha;
        this.detalles = detalles;
        this.clientes = clientes;
    }

    

    public int getId_misfacturas() {
        return id_misfacturas;
    }

    public void setId_misfacturas(int id_misfacturas) {
        this.id_misfacturas = id_misfacturas;
    }

    public String getCodigofactura() {
        return codigofactura;
    }

    public void setCodigofactura(String codigofactura) {
        this.codigofactura = codigofactura;
    }

    public String getVendedor() {
        return vendedor;
    }

    public void setVendedor(String vendedor) {
        this.vendedor = vendedor;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getNit() {
        return nit;
    }

    public void setNit(int nit) {
        this.nit = nit;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public Detalles getDetalles() {
        return detalles;
    }

    public void setDetalles(Detalles detalles) {
        this.detalles = detalles;
    }

    public Clientes getClientes() {
        return clientes;
    }

    public void setClientes(Clientes clientes) {
        this.clientes = clientes;
    }

}
