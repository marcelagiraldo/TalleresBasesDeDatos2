/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package generarauditoria;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Date;

/**
 *
 * @author Marcela Alzate
 */
public class GenerarAuditoria {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("call tallercinco.generar_auditoria(?,?)");
            
            Date fecha_inicial = Date.valueOf("2024-08-28");
            Date fecha_final = Date.valueOf("2024-08-29");
            ejecucion.setDate(1, fecha_inicial);
            ejecucion.setDate(2, fecha_final);
            System.out.println("Ejecutando el procedimiento almacenado...");
            ejecucion.execute();
            System.out.println("Procedimiento ejecutado.");
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
