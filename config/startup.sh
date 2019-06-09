#!/bin/sh

DTU='python /config/dtu.py'

: ${KEYSTONE_DB_HOST:=database}
export KEYSTONE_DB_HOST

echo "* generating config files from templates"
$DTU -o /etc/keystone/keystone.conf /config/keystone.j2.conf
$DTU -o /etc/httpd/conf.d/keystone-wsgi-main.conf /config/keystone-wsgi-main.j2.conf
$DTU -o /root/clouds.yaml /config/clouds.j2.yaml

echo "* initializing fernet tokens"
install -d -o root -g keystone -m 775 /etc/keystone/fernet-keys
runuser -u keystone -- keystone-manage fernet_setup \
	--keystone-user keystone \
	--keystone-group keystone

echo "* initializing database schema"
while ! keystone-manage db_sync; do
	echo "! database schema initialization failed; retrying in 5 seconds..."
	sleep 5
done

echo "* initializing service catalog"
runuser -u keystone -- keystone-manage bootstrap \
	--bootstrap-password ${KEYSTONE_ADMIN_PASSWORD} \
	--bootstrap-internal-url http://localhost:5000 \
	--bootstrap-public-url ${KEYSTONE_PUBLIC_URL:-http://localhost:5000} \
	--bootstrap-region-id ${KEYSTONE_REGION:-RegionOne}

echo "* starting httpd"
exec /usr/sbin/httpd -DFOREGROUND
