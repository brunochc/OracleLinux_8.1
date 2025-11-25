-- =============================================
-- DATOS DE PRUEBA - SISTEMA EMPRESARIAL
-- =============================================

PROMPT Insertando departamentos...
INSERT INTO departamentos VALUES (1, 'GERENCIA GENERAL', 'SANTIAGO - SEDE CENTRAL', 1200000, SYSDATE, 'CARLOS ROBLES', 'ACTIVO', 'gerencia@empresa.com', '01-1234567');
INSERT INTO departamentos VALUES (2, 'VENTAS Y MARKETING', 'SANTIAGO - OFICINA PRINCIPAL', 800000, SYSDATE, 'ANA TORRES', 'ACTIVO', 'ventas@empresa.com', '01-1234568');
INSERT INTO departamentos VALUES (3, 'SISTEMAS E IT', 'SANTIAGO - DATA CENTER', 950000, SYSDATE, 'LUIS MARTINEZ', 'ACTIVO', 'sistemas@empresa.com', '01-1234569');
INSERT INTO departamentos VALUES (4, 'CONTABILIDAD Y FINANZAS', 'SANTIAGO - PISO 3', 600000, SYSDATE, 'MARIA GONZALES', 'ACTIVO', 'contabilidad@empresa.com', '01-1234570');
INSERT INTO departamentos VALUES (5, 'RECURSOS HUMANOS', 'SANTIAGO - PISO 2', 450000, SYSDATE, 'PEDRO RAMIREZ', 'ACTIVO', 'rrhh@empresa.com', '01-1234571');

PROMPT Insertando empleados...
INSERT INTO empleados VALUES (seq_empleados.NEXTVAL, '12345678', 'JUAN', 'PEREZ', 'GOMEZ', TO_DATE('15-03-1985', 'DD-MM-YYYY'), 'M', 'juan.perez@empresa.com', '999888777', 8500.00, TO_DATE('01-01-2020', 'DD-MM-YYYY'), 1, 'GERENTE GENERAL', 'ACTIVO');
INSERT INTO empleados VALUES (seq_empleados.NEXTVAL, '87654321', 'ANA', 'TORRES', 'LOPEZ', TO_DATE('22-07-1990', 'DD-MM-YYYY'), 'F', 'ana.torres@empresa.com', '999777666', 6500.00, TO_DATE('15-03-2021', 'DD-MM-YYYY'), 2, 'GERENTE DE VENTAS', 'ACTIVO');
INSERT INTO empleados VALUES (seq_empleados.NEXTVAL, '11223344', 'LUIS', 'MARTINEZ', 'ROJAS', TO_DATE('10-11-1988', 'DD-MM-YYYY'), 'M', 'luis.martinez@empresa.com', '999666555', 7200.00, TO_DATE('20-05-2019', 'DD-MM-YYYY'), 3, 'JEFE DE SISTEMAS', 'ACTIVO');

PROMPT Insertando clientes...
INSERT INTO clientes VALUES (seq_clientes.NEXTVAL, '20123456789', 'INVERSIONES ABC S.A.', 'ABC CORPORATION', 'AV. AREQUIPA 1234 - LIMA', '01-2345678', 'ventas@abc.com', 'CORPORATIVO', SYSDATE, 1002, 'ACTIVO', 50000);
INSERT INTO clientes VALUES (seq_clientes.NEXTVAL, '20234567890', 'TECNOLOGIA XYZ E.I.R.L.', 'TECNOXYZ', 'JR. UNION 567 - MIRAFLORES', '01-3456789', 'info@tecnoxyz.com', 'MEDIANO', SYSDATE, 1002, 'ACTIVO', 25000);

PROMPT === VERIFICACIÓN DE DATOS INSERTADOS ===
SELECT 'Departamentos: ' || COUNT(*) FROM departamentos;
SELECT 'Empleados: ' || COUNT(*) FROM empleados;
SELECT 'Clientes: ' || COUNT(*) FROM clientes;

PROMPT Confirmando cambios...
COMMIT;

PROMPT === MUESTRA DE DATOS ===
SELECT * FROM departamentos;
SELECT id_empleado, nombre, apellido_paterno, cargo FROM empleados;
SELECT id_cliente, razon_social, tipo_cliente FROM clientes;
