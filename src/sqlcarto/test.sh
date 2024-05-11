#!/bin/sh

createdb testdb
psql -d testdb -f test.sql
dropdb testdb
