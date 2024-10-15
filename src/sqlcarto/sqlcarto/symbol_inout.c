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


	if (PG_NARGS() <= 2) {
		elog(ERROR, "parse symbol error - no input ");
		PG_RETURN_NULL();
	}

	if (str[0] == '{') {
		hSym = sym_from_json_string(str);
		if (!hSym) {
			elog(ERROR, "Invalid symbol json string:");
			PG_RETURN_NULL();
		}
		buf = sym_serialize(hSym, &len);
		sym = (SYMSERIALIZED*)palloc(VARHDRSZ + len);
		SET_VARSIZE(sym, len + VARHDRSZ);
		memcpy((void*)VARDATA(sym), buf, len);
		free(buf);
		sym_destroy(hSym);
		PG_RETURN_POINTER(sym);
	}
	else {
		elog(ERROR, "Invalid symbol string");
	}

	PG_RETURN_POINTER(NULL);
}


PG_FUNCTION_INFO_V1(SYMBOL_out);
Datum SYMBOL_out(PG_FUNCTION_ARGS)
{
	SYMSERIALIZED* sym = PG_GETARG_SYMSERIALIZED_P(0);
	SYMBOL_H hSym = NULL;
	char* json_string = NULL;
	char* buf;
	size_t len;

	if (PG_ARGISNULL(0)) {
		PG_RETURN_NULL();
	}

	if (!(hSym = sym_deserialize(VARDATA(sym)))) {
		elog(ERROR, "deserialize symbol error");
		PG_RETURN_NULL();
	}

	buf = sym_to_json_string(hSym, &len);
	json_string = (char*)palloc(len + 1);
	memcpy(json_string, buf, len);
	json_string[len] = '\0';
	free(buf);

	PG_RETURN_CSTRING(json_string);
}


// GSERIALIZED* geometry_serialize(LWGEOM *lwgeom)
// {
// 	size_t ret_size;
// 	GSERIALIZED *g;

// 	g = gserialized_from_lwgeom(lwgeom, &ret_size);
// 	SET_VARSIZE(g, ret_size);
// 	return g;
// }