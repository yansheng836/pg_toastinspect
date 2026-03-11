// pg_toastinspect.c
#include "postgres.h"
#include "fmgr.h"
#include "varatt.h"
#include "funcapi.h"
#include <string.h>

PG_MODULE_MAGIC;

/*
 * 直接 memcpy 替代 VARATT_EXTERNAL_GET_POINTER
 * 避免不同 PG 版本的符号兼容问题
 */
static inline void
get_toast_ptr(struct varlena *val, varatt_external *out)
{
    memcpy(out, VARDATA_EXTERNAL(val), sizeof(varatt_external));
}


/* ------------------------------------------------
 * get_toast_chunk_id(anycolumn)
 * 返回 chunk_id，未 toast 则返回 NULL
 * ------------------------------------------------ */
PG_FUNCTION_INFO_V1(get_toast_chunk_id);
Datum
get_toast_chunk_id(PG_FUNCTION_ARGS)
{
    struct varlena  *val = PG_GETARG_RAW_VARLENA_P(0);
    varatt_external  toast_ptr;

    if (VARATT_IS_EXTERNAL_ONDISK(val))
    {
        get_toast_ptr(val, &toast_ptr);
        PG_RETURN_OID(toast_ptr.va_valueid);
    }

    PG_RETURN_NULL();
}


/* ------------------------------------------------
 * get_toast_info(anycolumn)
 * 返回完整 toast 指针信息
 * ------------------------------------------------ */
PG_FUNCTION_INFO_V1(get_toast_info);
Datum
get_toast_info(PG_FUNCTION_ARGS)
{
    struct varlena  *val = PG_GETARG_RAW_VARLENA_P(0);
    varatt_external  toast_ptr;
    TupleDesc        tupdesc;
    Datum            values[4];
    bool             nulls[4];
    HeapTuple        tuple;

    if (get_call_result_type(fcinfo, NULL, &tupdesc) != TYPEFUNC_COMPOSITE)
        ereport(ERROR,
                (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
                 errmsg("function returning record called in context "
                        "that cannot accept type record")));

    tupdesc = BlessTupleDesc(tupdesc);

    if (VARATT_IS_EXTERNAL_ONDISK(val))
    {
        get_toast_ptr(val, &toast_ptr);

        nulls[0] = false;
        nulls[1] = false;
        nulls[2] = false;
        nulls[3] = false;
        values[0] = Int32GetDatum(toast_ptr.va_rawsize);       /* 原始大小       */
        values[1] = Int32GetDatum(toast_ptr.va_extinfo);       /* toast存储大小  */
        values[2] = ObjectIdGetDatum(toast_ptr.va_valueid);    /* chunk_id      */
        values[3] = ObjectIdGetDatum(toast_ptr.va_toastrelid); /* toast表OID    */
    }
    else
    {
        memset(nulls, true, sizeof(nulls));
        memset(values, 0, sizeof(values));
    }

    tuple = heap_form_tuple(tupdesc, values, nulls);
    PG_RETURN_DATUM(HeapTupleGetDatum(tuple));
}
