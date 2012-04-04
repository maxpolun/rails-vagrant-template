#!/bin/bash

/usr/bin/psql template1 -c "UPDATE pg_database SET datallowconn = TRUE where datname = 'template0';"
/usr/bin/psql template0 -c "UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';"
/usr/bin/psql template0 -c "DROP DATABASE template1;"
/usr/bin/psql template0 -c "create database template1 with template = template0 encoding = 'utf8';"
/usr/bin/psql template0 -c "UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';"
/usr/bin/psql template1 -c "UPDATE pg_database SET datallowconn = FALSE where datname = 'template0';"