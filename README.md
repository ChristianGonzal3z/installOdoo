# installOdoo
Este repositorio contiene un script de instalación para Odoo en Ubuntu o Debian. El script instala todas las dependencias necesarias, configura el entorno y crea un servicio de sistema para Odoo.

## Características
- Instalación automatizada de Odoo y sus dependencias
- Creación de un usuario de sistema y de Postgres SQL para Odoo
- Configuración de un entorno virtual de Python para Odoo
- Instalación de WKHTMLTOPDF para la generación de informes en PDF
- Configuración de un directorio para módulos personalizados (custom-addons)
- Creación de un servicio de sistema para Odoo

## Uso
1. Clona este repositorio o descarga el script `install_odoo.sh`.
2. Ejecuta el script con permisos de administrador: 
    ````bash
    sudo bash install_odoo.sh
    ````
3. Espera a que el script termine la instalación. Al finalizar, se mostrará información sobre la ubicación de la instalación, el nombre de usuario y la contraseña aleatoria del administrador.

4. Accede a la instancia de Odoo en http://localhost:8069.

## Notas
- No olvides guardar la contraseña del administrador en un lugar seguro.
- Para agregar módulos personalizados, colócalos en el directorio `/opt/odoo/custom-addons` y reinicia el servicio de Odoo:
    ````bash
    sudo systemctl restart odoo.service
    ````    
- Si necesitas modificar la configuración de Odoo, edita el archivo `/etc/odoo.conf` y reinicia el servicio de Odoo para que se vean los cambios.
