create table cursores.envio(
	id SERIAL primary key unique not null,
	fecha_envio date,
	destino varchar(50) not null,
	observacion varchar(140),
	estado varchar(50) not null
);
drop table cursores.envio;
create or replace procedure cursores.crear_envios()
language plpgsql
as $$
DECLARE
	fecha_envio_ date;
	destino_ varchar;
	observacion_ varchar;
	estado_ varchar;
	estados varchar[] := ARRAY['Pendiente','En ruta','Entregado'];
begin
	for cant in 1..50
	loop
		destino_ := 'Destino ' || (FLOOR(RANDOM() * 100) + 1);
		estado_ := estados[FLOOR(RANDOM() * array_length(estados, 1) + 1)];
		insert into cursores.envio(fecha_envio,destino,observacion,estado)
		values (fecha_envio_,destino_,observacion_,estado_);
	end loop;	
end;
$$;
delete from cursores.envio ;
call cursores.crear_envios();

create or replace procedure cursores.primera_fase_envio()
language plpgsql
as $$
DECLARE
	cursor_ cursor for select id,fecha_envio,destino,observacion,estado from cursores.envio;
	id_ integer;	
	fecha_ date;
	destino_ varchar;
	observacion_ varchar;
	estado_ varchar;
begin
	open cursor_;
	loop
		fetch cursor_ into id_,fecha_,destino_,observacion_,estado_;
		exit when not found;
		if estado_ = 'Pendiente' then 
			update cursores.envio set fecha_envio = (date '2024-09-01' + (RANDOM() * (date '2024-10-04' - date '2024-09-01'))::int) where id = id_;
			update cursores.envio set observacion = 'Primera etapa del envio' where id = id_;
			update cursores.envio set estado = 'En ruta' where id = id_;
		end if;
	end loop;
	close cursor_;
end;
$$;

call cursores.primera_fase_envio();
select * from cursores.envio e ;	

create or replace procedure cursores.ultima_fase_envio()
language plpgsql
as $$
DECLARE
	cursor_ cursor for select id,fecha_envio,destino,observacion,estado from cursores.envio;
	id_ integer;	
	fecha_ date;
	destino_ varchar;
	observacion_ varchar;
	estado_ varchar;
	dias_transcurridos integer;
begin
	open cursor_;
	loop
		fetch cursor_ into id_,fecha_,destino_,observacion_,estado_;
		exit when not found;
		if estado_ = 'En ruta' then 
			dias_transcurridos := (CURRENT_DATE - fecha_)::int;
			if dias_transcurridos > 5 then
				update cursores.envio set observacion = 'Envío realizado satisfactoriamente' where id = id_;
				update cursores.envio set estado = 'Entregado' where id = id_;	
			end if;		
		end if;
	end loop;
	close cursor_;
end;
$$;

call cursores.ultima_fase_envio();
select * from cursores.envio e ;	