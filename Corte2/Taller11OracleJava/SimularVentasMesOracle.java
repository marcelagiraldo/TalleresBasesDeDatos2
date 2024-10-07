/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package simularventasmesoracle;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;

/**
 *
 * @author Marcela Alzate
 */
public class SimularVentasMesOracle {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XEPDB1","system","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("call VENTAS.simular_ventas_mes_oracle(?)");
        
            ejecucion.setString(1,"2352");
            System.out.println("Ejecutando el procedimiento almacenado...");
            ejecucion.execute();
            System.out.println("Procedimiento ejecutado.");
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
