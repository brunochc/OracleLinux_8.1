-- =============================================
-- VISTAS PARA REPORTES Y CONSULTAS
-- =============================================

PROMPT Creando vista: V_EMPLEADOS_COMPLETOS...
CREATE OR REPLACE VIEW v_empleados_completos AS
SELECT 
    e.id_empleado,
    e.dni,
    e.nombre || ' ' || e.apellido_paterno || ' ' || COALESCE(e.apellido_materno, '') as nombre_completo,
    e.fecha_nacimiento,
    e.email,
    e.telefono,
    e.salario,
    e.fecha_contratacion,
    e.cargo,
    d.nombre_depto as departamento,
    d.ubicacion,
    e.estado
FROM empleados e
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

PROMPT Creando vista: V_CLIENTES_CON_VENDEDOR...
CREATE OR REPLACE VIEW v_clientes_con_vendedor AS
SELECT 
    c.id_cliente,
    c.ruc,
    c.razon_social,
    c.nombre_comercial,
    c.tipo_cliente,
    c.limite_credito,
    c.fecha_registro,
    e.nombre || ' ' || e.apellido_paterno as vendedor_asignado,
    d.nombre_depto as departamento_vendedor
FROM clientes c
LEFT JOIN empleados e ON c.vendedor_asignado = e.id_empleado
LEFT JOIN departamentos d ON e.id_departamento = d.id_departamento;

PROMPT Creando vista: V_RESUMEN_DEPARTAMENTOS...
CREATE OR REPLACE VIEW v_resumen_departamentos AS
SELECT 
    d.id_departamento,
    d.nombre_depto,
    d.jefe_departamento,
    d.presupuesto_anual,
    COUNT(e.id_empleado) as cantidad_empleados,
    ROUND(AVG(e.salario), 2) as salario_promedio,
    SUM(e.salario) * 12 as costo_anual_personal
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento AND e.estado = 'ACTIVO'
GROUP BY d.id_departamento, d.nombre_depto, d.jefe_departamento, d.presupuesto_anual;

PROMPT === VERIFICACIÓN DE VISTAS CREADAS ===
SELECT view_name, text_length 
FROM user_views 
ORDER BY view_name;
