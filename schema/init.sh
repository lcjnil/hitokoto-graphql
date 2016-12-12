#!/bin/bash
set -e

psql -U postgres -f /usr/src/schema/schema.sql &&\
psql -U postgres -f /usr/src/schema/role.sql &&\
psql -U postgres -f /usr/src/schema/data.sql
