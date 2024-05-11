#include "sqlcarto.h"



PG_MODULE_MAGIC;


PG_FUNCTION_INFO_V1(sc_send_mail); 		// 发送邮件



Datum 
sc_send_mail(PG_FUNCTION_ARGS)
{
    PG_RETURN_BOOL(TRUE);
}
