create table exml.libros(
	isbn varchar(10) primary key unique,
	descripcion xml
);

insert into exml.libros(isbn,descripcion)
values('135B',xmlparse(document '<libro><titulo>Quijote</titulo><autor>Miguel de Cervantes</autor><aio>1605</aio></libro>'));

insert into exml.libros(isbn,descripcion)
values('3456A',xmlparse(document '<libro><titulo>Bajo la misma estrella</titulo><autor>John Green</autor><aio>2012</aio></libro>'));

insert into exml.libros(isbn,descripcion)
values('8765C',xmlparse(document '<libro><titulo>A tres metros sobre el cielo</titulo><autor>Federico Moccia</autor><aio>1992</aio></libro>'));

insert into exml.libros(isbn,descripcion)
values('349A',xmlparse(document '<libro><titulo>Salvaje</titulo><autor>Cheryl Strayed</autor><aio>2012</aio></libro>'));

select isbn, xpath('//titulo/text()',descripcion)::text as Titulo,xpath('//autor/text()',descripcion)::text as Autor,xpath('//aio/text()',descripcion)::text as Aio from exml.libros;

create or replace procedure exml.guardar_libro(p_isbn varchar,p_libro varchar)
as $$
begin
	insert into exml.libros(isbn,descripcion) values(p_isbn,xmlparse(document p_libro));
end;
$$ language plpgsql;

call exml.guardar_libro('3456E','<libro><titulo>Tres veces tu</titulo><autor>Federico Moccia</autor><aio>2017</aio></libro>');

create or replace procedure exml.actualizar_libro(p_libro varchar,p_isbn varchar)
as $$
begin 
	update exml.libros set descripcion = xmlparse(document p_libro) where isbn = p_isbn;
end;
$$ language plpgsql;

call exml.actualizar_libro('<libro><titulo>Tengo ganas de ti</titulo><autor>Federico Moccia</autor><aio>2017</aio></libro>','3456E');

create or replace function exml.obtener_autor_libro_por_isbn(f_isbn varchar)
returns varchar 
as $$
declare 
	autor_libro varchar(100);
begin
	select unnest(xpath('//autor/text()',descripcion))::text as autor into autor_libro from exml.libros where isbn = f_isbn;
	return autor_libro;
end;
$$ language plpgsql;

select exml.obtener_autor_libro_por_isbn('349A');

create or replace function exml.obtener_autor_libro_por_titulo(f_titulo varchar)
returns varchar 
as $$
declare 
	autor_libro varchar(100);
begin
	select p.autor into autor_libro from exml.libros, 
	xmltable('/libro' passing descripcion columns titulo text path 'titulo', autor text path 'autor')
	as p where titulo=f_titulo;
	return autor_libro;
end;
$$ language plpgsql;

select exml.obtener_autor_libro_por_titulo('Tres veces tu');

create or replace function exml.obtener_libros_por_anio(f_anio varchar)
returns table (f_isbn varchar, f_titulo varchar, f_autor varchar, f_aio varchar)
as $$
begin
    return query 
    select isbn, 
       (xpath('//titulo/text()', descripcion))[1]::text::varchar as Titulo, 
       (xpath('//autor/text()', descripcion))[1]::text::varchar as Autor, 
       (xpath('//aio/text()', descripcion))[1]::text::varchar as Aio 
	from exml.libros
	where (xpath('//aio/text()', descripcion))[1]::text = f_anio;
end;
$$ language plpgsql;


select * from exml.obtener_libros_por_anio('2012');

