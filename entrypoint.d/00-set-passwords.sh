#!/bin/sh

sed \
	-e "s/MARKET_DB_PASSWORD/$MARKET_DB_PASSWORD/g" \
	-e "s/PROVIDER_DB_PASSWORD/$PROVIDER_DB_PASSWORD/g" \
	/sql/create_user_db.sql > /tmp/create_user_db.sql
