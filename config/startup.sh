#!/bin/sh

DTU='python /config/dtu.py'
WAITFORDB='python /config/waitfordb.py'

: ${KEYSTONE_DB_HOST:=database}
export KEYSTONE_DB_HOST

echo "* generating config files from templates"
$DTU -o /etc/keystone/keystone.conf /config/keystone.j2.conf
$DTU -o /etc/httpd/conf.d/keystone-wsgi-main.conf /config/keystone-wsgi-main.j2.conf
$DTU -o /root/clouds.yaml /config/clouds.j2.yaml

echo "* waiting for database"
$WAITFORDB --host ${KEYSTONE_DB_HOST} --user ${KEYSTONE_DB_USER} \
	--password ${KEYSTONE_DB_PASSWORD} ${KEYSTONE_DB_NAME}

echo "* initializing fernet tokens"
keystone-manage fernet_setup \
	--keystone-user keystone \
	--keystone-group keystone

echo "* initializing database schema"
keystone-manage db_sync

echo "* initializing service catalog"
keystone-manage bootstrap \
	--bootstrap-password ${KEYSTONE_ADMIN_PASSWORD} \
	--bootstrap-internal-url http://localhost:5000 \
	--bootstrap-public-url ${KEYSTONE_PUBLIC_URL:-http://localhost:5000} \
	--bootstrap-region-id ${KEYSTONE_REGION:-RegionOne}

echo "* starting httpd"
exec /usr/sbin/httpd -DFOREGROUND
