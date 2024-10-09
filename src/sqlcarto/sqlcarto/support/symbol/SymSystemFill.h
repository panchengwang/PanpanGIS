#ifndef __SYM_SYSTEM_FILL_H
#define __SYM_SYSTEM_FILL_H

#include "SymShape.h"
#include "SymFill.h"


class DLL_EXPORT SymSystemFill : public SymShape
{
public:
    SymSystemFill();
    virtual ~SymSystemFill();

    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();
    size_t memory_size();
    char* serialize(const char* buf);
protected:
    SymFill* _fill;
};

#endif
