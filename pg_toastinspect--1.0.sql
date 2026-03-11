-- pg_toastinspect--1.0.sql

-- 简单版：只返回 chunk_id
CREATE FUNCTION get_toast_chunk_id(val text)
RETURNS oid
AS '$libdir/pg_toastinspect', 'get_toast_chunk_id'
LANGUAGE C STRICT;

-- 也支持 bytea / jsonb 等类型
CREATE FUNCTION get_toast_chunk_id(val bytea)
RETURNS oid
AS '$libdir/pg_toastinspect', 'get_toast_chunk_id'
LANGUAGE C STRICT;

CREATE FUNCTION get_toast_chunk_id(val jsonb)
RETURNS oid
AS '$libdir/pg_toastinspect', 'get_toast_chunk_id'
LANGUAGE C STRICT;


-- 完整版：返回所有 toast 指针信息
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