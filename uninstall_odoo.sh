#!/bin/bash

# Detener el servicio de Odoo
sudo systemctl stop odoo.service

# Eliminar el servicio de Odoo
sudo rm /etc/systemd/system/odoo.service

# Eliminar la carpeta de Odoo
sudo rm -rf /opt/odoo

# Eliminar el usuario de Odoo
sudo userdel -r odoo

# Eliminar la db de Odoo
sudo su - postgres -c "dropdb odoo"

# Eliminar el usuario de la db de Odoo
sudo su - postgres -c "dropuser odoo"

# Eliminar el archivo de configuración de Odoo
sudo rm /etc/odoo/odoo.conf

# Eliminar el archivo de registro de Odoo
sudo rm /var/log/odoo/odoo-server.log

# Eliminar el archivo de registro de errores de Odoo
sudo rm /var/log/odoo/odoo-server.log
