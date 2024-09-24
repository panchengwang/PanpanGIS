#include "sqlcarto.h"
#include "symbol.h"


Datum SYMBOL_in(PG_FUNCTION_ARGS);
Datum SYMBOL_out(PG_FUNCTION_ARGS);



/*
 * LWGEOM_in(cstring)
 * format is '[SRID=#;]wkt|wkb'
 *  LWGEOM_in( 'SRID=99;POINT(0 0)')
 *  LWGEOM_in( 'POINT(0 0)')            --> assumes SRID=SRID_UNKNOWN
 *  LWGEOM_in( 'SRID=99;0101000000000000000000F03F000000000000004')
 *  LWGEOM_in( '0101000000000000000000F03F000000000000004')
 *  LWGEOM_in( '{"type":"Point","coordinates":[1,1]}')
 *  returns a GSERIALIZED object
 */
PG_FUNCTION_INFO_V1(SYMBOL_in);
Datum SYMBOL_in(PG_FUNCTION_ARGS)
{
	char *input = PG_GETARG_CSTRING(0);
	char *str = input;
	
	PG_RETURN_POINTER(NULL);

}


/*
 * LWGEOM_out(lwgeom) --> cstring
 * output is 'SRID=#;<wkb in hex form>'
 * ie. 'SRID=-99;0101000000000000000000F03F0000000000000040'
 * WKB is machine endian
 * if SRID=-1, the 'SRID=-1;' will probably not be present.
 */
PG_FUNCTION_INFO_V1(SYMBOL_out);
Datum SYMBOL_out(PG_FUNCTION_ARGS)
{
	// GSERIALIZED *geom = PG_GETARG_GSERIALIZED_P(0);
	// LWGEOM *lwgeom = lwgeom_from_gserialized(geom);
	// PG_RETURN_CSTRING(lwgeom_to_hexwkb_buffer(lwgeom, WKB_EXTENDED));

	PG_RETURN_POINTER(NULL);
}
