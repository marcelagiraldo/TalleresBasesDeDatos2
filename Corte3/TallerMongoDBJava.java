/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.tallermongodbjava;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import static com.mongodb.client.model.Filters.lt;
import com.mongodb.client.model.Indexes;
import static com.mongodb.client.model.Indexes.ascending;
import static com.mongodb.client.model.Updates.set;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author Marcela Alzate
 */
public class TallerMongoDBJava {

    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("talleresBD");
        MongoCollection<Document> collection = database.getCollection("productos");
        System.out.println("Conexion Exitosa");
        
        MongoCursor<Document> cursor = collection.find().iterator();
        while(cursor.hasNext()){
            System.out.println(cursor.next().toJson());
        }
        
        //Insertar productos
        /*Document producto1 = new Document("productoID", "011").append("nombre", "Camiseta").append("descripcion", "Camiseta de algodón talla S").append("precio", "30000")
        .append("categoria", new Document("categoriaID", "1").append("nombreCategoria", "Ropa"))
        .append("comentarios", Arrays.asList(
                new Document("comentarioID", "1").append("texto", "Muy cómoda").append("cliente", "Juan"),
                new Document("comentarioID", "2").append("texto", "Buena calidad").append("cliente", "Maria")));

        Document producto2 = new Document("productoID", "012").append("nombre", "Pantalón").append("descripcion", "Pantalón de mezclilla").append("precio", "60000")
                .append("categoria", new Document("categoriaID", "1").append("nombreCategoria", "Ropa"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Perfecto ajuste").append("cliente", "Carlos"),
                        new Document("comentarioID", "2").append("texto", "Buen material").append("cliente", "Luisa")));

        Document producto3 = new Document("productoID", "013").append("nombre", "Sudadera").append("descripcion", "Sudadera de algodón con capucha").append("precio", "80000")
                .append("categoria", new Document("categoriaID", "1").append("nombreCategoria", "Ropa"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Muy cálida").append("cliente", "Andrés"),
                        new Document("comentarioID", "2").append("texto", "Ideal para invierno").append("cliente", "Sofía")));

        Document producto4 = new Document("productoID", "014").append("nombre", "Gorra").append("descripcion", "Gorra deportiva unisex").append("precio", "15000")
                .append("categoria", new Document("categoriaID", "2").append("nombreCategoria", "Accesorios"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Muy cómoda y ligera").append("cliente", "Diego"),
                        new Document("comentarioID", "2").append("texto", "Buena protección solar").append("cliente", "Carla")));

        Document producto5 = new Document("productoID", "015").append("nombre", "Cinturón").append("descripcion", "Cinturón de cuero genuino").append("precio", "25000")
                .append("categoria", new Document("categoriaID", "2").append("nombreCategoria", "Accesorios"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Excelente calidad").append("cliente", "Pedro"),
                        new Document("comentarioID", "2").append("texto", "Perfecto para jeans").append("cliente", "Ana")));

        Document producto6 = new Document("productoID", "016").append("nombre", "Zapatos").append("descripcion", "Zapatos deportivos").append("precio", "120000")
                .append("categoria", new Document("categoriaID", "3").append("nombreCategoria", "Calzado"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Muy cómodos para correr").append("cliente", "Luis"),
                        new Document("comentarioID", "2").append("texto", "Buen soporte").append("cliente", "Elena")));

        Document producto7 = new Document("productoID", "017").append("nombre", "Chaqueta").append("descripcion", "Chaqueta impermeable").append("precio", "95000")
                .append("categoria", new Document("categoriaID", "1").append("nombreCategoria", "Ropa"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Excelente para la lluvia").append("cliente", "Diana"),
                        new Document("comentarioID", "2").append("texto", "Muy ligera").append("cliente", "Roberto")));

        Document producto8 = new Document("productoID", "018").append("nombre", "Bolso").append("descripcion", "Bolso de cuero grande").append("precio", "85000")
                .append("categoria", new Document("categoriaID", "2").append("nombreCategoria", "Accesorios"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Espacioso y elegante").append("cliente", "Lucía"),
                        new Document("comentarioID", "2").append("texto", "Muy resistente").append("cliente", "Miguel")));

        Document producto9 = new Document("productoID", "019").append("nombre", "Calcetines").append("descripcion", "Calcetines de algodón").append("precio", "5000")
                .append("categoria", new Document("categoriaID", "1").append("nombreCategoria", "Ropa"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Suaves y cómodos").append("cliente", "Rafael"),
                        new Document("comentarioID", "2").append("texto", "Buena calidad").append("cliente", "Gabriela")));

        Document producto10 = new Document("productoID", "020").append("nombre", "Bufanda").append("descripcion", "Bufanda de lana").append("precio", "30000")
                .append("categoria", new Document("categoriaID", "2").append("nombreCategoria", "Accesorios"))
                .append("comentarios", Arrays.asList(
                        new Document("comentarioID", "1").append("texto", "Muy abrigadora").append("cliente", "Paula"),
                        new Document("comentarioID", "2").append("texto", "Perfecta para invierno").append("cliente", "Javier")));
        
        collection.insertMany(Arrays.asList(producto1,producto2,producto3,producto4,producto5,producto6,producto7,producto8,producto9,producto10));
        */
        
        //Actualizar productos
        /*
        collection.updateOne(eq("productoID", "011"), set("categoria", new Document("categoriaID", "4").append("nombreCategoria", "Deportes")));

        collection.updateOne(eq("productoID", "012"), set("categoria", new Document("categoriaID", "5").append("nombreCategoria", "Electrónica")));

        collection.updateOne(eq("productoID", "013"), set("categoria", new Document("categoriaID", "4").append("nombreCategoria", "Deportes")));

        collection.updateOne(eq("productoID", "014"), set("categoria", new Document("categoriaID", "5").append("nombreCategoria", "Electrónica")));

        collection.updateOne(eq("productoID", "015"), set("categoria", new Document("categoriaID", "4").append("nombreCategoria", "Deportes")));
        */
        //Eliminar productos
        /*
        collection.deleteOne(eq("productoID", "019"));
        collection.deleteOne(eq("productoID", "020"));
        */
        //Precio mayor a 90.000
        System.out.println("Productos mayores a 90.000");
        MongoCursor<Document> cursor1 = collection.find(gt("precio","70000")).iterator();
        while (cursor1.hasNext()) {
            System.out.println(cursor1.next().toJson());            
        }
        
        //Precio mayor a 25.000 y categoria Deportes
        System.out.println("Productos mayores a 25.000 y categoria Deportes");
        MongoCursor<Document> cursor2 = collection.find(and(gt("precio","25000"),eq("categoria.nombreCategoria", "Deportes"))).iterator();
        while (cursor2.hasNext()) {
            System.out.println(cursor2.next().toJson());            
        }
    }
}
