#ifndef __SYM_CIRCLE_H
#define __SYM_CIRCLE_H

#include <dllexport.h>
#include "SymPoint.h"
#include <string>
#include <json_tokener.h>
#include <vector>
#include "SymShape.h"


class DLL_EXPORT SymCircle : public SymShape
{
public:
    SymCircle();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object() ;

protected:
    
};

#endif
