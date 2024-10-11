CREATE OR REPLACE FUNCTION sc_symbol_in(cstring)
	RETURNS symbol
	AS 'MODULE_PATHNAME','SYMBOL_in'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION sc_symbol_out(symbol)
	RETURNS cstring
	AS 'MODULE_PATHNAME','SYMBOL_out'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE symbol (
	internallength = variable,
	input = sc_symbol_in,
	output = sc_symbol_out,
	alignment = double,
	storage = main
);