create table IF NOT EXISTS clienteInventario (
	identificacion varchar(10) primary key unique not null,
	nombre varchar (50) not null,
	edad int not null,
	correo varchar(50) not null
);

create table productoInventario (
	codigo_producto varchar(10) primary key unique not null,
	nombre varchar (50) not null,
	stock int not null,
	valor_unitario int not null	
);

create table if not exists FacturasInventario (
	id_factura SERIAL primary key,
	fecha date not null,
	cantidad int not null,
	valor_total int not null,
	estado_pedido varchar(10) not null,
	id_producto varchar(10) not null,
	id_cliente varchar(10) NOT null,
	constraint fk_cliente_id FOREIGN KEY (id_cliente) REFERENCES clientesInventario(identificacion),
	constraint producto_id FOREIGN KEY (id_producto) REFERENCES productosInventario(codigo_producto)
);

insert into clientesInventario(identificacion,nombre,edad,correo)
values (1098675834,'Fernanda', 19, 'fernanda@gmail.com');
insert into clientesInventario(identificacion,nombre,edad,correo)
values (1993546789,'Maicol', 21, 'maicol@gmail.com');
insert into clientesInventario(identificacion,nombre,edad,correo)
values (1002543765,'Alex', 25, 'alex@gmail.com');

insert into productosInventario(codigo_producto,nombre,stock,valor_unitario)
values ('2352','Mesa', 32,127990);
insert into productosInventario(codigo_producto,nombre,stock,valor_unitario)
values ('4356','Silla', 35,97960);
insert into productosInventario(codigo_producto,nombre,stock,valor_unitario)
values ('6789','Escritorio', 25,235900);

insert into FacturasInventario (fecha,cantidad,valor_total,estado_pedido,id_producto,id_cliente)
values ('2024-08-29',5,365700,'PENDIENTE',2352,1002543765);
insert into FacturasInventario (fecha,cantidad,valor_total,estado_pedido,id_producto,id_cliente)
values ('2024-08-30',10,267800,'ENTREGADO',4356,1002543765);
insert into FacturasInventario (fecha,cantidad,valor_total,estado_pedido,id_producto,id_cliente)
values ('2024-08-29',27,986500,'BLOQUEADO',6789,1098675834);
insert into FacturasInventario (fecha,cantidad,valor_total,estado_pedido,id_producto,id_cliente)
values ('2024-08-29',2,87320,'BLOQUEADO',6789,1993546789);

select * from facturasinventario; 

create or replace procedure verificar_stock(id_producto varchar(10),cantidad_compra int)
language plpgsql
as $$
DECLARE
    stock_actual INT;
begin
	select stock into stock_actual
	from productosInventario 
	WHERE codigo_producto = id_producto;

	if stock_actual is null then
		raise notice 'El producto con código % no existe.', id_producto;
 	elsif stock_actual < cantidad_compra THEN
		raise notice 'No hay suficiente Stock';
	else
		raise notice 'Puede realizar la compra';
	end if;
end;
$$;

CALL verificar_stock('2352', 40);
CALL verificar_stock('4356', 10);

create or replace procedure actualizar_estado_pedido(p_id_factura INT,nuevo_estado varchar(20))
language plpgsql
as $$
DECLARE
    estado_actual varchar(20);
begin
	select estado_pedido into estado_actual
	from facturasinventario
	WHERE id_factura = p_id_factura;

	if estado_actual = 'ENTREGADO' THEN
		raise notice 'EL PEDIDO YA FUE ENTREGADO';
 	elsif estado_actual = 'PENDIENTE' THEN
		UPDATE facturasinventario SET estado_pedido = nuevo_estado WHERE id_factura = p_id_factura;
		raise notice 'EL PEDIDO YA FUE ACTUALIZADO CORRECTAMENTE';
	else
		raise notice 'EL PEDIDO SIGUE EN PROCESO';
	end if;
end;
$$;
drop procedure actualizar_estado_pedido;
CALL actualizar_estado_pedido(3, 'ENTREGADO');
CALL actualizar_estado_pedido(2, 'ENTREGADO');
select * from facturasinventario;
CALL actualizar_estado_pedido(4, 'ENTREGADO');
CALL actualizar_estado_pedido(5, 'ENTREGADO');

/******************TALLER 5*************************/
/******************PARTE 1*************************/
create or replace procedure obtener_total_stock()
language plpgsql
as $$
DECLARE
    v_total_stock integer := 0;
	v_stock_actual integer;
	v_nombre_producto varchar;
begin
	for v_nombre_producto,v_stock_actual in select nombre,stock from productosInventario
	loop
		raise notice 'El nombre del producto es: %',v_nombre_producto;
		raise notice 'El stock del producto es: %',v_stock_actual;
		v_total_stock := v_total_stock + v_stock_actual;
	end loop;
	raise notice 'El stock total es: %',v_total_stock;
end;
$$;

call obtener_total_stock();

/******************TALLER 5*************************/
/******************PARTE 2*************************/
create table IF NOT EXISTS auditoria (
	id_auditoria SERIAL primary key,
	fecha_inicio date not null,
	fecha_final date not null,
	factura_id int not null,
	pedido_estado varchar(20)
);

create or replace procedure generar_auditoria(v_fecha_inicio date,v_fecha_final date)
language plpgsql
as $$
DECLARE
	fecha_factura date;
	v_id_factura int;
	v_estado_pedido varchar;
begin
	for fecha_factura, v_id_factura, v_estado_pedido in select fecha, id_factura, estado_pedido from FacturasInventario
	loop
		if fecha_factura >= v_fecha_inicio and fecha_factura <= v_fecha_final then
			insert into auditoria(fecha_inicio,fecha_final,factura_id,pedido_estado)
			values(v_fecha_inicio,v_fecha_final,v_id_factura,v_estado_pedido);
		end if;
	end loop;	
end;
$$;

call generar_auditoria('2024/08/30','2024/09/02');
select * from auditoria;

/******************TALLER 5*************************/
/******************PARTE 3*************************/
create or replace procedure simular_ventas_mes(v_codigo_producto varchar)
language plpgsql
as $$
DECLARE
	v_dia integer := 1;
	v_identificacion varchar;
	cantidad_random int;
	valor_total int;
	v_valor_producto int;
begin
	select valor_unitario into v_valor_producto
	from productosInventario 
	WHERE codigo_producto = v_codigo_producto;

	while v_dia <=30 loop
		for v_identificacion in select identificacion from clientesInventario
		loop
			cantidad_random = FLOOR(1+(10-1+1)*RANDOM());
			valor_total = cantidad_random*v_valor_producto;
			insert into FacturasInventario (fecha,cantidad,valor_total,estado_pedido,id_producto,id_cliente)
			values (
				CURRENT_DATE,
				cantidad_random,
				valor_total,
				(ARRAY['ENTREGADO', 'PENDIENTE', 'BLOQUEADO'])[FLOOR(1 + RANDOM() * 3)],
				v_codigo_producto,
				v_identificacion);
		end loop;
	end loop;
end;
$$;

drop procedure simular_ventas_mes;
call simular_ventas_mes('2352');
select (ARRAY['ENTREGADO', 'PENDIENTE', 'BLOQUEADO'])[FLOOR(1 + RANDOM() * 3)] AS random_estado;





