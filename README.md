# 🗄️ Oracle Database 19c - Proyecto de Aprendizaje

[![Oracle Database](https://img.shields.io/badge/Oracle-19c-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/database/)
[![Oracle Linux](https://img.shields.io/badge/Oracle_Linux-8.10-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/linux/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

Proyecto completo de instalación, configuración y desarrollo de un sistema empresarial con **Oracle Database 19c Enterprise Edition** sobre **Oracle Linux 8.10**.

---

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Características](#-características)
- [Arquitectura del Proyecto](#-arquitectura-del-proyecto)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación](#-instalación)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Uso](#-uso)
- [Modelo de Base de Datos](#-modelo-de-base-de-datos)
- [Scripts SQL Disponibles](#-scripts-sql-disponibles)
- [Documentación](#-documentación)
- [Contribuciones](#-contribuciones)
- [Licencia](#-licencia)

---

## 🎯 Descripción

Este repositorio contiene una **guía completa paso a paso** para la instalación de Oracle Database 19c en Oracle Linux 8.10, junto con un **sistema empresarial de ejemplo** que incluye:

- ✅ Gestión de departamentos
- ✅ Administración de empleados
- ✅ Control de clientes
- ✅ Procedimientos almacenados
- ✅ Triggers y vistas
- ✅ Paquetes PL/SQL

El proyecto está diseñado para **aprendizaje y desarrollo**, proporcionando una base sólida para comprender la arquitectura y administración de Oracle Database.

---

## ✨ Características

### Instalación y Configuración

- 📦 **Instalación silenciosa** de Oracle Database 19c
- 🔧 **Configuración automática** de usuarios, grupos y permisos
- 🗂️ **Estructura de directorios** optimizada
- ⚙️ **Variables de entorno** configuradas
- 🔐 **Límites del sistema** ajustados para Oracle

### Sistema Empresarial

- 👥 **Gestión de Empleados**: Control completo de personal
- 🏢 **Departamentos**: Organización empresarial
- 🤝 **Clientes**: Administración de cartera de clientes
- 📊 **Vistas**: Consultas predefinidas para reportes
- 🔄 **Triggers**: Automatización de procesos
- 📦 **Paquetes PL/SQL**: Lógica de negocio encapsulada

---

## 🏗️ Arquitectura del Proyecto

```
┌─────────────────────────────────────────┐
│     Oracle Linux 8.10 (VM)              │
│  ┌───────────────────────────────────┐  │
│  │  Oracle Database 19c EE           │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Base de Datos: ORCL        │  │  │
│  │  │  ├─ Tablespace: DATOS       │  │  │
│  │  │  ├─ Tablespace: ÍNDICES     │  │  │
│  │  │  └─ Tablespace: TEMPORAL    │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                    │  │
│  │  Usuario: ADMIN_EMPRESA            │  │
│  │  ├─ Tablas: 3                      │  │
│  │  ├─ Vistas: 3                      │  │
│  │  ├─ Procedimientos: 2              │  │
│  │  ├─ Funciones: 1                   │  │
│  │  ├─ Triggers: 3                    │  │
│  │  └─ Paquetes: 1                    │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## 📋 Requisitos Previos

### Hardware Recomendado

| Componente | Especificación Mínima | Recomendado |
|------------|----------------------|-------------|
| **CPU** | 2 vCPUs | 4 vCPUs |
| **RAM** | 4 GB | 8 GB |
| **Disco** | 40 GB | 100 GB |
| **Red** | Conexión a Internet | - |

### Software Necesario

- **Sistema Operativo**: Oracle Linux 8.10 (descarga desde [Oracle Linux ISOs](https://yum.oracle.com/oracle-linux-isos.html))
- **Oracle Database**: 19c Enterprise Edition (descarga desde [Oracle Database Downloads](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html))
- **Virtualización** (opcional): QEMU/KVM, VirtualBox, VMware

---

## 🚀 Instalación

### 1. Preparación del Sistema

```bash
# Actualizar el sistema
sudo dnf update -y

# Habilitar repositorios
sudo dnf config-manager --set-enabled ol8_baseos_latest ol8_appstream ol8_addons

# Instalar paquete de preinstalación Oracle
sudo dnf install -y oracle-database-preinstall-19c
```

### 2. Crear Estructura de Directorios

```bash
# Crear directorios principales
sudo mkdir -p /u01/app/oracle/product/19.3.0/dbhome_1
sudo mkdir -p /u01/app/oracle/oradata
sudo mkdir -p /u01/app/oracle/fast_recovery_area
sudo mkdir -p /u01/app/oracle/admin/ORCL/adump

# Asignar permisos
sudo chown -R oracle:oinstall /u01
sudo chmod -R 755 /u01
```

### 3. Configurar Variables de Entorno

```bash
# Crear archivo de perfil
sudo tee /etc/profile.d/oracle.sh << 'EOF'
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1
export ORACLE_SID=ORCL
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
EOF

# Cargar variables
source /etc/profile.d/oracle.sh
```

### 4. Instalar Oracle Database

Consulta la [documentación completa de instalación](documentation.md) para instrucciones detalladas paso a paso.

### 5. Configurar el Sistema Empresarial

```bash
# Conectar como SYSDBA
sqlplus / as sysdba

# Ejecutar scripts en orden
@02_configuracion/01_tablespaces.sql
@02_configuracion/02_usuario.sql
@03_tablas/01_departamentos.sql
@03_tablas/02_empleados.sql
@03_tablas/03_clientes.sql
@04_datos/datos_prueba.sql
```

---

## 📁 Estructura del Proyecto

```
OracleLinux/
│
├── 📄 README.md                          # Este archivo
├── 📄 documentation.md                   # Guía completa de instalación
├── 📄 database.md                        # Documentación de la base de datos
│
├── 📂 00_instalacion/                    # Scripts de instalación
│
├── 📂 01_verificacion/                   # Scripts de verificación
│   ├── verificar_espacio.sql            # Verificar espacio en disco
│   └── estado_orcl.sql                  # Estado de la base de datos
│
├── 📂 02_configuracion/                  # Configuración inicial
│   ├── 01_tablespaces.sql               # Crear tablespaces
│   ├── 02_usuario.sql                   # Crear usuario ADMIN_EMPRESA
│   └── 03_verificacion_config.sql       # Verificar configuración
│
├── 📂 03_tablas/                         # Definición de tablas
│   ├── 01_departamentos.sql             # Tabla departamentos
│   ├── 02_empleados.sql                 # Tabla empleados
│   └── 03_clientes.sql                  # Tabla clientes
│
├── 📂 04_datos/                          # Datos de prueba
│   └── datos_prueba.sql                 # Insertar datos de ejemplo
│
├── 📂 05_consultas/                      # Consultas SQL
│   └── consultas_basicas.sql            # Consultas de ejemplo
│
└── 📂 06_procedimientos/                 # Objetos PL/SQL
    ├── 01_vistas.sql                    # Vistas del sistema
    ├── 02_procedimientos_almacenados.sql # Procedimientos
    ├── 03_triggers.sql                  # Triggers
    ├── 04_paquetes.sql                  # Paquetes PL/SQL
    └── 05_ejemplos_uso.sql              # Ejemplos de uso
```

---

## 💻 Uso

### Conectar a la Base de Datos

```bash
# Como usuario SYSDBA
sqlplus / as sysdba

# Como usuario ADMIN_EMPRESA
sqlplus admin_empresa/password123
```

### Iniciar/Detener la Base de Datos

```sql
-- Iniciar
SQL> STARTUP

-- Detener
SQL> SHUTDOWN IMMEDIATE
```

### Verificar Estado

```sql
-- Estado de la instancia
SELECT status FROM v$instance;

-- Tablespaces disponibles
SELECT tablespace_name, status FROM dba_tablespaces;

-- Espacio en disco
@01_verificacion/verificar_espacio.sql
```

### Ejecutar Scripts

```bash
# Desde SQL*Plus
SQL> @ruta/al/script.sql

# Desde línea de comandos
sqlplus admin_empresa/password123 @ruta/al/script.sql
```

---

## 🗃️ Modelo de Base de Datos

### Diagrama Entidad-Relación

```
┌─────────────────────┐
│   DEPARTAMENTOS     │
├─────────────────────┤
│ PK id_departamento  │
│    nombre_depto     │
│    ubicacion        │
│    presupuesto_anual│
│    jefe_departamento│
└──────────┬──────────┘
           │
           │ 1:N
           │
┌──────────▼──────────┐         ┌─────────────────────┐
│     EMPLEADOS       │         │      CLIENTES       │
├─────────────────────┤         ├─────────────────────┤
│ PK id_empleado      │         │ PK id_cliente       │
│    dni              │         │    ruc              │
│    nombre           │         │    razon_social     │
│    apellido_paterno │         │    nombre_comercial │
│    apellido_materno │         │    direccion        │
│    fecha_nacimiento │         │    telefono         │
│    genero           │         │    email            │
│    email            │         │    tipo_cliente     │
│    telefono         │         │    fecha_registro   │
│    salario          │         │    vendedor_asignado│◄───┐
│    fecha_contratacion│        │    estado           │    │
│ FK id_departamento  │         │    limite_credito   │    │
│    cargo            │         └─────────────────────┘    │
│    estado           │                                     │
└─────────────────────┘                                     │
           │                                                │
           └────────────────────────────────────────────────┘
                              N:1
```

### Tablas Principales

#### 1. **DEPARTAMENTOS**
- Gestión de departamentos de la empresa
- Campos: ID, nombre, ubicación, presupuesto, jefe, estado

#### 2. **EMPLEADOS**
- Información completa de empleados
- Relación con departamentos (FK)
- Campos: DNI, nombre completo, contacto, salario, cargo

#### 3. **CLIENTES**
- Cartera de clientes
- Relación con vendedor asignado (FK a empleados)
- Campos: RUC, razón social, contacto, tipo, límite de crédito

---

## 📜 Scripts SQL Disponibles

### Configuración

| Script | Descripción |
|--------|-------------|
| `01_tablespaces.sql` | Crea tablespaces para datos, índices y temporales |
| `02_usuario.sql` | Crea usuario ADMIN_EMPRESA con privilegios |
| `03_verificacion_config.sql` | Verifica la configuración del sistema |

### Tablas

| Script | Descripción |
|--------|-------------|
| `01_departamentos.sql` | Crea tabla departamentos con índices y secuencias |
| `02_empleados.sql` | Crea tabla empleados con constraints |
| `03_clientes.sql` | Crea tabla clientes con relaciones |

### Procedimientos y Funciones

| Objeto | Tipo | Descripción |
|--------|------|-------------|
| `sp_actualizar_salario` | Procedimiento | Actualiza salario de empleado por porcentaje |
| `sp_insertar_empleado` | Procedimiento | Inserta nuevo empleado con validaciones |
| `fn_calcular_antiguedad` | Función | Calcula años de antigüedad de un empleado |

### Triggers

| Trigger | Tabla | Descripción |
|---------|-------|-------------|
| `trg_departamentos_audit` | DEPARTAMENTOS | Audita cambios en departamentos |
| `trg_empleados_salario` | EMPLEADOS | Valida salarios antes de insertar/actualizar |
| `trg_clientes_fecha` | CLIENTES | Establece fecha de registro automáticamente |

### Vistas

| Vista | Descripción |
|-------|-------------|
| `v_empleados_completo` | Vista completa de empleados con departamento |
| `v_departamentos_resumen` | Resumen de departamentos con cantidad de empleados |
| `v_clientes_activos` | Clientes activos con vendedor asignado |

---

## 📚 Documentación

### Documentos Disponibles

- **[documentation.md](documentation.md)**: Guía completa de instalación paso a paso de Oracle Database 19c
- **[database.md](database.md)**: Documentación técnica de la base de datos empresarial

### Temas Cubiertos en la Documentación

1. **Instalación de Oracle Linux 8.10**
   - Descarga e instalación
   - Configuración de máquina virtual
   - Especificaciones recomendadas

2. **Configuración del Sistema**
   - Actualización de paquetes
   - Instalación de prerequisitos
   - Configuración de usuarios y grupos
   - Límites del kernel

3. **Instalación de Oracle Database 19c**
   - Descarga del software
   - Instalación silenciosa
   - Scripts post-instalación
   - Creación de la base de datos con DBCA

4. **Administración y Monitoreo**
   - Comandos de inicio/parada
   - Verificación de espacio en disco
   - Análisis de tablespaces
   - Configuración de control files

5. **Solución de Problemas**
   - Errores comunes y soluciones
   - Verificación de configuración
   - Troubleshooting

---

## 🛠️ Comandos Útiles

### Administración de la Base de Datos

```sql
-- Ver estado de la instancia
SELECT instance_name, status, database_status FROM v$instance;

-- Ver tablespaces
SELECT tablespace_name, status, contents FROM dba_tablespaces;

-- Ver archivos de datos
SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb 
FROM dba_data_files;

-- Ver usuarios
SELECT username, account_status, default_tablespace 
FROM dba_users 
WHERE username = 'ADMIN_EMPRESA';
```

### Verificación de Objetos

```sql
-- Listar tablas del usuario
SELECT table_name FROM user_tables;

-- Listar procedimientos y funciones
SELECT object_name, object_type FROM user_objects 
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE');

-- Listar triggers
SELECT trigger_name, table_name, status FROM user_triggers;

-- Listar vistas
SELECT view_name FROM user_views;
```

### Monitoreo de Espacio

```sql
-- Espacio usado por tablespace
SELECT tablespace_name, 
       ROUND(SUM(bytes)/1024/1024,2) as total_mb
FROM dba_data_files
GROUP BY tablespace_name;

-- Espacio usado por objetos
SELECT segment_name, segment_type,
       ROUND(bytes/1024/1024,2) as size_mb
FROM user_segments
ORDER BY bytes DESC;
```

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este proyecto:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📝 Notas Importantes

> **⚠️ Advertencia**: Este proyecto está diseñado para **entornos de desarrollo y aprendizaje**. Para ambientes de producción, se recomienda:
> - Habilitar modo ARCHIVELOG
> - Configurar backups automáticos con RMAN
> - Implementar estrategias de alta disponibilidad
> - Revisar y ajustar parámetros de seguridad
> - Configurar Oracle Enterprise Manager

> **💡 Tip**: Las contraseñas de ejemplo (`oracle`, `password123`) deben cambiarse en entornos reales.

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

## 👤 Autor

**Neo**

- GitHub: [@brunochc](https://github.com/brunochc)
- Proyecto: OracleLinux_8.1

---

## 🙏 Agradecimientos

- Oracle Corporation por Oracle Database y Oracle Linux
- Comunidad de Oracle Database
- Documentación oficial de Oracle

---

## 📞 Soporte

Si tienes preguntas o problemas:

1. Revisa la [documentación completa](documentation.md)
2. Consulta la sección de [solución de problemas](documentation.md#solución-de-problemas-comunes)
3. Abre un issue en GitHub

---

## 🔗 Enlaces Útiles

- [Documentación Oracle Database 19c](https://docs.oracle.com/en/database/oracle/oracle-database/19/)
- [Oracle Linux Documentation](https://docs.oracle.com/en/operating-systems/oracle-linux/)
- [Oracle Database Installation Guide](https://docs.oracle.com/en/database/oracle/oracle-database/19/ladbi/)
- [Oracle SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/)
- [PL/SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/)

---

<div align="center">

**⭐ Si este proyecto te fue útil, considera darle una estrella ⭐**

*Última actualización: Noviembre 2025*

</div>
