FROM postgres:16-alpine

ENV POSTGRES_DB=mydb
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword

COPY 1_task.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
