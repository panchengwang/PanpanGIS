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

bool SymShapeWithStrokeAndFill::fromJsonObject(json_object* obj) {
    if (!SymShapeWithStroke::fromJsonObject(obj)) {
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

    if (!_fill->fromJsonObject(fillobj)) {
        _errorMessage = _fill->getErrorMessage();
        return false;
    }

    return true;
}


json_object* SymShapeWithStrokeAndFill::toJsonObject() {
    json_object* obj = SymShapeWithStroke::toJsonObject();
    json_object_object_add(obj, "fill", _fill->toJsonObject());
    return obj;
}


size_t SymShapeWithStrokeAndFill::memorySize() {
    size_t len = SymShapeWithStroke::memorySize();
    if (_fill) {
        len += _fill->memorySize();
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
