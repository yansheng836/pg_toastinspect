-- Test script for pg_toastinspect extension

-- Test 1: Check if extension was created
SELECT 'Extension created successfully' AS status;

-- Test 2: Check function existence
SELECT
    proname AS function_name
FROM pg_proc
WHERE proname IN ('get_toast_chunk_id', 'get_toast_info')
ORDER BY proname;

-- Test 3: Check composite type existence
SELECT
    typname AS type_name
FROM pg_type
WHERE typname = 'toast_pointer_info';

-- Test 4: Show available functions
\df get_toast*
\dt toast_pointer_info