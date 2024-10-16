#include "SymShapeWithStroke.h"

#include "jsonutils.h"

SymShapeWithStroke::SymShapeWithStroke() {
    _stroke = new SymStroke();
}

SymShapeWithStroke::~SymShapeWithStroke() {
    if (_stroke) {
        delete _stroke;
    }
}

size_t SymShapeWithStroke::memorySize() {
    size_t len = SymShape::memorySize();
    if (_stroke) {
        len += _stroke->memorySize();
    }
    return len;
}

bool SymShapeWithStroke::fromJsonObject(json_object* obj) {
    json_object* strokeobj = json_object_object_get(obj, "stroke");
    if (!strokeobj) {
        _errorMessage = "Can not find stroke information!";
        return false;
    }
    if (_stroke) {
        delete _stroke;
    }
    _stroke = new SymStroke();
    if (!_stroke->fromJsonObject(strokeobj)) {
        _errorMessage = _stroke->getErrorMessage();
        return false;
    }
    return true;
}


json_object* SymShapeWithStroke::toJsonObject() {
    json_object* obj = json_object_new_object();

    json_object_object_add(obj, "stroke", _stroke->toJsonObject());

    return obj;
}

char* SymShapeWithStroke::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShape::serialize(p);
    p = _stroke->serialize(p);
    return p;
}


char* SymShapeWithStroke::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShape::deserialize(p);
    p = _stroke->deserialize(p);
    return p;
}


double SymShapeWithStroke::getStrokeWidth() const {
    return _stroke->getWidth();
}


SymRect SymShapeWithStroke::getMBR() const {
    return SymRect();
}