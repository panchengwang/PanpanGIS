#ifndef __PG_SYMBOL_H
#define __PG_SYMBOL_H

#include <inttypes.h>

typedef struct
{
    uint32_t size; /* For PgSQL use only, use VAR* macros to manipulate. */
    uint8_t data[1]; /* See gserialized.txt */
} SYMSERIALIZED;



#endif
