/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package librosaioxml;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 *
 * @author Marcela Alzate
 */
public class LibrosAioXML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("{call exml.obtener_libros_por_anio(?)}");
                
            ejecucion.setString(1, "2012");
            
            ejecucion.execute();
            
            ResultSet resultado = ejecucion.executeQuery();
            while (resultado.next()) {
                String isbn = resultado.getString("f_isbn");
                String titulo = resultado.getString("f_titulo");
                String autor = resultado.getString("f_autor");
                String aio = resultado.getString("f_aio");

                System.out.println("Titulo: " + titulo);
                System.out.println("autor: " + autor);
                System.out.println("Aio: " + aio);
                
                System.out.println("-----------------------------------");
            }
            resultado.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
