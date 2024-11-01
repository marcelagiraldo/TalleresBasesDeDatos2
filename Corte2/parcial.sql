
/*-------PRIMERA---------------*/
create table pagaya.usuarios(
	id varchar primary key,
	nombre varchar,
	direccion varchar,
	email varchar unique,
	fecha_registro date,
	estado varchar
);

create table pagaya.tarjetas(
	id serial primary key,
	numero_tarjeta varchar unique,
	fecha_expedicion date,
	cvv integer unique,
	tipo_tarjeta varchar,
	usuario_id varchar,
	constraint fk_usuario_id foreign key(usuario_id) references pagaya.usuarios(id)
);

create table pagaya.productos(
	id serial primary key,
	codigo_producto varchar unique,
	nombre varchar,
	categoria varchar,
	porcentaje_impuesto numeric,
	precio numeric
);

create table pagaya.pagos(
	id serial primary key,
	codigo_pago varchar unique,
	fecha date,
	estado varchar,
	monto numeric,
	producto_id varchar unique,
	tarjeta_id varchar unique,
	usuario_id varchar unique,
	constraint fk_usuario_id foreign key(usuario_id) references pagaya.usuarios(id),
	constraint fk_tarjeta_id foreign key(tarjeta_id) references pagaya.tarjetas(numero_tarjeta),
	constraint fk_producto_id foreign key(producto_id) references pagaya.productos(codigo_producto)
);

insert into pagaya.usuarios(id,nombre,direccion,email,fecha_registro,estado) values
('1054768930','Felipe Cardona','Cra20#26-32','felipe.cardona@gmail.com','2023-10-15','Activo');
insert into pagaya.usuarios(id,nombre,direccion,email,fecha_registro,estado) values
('1056743256','Melissa Perez','Calle78#23-09','melissa@gmail.com','2011-01-23','Inactivo');

insert into pagaya.tarjetas(numero_tarjeta,fecha_expedicion,cvv,tipo_tarjeta,usuario_id) values
('972176438723','2023-10-16',987,'Visa','1054768930');

insert into pagaya.productos(codigo_producto,nombre,categoria,porcentaje_impuesto,precio) values
('001','Camisa','Ropa',0.08,36000);

insert into pagaya.pagos(codigo_pago,fecha,estado,monto,producto_id,tarjeta_id,usuario_id) values
('F987','2024-10-31','Exitoso',72000,'001','972176438723','1054768930');

create or replace function pagaya.obtener_pagos_usuario(id_usuario varchar,fecha_v date)
returns table(
	codigo_pago_v varchar,
	nombre_producto_V varchar,
	monto_v numeric,
	estado_v varchar
) as $$
begin
	return query
	select pa.codigo_pago,pr.nombre,pa.monto,pa.estado
	from pagaya.pagos pa
	join pagaya.productos pr on pa.producto_id = pr.codigo_producto
	join pagaya.usuarios us on pa.usuario_id = us.id
    where pa.usuario_id = id_usuario and pa.fecha = fecha ;
end;
$$ language plpgsql;

select * from pagaya.obtener_pagos_usuario('1054768930','2024-10-31');

create or replace function pagaya.obtener_tarjetas_usuario(id_usuario varchar)
returns table(
	nombre_usuario_v varchar,
	email_v varchar,
	numero_tarjeta_v varchar,
	cvv_v integer,
	tipo_tarjeta_v varchar
) as $$
begin
	return query
	select us.nombre,us.email,ta.numero_tarjeta,ta.cvv,ta.tipo_tarjeta
	from pagaya.pagos pa
	join pagaya.tarjetas ta on pa.tarjeta_id = ta.numero_tarjeta
	join pagaya.usuarios us on pa.usuario_id = us.id
    where pa.usuario_id = id_usuario and pa.monto > 1000 ;
end;
$$ language plpgsql;

select * from pagaya.obtener_tarjetas_usuario('1054768930');

/*-------SEGUNDA----------*/

insert into pagaya.usuarios2(id,nombre,direccion,email,fecha_registro,estado) values
('1054768930','Felipe Cardona','Cra20#26-32','felipe.cardona@gmail.com','2023-10-15','Activo');

create or replace function pagaya.obtener_tarjetas_detalle_usuario(usuario_id varchar)
as $$
declare
	cursor_ cursor for select numero_tarjeta,fecha,expiracion,nombre,email from pagaya.tarjetas;
begin
	open cursor_
	
end
$$ language plpgsql;

create or replace function pagaya.obtener_pagos_menores(fecha_v date)
as $$
declare
	cursor_ cursor for select monto,estado,nombre_producto,porcentaje_impuesto,usuario_direccion,email, from pagaya.tarjetas;
begin
	open cursor_
	
end
$$ language plpgsql;

create table pagaya.comprobantes_pago_xml(
	id serial primary key,
	detalles_xml xml
);

create table pagaya.comprobantes_pago_json(
	id serial primary key,
	detalles_json jsonb
);

insert into pagaya.pagos(codigo_pago,fecha,estado,monto,producto_id,tarjeta_id,usuario_id) values
('F987','2024-10-31','Exitoso',72000,'001','972176438723','1054768930');

create or replace procedure pagaya.guardarxml()
as $$
begin 
	insert into pagaya.comprobantes_pago_xml(detalles_xml) values
	(xmlparse(document '<pago><codigo_pago>F987</codigo_pago><nombre_usuario>Felipe Cardona</nombre_usuario><numero_tarjeta>F987</numero_tarjeta><nombre_producto>F987</nombre_producto><nombre_pago>F987</nombre_pago></pago>'));
end;
$$ language plpgsql;

call pagaya.guardarxml();

create or replace procedure pagaya.guardarjson()
as $$
begin 
	insert into pagaya.comprobantes_pago_json(detalles_json) values
	('{"email_usuario":"felipe.cardona@gmail.com","numero_tarjeta":"972176438723","tipo_tarjeta":"Visa","codigo_producto":"001","codigo_pago":"F987","monto_pago":7200}');
end;
$$ language plpgsql;


call pagaya.guardarjson();

/*----------------------TERCERA----------------*/
create or replace function pagaya.insertar_producto()
returns trigger as $$
declare
    precio numeric;
    impuesto numeric;
begin
	if new.precio < 0 and new.precio > 20000 then
        raise exception 'El precio no esta dentro del rango';
    end if;
	if new.porcentaje_impuesto < 0.01 and new.porcentaje_impuesto > 0.2 then
        raise exception 'El impuesto no esta dentro del rango';
    end if;
	insert into pagaya.productos(codigo_producto,nombre,categoria,porcentaje_impuesto,precio) values
	('002','Medias','Ropa',0.02,30000);
   return new;
end;
$$ language plpgsql;

create trigger validaciones_producto_
before insert on pagaya.productos 
for each row
execute function pagaya.insertar_producto();

select * from pagaya.insertar_producto();