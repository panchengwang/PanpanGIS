#include "symbol_c.h"
#include "Symbol.h"
#include <string>

SYMBOL_H sym_from_json_string(const char* jsonstr) {
    Symbol* sym = new Symbol();
    if (!sym->fromJsonString(jsonstr)) {
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
        delete sym;
        return NULL;
    }
    return (SYMBOL_H*)sym;
}

