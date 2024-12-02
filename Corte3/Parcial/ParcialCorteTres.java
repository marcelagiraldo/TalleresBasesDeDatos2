/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.parcialcortetres;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import static com.mongodb.client.model.Updates.set;
import org.bson.Document;
import java.util.Arrays;

/**
 *
 * @author Marcela Alzate
 */
public class ParcialCorteTres {

    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase mongoDatabase = mongoClient.getDatabase("parcial");
        MongoCollection<Document> collectionProductos = mongoDatabase.getCollection("productos");
        MongoCollection<Document> collectionPedidos = mongoDatabase.getCollection("pedidos");
        MongoCollection<Document> collectionDetallesPedido = mongoDatabase.getCollection("detalles_pedido");
        MongoCollection<Document> collectionReservas = mongoDatabase.getCollection("reservas");
        System.out.println("Conexion Exitosa");
        
        //Insertar productos
        /*Document producto1 = new Document("_id", "producto002").append("nombre", "Pantalon tela").append("descripcion", "Pantalon de tela Talla 36").append("precio", 20.15).append("stock", 200);
        Document producto2 = new Document("_id", "producto003").append("nombre", "Pantalon Jean").append("descripcion", "Pantalon de Jean Talla 38").append("precio", 22.15).append("stock", 200);
        Document producto3 = new Document("_id", "producto004").append("nombre", "Pantalon").append("descripcion", "Pantalon de tela Talla 42").append("precio", 20.15).append("stock", 200);
        Document producto4 = new Document("_id", "producto005").append("nombre", "Camisa").append("descripcion", "Camisa talla M").append("precio", 18.28).append("stock", 200);
        Document producto5 = new Document("_id", "producto006").append("nombre", "Boxer").append("descripcion", "Boxer talla M").append("precio", 12.30).append("stock", 200);
        collectionProductos.insertMany(Arrays.asList(producto1,producto2,producto3,producto4,producto5));*/
        
        //Actualizar productos
        //collectionProductos.updateOne(eq("_id", "producto002"), set("descripcion", "Pantalon Talla 42"));
        
        //Eliminar productos
        //collectionProductos.deleteOne(eq("_id", "Producto001"));
        
        //Insertar pedidos
        /*Document pedido1 = new Document("_id", "pedido002").append("cliente", "cliente002").append("fecha_pedido", "2024-12-02").append("estado", "Enviado").append("total", 20.15);
        Document pedido2 = new Document("_id", "pedido003").append("cliente", "cliente003").append("fecha_pedido", "2024-12-01").append("estado", "Enviado").append("total", 44.3);
        Document pedido3 = new Document("_id", "pedido004").append("cliente", "cliente003").append("fecha_pedido", "2024-12-02").append("estado", "Pendiente").append("total", 20.15);
        
        collectionPedidos.insertMany(Arrays.asList(pedido1,pedido2,pedido3));*/
        
        //Actualizar pedidos
        //collectionPedidos.updateOne(eq("_id", "pedido004"), set("estado", "Enviado"));
        
        //Eliminar pedidos
        collectionPedidos.deleteOne(eq("_id", "pedido001"));
        
        //Insertar detalles pedidos
        /*Document detalle_pedido1 = new Document("_id", "detalle002").append("pedido_id", "pedido002").append("producto_id", "producto002").append("cantidad", 1).append("precio_unitario", 20.15);
        Document detalle_pedido2 = new Document("_id", "detalle003").append("pedido_id", "pedido003").append("producto_id", "producto002").append("estado", 2).append("precio_unitario", 44.3);
        Document detalle_pedido3 = new Document("_id", "detalle004").append("pedido_id", "pedido004").append("producto_id", "producto002").append("estado", 1).append("precio_unitario", 20.15);
        
        collectionDetallesPedido.insertMany(Arrays.asList(detalle_pedido1,detalle_pedido2,detalle_pedido3));*/
        
        //Actualizar detalles pedidos
        //collectionDetallesPedido.updateOne(eq("_id", "detalle003"), set("producto_id", "producto003"));
        //collectionDetallesPedido.updateOne(eq("_id", "detalle004"), set("producto_id", "producto004"));
        
        //Eliminar detalles pedidos
        //collectionDetallesPedido.deleteOne(eq("_id", "detalle001"));
        
        System.out.println("------------------------------------------------Pedidos:");
        MongoCursor<Document> cursorPedido = collectionPedidos.find().iterator();
        while(cursorPedido.hasNext()){
            System.out.println(cursorPedido.next().toJson());
        }
        
