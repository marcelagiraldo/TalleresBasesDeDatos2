--Parte 1
create table usuario_vii(
	identificacion varchar(10) primary key unique not null,
	nombre varchar(50) not null,
	edad integer not null,
	correo varchar(50) not null
);

create table factura_vii(
	id_factura SERIAL primary key unique not null,
	fecha date not null,
	producto varchar(20) not null,
	cantidad integer not null,
	valor_unitario integer not null,
	valor_total integer not null,
	usuario_id varchar(10) not null,
	constraint fk_usuario_id FOREIGN KEY (usuario_id) REFERENCES usuario_vii(identificacion)
);

create or replace procedure crear_usuario_vii()
language plpgsql
as $$
DECLARE
	identificacion varchar;
	nombre_completo varchar;
	email varchar;
	edad integer;
	nombre varchar;
	apellido varchar;
	nombres varchar[] := ARRAY['Ana', 'Luis', 'Pedro', 'Maria', 'Carlos', 'Laura'];
    apellidos varchar[] := ARRAY['Gomez', 'Lopez', 'Martinez', 'Hernandez', 'Perez', 'Rodriguez'];
	dominios varchar[] := ARRAY['example.com', 'test.com', 'demo.com', 'sample.com'];
	dominio varchar;
begin
	for cant in 1..50
	loop
		identificacion := LPAD(FLOOR(RANDOM() * 1000000000)::INT::varchar, 10, '0');
		
		nombre := nombres[FLOOR(RANDOM() * array_length(nombres, 1) + 1)];
	    apellido := apellidos[FLOOR(RANDOM() * array_length(apellidos, 1) + 1)];
		
		nombre_completo := CONCAT(nombre, ' ', apellido);
        email := CONCAT((LOWER(nombre), '.', LOWER(apellido))::varchar, '@','gmail.com');
		
		edad := floor(random() * 82)+16;
		
		insert into usuario_vii(identificacion,nombre,edad,correo)
		values (identificacion,nombre_completo,edad,email);
	end loop;
end;
$$;
call crear_usuario_vii();
select * from  usuario_vii;

create or replace procedure crear_factura_vii()
language plpgsql
as $$
DECLARE
	fecha date;
	producto varchar;
	cantidad integer;
	valor_unitario integer;
	valor_total integer;
	id_usuario varchar;
	productos varchar[] := ARRAY['Lapiz', 'Lapicero', 'Cuaderno', 'Zacapuntas', 'Borrador', 'Marcador', 'Resaltador', 'Colores'];
begin
	for cant in 1..25
	loop
		fecha := (current_date - INTERVAL '369 days' + (FLOOR(RANDOM() * 369) || ' days')::interval)::date;
		producto := productos[FLOOR(RANDOM() * array_length(productos, 1) + 1)];
		cantidad := floor(random() * 40)+1;
		valor_unitario := FLOOR(0 + (RANDOM() * (58700 - 0)));
		valor_total := valor_unitario*cantidad;
		select identificacion into id_usuario from usuario_vii ORDER BY RANDOM() LIMIT 1; 

		insert into factura_vii(fecha,producto,cantidad,valor_unitario,valor_total,usuario_id)
		values (fecha,producto,cantidad,valor_unitario,valor_total,id_usuario);
	end loop;
end;
$$;
call crear_factura_vii();
select * from  factura_vii;

--Parte 2
create or replace procedure prueba_identificacion_unica(identificacion varchar(10))
language plpgsql
as $$
declare 
	id varchar(10);
begin
	insert into usuario_vii(identificacion,nombre,edad,correo)
	values (identificacion,'Manuela Rivera',25,'manuelita@gmail.com');
exception
	when unique_violation then
		raise notice 'La identificación del usuario ya existe... %',sqlerrm;
		rollback;
		id := LPAD(FLOOR(RANDOM() * 1000000000)::INT::varchar, 10, '0');
		insert into usuario_vii(identificacion,nombre,edad,correo)
		values (id,'Manuela Rivera',25,'manuelita@gmail.com');
		raise notice 'Usuario creado exitosamente con id: %',id;
end;
$$;
call prueba_identificacion_unica('0396325103');

--Parte 3
create or replace procedure prueba_cliente_debe_existir()
language plpgsql
as $$
declare
	id varchar(10);
begin
	insert into factura_vii(fecha,producto,cantidad,valor_unitario,valor_total,usuario_id)
	values ('2024-09-14','Catuchera',1,89780,89780,0446331466);
	insert into factura_vii(fecha,producto,cantidad,valor_unitario,valor_total,usuario_id)
	values ('2024-09-14','Cartucherita',2,89780,89780*2,12345678);
exception
	when foreign_key_violation then
		raise notice 'El usuario debe de existir... %',sqlerrm;
		rollback;
end;
$$;
call prueba_cliente_debe_existir();
select * from  factura_vii;

--Parte 4
create or replace procedure prueba_producto_vacio()
language plpgsql
as $$
begin
	insert into factura_vii(fecha,producto,cantidad,valor_unitario,valor_total,usuario_id)
	values ('2024-09-14','Catuchera',1,89780,89780,'0446331466');
	insert into factura_vii(fecha,producto,cantidad,valor_unitario,valor_total,usuario_id)
	values ('2024-09-14',null,2,89780,89780*2,'0446331466');
exception
	when others then
        RAISE NOTICE 'Se produjo un error: %', SQLERRM;
		ROLLBACK;
end;
$$;
SELECT * FROM usuario_vii WHERE identificacion = '0446331466';
call prueba_producto_vacio();
select * from  factura_vii;
