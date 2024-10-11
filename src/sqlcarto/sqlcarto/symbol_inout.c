#include "sqlcarto.h"
#include "symbol_inout.h"
#include <symbol_c.h>

Datum SYMBOL_in(PG_FUNCTION_ARGS);
Datum SYMBOL_out(PG_FUNCTION_ARGS);




PG_FUNCTION_INFO_V1(SYMBOL_in);
Datum SYMBOL_in(PG_FUNCTION_ARGS)
{
	char* input = PG_GETARG_CSTRING(0);
	char* str = input;

	SYMSERIALIZED* sym = NULL;
	SYMBOL_H hSym = NULL;
	char* buf;
	size_t len;

	if (PG_NARGS() != 1) {
		ereport(ERROR, (errmsg("parse symbol error - no input ")));
		PG_RETURN_NULL();
	}

	if (str[0] == '{') {
		hSym = sym_form_json_string(str);
		if (!hSym) {
			ereport(ERROR, (errmsg("parse error - invalid json format")));
			PG_RETURN_NULL();
		}

	}

	PG_RETURN_POINTER(NULL);
}


PG_FUNCTION_INFO_V1(SYMBOL_out);
Datum SYMBOL_out(PG_FUNCTION_ARGS)
{
	// GSERIALIZED *geom = PG_GETARG_GSERIALIZED_P(0);
	// LWGEOM *lwgeom = lwgeom_from_gserialized(geom);
	// PG_RETURN_CSTRING(lwgeom_to_hexwkb_buffer(lwgeom, WKB_EXTENDED));

	PG_RETURN_POINTER(NULL);
}
