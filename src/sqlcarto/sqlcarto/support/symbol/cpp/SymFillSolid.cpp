#include "SymFillSolid.h"
#include "jsonutils.h"

SymFillSolid::SymFillSolid()
{
    _type = FILL_SOLID;
}

bool SymFillSolid::fromJsonObject(json_object* obj)
{
    _type = FILL_SOLID;
    json_object* colorobj = NULL;
    JSON_GET_OBJ(obj, "color", colorobj, _errorMessage);
    if (!_color.fromJsonObject(colorobj)) {
        _errorMessage = _color.getErrorMessage();
        return false;
    }
    return true;
}

json_object* SymFillSolid::toJsonObject()
{
    json_object* obj = json_object_new_object();
    JSON_ADD_STRING(obj, "type", "SOLID");
    json_object_object_add(obj, "color", _color.toJsonObject());
    return obj;

}


size_t SymFillSolid::memorySize() {
    size_t len = SymFill::memorySize();
    len += _color.memorySize();
    return len;
}


char* SymFillSolid::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymFill::serialize(p);
    p = _color.serialize(p);
    return p;
}


char* SymFillSolid::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymFill::deserialize(p);
    p = _color.deserialize(p);
    return p;
}