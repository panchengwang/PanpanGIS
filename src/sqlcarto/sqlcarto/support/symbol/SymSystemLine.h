#ifndef __SYM_SYSTEM_LINE_H
#define __SYM_SYSTEM_LINE_H

#include <dllexport.h>
#include <stdint.h>
#include "json_tokener.h"
#include "SymShape.h"

class DLL_EXPORT SymSystemLine : public SymShape
{
public:

    virtual bool from_json_object(json_object* obj) ;
    virtual json_object* to_json_object() ;
    
protected:



};

#endif
