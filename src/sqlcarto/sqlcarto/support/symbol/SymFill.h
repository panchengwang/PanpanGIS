#ifndef __SYM_FILL_H
#define __SYM_FILL_H

#include <dllexport.h>
#include "SymColor.h"
#include <string>
#include <json_tokener.h>
#include <vector>


class DLL_EXPORT SymFill
{
public:
    SymFill();
    const std::string& getErrorMessage() const;
    virtual bool from_json_object(json_object* obj) = 0;
    virtual json_object* to_json_object() = 0;

protected:
    uint8_t _type;
    std::string _errorMessage; 
};

#endif
