-- =============================================
-- CONSULTAS BÁSICAS DEL SISTEMA
-- =============================================

PROMPT === EMPLEADOS POR DEPARTAMENTO ===
SELECT d.nombre_depto as Departamento,
       COUNT(e.id_empleado) as "Cantidad Empleados",
       ROUND(AVG(e.salario),2) as "Salario Promedio"
FROM departamentos d
LEFT JOIN empleados e ON d.id_departamento = e.id_departamento
GROUP BY d.nombre_depto
ORDER BY COUNT(e.id_empleado) DESC;

PROMPT === CLIENTES POR VENDEDOR ===
SELECT e.nombre || ' ' || e.apellido_paterno as Vendedor,
       COUNT(c.id_cliente) as "Clientes Asignados",
       SUM(c.limite_credito) as "Total Límite Crédito"
FROM empleados e
LEFT JOIN clientes c ON e.id_empleado = c.vendedor_asignado
WHERE e.id_departamento = 2  -- Departamento de Ventas
GROUP BY e.nombre, e.apellido_paterno
ORDER BY COUNT(c.id_cliente) DESC;

PROMPT === PRESUPUESTO POR DEPARTAMENTO ===
SELECT nombre_depto as Departamento,
       ROUND(presupuesto_anual/1000, 2) as "Presupuesto (Miles)",
       jefe_departamento as "Jefe Departamento"
FROM departamentos
ORDER BY presupuesto_anual DESC;
