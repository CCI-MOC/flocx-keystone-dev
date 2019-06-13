CREATE DATABASE IF NOT EXISTS flocx_market;
grant all privileges on flocx_market.* to 'flocx_market'@'localhost' identified by 'MARKET_DB_PASSWORD';
CREATE DATABASE IF NOT EXISTS flocx_provider;
grant all privileges on flocx_provider.* to 'flocx_provider'@'localhost' identified by 'PROVIDER_DB_PASSWORD';

