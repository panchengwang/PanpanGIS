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

bool SymSystemLine::from_json_object(json_object* obj)
{
    _type = SYM_SHAPE_SYSTEM_LINE;
    if (!SymShapeWithStroke::from_json_object(obj)) {
        return false;
    }
    return true;
}

json_object* SymSystemLine::to_json_object() {
    json_object* obj = SymShapeWithStroke::to_json_object();
    JSON_ADD_STRING(obj, "type", "SYSTEMLINE");
    return obj;
}


size_t SymSystemLine::memory_size() {
    size_t len = SymShapeWithStroke::memory_size();

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
