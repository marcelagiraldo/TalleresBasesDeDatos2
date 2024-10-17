/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package autortituloxml;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 *
 * @author Marcela Alzate
 */
public class AutorTituloXML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            //Procedimientos almacenados
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","AutonomaSQL123.");
            CallableStatement ejecucion = conexion.prepareCall("{call exml.obtener_autor_libro_por_titulo(?)}");
            ejecucion.setString(1,"Quijote");
            ResultSet resultado = ejecucion.executeQuery();
            String autor = null;
            while (resultado.next()){
                autor = resultado.getString(1);
            }
            if (autor != null) {
                System.out.println(autor);  // Imprimir directamente el autor
            } else {
                System.out.println("No se encontró el autor para el ISBN proporcionado.");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
}
