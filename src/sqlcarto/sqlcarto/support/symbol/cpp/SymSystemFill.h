#ifndef __SYM_SYSTEM_FILL_H
#define __SYM_SYSTEM_FILL_H

#include "SymShape.h"
#include "SymFill.h"


class DLL_EXPORT SymSystemFill : public SymShape
{
public:
    SymSystemFill();
    virtual ~SymSystemFill();

    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    SymFill* _fill;
};

#endif
