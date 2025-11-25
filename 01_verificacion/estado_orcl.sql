-- ============================================
-- VERIFICACION COMPLETA DEL ESTADO ORACLE ORCL
-- =============================================


PROMPT === INFORMACION DE LA BASE DE DATOS ===
SELECT name, dbid, created, log_mode, open_mode
FROM v$instance;

PROMPT === ESTADO DE LA INSTANCIA ===
SELECT instance_name, status, database_status, host_name
FROM v$instance;

PROMPT === TABLESPACES EXISTENTES ===
SELECT tablespace_name, status, contents, extent_management
FROM dba_tablespaces
ORDER BY tablespace_name;

PROMPT === ESPACIO EN TABLESPACES ===
SELECT tablespace_name,
	ROUND(SUM(bytes)/1024/1024,2) as size_mb,
	ROUND(SUM(maxbytes)/1024/1024,2) as max_size_mb
FROM dba_dba_files
GROUP BY tablespace_name;

PROMPT === USUARIOS DEL SISTEMA ===
SELECT username, account_status, created, default_tablespace
FROM dba_users
WHERE username IN ('SYS', 'SYSTEM', 'DBSNMP')
ORDER BY username;

PROMPT === PARAMETROS IMPORTANTES ===
SELECT name, value, description
FROM v$parameter
WHERE name IN ('db_block_size', 'sga_target', 'pga_aggregate_target');
