#ifndef __SYM_CHORD_H
#define __SYM_CHORD_H

#include <dllexport.h>
#include "SymPoint.h"
#include <string>
#include <json_tokener.h>
#include <vector>
#include "SymArc.h"


class DLL_EXPORT SymChord : public SymArc
{
public:
    SymChord();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object() ;

protected:
    
};

#endif
