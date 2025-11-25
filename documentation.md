# Guía de Instalación de Oracle Database 19c en Oracle Linux 8.10

## Índice

1. [Introducción](#introducción)
2. [Preparación del Entorno](#preparación-del-entorno)
   - [Instalación de Oracle Linux 8.10](#instalación-de-oracle-linux-810)
   - [Configuración de la Máquina Virtual](#configuración-de-la-máquina-virtual)
3. [Configuración Inicial del Sistema](#configuración-inicial-del-sistema)
   - [Actualización del Sistema](#actualización-del-sistema)
   - [Instalación de Paquetes Necesarios](#instalación-de-paquetes-necesarios)
   - [Verificación de Usuarios y Grupos](#verificación-de-usuarios-y-grupos)
4. [Configuración de Directorios Oracle](#configuración-de-directorios-oracle)
5. [Configuración de Variables de Entorno](#configuración-de-variables-de-entorno)
6. [Configuración de Límites del Sistema](#configuración-de-límites-del-sistema)
7. [Instalación del Software Oracle Database 19c](#instalación-del-software-oracle-database-19c)
   - [Descarga del Software](#descarga-del-software)
   - [Preparación de Archivos](#preparación-de-archivos)
   - [Instalación Silenciosa](#instalación-silenciosa)
   - [Scripts Post-Instalación](#scripts-post-instalación)
8. [Creación de la Base de Datos](#creación-de-la-base-de-datos)
   - [Preparación de Directorios](#preparación-de-directorios)
   - [Ejecución de DBCA](#ejecución-de-dbca)
   - [Verificación de la Instalación](#verificación-de-la-instalación)
9. [Estructura de Archivos Creados](#estructura-de-archivos-creados)
10. [Inicio de la Base de Datos](#inicio-de-la-base-de-datos)

---

## Introducción

Este documento describe el proceso completo de instalación y configuración de **Oracle Database 19c Enterprise Edition** en **Oracle Linux 8.10**, utilizando una máquina virtual con **QEMU/KVM** sobre un sistema host **Ubuntu 24.04 LTS**.

### Objetivo

Proporcionar una guía paso a paso para configurar un entorno de desarrollo y aprendizaje de Oracle Database, optimizado para el estudio y la práctica profesional.

### Ventajas de Oracle Linux para Oracle Database

Oracle Linux ofrece ventajas exclusivas para ejecutar Oracle Database:

- **Optimización específica** para Oracle DB
- **Smart Flash Cache** (exclusivo de Oracle Linux)
- **UEK (Unbreakable Enterprise Kernel)** con mejoras de rendimiento
- **Soporte para alta disponibilidad** (Oracle Clusterware)
- **Zero downtime patching** con Ksplice
- **Integración directa** con el stack completo de Oracle

---

## Preparación del Entorno

### Instalación de Oracle Linux 8.10

#### Descarga de la ISO

1. Acceder al sitio oficial de Oracle:
   ```
   https://yum.oracle.com/oracle-linux-isos.html
   ```

2. Descargar la siguiente imagen ISO:
   ```
   OracleLinux-R8-U10-x86_64-dvd.iso
   ```

### Configuración de la Máquina Virtual

#### Especificaciones Recomendadas

Para un equipo con **12 GB de RAM**, se recomienda la siguiente configuración:

| Componente | Especificación |
|------------|----------------|
| **CPU** | 2-4 vCPUs |
| **RAM** | 6-8 GB |
| **Disco** | 60-100 GB (formato qcow2) |
| **Red** | VirtIO |
| **Almacenamiento** | VirtIO |
| **Gráficos** | QXL o Virtio-GPU |
| **Firmware** | BIOS (no UEFI para Oracle 19c) |

#### Creación de la VM en virt-manager

1. Abrir **Virtual Machine Manager**
2. Hacer clic en **Create a New Virtual Machine**
3. Seleccionar: **Local install media (ISO)**
4. Seleccionar la ISO descargada
5. El sistema detectará automáticamente **"Oracle Linux"**
6. Asignar CPU y RAM según las especificaciones
7. Crear un disco de 60-100 GB
8. Finalizar la configuración

#### Configuración del Usuario

Durante la instalación, crear un usuario con **permisos de sudo** (administrador).

---

## Configuración Inicial del Sistema

### Actualización del Sistema

Una vez completada la instalación de Oracle Linux, ejecutar:

```bash
sudo dnf update -y
```

> **Nota:** Verificar la conexión a Internet, ya que este comando descarga recursos externos.

### Habilitar Repositorios Oficiales

```bash
sudo dnf config-manager --set-enabled ol8_baseos_latest ol8_appstream ol8_addons
```

### Instalación de Paquetes Necesarios

Instalar el paquete de preinstalación de Oracle Database 19c:

```bash
sudo dnf install -y oracle-database-preinstall-19c
```

> **Importante:** Este paquete configura automáticamente usuarios, grupos y parámetros del kernel necesarios para Oracle Database.

### Verificación de Usuarios y Grupos

Verificar que los grupos y usuarios se crearon correctamente:

```bash
# Verificar grupos
getent group oinstall
getent group dba
getent group oper

# Verificar usuario oracle
id oracle
```

**Salida esperada:**
- Grupo `oinstall` creado
- Grupo `dba` creado
- Grupo `oper` creado
- Usuario `oracle` creado y asignado a los grupos correspondientes

---

## Configuración de Directorios Oracle

### Crear Estructura de Directorios

```bash
# Crear directorios principales de Oracle
sudo mkdir -p /u01/app/oracle/product/19.3.0/dbhome_1
sudo mkdir -p /u01/app/oracle/oradata
sudo mkdir -p /u01/app/oracle/fast_recovery_area
sudo mkdir -p /u01/app/oracle/admin/ORCLCDB/adump

# Asignar propietarios y permisos
sudo chown -R oracle:oinstall /u01
sudo chmod -R 755 /u01

# Verificar la estructura
ls -la /u01/app/oracle/
```

### Descripción de Directorios

| Directorio | Propósito |
|------------|-----------|
| `/u01/app/oracle/product/19.3.0/dbhome_1` | Binarios y librerías de Oracle Database |
| `/u01/app/oracle/oradata` | Archivos de datos de la base de datos |
| `/u01/app/oracle/fast_recovery_area` | Área de recuperación rápida (backups) |
| `/u01/app/oracle/admin/ORCLCDB/adump` | Archivos de auditoría |

---

## Configuración de Variables de Entorno

### Variables de Entorno del Sistema

Crear archivo de perfil para todos los usuarios:

```bash
sudo tee /etc/profile.d/oracle.sh << 'EOF'
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
EOF

# Cargar variables en la sesión actual
source /etc/profile.d/oracle.sh
```

### Variables de Entorno del Usuario Oracle

Crear archivo de perfil específico para el usuario `oracle`:

```bash
sudo -u oracle tee /home/oracle/.bash_profile << 'EOF'
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
EOF
```

### Explicación de Variables de Entorno

| Variable | Descripción |
|----------|-------------|
| `ORACLE_BASE` | Directorio base donde se instalan todos los componentes de Oracle |
| `ORACLE_HOME` | Ubicación exacta de los binarios y librerías de Oracle Database |
| `ORACLE_SID` | Nombre de la instancia de base de datos |
| `PATH` | Agrega los binarios de Oracle al PATH del sistema para ejecutar comandos como `sqlplus` |
| `LD_LIBRARY_PATH` | Define dónde buscar librerías compartidas (.so files) |

### ¿Por Qué Dos Archivos Diferentes?

#### `/etc/profile.d/oracle.sh` (Para todos los usuarios)

- **Propósito:** Hace las variables disponibles para TODOS los usuarios del sistema
- **Cuándo se carga:** Al iniciar sesión cualquier usuario
- **Ventaja:** Si otros usuarios necesitan acceder a Oracle, ya tienen las variables configuradas

#### `/home/oracle/.bash_profile` (Solo para usuario oracle)

- **Propósito:** Configuración específica para el usuario `oracle`
- **Cuándo se carga:** Solo cuando el usuario `oracle` inicia sesión
- **Ventaja:** Configuración personalizada y segura para el usuario de la base de datos

---

## Configuración de Límites del Sistema

### Configurar Límites del Kernel

```bash
sudo tee -a /etc/sysctl.conf << 'EOF'
# Oracle 19c recommended settings
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 4294967295
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
EOF

# Aplicar los cambios del kernel
sudo sysctl -p
```

### Configurar Límites de Usuario

```bash
sudo tee -a /etc/security/limits.conf << 'EOF'
# Oracle settings
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack 10240
oracle hard stack 32768
EOF
```

### Explicación de Límites del Kernel

#### Memoria Compartida (Shared Memory)

```bash
kernel.shmall = 2097152        # Total de páginas de memoria compartida
kernel.shmmax = 4294967295     # Tamaño máximo de segmento de memoria (4GB)
kernel.shmmni = 4096           # Número máximo de segmentos de memoria
```

**Propósito:** Oracle usa memoria compartida para el SGA (System Global Area), donde la base de datos carga datos en memoria para acceso rápido.

#### Semáforos

```bash
kernel.sem = 250 32000 100 128
```

**Formato:** `semmsl semmns semopm semmni`

**Propósito:** Controla el acceso concurrente a recursos compartidos. Oracle los usa para controlar procesos que acceden a los mismos datos.

#### Archivos y I/O

```bash
fs.aio-max-nr = 1048576        # Número máximo de operaciones I/O asíncronas
fs.file-max = 6815744          # Número máximo de archivos abiertos en el sistema
```

**Propósito:** Oracle realiza muchas operaciones de I/O simultáneas y mantiene muchos archivos abiertos (datafiles, logs, etc.).

#### Red

```bash
net.ipv4.ip_local_port_range = 9000 65500    # Rango de puertos para conexiones
net.core.rmem_default = 262144              # Buffer de recepción por defecto
net.core.rmem_max = 4194304                 # Buffer máximo de recepción
net.core.wmem_default = 262144              # Buffer de envío por defecto
net.core.wmem_max = 1048576                 # Buffer máximo de envío
```

**Propósito:** Optimiza la comunicación de red para conexiones de base de datos. Oracle tiene muchos procesos que se comunican entre sí y con clientes.

### Explicación de Límites de Usuario

#### Número de Procesos

```bash
oracle soft nproc 2047         # Límite flexible de procesos
oracle hard nproc 16384        # Límite máximo estricto de procesos
```

**Propósito:** Controla cuántos procesos puede crear el usuario Oracle. Oracle DB ejecuta muchos procesos en segundo plano (PMON, SMON, LGWR, etc.).

#### Archivos Abiertos

```bash
oracle soft nofile 1024        # Límite flexible de archivos abiertos
oracle hard nofile 65536       # Límite máximo estricto de archivos
```

**Propósito:** Controla cuántos archivos puede tener abiertos simultáneamente. Oracle mantiene muchos datafiles, logfiles y archivos de control abiertos.

#### Tamaño de Stack

```bash
oracle soft stack 10240        # Límite flexible de stack memory (KB)
oracle hard stack 32768        # Límite máximo estricto de stack (KB)
```

**Propósito:** Controla la memoria de stack para cada proceso. Los procesos de Oracle necesitan suficiente stack para ejecutar correctamente.

### ¿Por Qué se Necesitan Estos Límites?

#### Sin estos límites:

- ❌ Oracle no puede asignar suficiente memoria
- ❌ Los procesos se bloquean por falta de recursos
- ❌ La base de datos no inicia o funciona mal
- ❌ Conexiones fallan aleatoriamente

#### Con estos límites:

- ✅ Oracle puede usar la memoria que necesita
- ✅ Múltiples procesos funcionan simultáneamente
- ✅ La base de datos inicia y corre establemente
- ✅ Conexiones de clientes funcionan correctamente

### Verificación de Límites

```bash
# Verificar límites del kernel
sysctl -a | grep shm
sysctl -a | grep file-max

# Verificar límites del usuario oracle
sudo -u oracle bash -c 'ulimit -a'
```

---

## Instalación del Software Oracle Database 19c

### Descarga del Software

1. Acceder al sitio oficial de Oracle:
   ```
   https://www.oracle.com/es/database/technologies/oracle19c-linux-downloads.html
   ```

2. Descargar el archivo:
   ```
   LINUX.X64_193000_db_home.zip
   ```

### Preparación de Archivos

#### Mover el Archivo al Directorio Oracle

```bash
sudo mv ~/Downloads/LINUX.X64_193000_db_home.zip /u01/app/oracle/product/19.3.0/dbhome_1/
sudo chown oracle:oinstall /u01/app/oracle/product/19.3.0/dbhome_1/LINUX.X64_193000_db_home.zip
```

> **Nota:** Este comando mueve el archivo desde la carpeta Downloads y ajusta la propiedad para que el usuario `oracle` y el grupo `oinstall` tengan acceso.

#### Descomprimir el Archivo

```bash
sudo -u oracle unzip /u01/app/oracle/product/19.3.0/dbhome_1/LINUX.X64_193000_db_home.zip -d /u01/app/oracle/product/19.3.0/dbhome_1/
```

### Instalación Silenciosa

#### Crear Response File

Crear un archivo de respuesta válido para la instalación silenciosa:

```bash
cat > /home/oracle/db_install.rsp << 'EOF'
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1
ORACLE_BASE=/u01/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.CLUSTER_NODES=
oracle.install.db.isRACOneInstall=false
oracle.install.db.rac.serverpoolCardinality=0
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=orcl
oracle.install.db.config.starterdb.SID=orcl
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=true
oracle.install.db.config.starterdb.memoryLimit=8192
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=/u01/app/oracle/oradata
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=/u01/app/oracle/fast_recovery_area
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
EOF
```

#### Configurar Bypass para Verificación del SO

```bash
export CV_ASSUME_DISTID=OEL8
```

> **Nota:** Oracle 19c no reconoce oficialmente Oracle Linux 8.10, por lo que se requiere este bypass.

#### Ejecutar el Instalador

```bash
su - oracle
cd /u01/app/oracle/product/19.3.0/dbhome_1
./runInstaller -silent -responseFile /home/oracle/db_install.rsp -ignorePrereqFailure -waitforcompletion
```

**Parámetros del instalador:**

- `-silent`: Modo no interactivo
- `-responseFile`: Archivo de respuesta con la configuración
- `-ignorePrereqFailure`: Ignora fallos de prerequisitos (necesario para Oracle Linux 8.10)
- `-waitforcompletion`: Espera a que la instalación complete

### Scripts Post-Instalación

Una vez completada la instalación, ejecutar los siguientes scripts como usuario **root**:

```bash
# Script 1: Configuración del inventario
/u01/app/oraInventory/orainstRoot.sh

# Script 2: Configuración de Oracle Home
/u01/app/oracle/product/19.3.0/dbhome_1/root.sh
```

### Actualizar Variables de Entorno

Editar `/home/oracle/.bash_profile` para actualizar el `ORACLE_SID`:

```bash
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1
export ORACLE_SID=orcl  # Cambiado de ORCLCDB a orcl
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
```

### Estado de la Instalación

Al finalizar esta fase:

- ✅ Software instalado: Oracle Database 19c Enterprise Edition
- ✅ Estructura de directorios: Configurada correctamente
- ✅ Variables de entorno: Configuradas y funcionando
- ✅ Conexión SQL*Plus: Funcionando (`sqlplus / as sysdba` conecta a instancia idle)

> **Importante:** La instalación fue de tipo `INSTALL_DB_SWONLY` (solo software), por lo que aún falta crear la base de datos usando DBCA.

---

## Creación de la Base de Datos

### Preparación de Directorios

Antes de crear la base de datos, es necesario crear la estructura de directorios específica:

```bash
# Crear estructura completa para la base de datos 'orcl'
mkdir -p /u01/app/oracle/oradata/orcl
mkdir -p /u01/app/oracle/fast_recovery_area/orcl
mkdir -p /u01/app/oracle/admin/orcl/adump
mkdir -p /u01/app/oracle/admin/orcl/dpdump
mkdir -p /u01/app/oracle/admin/orcl/pfile

# Verificar que se crearon correctamente
ls -la /u01/app/oracle/oradata/
ls -la /u01/app/oracle/admin/
```

### Ejecución de DBCA

#### Comando Completo

```bash
dbca -silent -createDatabase \
 -templateName General_Purpose.dbc \
 -gdbname orcl -sid orcl \
 -sysPassword oracle \
 -systemPassword oracle \
 -characterSet AL32UTF8 \
 -createAsContainerDatabase false \
 -databaseType MULTIPURPOSE \
 -memoryPercentage 40 \
 -storageType FS \
 -datafileDestination /u01/app/oracle/oradata \
 -recoveryAreaDestination /u01/app/oracle/fast_recovery_area \
 -enableArchive false
```

#### Explicación Detallada de Parámetros

| Parámetro | Descripción |
|-----------|-------------|
| `dbca -silent -createDatabase` | Database Configuration Assistant en modo no interactivo |
| `-templateName General_Purpose.dbc` | Plantilla de configuración predefinida para uso general |
| `-gdbname orcl` | Global Database Name (nombre único en red) |
| `-sid orcl` | System Identifier (identificador de instancia) |
| `-sysPassword oracle` | Contraseña para el usuario SYS (superusuario) |
| `-systemPassword oracle` | Contraseña para el usuario SYSTEM (administrador) |
| `-characterSet AL32UTF8` | Juego de caracteres Unicode UTF-8 (internacionalización completa) |
| `-createAsContainerDatabase false` | Base de datos NO contenedora (arquitectura tradicional) |
| `-databaseType MULTIPURPOSE` | Optimizado para cargas mixtas (OLTP + Data Warehouse) |
| `-memoryPercentage 40` | 40% de RAM total asignada a Oracle (SGA + PGA) |
| `-storageType FS` | Almacenamiento en File System (sistema de archivos estándar) |
| `-datafileDestination` | Ubicación de archivos de datos (.dbf, control files, redo logs) |
| `-recoveryAreaDestination` | Fast Recovery Area para backups y recuperación |
| `-enableArchive false` | Modo NOARCHIVELOG (no guarda redo logs archivados) |

> **Nota para Producción:** Para ambientes de producción, cambiar `-enableArchive` a `true` para habilitar ARCHIVELOG mode.

#### Progreso de la Creación

Durante la ejecución, DBCA mostrará el siguiente progreso:

```
10%  - Prepare for db operation
40%  - Copying database files
42%  - Creating and starting Oracle instance
66%  - Completing Database Creation
100% - Database creation complete
```

### Verificación de la Instalación

#### Conexión a la Base de Datos

```bash
# Opción 1: Autenticación del sistema operativo
sqlplus / as sysdba

# Opción 2: Autenticación con contraseña
sqlplus sys/oracle as sysdba
```

#### Usuarios Creados

| Usuario | Contraseña | Privilegios | Uso Recomendado |
|---------|------------|-------------|-----------------|
| **SYS** | oracle | SYSDBA (máximos) | Solo mantenimiento del sistema |
| **SYSTEM** | oracle | DBA (administrativos) | Trabajo diario y administración |

---

## Estructura de Archivos Creados

### Datos de la Base de Datos

```
/u01/app/oracle/oradata/orcl/
├── control01.ctl, control02.ctl    # Archivos de control
├── redo01.log, redo02.log, redo03.log  # Redo logs
├── system01.dbf    # Tablespace SYSTEM
├── sysaux01.dbf    # Tablespace SYSAUX  
├── undotbs01.dbf   # Tablespace UNDO
├── temp01.dbf      # Tablespace TEMPORARY
└── users01.dbf     # Tablespace USERS
```

### Archivos de Configuración

```
/u01/app/oracle/product/19.3.0/dbhome_1/dbs/
├── spfileorcl.ora  # Server Parameter File
└── orapworcl       # Password file
```

### Archivos Administrativos

```
/u01/app/oracle/admin/orcl/
├── adump/          # Audit files
├── dpdump/         # Data Pump files
└── pfile/          # Parameter files
```

### Logs de Instalación

**Ubicación:** `/u01/app/oracle/cfgtoollogs/dbca/orcl/orcl.log`

**Contenido:** Detalle completo del proceso de creación de la base de datos.

---

## Inicio de la Base de Datos

### Iniciar Sesión en SQL*Plus

```bash
sqlplus / as sysdba
```

### Iniciar la Base de Datos

```sql
SQL> STARTUP
```

**Salida esperada:**

```
ORACLE instance started.

Total System Global Area  xxxxxxxx bytes
Fixed Size                  xxxxxxx bytes
Variable Size             xxxxxxxx bytes
Database Buffers          xxxxxxxx bytes
Redo Buffers                xxxxxx bytes
Database mounted.
Database opened.
```

### Verificar Estado de la Base de Datos

```sql
SQL> SELECT status FROM v$instance;

STATUS
------------
OPEN
```

### Comandos Útiles de Administración

```sql
-- Ver información de la instancia
SELECT instance_name, status, database_status FROM v$instance;

-- Ver tablespaces
SELECT tablespace_name, status FROM dba_tablespaces;

-- Ver archivos de datos
SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb FROM dba_data_files;

-- Apagar la base de datos
SHUTDOWN IMMEDIATE;

-- Iniciar en modo MOUNT (sin abrir)
STARTUP MOUNT;

-- Abrir la base de datos
ALTER DATABASE OPEN;
```

---

## Resumen de la Instalación

### Estado Final del Sistema

- ✅ **Sistema Operativo:** Oracle Linux 8.10 en máquina virtual QEMU/KVM
- ✅ **Software Oracle:** Oracle Database 19c Enterprise Edition instalado
- ✅ **Base de Datos:** Base de datos `orcl` creada y funcional
- ✅ **Usuarios:** SYS y SYSTEM configurados
- ✅ **Estructura de directorios:** Completa y con permisos correctos
- ✅ **Variables de entorno:** Configuradas para todos los usuarios
- ✅ **Límites del sistema:** Optimizados para Oracle Database
- ✅ **SQL*Plus:** Funcionando correctamente

### Próximos Pasos Recomendados

1. **Configurar backups automáticos** con RMAN
2. **Crear usuarios de aplicación** con privilegios limitados
3. **Configurar Oracle Enterprise Manager** para administración gráfica
4. **Habilitar ARCHIVELOG mode** para ambientes de producción
5. **Implementar estrategia de monitoreo** y alertas
6. **Configurar Oracle Net Services** para conexiones remotas

---

## Notas Adicionales

### Solución de Problemas Comunes

#### Error: "ORA-01034: ORACLE not available"

**Solución:** La instancia no está iniciada. Ejecutar `STARTUP` en SQL*Plus.

#### Error: "ORA-12162: TNS:net service name is incorrectly specified"

**Solución:** Verificar que `ORACLE_SID` esté correctamente configurado en las variables de entorno.

#### Error: Instalador no reconoce Oracle Linux 8.10

**Solución:** Usar `export CV_ASSUME_DISTID=OEL8` antes de ejecutar el instalador.

### Referencias

- [Documentación oficial de Oracle Database 19c](https://docs.oracle.com/en/database/oracle/oracle-database/19/)
- [Oracle Linux Documentation](https://docs.oracle.com/en/operating-systems/oracle-linux/)
- [Oracle Database Installation Guide](https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/)

---

**Documento creado para referencia personal del proceso de instalación de Oracle Database 19c en Oracle Linux 8.10**

*Última actualización: 2025-11-22*

---

## Monitoreo y Administración del Sistema

### Análisis de Espacio en Disco

#### Verificación del Sistema de Archivos

Para monitorear el espacio disponible en el sistema, ejecutar:

```bash
df -h /
```

**Salida esperada:**

```
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/ol-root   37G   21G   17G  55% /
```

#### Interpretación de Resultados

| Componente | Valor | Explicación |
|------------|-------|-------------|
| **Filesystem** | `/dev/mapper/ol-root` | Sistema de archivos usando LVM (Logical Volume Manager) |
| **Size** | 37G | Capacidad total del filesystem: 37 Gigabytes |
| **Used** | 21G | Espacio utilizado: 21 GB (56% del total) |
| **Avail** | 17G | Espacio disponible: 17 GB (44% del total) |
| **Use%** | 55% | Porcentaje de uso actual |
| **Mounted on** | `/` | Punto de montaje: Directorio raíz del sistema |

**Estado del sistema:**
- ✅ **Estable:** 55% de uso está dentro de límites seguros
- ✅ **Margen de seguridad:** 17GB libres para crecimiento
- ⚠️ **Alerta crítica:** Se recomienda acción cuando supere 80% (≈ 7GB libres)

---

### Análisis de Directorios Oracle

#### Comando de Verificación

```bash
du -sh /u01/app/oracle/* | sort -rh
```

**Salida esperada:**

```
9.9G    /u01/app/oracle/product
2.4G    /u01/app/oracle/oradata
28M     /u01/app/oracle/cfgtoollogs
11M     /u01/app/oracle/fast_recovery_area
9.6M    /u01/app/oracle/admin
5.7M    /u01/app/oracle/diag
0       /u01/app/oracle/checkpoints
0       /u01/app/oracle/audit
```

#### Desglose por Directorio

##### `/u01/app/oracle/product` - 9.9GB

- **Propósito:** Binarios y archivos de instalación de Oracle Database
- **Contiene:** Ejecutables, librerías, software de Oracle
- **Comportamiento:** Tamaño fijo - no crece después de la instalación
- **Importancia:** ❗ **CRÍTICO** - sin esto, Oracle no funciona

##### `/u01/app/oracle/oradata` - 2.4GB

- **Propósito:** Archivos de datos de la base de datos
- **Contiene:**
  - Datafiles (.dbf) - datos de tablas, índices
  - Control files - estructura de la BD
  - Redo logs - transacciones
- **Comportamiento:** **CRECIMIENTO CONTINUO** - según se insertan datos
- **Importancia:** ❗ **CRÍTICO** - aquí están los datos reales

##### `/u01/app/oracle/cfgtoollogs` - 28MB

- **Propósito:** Logs de configuración y herramientas Oracle
- **Contiene:** Logs de instalación, parches, operaciones de configuración
- **Comportamiento:** Crecimiento lento y estable
- **Importancia:** ⚠️ **MEDIO** - importante para troubleshooting

##### `/u01/app/oracle/fast_recovery_area` - 11MB

- **Propósito:** Área de recuperación rápida (FRA)
- **Contiene:**
  - Backups automáticos de control files
  - Archived redo logs
  - Flashback logs
- **Comportamiento:** Puede crecer según configuración de backups
- **Importancia:** 🚨 **MUY CRÍTICO** - esencial para recuperación

---

### Resumen del Estado del Sistema

#### Aspectos Positivos

- ✅ Filesystem principal con 55% de uso (dentro de márgenes seguros)
- ✅ Binarios Oracle estables (9.9GB - tamaño fijo)
- ✅ Base de datos de tamaño moderado (2.4GB)
- ✅ FRA configurado correctamente

#### Monitoreo Recomendado

**Comandos de monitoreo diario/semanal:**

```bash
# 1. Ver espacio general (DIARIO)
df -h

# 2. Ver qué ocupa espacio en Oracle (SEMANAL)  
du -sh /u01/app/oracle/* | sort -rh

# 3. Ver espacio del FRA específicamente (DIARIO)
du -sh /u01/app/oracle/fast_recovery_area/*
```

**Comandos de limpieza periódica:**

```bash
# Limpiar logs antiguos (SEMANAL)
find /u01/app/oracle/diag -name "*.tr*" -mtime +7 -delete

# Ver los archived logs más grandes
find /u01/app/oracle/fast_recovery_area -name "*.arc" -exec ls -lh {} \; | sort -k5 -rh
```

---

### Verificación del Fast Recovery Area (FRA)

#### Análisis del Contenido del FRA

```bash
du -sh /u01/app/oracle/fast_recovery_area/ORCL/*
```

**Salida esperada:**

```
0       /u01/app/oracle/fast_recovery_area/ORCL/archivelog
11M     /u01/app/oracle/fast_recovery_area/ORCL/control02.ctl
0       /u01/app/oracle/fast_recovery_area/ORCL/onlinelog
```

#### Explicación de los Componentes

| Componente | Tamaño | Descripción |
|------------|--------|-------------|
| `control02.ctl` | 11MB | Control file de la base de datos (archivo crítico de respaldo) |
| `archivelog/` | 0 bytes | Directorio para archived logs (vacío - modo NOARCHIVELOG activo) |
| `onlinelog/` | 0 bytes | Directorio para online redo logs (vacío) |

> **Importante:** Los 11MB son del control file (archivo necesario). No hay archived logs acumulándose porque la base de datos está en modo NOARCHIVELOG.

---

## Comandos de Acceso a Oracle

### Herramientas Disponibles

#### SQL*Plus (Administración General)

```bash
sqlplus / as sysdba
```

**Uso recomendado:**
- Ejecutar comandos SQL y DDL
- Consultas a la base de datos
- Gestión de parámetros
- Administración de usuarios y privilegios

#### RMAN (Backup y Recovery)

```bash
rman target /
```

**Uso recomendado:**
- Backup de la base de datos
- Restore y recovery
- Gestión de archived logs
- Mantenimiento del FRA

### Resumen de Herramientas

| Comando | Prompt | Uso Principal |
|---------|--------|---------------|
| `sqlplus / as sysdba` | `SQL>` | Consultas, crear tablas, parámetros, usuarios |
| `rman target /` | `RMAN>` | Backups, recovery, archived logs, restore |

---

## Configuración de Control Files

### Verificación de Control Files

```sql
SQL> SHOW PARAMETER CONTROL_FILES;
```

**Salida esperada:**

```
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
control_files                        string      /u01/app/oracle/oradata/ORCL/control01.ctl
                                                 /u01/app/oracle/fast_recovery_area/ORCL/control02.ctl
```

### Análisis de la Configuración

#### Configuración Actual

- **Número de control files:** 2 (multiplexados)
- **Ubicación 1:** `/u01/app/oracle/oradata/ORCL/control01.ctl` (PRIMARIO)
- **Ubicación 2:** `/u01/app/oracle/fast_recovery_area/ORCL/control02.ctl` (COPIA DE RESPALDO)

#### ¿Qué son los Control Files?

Los control files son archivos binarios críticos que contienen:

- Estructura física de la base de datos
- Ubicación de datafiles, redo logs y otros componentes
- Información de sincronización y checkpoint
- Metadata esencial para el funcionamiento de Oracle

> **Crítico:** Sin control files, Oracle no puede abrir la base de datos.

#### ¿Por Qué Hay 2 Control Files?

**Razón: Redundancia y Seguridad**

- Si un disco falla, existe una copia en otra ubicación
- Buenas prácticas de Oracle: siempre multiplexar control files
- El segundo en el FRA es una ubicación estándar recomendada por Oracle

### Estado de la Configuración

#### Verificación de Buenas Prácticas

- ✅ Control files multiplexados (2 copias)
- ✅ Una copia en el FRA (buena práctica)
- ✅ Espacio usado es normal (11MB por control file)
- ✅ No hay archived logs acumulados

#### Resumen de Espacio del Sistema

```
Filesystem root:    17GB libres (55% uso) ✅
Oracle Binarios:    9.9GB (fijo) ✅  
Datos BD:           2.4GB (crecimiento lento) ✅
FRA:                11MB (control file - normal) ✅
```

### Conclusión del Análisis

> **Sistema Correctamente Configurado**
>
> - El FRA tiene el espacio apropiado
> - Los control files están correctamente multiplexados
> - No hay problemas de espacio inminentes
> - El sistema puede continuar con operaciones normales
