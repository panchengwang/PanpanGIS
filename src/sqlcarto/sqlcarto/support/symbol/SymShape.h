#ifndef __SYM_SHAPE_H
#define __SYM_SHAPE_H

#include <dllexport.h>
#include <stdint.h>
#include "json_tokener.h"
#include <string>




class DLL_EXPORT SymShape
{
public:
    enum
    {
        SYSTEM_LINE = 1,
        LINESTRING,
        POLYGON,
        ARC,
        CIRCLE,
        ELLIPSE,
        PIE,
        CHORD,
        PATH
    };


    virtual bool from_json_object(json_object* obj) = 0;
    virtual json_object* to_json_object() = 0;

    const std::string& getErrorMessage() const;

protected:
    uint8_t  _type;

    std::string _errorMessage;
};

#endif
