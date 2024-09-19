#!/bin/sh
dropdb testdb
createdb testdb
psql -d testdb -f test.sql

