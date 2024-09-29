#ifndef __SYM_STROKE_H
#define __SYM_STROKE_H

#include <dllexport.h>
#include "SymColor.h"
#include <string>
#include <json_tokener.h>





class DLL_EXPORT SymStroke
{
public:
    SymStroke();
    const std::string& getErrorMessage() const;
    bool from_json_object(json_object* obj);
    json_object* to_json_object();

protected:
    SymColor    _color;
    std::string _errorMessage; 
};

#endif
