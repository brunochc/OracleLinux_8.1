-- =============================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================

PROMPT Creando procedimiento: SP_ACTUALIZAR_SALARIO...
CREATE OR REPLACE PROCEDURE sp_actualizar_salario (
    p_id_empleado IN NUMBER,
    p_porcentaje IN NUMBER,
    p_resultado OUT VARCHAR2
) IS
    v_salario_actual NUMBER;
    v_nuevo_salario NUMBER;
BEGIN
    -- Obtener salario actual
    SELECT salario INTO v_salario_actual
    FROM empleados
    WHERE id_empleado = p_id_empleado;
    
    -- Calcular nuevo salario
    v_nuevo_salario := v_salario_actual * (1 + p_porcentaje/100);
    
    -- Actualizar salario
    UPDATE empleados 
    SET salario = v_nuevo_salario
    WHERE id_empleado = p_id_empleado;
    
    p_resultado := 'SALARIO ACTUALIZADO: ' || v_salario_actual || ' -> ' || v_nuevo_salario;
    COMMIT;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_resultado := 'ERROR: EMPLEADO NO ENCONTRADO';
    WHEN OTHERS THEN
        p_resultado := 'ERROR: ' || SQLERRM;
        ROLLBACK;
END sp_actualizar_salario;
/

PROMPT Creando procedimiento: SP_INSERTAR_EMPLEADO...
CREATE OR REPLACE PROCEDURE sp_insertar_empleado (
    p_dni IN VARCHAR2,
    p_nombre IN VARCHAR2,
    p_apellido_paterno IN VARCHAR2,
    p_apellido_materno IN VARCHAR2,
    p_salario IN NUMBER,
    p_id_departamento IN NUMBER,
    p_cargo IN VARCHAR2,
    p_id_empleado OUT NUMBER
) IS
BEGIN
    -- Obtener siguiente ID de la secuencia
    SELECT seq_empleados.NEXTVAL INTO p_id_empleado FROM DUAL;
    
    -- Insertar nuevo empleado
    INSERT INTO empleados (
        id_empleado, dni, nombre, apellido_paterno, apellido_materno,
        salario, id_departamento, cargo, fecha_contratacion
    ) VALUES (
        p_id_empleado, p_dni, p_nombre, p_apellido_paterno, p_apellido_materno,
        p_salario, p_id_departamento, p_cargo, SYSDATE
    );
    
    COMMIT;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_id_empleado := -1; -- DNI duplicado
        ROLLBACK;
    WHEN OTHERS THEN
        p_id_empleado := -2; -- Otro error
        ROLLBACK;
END sp_insertar_empleado;
/

PROMPT Creando función: FN_CALCULAR_ANTIGUEDAD...
CREATE OR REPLACE FUNCTION fn_calcular_antiguedad (
    p_id_empleado IN NUMBER
) RETURN NUMBER IS
    v_fecha_contratacion DATE;
    v_antiguedad NUMBER;
BEGIN
    SELECT fecha_contratacion INTO v_fecha_contratacion
    FROM empleados
    WHERE id_empleado = p_id_empleado;
    
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_contratacion) / 12);
    
    RETURN v_antiguedad;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN -2;
END fn_calcular_antiguedad;
/
