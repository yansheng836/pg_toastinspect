-- pg_toastinspect--1.0.sql

-- Simple version: returns only chunk_id
CREATE FUNCTION get_toast_chunk_id(val text)
RETURNS oid
AS '$libdir/pg_toastinspect', 'get_toast_chunk_id'
LANGUAGE C STRICT;

-- Also supports bytea / jsonb and other types
CREATE FUNCTION get_toast_chunk_id(val bytea)
RETURNS oid
AS '$libdir/pg_toastinspect', 'get_toast_chunk_id'
LANGUAGE C STRICT;

CREATE FUNCTION get_toast_chunk_id(val jsonb)
RETURNS oid
AS '$libdir/pg_toastinspect', 'get_toast_chunk_id'
LANGUAGE C STRICT;


-- Complete version: returns all toast pointer information
CREATE TYPE toast_pointer_info AS (
    raw_size        int4,
    ext_size        int4,
    chunk_id        oid,
    reltoastrelid   oid
);

CREATE FUNCTION get_toast_info(val text)
RETURNS toast_pointer_info
AS '$libdir/pg_toastinspect', 'get_toast_info'
LANGUAGE C STRICT;

CREATE FUNCTION get_toast_info(val bytea)
RETURNS toast_pointer_info
AS '$libdir/pg_toastinspect', 'get_toast_info'
LANGUAGE C STRICT;

CREATE FUNCTION get_toast_info(val jsonb)
RETURNS toast_pointer_info
AS '$libdir/pg_toastinspect', 'get_toast_info'
LANGUAGE C STRICT;