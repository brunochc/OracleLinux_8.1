-- =============================================
-- PAQUETES PARA ORGANIZACIÓN DE CÓDIGO
-- =============================================

PROMPT Creando paquete: PKG_GESTION_EMPLEADOS...
CREATE OR REPLACE PACKAGE pkg_gestion_empleados AS
    -- Procedimientos
    PROCEDURE sp_actualizar_salario(p_id_empleado IN NUMBER, p_porcentaje IN NUMBER);
    PROCEDURE sp_insertar_empleado(
        p_dni IN VARCHAR2, p_nombre IN VARCHAR2, p_apellido_paterno IN VARCHAR2,
        p_apellido_materno IN VARCHAR2, p_salario IN NUMBER, 
        p_id_departamento IN NUMBER, p_cargo IN VARCHAR2
    );
    
    -- Funciones
    FUNCTION fn_calcular_antiguedad(p_id_empleado IN NUMBER) RETURN NUMBER;
    FUNCTION fn_obtener_info_empleado(p_id_empleado IN NUMBER) RETURN VARCHAR2;
    
    -- Constantes
    SALARIO_MINIMO CONSTANT NUMBER := 1025; -- Salario mínimo referencial
    SALARIO_MAXIMO CONSTANT NUMBER := 50000; -- Salario máximo referencial
    
END pkg_gestion_empleados;
/

CREATE OR REPLACE PACKAGE BODY pkg_gestion_empleados AS

    PROCEDURE sp_actualizar_salario(p_id_empleado IN NUMBER, p_porcentaje IN NUMBER) IS
        v_salario_actual NUMBER;
    BEGIN
        SELECT salario INTO v_salario_actual FROM empleados WHERE id_empleado = p_id_empleado;
        
        IF (v_salario_actual * (1 + p_porcentaje/100)) > SALARIO_MAXIMO THEN
            RAISE_APPLICATION_ERROR(-20010, 'El nuevo salario excede el máximo permitido');
        END IF;
        
        UPDATE empleados SET salario = salario * (1 + p_porcentaje/100)
        WHERE id_empleado = p_id_empleado;
        
        COMMIT;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011, 'Empleado no encontrado');
    END sp_actualizar_salario;

    PROCEDURE sp_insertar_empleado(
        p_dni IN VARCHAR2, p_nombre IN VARCHAR2, p_apellido_paterno IN VARCHAR2,
        p_apellido_materno IN VARCHAR2, p_salario IN NUMBER, 
        p_id_departamento IN NUMBER, p_cargo IN VARCHAR2
    ) IS
        v_id_empleado NUMBER;
    BEGIN
        IF p_salario < SALARIO_MINIMO THEN
            RAISE_APPLICATION_ERROR(-20012, 'El salario no puede ser menor al mínimo');
        END IF;
        
        SELECT seq_empleados.NEXTVAL INTO v_id_empleado FROM DUAL;
        
        INSERT INTO empleados VALUES (
            v_id_empleado, p_dni, p_nombre, p_apellido_paterno, p_apellido_materno,
            NULL, NULL, NULL, p_salario, SYSDATE, p_id_departamento, p_cargo, 'ACTIVO'
        );
        
        COMMIT;
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20013, 'DNI ya existe en el sistema');
    END sp_insertar_empleado;

    FUNCTION fn_calcular_antiguedad(p_id_empleado IN NUMBER) RETURN NUMBER IS
        v_fecha_contratacion DATE;
    BEGIN
        SELECT fecha_contratacion INTO v_fecha_contratacion
        FROM empleados WHERE id_empleado = p_id_empleado;
        
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_contratacion) / 12);
    END fn_calcular_antiguedad;

    FUNCTION fn_obtener_info_empleado(p_id_empleado IN NUMBER) RETURN VARCHAR2 IS
        v_info VARCHAR2(500);
    BEGIN
        SELECT nombre || ' ' || apellido_paterno || ' - ' || cargo || ' - S/' || salario
        INTO v_info
        FROM empleados 
        WHERE id_empleado = p_id_empleado;
        
        RETURN v_info;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'EMPLEADO NO ENCONTRADO';
    END fn_obtener_info_empleado;

END pkg_gestion_empleados;
/
