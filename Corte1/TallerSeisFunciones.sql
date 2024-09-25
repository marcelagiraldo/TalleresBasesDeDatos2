/*-----------------Taller 6 Parte 1------------------------*/
create table IF NOT EXISTS clientePagos (
	identificacion varchar(10) primary key unique not null,
	nombre varchar (50) not null,
	email varchar(50) not null,
	direccion varchar(50) not null,
	telefono varchar(10) not null
);

create table IF NOT EXISTS servicioPagos (
	codigo varchar(20) primary key unique not null,
	tipo varchar (50) not null,
	estado varchar(20) not null,
	monto numeric not null,
	cuota numeric,
	intereses numeric,
	valor_total numeric not null,
	id_cliente varchar(10) not null,
	constraint fk_cliente_id FOREIGN KEY (id_cliente) REFERENCES clientePagos(identificacion)
);

create table if not exists pagoServicios(
	codigo_transaccion varchar(30) primary key unique not null,
	fecha_pago date not null,
	total numeric not null,
	id_servicio varchar(10) not null,
	constraint fk_servicio_id FOREIGN KEY (id_servicio) REFERENCES servicioPagos(codigo)
);


create or replace procedure crear_clientes()
language plpgsql
as $$
DECLARE
	identificacion varchar;
	nombre_completo varchar;
	email varchar;
	direccion varchar;
	telefono varchar;
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
		
		direccion := concat('Cra ', floor(random() * 50) + 1, '#', floor(random() * 100) + 1,'-',floor(random() * 20) + 1);
		telefono := LPAD(FLOOR(RANDOM() * 1000000000)::INT::varchar, 10, '3');
		
		insert into clientePagos(identificacion,nombre,email,direccion,telefono)
		values (identificacion,nombre_completo, email,direccion,telefono);
	end loop;	
end;
$$;
call crear_clientes();
select * from clientePagos;


create or replace procedure crear_servicios()
language plpgsql
as $$
DECLARE
	vi_codigo varchar;
	vi_tipo varchar;
	vi_estado varchar;
	vi_monto numeric;
	vi_cuota numeric;
	vi_intereses numeric := 0.12;
	vi_valor_total numeric;
	vi_id_cliente varchar;
begin
	for vi_id_cliente in select identificacion from clientePagos
	loop
		for cant in 1..3
		loop
			vi_codigo := LPAD(FLOOR(RANDOM() * 1000000000)::INT::varchar, 10, '0');
			vi_tipo := (ARRAY['Energía', 'Agua', 'Gas', 'Internet', 'Televisión', 'Telefonía'])[FLOOR(1 + RANDOM() * 5)];
			vi_estado := (ARRAY['PAGO', 'NO PAGO', 'PENDIENTE'])[FLOOR(1 + RANDOM() * 3)];
			vi_monto := FLOOR(0 + (RANDOM() * (1000000 - 0)));
			vi_cuota := floor(random() * 12);
			vi_valor_total := vi_monto + (vi_monto * vi_intereses * vi_cuota);
			insert into servicioPagos(codigo,tipo,estado,monto,cuota,intereses,valor_total,id_cliente)
			values(vi_codigo,vi_tipo,vi_estado,vi_monto,vi_cuota,vi_intereses,vi_valor_total,vi_id_cliente);
		end loop;
	end loop;	
end;
$$;
call crear_servicios();
select * from serviciopagos;

create or replace procedure crear_pagos()
language plpgsql
as $$
DECLARE
	vi_codigo_transaccion varchar;
	vi_fecha_pago date;
	vi_total numeric;
	vi_id_servicio varchar;
begin
	for cant in 1..50
	loop
		vi_codigo_transaccion := LPAD(FLOOR(RANDOM() * 1000000000)::INT::varchar, 10, '0');
		select codigo into vi_id_servicio from servicioPagos ORDER BY RANDOM() LIMIT 1; 
		vi_fecha_pago := (current_date - INTERVAL '369 days' + (FLOOR(RANDOM() * 369) || ' days')::interval)::date;
		select valor_total into vi_total from servicioPagos where codigo = vi_id_servicio LIMIT 1;
		insert into pagoServicios(codigo_transaccion,fecha_pago,total,id_servicio)
		values(vi_codigo_transaccion,vi_fecha_pago,vi_total,vi_id_servicio);
	end loop;	
end;
$$;

call crear_pagos();
select * from pagoServicios;

select * from pagoServicios where id_servicio='0631532615';
select * from pagoServicios where id_servicio='0153049191';
select * from pagoServicios where id_servicio='0123557060';

select * from servicioPagos where codigo='0631532615';
select * from servicioPagos where codigo='0153049191';
select * from servicioPagos where codigo='0123557060';
select * from servicioPagos where id_cliente ='0975943352';

/*-----------------Taller 6 - Parte 2 -----------------------------*/
create or replace function transaccion_total_mes(mes date,vi_id_cliente varchar)
returns numeric as
$$
declare
	total_pago numeric := 0;
	vi_subtotal numeric :=0; 
begin
	for vi_subtotal in select valor_total from pagoServicios ps join servicioPagos sp on ps.id_servicio=sp.codigo where sp.id_cliente=vi_id_cliente and DATE_TRUNC('month', ps.fecha_pago) = DATE_TRUNC('month', mes) and sp.estado = 'PAGO'
	loop
		total_pago := total_pago + vi_subtotal;
	end loop;
	return total_pago;
end
$$
language plpgsql;

drop function transaccion_total_mes;
select transaccion_total_mes('2024-07-30','0477672096');
select transaccion_total_mes('2024-06-30','0975943352');