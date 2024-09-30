/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package simularventasmes;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;

/**
 *
 * @author Marcela Alzate
 */
public class SimularVentasMes {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("call public.simular_ventas_mes(?)");
            
            ejecucion.setString(1, "6789");
            System.out.println("Ejecutando el procedimiento almacenado...");
            ejecucion.execute();
            System.out.println("Procedimiento ejecutado.");
            ejecucion.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
