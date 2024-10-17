/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package actualizarlibroxml;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author Marcela Alzate
 */
public class ActualizarLibroXML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("call exml.actualizar_libro(?,?)");
            
            ejecucion.setString(2, "6789F");
            ejecucion.setString(1, "<libro><titulo>El amor en los tiempos del cólera</titulo><autor>Gabriel Márquez</autor><aio>1985</aio></libro>");
            ejecucion.execute();
            System.out.println("Procedimiento ejecutado.");
            ejecucion.close();
            conexion.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
