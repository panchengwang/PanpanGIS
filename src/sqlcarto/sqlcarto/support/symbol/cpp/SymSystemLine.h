#ifndef __SYM_SYSTEM_LINE_H
#define __SYM_SYSTEM_LINE_H

#include "SymShapeWithStroke.h"

class DLL_EXPORT SymSystemLine : public SymShapeWithStroke
{
public:
    SymSystemLine();
    virtual ~SymSystemLine();

    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);

    SymRect getMBR() const;
    virtual void draw(SymCanvas* canvas);
protected:



};

#endif
