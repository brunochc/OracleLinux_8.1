-- =============================================
-- TABLA: DEPARTAMENTOS
-- =============================================

PROMPT Creando tabla DEPARTAMENTOS...
CREATE TABLE departamentos (
    id_departamento    NUMBER        PRIMARY KEY,
    nombre_depto       VARCHAR2(50)  NOT NULL,
    ubicacion          VARCHAR2(100),
    presupuesto_anual  NUMBER(15,2)  DEFAULT 0,
    fecha_creacion     DATE          DEFAULT SYSDATE,
    jefe_departamento  VARCHAR2(100),
    estado             VARCHAR2(20)  DEFAULT 'ACTIVO',
    email_departamento VARCHAR2(100),
    telefono           VARCHAR2(20)
);

PROMPT Agregando comentarios...
COMMENT ON TABLE departamentos IS 'Tabla maestra de departamentos de la empresa';
COMMENT ON COLUMN departamentos.id_departamento IS 'Identificador único del departamento (PK)';
COMMENT ON COLUMN departamentos.nombre_depto IS 'Nombre oficial del departamento';
COMMENT ON COLUMN departamentos.presupuesto_anual IS 'Presupuesto anual asignado en soles';

PROMPT Creando secuencia para ID automático...
CREATE SEQUENCE seq_departamentos
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

PROMPT Creando índice para búsquedas por nombre...
CREATE INDEX idx_departamentos_nombre ON departamentos(nombre_depto) 
TABLESPACE ts_empresa_idx;

PROMPT === VERIFICACIÓN TABLA CREADA ===
DESC departamentos;
