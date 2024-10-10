#include "SymFillSolid.h"
#include "jsonutils.h"

SymFillSolid::SymFillSolid()
{
    _type = FILL_SOLID;
}

bool SymFillSolid::from_json_object(json_object* obj)
{
    json_object* colorobj = NULL;
    JSON_GET_OBJ(obj, "color", colorobj, _errorMessage);
    if (!_color.from_json_object(colorobj)) {
        _errorMessage = _color.getErrorMessage();
        return false;
    }
    return true;
}

json_object* SymFillSolid::to_json_object()
{
    json_object* obj = json_object_new_object();
    JSON_ADD_STRING(obj, "type", "SOLID");
    json_object_object_add(obj, "color", _color.to_json_object());
    return obj;

}


size_t SymFillSolid::memory_size() {
    size_t len = SymFill::memory_size();
    len += _color.memory_size();
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