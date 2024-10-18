#include "symbol_c.h"
#include "Symbol.h"
#include <string>
#include <string.h>


SYMBOL_H sym_from_json_string(const char* jsonstr) {
    Symbol* sym = new Symbol();
    if (!sym->fromJsonString(jsonstr)) {
        strncpy(symbol_parse_error, sym->getErrorMessage().c_str(), 1024);
        delete sym;

        return NULL;
    }
    return (SYMBOL_H)sym;
}


char* sym_to_json_string(SYMBOL_H hSym, size_t* len) {
    Symbol* sym = (Symbol*)hSym;

    std::string jsonstr = sym->toJsonString();
    *len = jsonstr.size();
    char* buf = (char*)malloc(*len + 1);
    memcpy(buf, jsonstr.c_str(), *len);
    buf[*len] = '\0';

    return buf;
}



void sym_destroy(SYMBOL_H hSym) {
    Symbol* sym = (Symbol*)hSym;
    delete sym;
}


char* sym_serialize(SYMBOL_H hSym, size_t* len) {
    Symbol* sym = (Symbol*)hSym;
    char* buf = NULL;
    buf = sym->serialize(*len);
    return buf;
}


SYMBOL_H* sym_deserialize(const char* data) {
    Symbol* sym = new Symbol();
    if (!sym->deserialize(data)) {
        strncpy(symbol_parse_error, sym->getErrorMessage().c_str(), 1024);
        delete sym;
        return NULL;
    }
    return (SYMBOL_H*)sym;
}


unsigned char* sym_to_image(SYMBOL_H hSym, const char* format, double dotsPerMM, size_t* len) {
    Symbol* sym = (Symbol*)hSym;
    unsigned char* buf = NULL;
    buf = sym->toImage(format, dotsPerMM, *len);
    return buf;
}