        System.out.println("------------------------------------------------Productos:");
        MongoCursor<Document> cursorProductos = collectionProductos.find().iterator();
        while(cursorProductos.hasNext()){
            System.out.println(cursorProductos.next().toJson());
        }
        
        System.out.println("------------------------------------------------Detalles Pedidos:");
        MongoCursor<Document> cursorDetallesPedido = collectionDetallesPedido.find().iterator();
        while(cursorDetallesPedido.hasNext()){
            System.out.println(cursorDetallesPedido.next().toJson());
        }
        
        //Consultas
        //Productos con precio mayor a 20
        System.out.println("---------------------------------------------------Productos mayores a 20");
        MongoCursor<Document> cursor1 = collectionProductos.find(gt("precio","20.00")).iterator();
        while (cursor1.hasNext()) {
            System.out.println(cursor1.next().toJson());            
        }
        
        //Pedidos con total mayor a 40
        System.out.println("---------------------------------------------------Pedidos Total mayor a 40");
        cursor4MongoCursor<Document> cursor2 = collectionPedidos.find(gt("total","40.00")).iterator();
        while (cursor2.hasNext()) {
            System.out.println(cursor1.next().toJson());            
        }
        
        //Desnormalización
        /*Document reserva1 = new Document("_id", "reserva001")
                .append("cliente", new Document("nombre","Ana Gomez").append("correo", "ana@email.com").append("telefono", "8897654").append("direccion", "Cra 54-09-23"))
                .append("habitacion", new Document("tipo","Suite").append("numero", 101).append("precio_noche", 200.00).append("cantidad", 2).append("descripcion", "Suite con vista al mar"))
                .append("fecha_entrega", "2024-12-11").append("fecha_salida", "2024-12-20").append("total", 3600.00).append("estado_pago", "Pagado").append("metodo_pago", "Tarjeta de credito").append("fecha_reserva", "2024-12-2");
        Document reserva2 = new Document("_id", "reserva002")
                .append("cliente", new Document("nombre","Felipe Suarez").append("correo", "felipe@email.com").append("telefono", "8897653").append("direccion", "Cra 54-09-25"))
                .append("habitacion", new Document("tipo","Habitacion").append("numero", 203).append("precio_noche", 150.00).append("cantidad", 1).append("descripcion", "Habitacion normal"))
                .append("fecha_entrega", "2024-12-11").append("fecha_salida", "2024-12-13").append("total", 350.00).append("estado_pago", "Pagado").append("metodo_pago", "Transferencia").append("fecha_reserva", "2024-12-2");
        Document reserva3 = new Document("_id", "reserva003")
                .append("cliente", new Document("nombre","Fernando Alzate").append("correo", "fernando@email.com").append("telefono", "8897652").append("direccion", "Cra 54-09-26"))
                .append("habitacion", new Document("tipo","Habitacion").append("numero", 304).append("precio_noche", 200.00).append("cantidad", 1).append("descripcion", "Habitacion normal"))
                .append("fecha_entrega", "2024-12-11").append("fecha_salida", "2024-12-13").append("total", 400.00).append("estado_pago", "Pagado").append("metodo_pago", "Tarjeta de credito").append("fecha_reserva", "2024-12-2");
        Document reserva4 = new Document("_id", "reserva004")
                .append("cliente", new Document("nombre","Mariana Mendez").append("correo", "mariana@email.com").append("telefono", "8897651").append("direccion", "Cra 54-09-29"))
                .append("habitacion", new Document("tipo","Suite").append("numero", 107).append("precio_noche", 200.00).append("cantidad", 1).append("descripcion", "Suite con vista al mar"))
                .append("fecha_entrega", "2024-12-11").append("fecha_salida", "2024-12-13").append("total", 400.00).append("estado_pago", "Pagado").append("metodo_pago", "Transferencia").append("fecha_reserva", "2024-12-2");
      
        collectionReservas.insertMany(Arrays.asList(reserva1,reserva2,reserva3,reserva4));
        */
        //Actualizar reserva
        //collectionReservas.updateOne(eq("_id", "reserva001"), set("habitacion", new Document("numero",110)));
        
        
        //Eliminar reserva
        collectionReservas.deleteOne(eq("_id", "reserva001"));
        
        System.out.println("------------------------------------------------Reservas:");
        MongoCursor<Document> cursorReserva = collectionReservas.find().iterator();
        while(cursorReserva.hasNext()){            
            System.out.println(cursorReserva.next().toJson());
        }
        
        //Consultas
        MongoCursor<Document> cursor3 = collectionReservas.find(gt("tipo","sencilla")).iterator();
        while (cursor3.hasNext()) {
            System.out.println(cursor3.next().toJson());            
        }
        
    }
}
