#!/bin/bash

# Función para verificar si la versión de Odoo es válida
check_odoo_version() {
  echo "Verificando si la versión de Odoo proporcionada existe..."
  if ! git ls-remote --tags https://github.com/odoo/odoo.git "refs/tags/$odoo_version*" &> /dev/null; then
    echo "La versión proporcionada de Odoo no existe o no está disponible como una etiqueta en el repositorio oficial."
    echo "Por favor, verifique la versión deseada en el repositorio oficial: https://github.com/odoo/odoo/tags."
    exit 1
  fi
}

echo "¿Qué versión de Odoo desea instalar? (ejemplo: 13.0, 14.0, etc.):"
read -r odoo_version
check_odoo_version

echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando dependencias necesarias para Odoo..."
sudo apt install git python3-pip build-essential wget python3-dev python3-venv \
python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools \
node-less pwgen xz-utils -y

echo "Instalando PostgreSQL..."
sudo apt install postgresql -y
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "Creando usuario de sistema para Odoo..."
sudo useradd -m -U -r -d /opt/odoo -s /bin/bash odoo

echo "Creando usuario de PostgreSQL para Odoo..."
sudo su - postgres -c "createuser -s odoo"

echo "Instalando WKHTMLTOPDF..."
WKHTMLTOX_X64="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb"
wget -qO wkhtmltox.deb ${WKHTMLTOX_X64}
sudo apt install -y ./wkhtmltox.deb
rm -f wkhtmltox.deb

echo "Clonando el repositorio de Odoo..."
sudo su - odoo -c "git clone --depth 1 --branch $odoo_version https://www.github.com/odoo/odoo /opt/odoo/odoo"

echo "Creando entorno virtual de Python para Odoo..."
sudo su - odoo -c "python3 -m venv /opt/odoo/venv"

echo "Instalando dependencias de Python para Odoo..."
sudo su - odoo -c "/opt/odoo/venv/bin/pip install wheel"
sudo su - odoo -c "/opt/odoo/venv/bin/pip install -r /opt/odoo/odoo/requirements.txt"

echo "Generando contraseña aleatoria para el usuario administrador de Odoo..."
ODOO_ADMIN_PASSWD=$(pwgen 16 1)

echo "Creando archivo de configuración de Odoo..."
sudo tee /etc/odoo.conf > /dev/null <<EOL
[options]
admin_passwd = ${ODOO_ADMIN_PASSWD}
db_host = False
db_port = False
db_user = odoo
db_password = False
addons_path = /opt/odoo/odoo/addons
EOL

echo "Creando servicio de Odoo..."
sudo tee /etc/systemd/system/odoo.service > /dev/null <<EOL
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

echo "Habilitando e iniciando el servicio de Odoo..."
sudo systemctl daemon-reload
sudo systemctl enable --now odoo.service

echo "Instalación completada."
echo "Datos de la instalación:"
echo "Ubicación de la instalación: /opt/odoo"
echo "Usuario del sistema: odoo"
echo "Contraseña del administrador de Odoo: ${ODOO_ADMIN_PASSWD}"
echo "Acceso a Odoo: http://localhost:8069"

# Nota: asegúrese de abrir el puerto 8069 si está utilizando un firewall.
