#ifndef __SYM_FILL_SOLID_H
#define __SYM_FILL_SOLID_H

#include "SymFill.h"
#include "SymColor.h"

class DLL_EXPORT SymFillSolid : public SymFill
{
public:
    SymFillSolid();

    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();
    size_t memory_size();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    SymColor _color;
};

#endif
