#include "SymSystemLine.h"
#include "jsonutils.h"
#include <iostream>


SymSystemLine::SymSystemLine()
{
    _type = SYM_SHAPE_SYSTEM_LINE;
}

SymSystemLine::~SymSystemLine()
{
}

bool SymSystemLine::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_SYSTEM_LINE;
    if (!SymShapeWithStroke::fromJsonObject(obj)) {
        return false;
    }
    return true;
}

json_object* SymSystemLine::toJsonObject() {
    json_object* obj = SymShapeWithStroke::toJsonObject();
    JSON_ADD_STRING(obj, "type", "SYSTEMLINE");
    return obj;
}


size_t SymSystemLine::memorySize() {
    size_t len = SymShapeWithStroke::memorySize();

    return len;
}

char* SymSystemLine::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::serialize(p);
    return p;
}

char* SymSystemLine::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::deserialize(p);
    return p;
}


SymRect SymSystemLine::getMBR() const {
    return SymRect(-1, 0, 1, 0);
}