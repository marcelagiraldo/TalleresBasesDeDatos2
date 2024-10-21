create table ejson.factura(
	codigo varchar primary key,
	descripcion jsonb
);

insert into ejson.factura(codigo,descripcion)
values('PV03','{"cliente":"Consumidor final","identificacion":"222222","direccion":"Ninguna","codigoFactura":"F-543",
"totalDescuento":0,"total":243660,"items":[{"cantidad":4,"valor":60915,"producto":{"nombre":"Jean","descripcion":"Talla M",
"precio":60914,"categoria":["Ropa","Hombre"]}}]}');

create or replace procedure ejson.guardar_facturas(p_codigo varchar, p_descripcion jsonb)
as $$
declare
	v_precio numeric;
	v_descuento numeric;
begin 
	v_precio := (p_descripcion->>'total')::numeric;
	v_descuento := (p_descripcion->>'totalDescuento')::numeric;

	if(v_precio>42437922) then
		raise exception 'El precio no puede ser mayor a 10.000 dolares';
	end if;

	if(v_descuento>212189) then
		raise exception 'El descuento no puede ser mayor a 50 dolares';
	end if;

	insert into ejson.factura(codigo,descripcion)
	values(p_codigo,p_descripcion);
end;
$$ language plpgsql;

call ejson.guardar_facturas('PV04','{"cliente":"Fernando Perez","identificacion":"32456789","direccion":"Cra56#24-32","codigoFactura":"F-342",
"totalDescuento":13000,"total":117000,"items":[{"cantidad":1,"valor":130000,"producto":{"nombre":"Tenis","descripcion":"Talla 42",
"precio":130000,"categoria":["Calzado","Mujer"]}}]}');

call ejson.guardar_facturas('PV05','{"cliente":"Esteban Rivera","identificacion":"1987654321","direccion":"Cra25#98-62","codigoFactura":"F-343",
"totalDescuento":9500,"total":85500,"items":[{"cantidad":1,"valor":53000,"producto":{"nombre":"Buso","descripcion":"Talla M",
"precio":53000,"categoria":["Ropa","Hombre"]}},{"cantidad":1,"valor":7000,"producto":{"nombre":"Medias","descripcion":"Talla 14",
"precio":7000,"categoria":["Calzado","Hombre"]}},{"cantidad":1,"valor":35000,"producto":{"nombre":"Camisa","descripcion":"Talla M",
"precio":35000,"categoria":["Ropa","Hombre"]}}]}');

create or replace procedure ejson.actualizar_factura(p_codigo varchar,p_descripcion jsonb)
as $$
begin 
	update ejson.factura
	set descripcion = p_descripcion
	where codigo=p_codigo;
	
	if not found then
        raise exception 'Factura con codigo % no encontrada', p_codigo;
    end if;
end;
$$ language plpgsql;

call ejson.actualizar_factura('PV04','{"cliente":"Fernando Perez","identificacion":"32456789","direccion":"Cra23#32-24","codigoFactura":"F-342",
"totalDescuento":13000,"total":117000,"items":[{"cantidad":1,"valor":130000,"producto":{"nombre":"Tenis","descripcion":"Talla 42",
"precio":130000,"categoria":["Calzado","Mujer"]}}]}');

create or replace function ejson.obtener_nombre_cliente(p_id varchar)
returns varchar
as $$
declare 
	nombre_cliente varchar;
begin 
	select descripcion->>'cliente' into nombre_cliente
	from ejson.factura where descripcion->>'identificacion'=p_id;
	return nombre_cliente;
end;
$$ language plpgsql;

select ejson.obtener_nombre_cliente('32456789');

create or replace function ejson.obtener_facturas()
returns table(p_nombre varchar,p_id varchar,p_codigoFactura varchar,p_totalDescuento numeric,p_totalFactura numeric)
as $$
begin
	return query
	select (descripcion->>'cliente')::varchar as p_nombre,
	(descripcion->>'identificacion')::varchar as p_id,
	(descripcion->>'codigoFactura')::varchar as p_codigoFactura, 
	(descripcion->>'totalDescuento')::numeric as p_totalDescuento,
	(descripcion->>'total')::numeric as p_totalFactura
	from ejson.factura;
end;
$$ language plpgsql;


select * from ejson.obtener_facturas();

create or replace function ejson.obtener_productos_vendidos(p_codigoFactura varchar)
returns table(
    p_nombre varchar,
    p_descripcion varchar,
    p_precio numeric,
    p_categoria varchar[]
) as $$
begin
    return query
    select 
        (item->'producto'->>'nombre')::varchar as p_nombre,
        (item->'producto'->>'descripcion')::varchar as p_descripcion,
        (item->'producto'->>'precio')::numeric as p_precio,
        array_agg(cat::varchar) as p_categoria
    from ejson.factura
    cross join jsonb_array_elements(descripcion->'items') as item
    cross join jsonb_array_elements_text(item->'producto'->'categoria') as cat
    where descripcion->>'codigoFactura' = p_codigoFactura
    group by 
        item->'producto'->>'nombre',
        item->'producto'->>'descripcion',
        item->'producto'->>'precio';
	if not found then
        raise exception 'Factura con codigo % no encontrada', p_codigoFactura;
    end if;
end;
$$ language plpgsql;

select * from ejson.obtener_productos_vendidos('F-343');