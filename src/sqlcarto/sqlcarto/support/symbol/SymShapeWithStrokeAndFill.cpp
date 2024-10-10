#include "SymShapeWithStrokeAndFill.h"
#include "SymFill.h"
#include "jsonutils.h"
#include "SymFillSolid.h"

SymShapeWithStrokeAndFill::SymShapeWithStrokeAndFill() {
    _fill = NULL;
}

SymShapeWithStrokeAndFill::~SymShapeWithStrokeAndFill() {
    if (_fill) {
        delete _fill;
    }
}

bool SymShapeWithStrokeAndFill::from_json_object(json_object* obj) {
    if (!SymShapeWithStroke::from_json_object(obj)) {
        return false;
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


json_object* SymShapeWithStrokeAndFill::to_json_object() {
    json_object* obj = SymShapeWithStroke::to_json_object();
    json_object_object_add(obj, "fill", _fill->to_json_object());
    return obj;
}


size_t SymShapeWithStrokeAndFill::memory_size() {
    size_t len = SymShapeWithStroke::memory_size();
    if (_fill) {
        len += _fill->memory_size();
    }
    return len;
}


char* SymShapeWithStrokeAndFill::serialize(const char* buf) {
    char* p = (char*)buf;

    p = SymShapeWithStroke::serialize(p);
    if (_fill) {
        p = _fill->serialize(p);
    }

    return p;
}


char* SymShapeWithStrokeAndFill::deserialize(const char* buf) {
    char* p = (char*)buf;

    p = SymShapeWithStroke::deserialize(p);
    uint8_t filltype;
    memcpy((void*)&filltype, p, sizeof(filltype));
    // p += sizeof(filltype);

    SymFill* myfill = NULL;
    if (filltype == FILL_SOLID) {
        myfill = new SymFillSolid();
    }

    if (!myfill) {
        return p;
    }

    p = myfill->deserialize(p);
    if (_fill) {
        delete _fill;
    }
    _fill = myfill;

    return p;
}
