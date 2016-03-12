FROM postgres

EXPOSE 5432
ADD init.sql /docker-entrypoint-initdb.d/

ENV PGDATA /var/lib/postgresql/data/pgdata

VOLUME  ["/var/lib/postgresql/data/pgdata"]
