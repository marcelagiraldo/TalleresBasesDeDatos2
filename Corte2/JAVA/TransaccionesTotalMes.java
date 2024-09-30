/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package transaccionestotalmes;

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
public class TransaccionesTotalMes {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("{call tallerseis.transaccion_total_mes(?,?)}");
            Date fecha = Date.valueOf("2024-05-04");
            ejecucion.setDate(1, fecha);
            ejecucion.setString(2,"0622036480");
            ResultSet resultado = ejecucion.executeQuery();
            BigDecimal total = new BigDecimal(0);
            while (resultado.next()){
                total = resultado.getBigDecimal(1);
            }
            System.out.println(total.doubleValue());
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
