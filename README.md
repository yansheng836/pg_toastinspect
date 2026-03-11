# pg_toastinspect

inspect the contents of pg_toast info at a low level

## use

make

```shell
make
make install
```

sql

```sql
CREATE extension pg_toastinspect;

-- chunk_id
SELECT ctid,id,get_toast_chunk_id(response_content),response_content from ai_call_log_copy1 where id = 668310181431480320;

-- toast全部数据
SELECT ctid,id,get_toast_info(response_content),response_content from ai_call_log_copy1 where id = 668310181431480320;
```
