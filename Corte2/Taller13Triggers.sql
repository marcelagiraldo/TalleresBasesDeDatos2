create table tallertriggers.empleado(
	identificacion varchar(10) primary key,
	nombre varchar(30) not null,
	edad integer not null,
	correo varchar(60) not null,
	salario numeric not null
);

create table tallertriggers.nomina(
	id serial primary key,
	fecha date not null,
	total_ingresos numeric not null,
	total_deducciones numeric,
	total_neto numeric not null,
	empleado_id_fk varchar(10) not null,
	constraint fk_empleado foreign key(empleado_id_fk) references tallertriggers.empleado(identificacion)
);

create table tallertriggers.detalles_nomina(
	id serial primary key,
	concepto varchar not null,
	tipo varchar not null,
	valor numeric not null,
	nomina_id_fk integer not null,
	constraint fk_nomina foreign key(nomina_id_fk) references tallertriggers.nomina(id)
);

create table tallertriggers.auditoria_nomina(
	id serial primary key,
	fecha date not null,
	identificacion varchar(10) not null,
	nombre varchar(30) not null,
	total_neto numeric not null
);

insert into tallertriggers.empleado(identificacion,nombre,edad,correo,salario) values
('143453454','Felipe',32,'felipe@gmail.com',2567000),
('235465464','Juan',28,'juan@gmail.com',5678900),
('789764354','Monica',27,'monica@gmail.com',2350000),
('463656226','Melissa',38,'melisa@gmail.com',4879600),
('575234345','Vanesa',42,'vanesa@gmail.com',1985000);

create or replace function validar_presupuesto_nomina()
returns trigger as $$
declare
    total_presupuesto NUMERIC := 12000000;
    total_actual NUMERIC;
begin
    -- Sumar todos los ingresos actuales en la tabla nomina
    select COALESCE(SUM(total_ingresos), 0)
    into total_actual
    from tallertriggers.nomina;

    -- Verificar si el total actual más el nuevo ingreso supera el presupuesto
    if (total_actual + new.total_ingresos) > total_presupuesto then
        raise exception 'El presupuesto de nómina ha sido superado. Presupuesto: %, Total actual: %, Nuevo ingreso: %',
            total_presupuesto, total_actual, new.total_ingresos;
    end if;

	insert into tallertriggers.auditoria_nomina (fecha, identificacion, nombre, total_neto)
    values (new.fecha, new.empleado_id_fk, (select nombre from tallertriggers.empleado where identificacion = new.empleado_id_fk), new.total_neto);

   return new;
end;
$$ language plpgsql;

create trigger antes_insertar_nomina
before insert on tallertriggers.nomina
for each row
execute function validar_presupuesto_nomina();

select * from tallertriggers.auditoria_nomina;

insert into tallertriggers.nomina(fecha,total_ingresos,total_deducciones,total_neto,empleado_id_fk) values
('2024-09-30',2567000,0,2567000,'143453454');
insert into tallertriggers.nomina(fecha,total_ingresos,total_deducciones,total_neto,empleado_id_fk) values
('2024-09-30',5678900,350000,5328900,'235465464');
insert into tallertriggers.nomina(fecha,total_ingresos,total_deducciones,total_neto,empleado_id_fk) values
('2024-09-30',2350000,100000,2250000,'789764354');

/*Este ya no lo deja insertar porque supera el presupuesto de nómina*/
insert into tallertriggers.nomina(fecha,total_ingresos,total_deducciones,total_neto,empleado_id_fk) values
('2024-09-30',1998000,0,1998000,'575234345');

insert into tallertriggers.detalles_nomina(concepto,tipo,valor,nomina_id_fk) values
('Ahorro','deduccion',350000,25),
('Llegadas tarde','deduccion',100000,26);

insert into tallertriggers.detalles_nomina(concepto,tipo,valor,nomina_id_fk) values
('Salario base','ingreso',5678900,25),
('Salario base','ingreso',2350000,26),
('Salario base','ingreso',2567000,24);

create or replace function validar_presupuesto_salario()
returns trigger as $$
declare
    total_presupuesto NUMERIC := 12000000;
    total_salarios NUMERIC;
    nuevo_salario NUMERIC;
	concepto_nuevo varchar(30);
begin
    -- Sumar todos los salarios actuales en la tabla empleado
    select COALESCE(SUM(salario), 0)
    into total_salarios
    from tallertriggers.empleado;

    -- Obtener el nuevo salario propuesto
    nuevo_salario := new.salario;

    -- Verificar si el total actual menos el salario antiguo más el nuevo salario supera el presupuesto
    if (total_salarios - old.salario + nuevo_salario) > total_presupuesto then
        raise exception 'El presupuesto de salarios ha sido superado. Presupuesto: %, Total actual: %, Nuevo salario: %',
            total_presupuesto, total_salarios, nuevo_salario;
    end if;
	
	if (nuevo_salario > old.salario) then
		concepto_nuevo := 'AUMENTO';
	else
		concepto_nuevo := 'DISMINUCION';
	end if;

	insert into tallertriggers.auditoria_empleado(fecha, nombre, identificacion,concepto,valor)
	values(CURRENT_DATE,new.nombre,new.identificacion,concepto_nuevo,nuevo_salario);

    return new;
end;
$$ language plpgsql;


create trigger antes_actualizar_salario
before update on tallertriggers.empleado
for each row
when (old.salario is distinct from new.salario)
execute function validar_presupuesto_salario();

update tallertriggers.empleado
set salario = 3980000
where identificacion = '143453454';


create table tallertriggers.auditoria_empleado(
	id serial primary key,
	fecha date not null,
	nombre varchar(30) not null,
	identificacion varchar(10) not null,
	concepto varchar(30) not null,
	valor numeric not null
);

select * from tallertriggers.auditoria_empleado;
