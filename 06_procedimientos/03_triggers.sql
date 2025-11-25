-- =============================================
-- TRIGGERS PARA AUDITORÍA Y REGLAS DE NEGOCIO
-- =============================================

PROMPT Creando tabla de auditoría para empleados...
CREATE TABLE auditoria_empleados (
    id_auditoria      NUMBER PRIMARY KEY,
    id_empleado       NUMBER,
    accion           VARCHAR2(10),
    salario_anterior NUMBER,
    salario_nuevo    NUMBER,
    usuario          VARCHAR2(50),
    fecha_cambio     DATE DEFAULT SYSDATE,
    descripcion      VARCHAR2(200)
);

PROMPT Creando secuencia para auditoría...
CREATE SEQUENCE seq_auditoria_empleados START WITH 1 INCREMENT BY 1;

PROMPT Creando trigger: TRG_AUDITORIA_SALARIOS...
CREATE OR REPLACE TRIGGER trg_auditoria_salarios
    BEFORE UPDATE OF salario ON empleados
    FOR EACH ROW
BEGIN
    IF :OLD.salario != :NEW.salario THEN
        INSERT INTO auditoria_empleados (
            id_auditoria, id_empleado, accion, 
            salario_anterior, salario_nuevo, usuario, descripcion
        ) VALUES (
            seq_auditoria_empleados.NEXTVAL, :OLD.id_empleado, 'UPDATE',
            :OLD.salario, :NEW.salario, USER,
            'Cambio de salario: ' || :OLD.salario || ' -> ' || :NEW.salario
        );
    END IF;
END;
/

PROMPT Creando trigger: TRG_VALIDAR_DNI_EMPLEADO...
CREATE OR REPLACE TRIGGER trg_validar_dni_empleado
    BEFORE INSERT OR UPDATE ON empleados
    FOR EACH ROW
BEGIN
    -- Validar que el DNI tenga exactamente 8 dígitos
    IF LENGTH(:NEW.dni) != 8 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El DNI debe tener exactamente 8 dígitos');
    END IF;
    
    -- Validar que el DNI contenga solo números
    IF NOT REGEXP_LIKE(:NEW.dni, '^[0-9]+$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'El DNI debe contener solo números');
    END IF;
END;
/

PROMPT Creando trigger: TRG_ACTUALIZAR_FECHA_MODIFICACION...
CREATE OR REPLACE TRIGGER trg_actualizar_fecha_modificacion
    BEFORE UPDATE ON departamentos
    FOR EACH ROW
BEGIN
    -- Este trigger puede ser extendido para llevar control de modificaciones
    -- Por ahora solo como ejemplo
    IF :OLD.presupuesto_anual != :NEW.presupuesto_anual THEN
        DBMS_OUTPUT.PUT_LINE('Presupuesto modificado para departamento: ' || :OLD.nombre_depto);
    END IF;
END;
/
