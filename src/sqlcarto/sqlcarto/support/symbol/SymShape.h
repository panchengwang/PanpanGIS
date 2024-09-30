#ifndef __SYM_SHAPE_H
#define __SYM_SHAPE_H

#include <dllexport.h>
#include <stdint.h>
#include "json_tokener.h"
#include <string>
#include "SymStroke.h"

#define SYM_SHAPE_SYSTEM_LINE       1
#define SYM_SHAPE_LINESTRING        2
#define SYM_SHAPE_POLYGON           3
#define SYM_SHAPE_ARC               4
#define SYM_SHAPE_CIRCLE            5
#define SYM_SHAPE_ELLIPSE           6
#define SYM_SHAPE_PIE               7
#define SYM_SHAPE_CHORD             8
#define SYM_SHAPE_PATH              9



class DLL_EXPORT SymShape
{
public:

    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();

    const std::string& getErrorMessage() const;
    
protected:
    uint8_t  _type;
    SymStroke _stroke;
    std::string _errorMessage;
};

#endif
