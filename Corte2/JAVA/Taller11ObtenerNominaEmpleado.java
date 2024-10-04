/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package obtenernominaempleado;


import java.sql.*;

/**
 *
 * @author Marcela Alzate
 */
public class ObtenerNominaEmpleado {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("{call returnquery.obtener_nomina_empleado(?, ?, ?)}");
                
            ejecucion.setString(1, "002");
            ejecucion.setString(2, "Enero");
            ejecucion.setString(3, "2024");
            
            ejecucion.execute();
            
            ResultSet resultado = ejecucion.executeQuery();
            while (resultado.next()) {
                String nombre = resultado.getString("nombre");
                double totalDevengado = resultado.getDouble("total_devengado");
                double totalDeducido = resultado.getDouble("total_deducido");
                double totalNomina = resultado.getDouble("total_nomina");

                System.out.println("Nombre: " + nombre);
                System.out.println("Total Devengado: " + totalDevengado);
                System.out.println("Total Deducido: " + totalDeducido);
                System.out.println("Total Nómina: " + totalNomina);
            }
            resultado.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
