-- ======================================
-- VERIFICACION COMPLETA DE CONFIGURACION
-- ======================================

PROMPT === TABLESPACES CREADOS ===
SELECT tablespace_name, status, contents, logging
FROM dba_tablespaces
WHERE tablespace_name LIKE 'TS_EMPRESA%';

PROMPT === DATAFILES CREADOS ===
SELECT file_name, tablespace_name,
	ROUND(bytes/1024/1024,2) as size_mb,
	autoextensible,
	ROUND(maxbytes/1024/1024,2) as max_mb
FROM dba_data_files
WHERE tablespace_name LIKE 'TS_EMPRESA%';

PROMPT === PRIVILEGIOS DEL USUARIO ===
SELECT privilege, admin_option
FROM dba_sys_privs
WHERE grantee = 'ADMIN_EMPRESA'
UNION
SELECT privilege, admin_option
FROM dba_sys_privs
WHERE grantee IN (
	SELECT granted_role FROM dba_role_privs WHERE grantee = 'ADMIN_EMPRESA'
);

PROMPT === CUOTAS DE TABLESPACE ===
SELECT tablespace_name, username, bytes/1024/1024 as mb_used, max_bytes/1024/1024 as max_mb
FROM dba_ts_quotas
WHERE username = 'ADMIN_EMPRESA';

