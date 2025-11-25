-- ===============================
-- CREACION DE USUARIO PROPIETARIO
-- ===============================

PROMPT Creando usuario admin_empresa...
CREATE USER admin_empresa
IDENTIFIED BY "Empresa2025"
DEFAULT TABLESPACE ts_empresa_datos
TEMPORARY TABLESPACE ts_empresa_temp
QUOTA UNLIMITED ON ts_empresa_datos
QUOTA UNLIMITED ON ts_empresa_idx;

PROMPT Asignando privilegios basicos...
GRANT CONNECT, RESOURCE TO admin_empresa;

PROMPT Asignando privilegios adicionales...
GRANT CREATE SESSION, CREATE VIEW, CREATE PROCEDURE TO admin_empresa;
GRANT CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER TO admin_empresa;

PROMPT Permisos para consultas del diccionario...
GRANT SELECT ANY DICTIONARY TO admin_empresa;

PROMPT === VERIFICION DE USUARIO CREADO ===
SELECT username, account_status, default_tablespace, temporary_tablespace, created
FROM dba_users
WHERE username = 'ADMIN_EMPRESA';
