-- =============================================
-- TABLA: EMPLEADOS
-- =============================================

PROMPT Creando tabla EMPLEADOS...
CREATE TABLE empleados (
    id_empleado        NUMBER        PRIMARY KEY,
    dni                VARCHAR2(8)   UNIQUE NOT NULL,
    nombre             VARCHAR2(50)  NOT NULL,
    apellido_paterno   VARCHAR2(50)  NOT NULL,
    apellido_materno   VARCHAR2(50),
    fecha_nacimiento   DATE,
    genero             VARCHAR2(1)   CHECK (genero IN ('M', 'F')),
    email              VARCHAR2(100) UNIQUE,
    telefono           VARCHAR2(20),
    salario            NUMBER(10,2)  CHECK (salario > 0),
    fecha_contratacion DATE          DEFAULT SYSDATE,
    id_departamento    NUMBER,
    cargo              VARCHAR2(50),
    estado             VARCHAR2(20)  DEFAULT 'ACTIVO',
    
    CONSTRAINT fk_emp_depto FOREIGN KEY (id_departamento) 
    REFERENCES departamentos(id_departamento)
);

PROMPT Comentarios de tabla...
COMMENT ON TABLE empleados IS 'Tabla de empleados de la empresa';
COMMENT ON COLUMN empleados.dni IS 'DNI del empleado (8 dígitos, único)';
COMMENT ON COLUMN empleados.salario IS 'Salario mensual en soles';

PROMPT Creando secuencia...
CREATE SEQUENCE seq_empleados
START WITH 1001
INCREMENT BY 1
NOCACHE
NOCYCLE;

PROMPT Creando índices...
CREATE INDEX idx_empleados_nombre ON empleados(nombre, apellido_paterno) 
TABLESPACE ts_empresa_idx;

CREATE INDEX idx_empleados_depto ON empleados(id_departamento) 
TABLESPACE ts_empresa_idx;

PROMPT === VERIFICACIÓN ===
DESC empleados;
