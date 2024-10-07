/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package generarauditoriaoracle;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;

/**
 *
 * @author Marcela Alzate
 */
public class GenerarAuditoriaOracle {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XEPDB1","system","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("call VENTAS.generar_auditoria_oracle(?,?)");
            
            Date fecha_inicial = Date.valueOf("2024-08-29");
            Date fecha_final = Date.valueOf("2024-08-30");
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
