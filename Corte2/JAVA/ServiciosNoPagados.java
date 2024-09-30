/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package serviciosnopagados;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 *
 * @author Marcela Alzate
 */
public class ServiciosNoPagados {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("{call public.obtener_servicios_no_pagados(?)}");
            ejecucion.setString(1, "0862786310");
            ResultSet resultado = ejecucion.executeQuery();
            BigDecimal total = new BigDecimal(0);
            while (resultado.next()){
                String codigo = resultado.getString("codigo_");
                String tipo = resultado.getString("tipo_");
                BigDecimal monto = resultado.getBigDecimal("monto_");

                System.out.println("Codigo: " + codigo);
                System.out.println("Tipo: " + tipo);
                System.out.println("Monto: " + monto);
                System.out.println("--------------------------");
            }
            System.out.println(total.doubleValue());
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
