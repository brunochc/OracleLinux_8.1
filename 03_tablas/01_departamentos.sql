-- ====================
-- TABLA: DEPARTAMENTOS
-- ====================

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
COMMENT ON COLUMN departamentos.id._departamento IS 'Identificador unico del departamento (PK)';
COMMENT ON COLUMN departamentos.nombre_depto IS 'Nombre oficial del departamento';
COMMENT ON COLUMN departamentos.presupuesto_anual IS 'Presupuesto anual asignado en pesos';

PROMPT Creando secuencia para ID automatico...
CREATE SEQUENCE seq_departamentos
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

