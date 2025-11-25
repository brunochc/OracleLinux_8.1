-- =============================================
-- VERIFICACIÓN DE ESPACIO EN DISCO
-- =============================================

PROMPT === ESPACIO EN DATAFILES ===
SELECT tablespace_name,
       file_name,
       ROUND(bytes/1024/1024,2) as size_mb,
       ROUND(maxbytes/1024/1024,2) as max_mb,
       autoextensible
FROM dba_data_files
ORDER BY tablespace_name, file_name;

PROMPT === ESPACIO LIBRE EN TABLESPACES ===
SELECT tablespace_name,
       ROUND(SUM(bytes)/1024/1024,2) as total_mb,
       ROUND(SUM(NVL(maxbytes,bytes))/1024/1024,2) as max_total_mb,
       ROUND((SUM(NVL(maxbytes,bytes)) - SUM(bytes))/1024/1024,2) as free_mb
FROM dba_data_files
GROUP BY tablespace_name
ORDER BY tablespace_name;

PROMPT === USO DE ESPACIO POR OBJETOS ===
SELECT owner, segment_name, segment_type,
       ROUND(bytes/1024/1024,2) as size_mb,
       tablespace_name
FROM dba_segments
WHERE owner = 'ADMIN_EMPRESA'
ORDER BY bytes DESC;
