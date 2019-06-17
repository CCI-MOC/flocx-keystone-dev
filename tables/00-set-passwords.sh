sed -i -e "s/MARKET_DB_PASSWORD/$MARKET_DB_PASSWORD/g" /docker-entrypoint-initdb.d/create_user_db.sql
sed -i -e "s/PROVIDER_DB_PASSWORD/$PROVIDER_DB_PASSWORD/g" /docker-entrypoint-initdb.d/create_user_db.sql
