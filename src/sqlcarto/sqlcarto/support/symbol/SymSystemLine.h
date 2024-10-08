#ifndef __SYM_SYSTEM_LINE_H
#define __SYM_SYSTEM_LINE_H

#include "SymShapeWithStroke.h"

class DLL_EXPORT SymSystemLine : public SymShapeWithStroke
{
public:
    SymSystemLine();
    virtual ~SymSystemLine();
    
    virtual bool from_json_object(json_object* obj) ;
    virtual json_object* to_json_object() ;
    
protected:



};

#endif
