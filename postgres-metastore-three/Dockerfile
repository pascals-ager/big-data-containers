FROM postgres:9.5.3

COPY hive-schema-3.1.0.postgres.sql /hive/hive-schema-3.1.0.postgres.sql

COPY init-hive-db.sh /docker-entrypoint-initdb.d/init-user-db.sh

EXPOSE 5432
