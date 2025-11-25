-- =============================================
-- EJEMPLOS DE USO DE PROCEDIMIENTOS Y FUNCIONES
-- =============================================

PROMPT === EJEMPLO 1: Usando vistas ===
SELECT * FROM v_empleados_completos WHERE departamento = 'VENTAS Y MARKETING';

PROMPT === EJEMPLO 2: Usando procedimiento almacenado ===
SET SERVEROUTPUT ON
DECLARE
    v_resultado VARCHAR2(200);
BEGIN
    sp_actualizar_salario(1001, 10, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

PROMPT === EJEMPLO 3: Usando función ===
SELECT nombre, fn_calcular_antiguedad(id_empleado) as antiguedad_anios
FROM empleados;

PROMPT === EJEMPLO 4: Probando trigger de auditoría ===
-- Actualizar salario para generar registro de auditoría
UPDATE empleados SET salario = salario * 1.05 WHERE id_empleado = 1002;
COMMIT;

-- Ver registros de auditoría
SELECT * FROM auditoria_empleados;

PROMPT === EJEMPLO 5: Usando paquete ===
BEGIN
    pkg_gestion_empleados.sp_actualizar_salario(1001, 5);
    DBMS_OUTPUT.PUT_LINE('Salario actualizado via paquete');
END;
/

PROMPT === EJEMPLO 6: Probando validación de DNI (debe fallar) ===
BEGIN
    -- Esto debería fallar por DNI inválido
    pkg_gestion_empleados.sp_insertar_empleado(
        '12345', 'TEST', 'USER', 'TEST', 1500, 2, 'ANALISTA'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error esperado: ' || SQLERRM);
END;
/

PROMPT === VERIFICACIÓN FINAL ===
SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'TRIGGER', 'PACKAGE', 'PACKAGE BODY', 'VIEW')
ORDER BY object_type, object_name;
