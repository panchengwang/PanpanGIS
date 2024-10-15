#ifndef __SYMBOL_C_H
#define __SYMBOL_C_H


#include <dllexport.h>

// #include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus


    typedef void* SYMBOL_H;

    DLL_EXPORT SYMBOL_H sym_from_json_string(const char* jsonstr);
    DLL_EXPORT char* sym_to_json_string(SYMBOL_H hSym, size_t* len);
    DLL_EXPORT void sym_destroy(SYMBOL_H hSym);

    DLL_EXPORT char* sym_serialize(SYMBOL_H hSym, size_t* len);
    DLL_EXPORT SYMBOL_H* sym_deserialize(const char* data);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif
