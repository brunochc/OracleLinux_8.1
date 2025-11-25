-- =============================================
-- TABLA: CLIENTES
-- =============================================

PROMPT Creando tabla CLIENTES...
CREATE TABLE clientes (
    id_cliente         NUMBER        PRIMARY KEY,
    ruc                VARCHAR2(11)  UNIQUE,
    razon_social       VARCHAR2(200) NOT NULL,
    nombre_comercial   VARCHAR2(200),
    direccion          VARCHAR2(300),
    telefono           VARCHAR2(20),
    email              VARCHAR2(100),
    tipo_cliente       VARCHAR2(20)  DEFAULT 'NORMAL',
    fecha_registro     DATE          DEFAULT SYSDATE,
    vendedor_asignado  NUMBER,
    estado             VARCHAR2(20)  DEFAULT 'ACTIVO',
    limite_credito     NUMBER(12,2)  DEFAULT 0,
    
    CONSTRAINT fk_cli_vendedor FOREIGN KEY (vendedor_asignado) 
    REFERENCES empleados(id_empleado)
);

PROMPT Comentarios...
COMMENT ON TABLE clientes IS 'Tabla de clientes de la empresa';
COMMENT ON COLUMN clientes.ruc IS 'RUC del cliente (11 dígitos)';
COMMENT ON COLUMN clientes.razon_social IS 'Razón social legal del cliente';

PROMPT Secuencia...
CREATE SEQUENCE seq_clientes
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

PROMPT Índices...
CREATE INDEX idx_clientes_ruc ON clientes(ruc) TABLESPACE ts_empresa_idx;
CREATE INDEX idx_clientes_razon ON clientes(razon_social) TABLESPACE ts_empresa_idx;
CREATE INDEX idx_clientes_vendedor ON clientes(vendedor_asignado) TABLESPACE ts_empresa_idx;

PROMPT === VERIFICACIÓN ===
DESC clientes;
