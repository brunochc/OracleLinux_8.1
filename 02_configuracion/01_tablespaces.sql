-- =============================================
-- CREACIÓN DE TABLESPACES PARA PROYECTO EMPRESA
-- =============================================

PROMPT Creando tablespace para datos...
CREATE TABLESPACE ts_empresa_datos
DATAFILE '/u01/app/oracle/oradata/ORCL/ts_empresa_datos01.dbf'
SIZE 200M
AUTOEXTEND ON NEXT 20M MAXSIZE 1G;

PROMPT Creando tablespace para índices...
CREATE TABLESPACE ts_empresa_idx
DATAFILE '/u01/app/oracle/oradata/ORCL/ts_empresa_idx01.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

PROMPT Creando tablespace temporal...
CREATE TEMPORARY TABLESPACE ts_empresa_temp
TEMPFILE '/u01/app/oracle/oradata/ORCL/ts_empresa_temp01.dbf'
SIZE 50M
AUTOEXTEND ON NEXT 5M MAXSIZE 200M;

PROMPT === VERIFICACIÓN DE TABLESPACES CREADOS ===
SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name LIKE 'TS_EMPRESA%';
