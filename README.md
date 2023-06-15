# installOdoo
Este repositorio contiene un script de instalación para Odoo en Ubuntu o Debian. El script instala todas las dependencias necesarias, configura el entorno y crea un servicio de sistema para Odoo.
## Script para instalar Odoo

### Características
- Instalación automatizada de Odoo y sus dependencias
- Creación de un usuario de sistema y de Postgres SQL para Odoo
- Configuración de un entorno virtual de Python para Odoo
- Instalación de WKHTMLTOPDF para la generación de informes en PDF
- Configuración de un directorio para módulos personalizados (custom-addons)
- Creación de un servicio de sistema para Odoo

### Uso
1. Clona este repositorio o descarga el script `install_odoo.sh`.
2. Ejecuta el script con permisos de administrador: 
    ````bash
    sudo bash install_odoo.sh
    ````
3. Espera a que el script termine la instalación. Al finalizar, se mostrará información sobre la ubicación de la instalación, el nombre de usuario y la contraseña aleatoria del administrador.

4. Accede a la instancia de Odoo en http://localhost:8069.

### Notas
- No olvides guardar la contraseña del administrador en un lugar seguro.
- Para agregar módulos personalizados, colócalos en el directorio `/opt/odoo/custom-addons` y reinicia el servicio de Odoo:
    ````bash
    sudo systemctl restart odoo.service
    ````    
- Si necesitas modificar la configuración de Odoo, edita el archivo `/etc/odoo.conf` y reinicia el servicio de Odoo para que se vean los cambios.


## Script para eliminar Odoo
Este script está diseñado para eliminar completamente una instalación de Odoo de su sistema. Asegúrese de comprender las implicaciones de eliminar Odoo antes de ejecutar este script, ya que eliminará todos los archivos, bases de datos y configuraciones asociadas con Odoo.

### Uso
1. Descargue el script ``unistall_odoo.sh`` en su sistema.
2. Abra una terminal y navegue hasta la ubicación donde descargó el script.
3. Otorgue permisos de ejecución al script con el siguiente comando:
    ```bash 
   chmod +x uninstall_odoo.sh
    ```
4. Ejecute el script con privilegios de root o sudo:
    ```bash  
   sudo ./uninstall_odoo.sh
    ````
### El script de desinstalación de Odoo realiza las siguientes acciones:
1. Detiene el servicio de Odoo si está en ejecución.
2. Elimina los archivos de configuración de Odoo.
3. Elimina los archivos de registro de Odoo.
4. Desinstala Odoo y sus dependencias.
5. Elimina las bases de datos de Odoo.
6. Elimina el usuario y el grupo de Odoo del sistema (opcional, se le preguntará durante la ejecución del script).
## Advertencia
Este script eliminará permanentemente Odoo y sus componentes asociados de su sistema. Asegúrese de haber realizado una copia de seguridad de todos los datos importantes antes de continuar.