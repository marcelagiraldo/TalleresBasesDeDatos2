create table empleados(
	identificacion varchar(10) primary key unique not null,
	nombre varchar(50) not null,
	id_tipo_contrato SERIAL not null,
	constraint fk_tipo_contrato_id FOREIGN KEY (id_tipo_contrato) REFERENCES tipo_contrato(id)
);

create table tipo_contrato(
	id SERIAL primary key unique not null,
	descripcion varchar(1000) not null,
	cargo varchar(20) not null,
	salario_total numeric not null
);

create table conceptos(
	codigo varchar(5) primary key unique not null,
	nombre varchar(60) not null,
	porcentaje numeric not null
);

create table detalles_nomina(
	id SERIAL primary key unique not null,
	id_concepto varchar(10) not null,
	valor numeric not null,
	id_nomina varchar(10) not null,
	constraint fk_nomina_id FOREIGN KEY (id_nomina) REFERENCES nomina(id),
	constraint fk_concepto_id FOREIGN KEY (id_concepto) REFERENCES conceptos(codigo)
);

create table nomina(
	id varchar(5) primary key unique not null,
	mes varchar(1000) not null,
	aio varchar(20) not null,
	fecha_pago date not null,
	total_devengado numeric not null,
	total_deducciones numeric not null,
	total numeric not null,
	id_empleado varchar(10) not null,
	constraint fk_empleado_id FOREIGN KEY (id_empleado) REFERENCES empleados(identificacion)
);

INSERT INTO tipo_contrato(descripcion, cargo, salario_total) VALUES
('Contrato por obra determinada', 'Ingeniero', 2500000),
('Contrato a plazo fijo', 'Administrativo', 2000000),
('Contrato de aprendizaje', 'Pasante', 900000),
('Contrato indefinido', 'Gerente de Proyectos', 2200000),
('Contrato temporal', 'Asistente', 1300000),
('Contrato de consultoría', 'Consultor', 1500000),
('Contrato a tiempo parcial', 'Vendedor', 800000),
('Contrato de trabajo remoto', 'Desarrollador', 3500000),
('Contrato estacional', 'Repartidor', 1000000),
('Contrato de investigación', 'Investigador', 2300000);

INSERT INTO empleados (identificacion, nombre, id_tipo_contrato) VALUES
('001', 'Juan Pérez', 1),
('002', 'Ana Gómez', 2),
('003', 'Luis Martínez', 3),
('004', 'Carla Torres', 3),
('005', 'Pedro Fernández', 5),
('006', 'Laura Sánchez', 7),
('007', 'Javier Ramírez', 7),
('008', 'Sofía Morales', 7),
('009', 'Diego López', 8),
('010', 'María Ruiz', 10);

INSERT INTO conceptos (codigo, nombre, porcentaje) VALUES
('C001', 'Salario Base', 100.00),
('C002', 'Bonificación', 10.00),
('C003', 'Descuento Salud', -4.00),
('C004', 'Descuento Pensión', -4.00),
('C005', 'Horas Extras', 25.00),
('C006', 'Prima Vacacional', 15.00),
('C007', 'Aguinaldo', 8.33),
('C008', 'Descuento Impuesto', -5.00),
('C009', 'Incentivo Productividad', 12.00),
('C010', 'Descuento Sindical', -2.00),
('C011', 'Bono de Transporte', 7.00),
('C012', 'Capacitación', 5.00),
('C013', 'Reembolso Gastos', 0.00),
('C014', 'Descuento Aportaciones', -3.00),
('C015', 'Retención Judicial', -10.00);

INSERT INTO nomina (id, mes, aio, fecha_pago, total_devengado, total_deducciones, total, id_empleado) VALUES
('N001', 'Enero', '2024', '2024-01-15', 1500.00, 200.00, 1300.00, '001'),
('N002', 'Enero', '2024', '2024-01-30', 1600.00, 250.00, 1350.00, '002'),
('N003', 'Febrero', '2024', '2024-02-15', 1700.00, 300.00, 1400.00, '003'),
('N004', 'Febrero', '2024', '2024-02-28', 1800.00, 150.00, 1650.00, '004'),
('N005', 'Marzo', '2024', '2024-03-15', 1900.00, 400.00, 1500.00, '005');

INSERT INTO detalles_nomina (id_concepto, valor, id_nomina) VALUES
('C001', 1500.00, 'N001'),
('C002', 100.00, 'N001'),
('C003', -60.00, 'N001'),
('C004', -60.00, 'N001'),
('C005', 200.00, 'N001'),
('C001', 1600.00, 'N002'),
('C002', 150.00, 'N002'),
('C003', -70.00, 'N002'),
('C004', -70.00, 'N002'),
('C005', 210.00, 'N002'),
('C001', 1700.00, 'N003'),
('C002', 120.00, 'N003'),
('C003', -80.00, 'N003'),
('C004', -80.00, 'N003'),
('C005', 220.00, 'N003'),
('C001', 1800.00, 'N004');

CREATE OR REPLACE FUNCTION obtener_nomina_empleado(empleado_id varchar, mes_ varchar, aio_ varchar)
RETURNS TABLE (
    nombre varchar,
    total_devengado numeric,
    total_deducido numeric,
    total_nomina numeric
) AS
$$
BEGIN
    RETURN QUERY
    SELECT e.nombre, n.total_devengado, n.total_deducciones, n.total
    FROM empleados e
    JOIN nomina n ON e.identificacion = n.id_empleado
    WHERE e.identificacion = empleado_id AND n.mes = mes_ AND n.aio = aio_;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM obtener_nomina_empleado('002', 'Enero', '2024');

CREATE OR REPLACE FUNCTION total_por_contrato(tipo_contrato_id integer)
RETURNS TABLE (
    nombre varchar,
    fecha_pago date,
    aio varchar,
    mes varchar,
    total_devengado numeric,
    total_deducido numeric,
    total_nomina numeric
) AS
$$
BEGIN
    RETURN QUERY
    SELECT e.nombre,n.fecha_pago,n.aio,n.mes, n.total_devengado, n.total_deducciones, n.total
    FROM tipo_contrato tc
    JOIN empleados e ON tc.id = e.id_tipo_contrato
	JOIN nomina n ON e.identificacion = n.id_empleado
    WHERE tc.id = tipo_contrato_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM total_por_contrato(1);