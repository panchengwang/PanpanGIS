#include "SymSystemFill.h"
#include "jsonutils.h"
#include "SymFillSolid.h"

SymSystemFill::SymSystemFill() {
    _type = SYM_SHAPE_SYSTEM_FILL;
    _fill = NULL;
}


SymSystemFill::~SymSystemFill() {
    if (_fill) {
        delete _fill;
    }
}


bool SymSystemFill::from_json_object(json_object* obj) {
    _type = SYM_SHAPE_SYSTEM_FILL;
    if (_fill) {
        delete _fill;
    }

    json_object* fillobj = NULL;
    JSON_GET_OBJ(obj, "fill", fillobj, _errorMessage);
    std::string typestr;
    JSON_GET_STRING(fillobj, "type", typestr, _errorMessage);


    if (typestr == "SOLID") {
        _fill = new SymFillSolid();
    }

    if (!_fill) {
        _errorMessage = "Invalid fill type: " + typestr;
        return false;
    }

    if (!_fill->from_json_object(fillobj)) {
        _errorMessage = _fill->getErrorMessage();
        return false;
    }

    return true;
}


json_object* SymSystemFill::to_json_object() {
    json_object* obj = json_object_new_object();
    JSON_ADD_STRING(obj, "type", "SYSTEMFILL");
    json_object_object_add(obj, "fill", _fill->to_json_object());
    return obj;
}


size_t SymSystemFill::memory_size() {
    size_t len = SymShape::memory_size();
    if (_fill) {
        len += _fill->memory_size();
    }
    return len;
}


char* SymSystemFill::serialize(const char* buf) {

}