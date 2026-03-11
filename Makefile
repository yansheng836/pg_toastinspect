# Makefile
MODULES = pg_toastinspect

EXTENSION = pg_toastinspect
DATA = pg_toastinspect--1.0.sql

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)