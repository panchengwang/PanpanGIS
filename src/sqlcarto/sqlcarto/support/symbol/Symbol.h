#ifndef __SYMBOL_H
#define __SYMBOL_H

#include <dllexport.h>
#include "SymPoint.h"
#include <string>
#include <json_tokener.h>





class DLL_EXPORT Symbol
{
public:
    Symbol();

    bool from_json_file(const char* filename);
    bool from_json_string(const char* jsonstr);
    std::string to_json_string();

    const std::string& getErrorMessage() const;
protected:
    bool from_json_object(json_object* obj);
    json_object* to_json_object();

private:
    SymPoint _offset;
    double _xscale,_yscale;

    std::string _errorMessage; 
};

#endif
