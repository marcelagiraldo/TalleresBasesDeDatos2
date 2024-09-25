ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

CREATE TABLE cliente (
	identificacion VARCHAR(10) PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	edad INTEGER NOT NULL,
	correo VARCHAR(50) NOT NULL
);

CREATE TABLE producto (
	codigo_producto VARCHAR(10) PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	stock INTEGER NOT NULL,
	valor_unitario NUMERIC NOT NULL	
);

CREATE TABLE factura (
	id_factura VARCHAR(10) PRIMARY KEY NOT NULL,
	cliente_id_fk VARCHAR(10) NOT NULL,
	producto_codigo_fk VARCHAR(10) NOT NULL,
	fecha DATE NOT NULL,
	cant_total INTEGER NOT NULL,
	pedido_estado VARCHAR(20) NOT NULL,
	constraint fk_cliente_id FOREIGN KEY (cliente_id_fk) REFERENCES cliente(identificacion),
	constraint producto_id FOREIGN KEY (producto_codigo_fk) REFERENCES producto(codigo_producto)
);
DROP TABLE factura;

insert into cliente(identificacion,nombre,edad,correo)
values ('1098675834','Fernanda', 19, 'fernanda@gmail.com');
insert into cliente(identificacion,nombre,edad,correo)
values (1993546789,'Maicol', 21, 'maicol@gmail.com');
insert into cliente(identificacion,nombre,edad,correo)
values (1002543765,'Alex', 25, 'alex@gmail.com');

SELECT * FROM PRODUCTO;

insert into producto(codigo_producto,nombre,stock,valor_unitario)
values ('2352','Mesa', 32,127990);
insert into producto(codigo_producto,nombre,stock,valor_unitario)
values ('4356','Silla', 35,97960);
insert into producto(codigo_producto,nombre,stock,valor_unitario)
values ('6789','Escritorio', 25,235900);

insert into factura(id_factura,cliente_id_fk,producto_codigo_fk,fecha,cant_total,pedido_estado)
values ('FE1','1098675834','2352','2024-09-10',12,'ENTREGADO');

insert into factura(id_factura,cliente_id_fk,producto_codigo_fk,fecha,cant_total,pedido_estado)
values ('FE3','1002543765','6789','2024-09-12',5,'BLOQUEADO');

ALTER USER TALLER QUOTA UNLIMITED ON USERS;

CREATE OR REPLACE PROCEDURE verificar_stock_oracle (
    id_producto IN VARCHAR2,
    cantidad_compra IN NUMBER
)
IS
    stock_actual NUMBER;
BEGIN
    SELECT stock INTO stock_actual
    FROM producto
    WHERE codigo_producto = id_producto;

    IF stock_actual < cantidad_compra THEN
        DBMS_OUTPUT.PUT_LINE('No hay suficiente Stock');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Puede realizar la compra');
    END IF;
END;


DROP PROCEDURE verificar_stock_oracle;

CALL verificar_stock_oracle('2352',10);
CALL verificar_stock_oracle('2352',50);