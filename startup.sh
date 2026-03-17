#!/bin/bash

# Add mysql home directory
usermod -d /var/lib/mysql/ mysql

# Start MySQL
service mysql start

# Optional: Set root password and allow remote access (for testing ONLY)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"

# Start Tomcat
$CATALINA_HOME/bin/startup.sh &

sleep 1

# Initialise the database
echo Initialise Db
curl --data "username=root&password=root&host=localhost&port=3306&wavsep_username=&wavsep_password=" http://localhost:8080/wavsep/wavsep-install/install.jsp

echo Db Initialised

# Keep container running
if [[ -n "${DEBUG}" ]]; then
  tail -f /opt/tomcat/logs/catalina.out
else
  tail -f /dev/null
fi
