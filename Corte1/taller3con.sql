create table IF NOT EXISTS clientesT3(
	id_cliente SERIAL primary key,
	identificacion varchar(10) unique not null,
	nombre varchar (50) not null,
	edad int not null,
	correo varchar(50) not null
);

create table productosT3 (
	codigo_producto varchar(10) primary key unique not null,
	nombre varchar (50) not null,
	stock int not null,
	valor_unitario int not null	
);

create table if not exists pedidosT3 (
	id_pedidos SERIAL primary key,
	id_cliente INT NOT null,
	codigo_producto varchar(10) NOT null,
	fecha date not null,
	cant_total int not null,
	constraint fk_cliente_id FOREIGN KEY (id_cliente) REFERENCES clientesT3(id_cliente),
	constraint producto_id FOREIGN KEY (codigo_producto) REFERENCES productosT3(codigo_producto)
);

/****************INSERT**************/
/*Se crea la transacción*/
begin;

/*Se insertan clientes a la tabla*/
insert into clientesT3(identificacion,nombre,edad,correo)
values ('67892145','Manuela', 32, 'manuela@gmail.com');
insert into clientesT3(identificacion,nombre,edad,correo)
values ('75698031','Vicente', 48, 'vicente@gmail.com');
insert into clientesT3(identificacion,nombre,edad,correo)
values ('1998765434','Merlina', 25, 'merlina@gmail.com');

/*Se insertan productos a la tabla*/
insert into productosT3(codigo_producto,nombre,stock,valor_unitario)
values ('7634','Shampoo', 27,24980);
insert into productosT3(codigo_producto,nombre,stock,valor_unitario)
values ('7633','Acondicionador', 27,24980);
insert into productosT3(codigo_producto,nombre,stock,valor_unitario)
values ('7632','Crema de peinar', 27,16800);

/*Se insertan pedidos a la tabla*/
insert into pedidosT3(id_cliente,codigo_producto,fecha,cant_total)
values (1,'7634','2024-08-28',2);
insert into pedidosT3(id_cliente,codigo_producto,fecha,cant_total)
values (1,'7633','2024-08-28',2);
insert into pedidosT3(id_cliente,codigo_producto,fecha,cant_total)
values (1,'7632','2024-08-28',2);

/****************UPDATE**************/

/*Se actualizan clientes*/
UPDATE clientesT3 SET nombre = 'Merlina Alvarez' WHERE identificacion = '1998765434';
UPDATE clientesT3 SET correo = 'manuela456@gmail.com' WHERE identificacion = '67892145';

/*Se actualizan productos*/
UPDATE productosT3 SET nombre = 'Shampoo Muss' WHERE codigo_producto = '7634';
UPDATE productosT3 SET valor_unitario = 13970 WHERE codigo_producto = '7632';

/*Se actualizan pedidos*/
UPDATE pedidosT3 SET cant_total = 3 WHERE id_pedidos = 1;

/****************DELETE**************/

/*Se elimina pedido*/
DELETE FROM pedidosT3 WHERE id_pedidos = 1;

/*Se elimina producto*/
DELETE FROM productosT3 WHERE codigo_producto = '7632';

/*Se elimina cliente*/
DELETE FROM clientesT3 WHERE id_cliente = 1;

/****************SELECT**************/
select * from clientesT3;
select * from productosT3;
select * from pedidosT3;

/*Se guardan los cambios*/
rollback to savepoint;