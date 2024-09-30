#ifndef __SYM_PIE_H
#define __SYM_PIE_H

#include <dllexport.h>
#include "SymPoint.h"
#include <string>
#include <json_tokener.h>
#include <vector>
#include "SymArc.h"


class DLL_EXPORT SymPie : public SymArc
{
public:
    SymPie();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object() ;
protected:
    
};

#endif
