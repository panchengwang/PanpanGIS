#ifndef __SYM_CHORD_H
#define __SYM_CHORD_H


#include "SymPie.h"
#include "SymFill.h"

class DLL_EXPORT SymChord : public SymPie
{
public:
    SymChord();
    virtual ~SymChord();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object() ;

protected:

};

#endif
