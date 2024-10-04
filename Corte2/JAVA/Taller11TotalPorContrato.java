/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package totalporcontrato;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.Date;

/**
 *
 * @author Marcela Alzate
 */
public class TotalPorContrato {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("{call returnquery.total_por_contrato(?)}");
                
            ejecucion.setInt(1, 3);
            
            ejecucion.execute();
            
            ResultSet resultado = ejecucion.executeQuery();
            while (resultado.next()) {
                String nombre = resultado.getString("nombre");
                Date fechaPago = resultado.getDate("fecha_pago");
                String aio = resultado.getString("aio");
                String mes = resultado.getString("mes");
                double total_devengado = resultado.getDouble("total_devengado");
                double total_deducido = resultado.getDouble("total_deducido");
                double total_nomina = resultado.getDouble("total_nomina");
                System.out.println("Nombre: " + nombre);
                System.out.println("Fecha Pago: " + fechaPago);
                System.out.println("Año: " + aio);
                System.out.println("Mes: " + mes);
                System.out.println("Total Devengado: " + total_devengado);
                System.out.println("Total Deducido: " + total_deducido);
                System.out.println("Total Nómina: " + total_nomina);
                System.out.println("---------------------------------------------------");
            }
            resultado.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
