/*Crear tabla clientes*/
create table IF NOT EXISTS clientes (
	id_cliente SERIAL primary key,
	identificacion varchar(10) unique not null,
	nombre varchar (50) not null,
	edad int not null,
	correo varchar(50) not null
);

/*Crear tabla productos*/
create table productos (
	codigo_producto varchar(10) primary key unique not null,
	nombre varchar (50) not null,
	stock int not null,
	valor_unitario int not null	
);

/*Crear tabla pedidos*/
create table if not exists pedidos (
	id_pedidos SERIAL primary key,
	id_cliente INT NOT null,
	codigo_producto varchar NOT null,
	fecha date not null,
	cant_total int not null,
	constraint fk_cliente_id FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
	constraint producto_id FOREIGN KEY (codigo_producto) REFERENCES productos(codigo_producto)
);

/****************INSERT**************/
/*Se crea la transacción*/
begin;

/*Se insertan clientes a la tabla*/
insert into clientes(identificacion,nombre,edad,correo)
values (1098675834,'Fernanda', 19, 'fernanda@gmail.com');
insert into clientes(identificacion,nombre,edad,correo)
values (1993546789,'Maicol', 21, 'maicol@gmail.com');
insert into clientes(identificacion,nombre,edad,correo)
values (1002543765,'Alex', 25, 'alex@gmail.com');

/*Se insertan productos a la tabla*/
insert into productos(codigo_producto,nombre,stock,valor_unitario)
values ('2352','Mesa', 32,127990);
insert into productos(codigo_producto,nombre,stock,valor_unitario)
values ('4356','Silla', 35,97960);
insert into productos(codigo_producto,nombre,stock,valor_unitario)
values ('6789','Escritorio', 25,235900);

/*Se insertan pedidos a la tabla*/
insert into pedidos (id_cliente,codigo_producto,fecha,cant_total)
values (1,2352,'13/06/2024',13);
insert into pedidos (id_cliente,codigo_producto,fecha,cant_total)
values (1,4356,'13/06/2024',2);
insert into pedidos (id_cliente,codigo_producto,fecha,cant_total)
values (4,6789,'23/08/2024',5);

/****************UPDATE**************/

/*Se actualizan clientes*/
UPDATE clientes SET nombre = 'Fernanda Martinez' WHERE id_cliente = 1;
UPDATE clientes SET edad = 32 WHERE id_cliente = 3;

/*Se actualizan productos*/
UPDATE productos SET nombre = 'Mesa Rimax' WHERE codigo_producto = '2352';
update productos SET stock = 45 WHERE codigo_producto = '6789';

/*Se actualizan pedidos*/
UPDATE pedidos SET id_cliente = '3' WHERE id_pedidos = 2;
UPDATE pedidos SET fecha = '23/08/2024' WHERE id_pedidos = 4;

/****************DELETE**************/

/*Se elimina pedido*/
DELETE FROM pedidos WHERE id_pedidos = 4;

/*Se elimina producto*/
DELETE FROM productos WHERE codigo_producto = '4356';

/*Se elimina cliente*/
DELETE FROM clientes WHERE id_cliente = 1;

/****************SELECT**************/
select * from clientes;
select * from productos;
select * from pedidos;

/*Se guardan los cambios*/
commit;
