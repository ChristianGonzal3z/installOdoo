#!/bin/bash
echo "Que version de Odoo quiere instalar:"
# shellcheck disable=SC2162
read odoo_version

Echo "Actualizando el sistema"
sudo apt update
sudo apt upgrade -y

# Instalar dependencias
sudo apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less pwgen -y

# Instalar PostgreSQL
sudo apt install postgresql -y
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "Creando usuario de Odoo...."
sudo useradd -m -U -r -d /opt/odoo -s /bin/bash odoo

# Crear usuario de PostgreSQL para Odoo
sudo su - postgres -c "createuser -s odoo"

# Instalar WKHTMLTOPDF

echo "
--------------------------------------------------
 Instalando Wkhtmltopdf
--------------------------------------------------"
WKHTMLTOX_X64=https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
wget ${WKHTMLTOX_X64}
sudo apt install -y ./wkhtmltox_0.12.5-1.bionic_amd64.deb
rm wkhtmltox_0.12.5-1.bionic_amd64.deb

# Clon el repositorio de Odoo
sudo su - odoo -c "git clone https://www.github.com/odoo/odoo --depth 1 --branch $odoo_version /opt/odoo/odoo"

# Crear entorno virtual de Python
sudo su - odoo -c "python3 -m venv /opt/odoo/venv"

# Instalar dependencias de Python
sudo su - odoo -c "/opt/odoo/venv/bin/pip install -r /opt/odoo/odoo/requirements.txt"

# Generar contraseña aleatoria
ODOO_ADMIN_PASSWD=$(pwgen 16 1)

# Crear archivo de configuración de Odoo
sudo touch /etc/odoo.conf
sudo bash -c "cat > /etc/odoo.conf" << EOL
[options]
; This is the password that allows database operations:
admin_passwd = ${ODOO_ADMIN_PASSWD}
db_host = False
db_port = False
db_user = odoo
db_password = False
addons_path = /opt/odoo/odoo/addons,/opt/odoo/custom-addons
EOL

# Crear archivo de servicio de Odoo
sudo touch /etc/systemd/system/odoo.service
sudo bash -c "cat > /etc/systemd/system/odoo.service" << EOL
[Unit]
Description=Odoo
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=odoo
PermissionsStartOnly=true
User=odoo
Group=odoo
ExecStart=/opt/odoo/venv/bin/python3 /opt/odoo/odoo/odoo-bin -c /etc/odoo.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOL

# Iniciar y habilitar el servicio de Odoo
sudo systemctl daemon-reload
sudo systemctl enable odoo.service
sudo systemctl start odoo.service

# Mostrar información de la instalación
echo "La instalación de Odoo ${odoo_version} ha finalizado."
echo "Ubicación de la instalación: /opt/odoo"
echo "Nombre de usuario: odoo"
echo "Contraseña aleatoria del administrador: ${ODOO_ADMIN_PASSWD}"
echo "Puedes acceder a la instancia en http://localhost:8069"
