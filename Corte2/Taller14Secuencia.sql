create table secuenciass.factura(
	id serial primary key,
	codigo bigint,
	cliente varchar(50),
	producto varchar(50),
	descuento numeric,
	valor_total numeric,
	numero_fe bigint
);

create sequence secuenciass.codigo_factura
	start with 100
	increment by 1;

create sequence secuenciass.numero_factura_electronica
	start with 500
	increment by 100;

select * from secuenciass.factura;
insert into secuenciass.factura(codigo,cliente,producto,descuento,valor_total,numero_fe) values
(nextval('secuenciass.codigo_factura'),'Consumidor final','Televisor',0.2,3467000,nextval('secuenciass.numero_factura_electronica'));

insert into secuenciass.factura(codigo,cliente,producto,descuento,valor_total,numero_fe) values
(nextval('secuenciass.codigo_factura'),'Consumidor final','Base cama + colchon',0.5,578900,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Fabian Orrego','Laptop hp core i3',0.10,2568000,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Consumidor final','Tab S6 Lite',0,1560000,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Consumidor final','Barra de sonido',0,548000,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Melissa Montes','Airpods',0.3,89890,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Consumidor final','Computador de mesa',0,4672000,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Consumidor final','Pantalla multifuncional',0.15,5698760,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Consumidor final','Televisor',0.2,3467000,nextval('secuenciass.numero_factura_electronica')),
(nextval('secuenciass.codigo_factura'),'Pedro Galvis','Televisor',0,1560000,nextval('secuenciass.numero_factura_electronica'));